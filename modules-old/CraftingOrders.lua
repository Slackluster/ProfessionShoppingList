--------------------------------------------------
-- Profession Shopping List: CraftingOrders.lua --
--------------------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

-- When the addon is fully loaded, actually run the components
app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Settings["craftingOrders"] = app.Settings["craftingOrders"] or {
			knowledgeCost = 85,
			artisanCost = 3,
			payoutCost = 50,
		}
		if app.Settings["craftingOrders"].trackReset == nil then app.Settings["craftingOrders"].trackReset = true end

		ProfessionShoppingList_CharacterData.Queue = ProfessionShoppingList_CharacterData.Queue or {}
		if ProfessionShoppingList_CharacterData.TrackConcentration ~= nil then
			ProfessionShoppingList_CharacterData.Queue.TrackConcentration = ProfessionShoppingList_CharacterData.TrackConcentration
			ProfessionShoppingList_CharacterData.TrackConcentration = nil
		end
		if ProfessionShoppingList_CharacterData.Queue.TrackConcentration == nil then
			ProfessionShoppingList_CharacterData.Queue.TrackConcentration = true
		end
		ProfessionShoppingList_CharacterData.Queue.Knowledge = ProfessionShoppingList_CharacterData.Queue.Knowledge or {}

		app.Flag.CraftingOrderAssets = false
		app.Flag.QuickOrder = 0
		app.RepeatQuickOrderTooltip = {}
		app.QuickOrderRecipeID = 0
		app.QuickOrderAttempts = 0
		app.QuickOrderErrors = 0
	end
end)

------------
-- ASSETS --
------------

-- Create buttons for the Crafting Orders window
function app:CreateCraftingOrdersAssets()
	-- Hide and disable existing tracking buttons
	ProfessionsCustomerOrdersFrame.Form.TrackRecipeCheckbox:SetAlpha(0)
	ProfessionsCustomerOrdersFrame.Form.TrackRecipeCheckbox.Checkbox:EnableMouse(false)

	-- Create the place crafting orders UI Track button
	if not app.TrackPlaceOrderButton then
		app.TrackPlaceOrderButton = app:MakeButton(ProfessionsCustomerOrdersFrame.Form, L.TRACK)
		app.TrackPlaceOrderButton:SetPoint("TOPLEFT", ProfessionsCustomerOrdersFrame.Form, "TOPLEFT", 12, -73)
		app.TrackPlaceOrderButton:SetScript("OnClick", function()
			api:TrackRecipe(app.SelectedRecipe.PlaceOrder.recipeID, 1, app.SelectedRecipe.PlaceOrder.recraft)
		end)
	end

	-- Create the place crafting orders UI untrack button
	if not app.UntrackPlaceOrderButton then
		app.UntrackPlaceOrderButton = app:MakeButton(ProfessionsCustomerOrdersFrame.Form, L.UNTRACK)
		app.UntrackPlaceOrderButton:SetPoint("TOPLEFT", app.TrackPlaceOrderButton, "TOPRIGHT", 2, 0)
		app.UntrackPlaceOrderButton:SetScript("OnClick", function()
			api:UntrackRecipe(app.SelectedRecipe.PlaceOrder.recipeID, 1)

			-- Show windows
			app:ShowWindow()
		end)
	end

	-- Create a frame overlay for hover detection
	local overlayFrame1 = CreateFrame("Frame", nil, app.TrackPlaceOrderButton)
	overlayFrame1:SetAllPoints(app.TrackPlaceOrderButton)
	overlayFrame1:EnableMouse(true)
	overlayFrame1:SetPropagateMouseClicks(true)
	overlayFrame1:SetPropagateMouseMotion(true)
	overlayFrame1:SetScript("OnEnter", function(self)
		if app.SelectedRecipe.PlaceOrder.recipeID == 0 then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L.RECRAFT_TOOLTIP)
			GameTooltip:Show()
		end
	end)
	overlayFrame1:SetScript("OnLeave", function()
		if app.SelectedRecipe.PlaceOrder.recipeID == 0 then
			GameTooltip:Hide()
		end
	end)

	-- Create the place crafting orders UI personal order name field
	if not app.QuickOrderTargetBox then
		app.QuickOrderTargetBox = CreateFrame("EditBox", nil, ProfessionsCustomerOrdersFrame.Form, "InputBoxTemplate")
		app.QuickOrderTargetBox:SetSize(80,20)
		app.QuickOrderTargetBox:SetPoint("CENTER", app.TrackPlaceOrderButton, "CENTER")
		app.QuickOrderTargetBox:SetPoint("LEFT", app.TrackPlaceOrderButton, "LEFT", 415, 0)
		app.QuickOrderTargetBox:SetAutoFocus(false)
		app.QuickOrderTargetBox:SetCursorPosition(0)
		app.QuickOrderTargetBox:SetScript("OnEditFocusLost", function(self)
			ProfessionShoppingList_CharacterData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] = tostring(app.QuickOrderTargetBox:GetText())
			app:UpdateAssets()
		end)
		app.QuickOrderTargetBox:SetScript("OnEnterPressed", function(self)
			ProfessionShoppingList_CharacterData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] = tostring(app.QuickOrderTargetBox:GetText())
			self:ClearFocus()
			app:UpdateAssets()
		end)
		app.QuickOrderTargetBox:SetScript("OnEscapePressed", function(self)
			app:UpdateAssets()
		end)
		app:SetBorder(app.QuickOrderTargetBox, -6, 1, 2, -2)
	end

	local function quickOrder(recipeID)
		-- Create crafting info variables
		app.QuickOrderRecipeID = recipeID
		local reagentInfo = {}
		local craftingReagentInfo = {}

		-- Signal that PSL is currently working on a quick order
		app.Flag.QuickOrder = 1

		local function localReagentsOrder()
			-- Cache reagent tier info
			local _ = {}
			app:GetReagents(_, recipeID, 1, false)

			-- Get recipe info
			local recipeInfo = C_TradeSkillUI.GetRecipeSchematic(recipeID, false).reagentSlotSchematics

			-- Go through all the reagents for this recipe
			local no1 = 1
			local no2 = 1
			for i, _ in ipairs(recipeInfo) do
				if recipeInfo[i].reagentType == 1 then
					-- Get the required quantity
					local quantityNo = recipeInfo[i].quantityRequired

					-- Get the primary reagent itemID
					local reagentID = recipeInfo[i].reagents[1].itemID

					-- Add the info for tiered reagents to craftingReagentItems
					if ProfessionShoppingList_Cache.ReagentTiers[reagentID].two ~= 0 then
						-- Set it to the lowest quality we have enough of for this order
						if C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].one, true, false, true, true) >= quantityNo then
							craftingReagentInfo[no1] = {reagent = { itemID = ProfessionShoppingList_Cache.ReagentTiers[reagentID].one}, dataSlotIndex = recipeInfo[i].dataSlotIndex, quantity = quantityNo}
							no1 = no1 + 1
						elseif C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].two, true, false, true, true) >= quantityNo then
							craftingReagentInfo[no1] = {reagent = { itemID = ProfessionShoppingList_Cache.ReagentTiers[reagentID].two}, dataSlotIndex = recipeInfo[i].dataSlotIndex, quantity = quantityNo}
							no1 = no1 + 1
						elseif C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].three, true, false, true, true) >= quantityNo then
							craftingReagentInfo[no1] = {reagent = { itemID = ProfessionShoppingList_Cache.ReagentTiers[reagentID].three}, dataSlotIndex = recipeInfo[i].dataSlotIndex, quantity = quantityNo}
							no1 = no1 + 1
						end
					-- Add the info for non-tiered reagents to reagentItems
					else
						if C_Item.GetItemCount(reagentID, true, false, true, true) >= quantityNo then
							reagentInfo[no2] = {reagent = { itemID = ProfessionShoppingList_Cache.ReagentTiers[reagentID].one}, quantity = quantityNo}
							no2 = no2 + 1
						end
					end
				end
			end
		end

		-- Only add the reagentInfo if the option is enabled
		if app.Settings["useLocalReagents"] then localReagentsOrder() end

		-- Signal that PSL is currently working on a quick order with tiered local reagents, if applicable
		local next = next
		if next(craftingReagentInfo) ~= nil and app.Settings["useLocalReagents"] then
			app.Flag.QuickOrder = 2
		end

		local orderType = Enum.CraftingOrderType.Personal
		if ProfessionShoppingList_CharacterData.Orders[recipeID] == "GUILD" then
			orderType = Enum.CraftingOrderType.Guild
		end

		local orderInfo = { skillLineAbilityID = ProfessionShoppingList_Library[recipeID].abilityID, orderType = orderType, orderDuration = app.Settings["quickOrderDuration"], tipAmount = 100, customerNotes = "", orderTarget = ProfessionShoppingList_CharacterData.Orders[recipeID], reagentInfos = reagentInfo, craftingReagentItems = craftingReagentInfo }
		C_CraftingOrders.PlaceNewOrder(orderInfo)
	end

	-- Create the place crafting orders personal order button
	if not app.QuickOrderButton then
		app.QuickOrderButton = app:MakeButton(ProfessionsCustomerOrdersFrame.Form, L.QUICKORDER)
		app.QuickOrderButton:SetPoint("CENTER", app.QuickOrderTargetBox, "CENTER")
		app.QuickOrderButton:SetPoint("RIGHT", app.QuickOrderTargetBox, "LEFT", -8, 0)
		app.QuickOrderButton:SetScript("OnClick", function()
			quickOrder(app.SelectedRecipe.PlaceOrder.recipeID)
		end)
	end

	-- Create a frame overlay for hover detection
	local overlayFrame2 = CreateFrame("Frame", nil, app.QuickOrderButton)
	overlayFrame2:SetAllPoints(app.QuickOrderButton)
	overlayFrame2:EnableMouse(true)
	overlayFrame2:SetPropagateMouseClicks(true)
	overlayFrame2:SetPropagateMouseMotion(true)
	overlayFrame2:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:SetText(L.QUICKORDER_TOOLTIP)
		GameTooltip:Show()
	end)
	overlayFrame2:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Create the local reagents checkbox
	if not app.LocalReagentsCheckbox then
		-- Temporary checkbox until Blizz fixes their shit
		app.LocalReagentsCheckbox = CreateFrame("CheckButton", nil, ProfessionsCustomerOrdersFrame.Form, "ChatConfigCheckButtonTemplate")
		app.LocalReagentsCheckbox:SetPoint("BOTTOMLEFT", app.QuickOrderButton, "TOPLEFT")
		app.LocalReagentsCheckbox.Text:SetText(L.LOCALREAGENTS_LABEL)
		app.LocalReagentsCheckbox.tooltip = L.LOCALREAGENTS_TOOLTIP
		app.LocalReagentsCheckbox:SetScript("OnClick", function(self)
			app.Settings["useLocalReagents"] = self:GetChecked()

			if ProfessionShoppingList_CharacterData.Orders["last"] ~= nil and ProfessionShoppingList_CharacterData.Orders["last"] ~= 0 then
				app.RepeatQuickOrderTooltip.Reagents = L.FALSE
				if app.Settings["useLocalReagents"] then
					app.RepeatQuickOrderTooltip.Reagents = L.TRUE
				end
			end
		end)
	end

	-- Create the repeat last crafting order button
	if not app.RepeatQuickOrderButton then
		app.RepeatQuickOrderButton = app:MakeButton(ProfessionsCustomerOrdersFrame, "")
		app.RepeatQuickOrderButton:SetPoint("BOTTOMLEFT", ProfessionsCustomerOrdersFrame, 170, 5)
		app.RepeatQuickOrderButton:SetScript("OnClick", function()
			if ProfessionShoppingList_CharacterData.Orders["last"] ~= nil and ProfessionShoppingList_CharacterData.Orders["last"] ~= 0 then
				quickOrder(ProfessionShoppingList_CharacterData.Orders["last"])
				ProfessionsCustomerOrdersFrame.MyOrdersPage:RefreshOrders()
			else
				app:Print("No last Quick Order found.")
			end
		end)
		app.RepeatQuickOrderButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(app.RepeatQuickOrderTooltip.Text)
			GameTooltip:Show()
		end)
		app.RepeatQuickOrderButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		-- Set the last used recipe name for the repeat order button title
		local recipeName = L.NOLASTORDER
		-- Check for the name if there has been a last order
		if ProfessionShoppingList_CharacterData.Orders["last"] ~= nil and ProfessionShoppingList_CharacterData.Orders["last"] ~= 0 then
			recipeName = C_TradeSkillUI.GetRecipeSchematic(ProfessionShoppingList_CharacterData.Orders["last"], false).name
		end
		app:UpdateButton(app.RepeatQuickOrderButton, recipeName)
	end

	-- Create the repeat last crafting order button text
	app.RepeatQuickOrderTooltip.Text = L.QUICKORDER_REPEAT_TOOLTIP

	if ProfessionShoppingList_CharacterData.Orders["last"] ~= nil and ProfessionShoppingList_CharacterData.Orders["last"] ~= 0 and ProfessionShoppingList_CharacterData.Orders[ProfessionShoppingList_CharacterData.Orders["last"]] ~= nil then
		app.RepeatQuickOrderTooltip.Reagents = L.FALSE
		if app.Settings["useLocalReagents"] then
			app.RepeatQuickOrderTooltip.Reagents = L.TRUE
		end
		app.RepeatQuickOrderTooltip.Text = L.QUICKORDER_REPEAT_TOOLTIP .. "\n" .. L.RECIPIENT .. ": " .. ProfessionShoppingList_CharacterData.Orders[ProfessionShoppingList_CharacterData.Orders["last"]] .. "\n" .. L.LOCALREAGENTS_LABEL .. ": " .. app.RepeatQuickOrderTooltip.Reagents
	end

	-- Set the flag for assets created to true
	app.Flag.CraftingOrderAssets = true
end

function app:CreateProfessionsOrdersAssets()
	if not app.TrackOrdersButton then
		app.TrackOrdersButton = app:MakeButton(ProfessionsFrame.OrdersPage.BrowseFrame, L.TRACK)
		app.TrackOrdersButton:SetPoint("LEFT", ProfessionsFrame.OrdersPage.BrowseFrame.PersonalOrdersButton, "RIGHT", 6, 0)
		app.TrackOrdersButton:SetScript("OnClick", function()
			local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
			for key, orderInfo in pairs(app.OrderInfo) do
				if orderInfo.learned and not ProfessionShoppingList_Data.Recipes[key] and skillLineID == orderInfo.skillLineID and orderInfo.view.orderType == Enum.CraftingOrderType.Npc then
					local profit = 1
					if C_AddOns.IsAddOnLoaded("Auctionator") then
						profit = orderInfo.profit
						for tradeSkillLineID, knowledge in pairs(orderInfo.knowledge) do
							if ProfessionShoppingList_CharacterData.Queue.Knowledge[tradeSkillLineID] then
								profit = profit + (knowledge * (app.Settings["craftingOrders"].knowledgeCost * 10000))
							end
						end
						profit = profit + (orderInfo.artisan * (app.Settings["craftingOrders"].artisanCost * 10000))
						profit = profit + (orderInfo.payout * (app.Settings["craftingOrders"].payoutCost * 10000))
					end

					if profit >= 0 and (ProfessionShoppingList_CharacterData.Queue.TrackConcentration or orderInfo.concentrationCost == 0) and (app.Settings["craftingOrders"].trackReset or orderInfo.expirationTime < (GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset() + (24 * 60 * 60))) then
						api:TrackRecipe(orderInfo.spellID, 1, orderInfo.isRecraft, orderInfo.orderID)
					end
				end
			end
			if app.OrdersQueue and app.OrdersQueue:IsShown() then
				app:UpdateOrdersQueue()
			end
		end)
		app.TrackOrdersButton:Hide()

		app.TrackOrdersSettingsButton = CreateFrame("Button", nil, app.TrackOrdersButton)
		app.TrackOrdersSettingsButton:SetPoint("LEFT", app.TrackOrdersButton, "RIGHT", 2, 0)
		app.TrackOrdersSettingsButton:SetSize(24, 24)
		local texture = app.TrackOrdersSettingsButton:CreateTexture(nil, "ARTWORK")
		texture:SetAllPoints(app.TrackOrdersSettingsButton)
		texture:SetAtlas("mechagon-projects", true)
		app.TrackOrdersSettingsButton:SetHighlightTexture("UI-Niffen-Highlight-Bottom")
		app.TrackOrdersSettingsButton:SetScript("OnMouseDown", function()
			app.TrackOrdersSettingsButton:SetPoint("LEFT", app.TrackOrdersButton, "RIGHT", 3, -1)
		end)
		app.TrackOrdersSettingsButton:SetScript("OnMouseUp", function()
			app.TrackOrdersSettingsButton:SetPoint("LEFT", app.TrackOrdersButton, "RIGHT", 2, 0)
		end)
		app.TrackOrdersSettingsButton:SetScript("OnClick", function()
			if not app.TrackOrdersSettings:IsShown() then
				app.TrackOrdersSettings:Show()
				app.TrackOrdersSettings:SetToplevel(true)
			else
				app.TrackOrdersSettings:Hide()
			end
		end)

		app.Flag.ReloadingOrders = 0
		local function sortOrders()
			ProfessionsFrame.OrdersPage:ResetSortOrder()
			ProfessionsFrame.OrdersPage:SetSortOrder(ProfessionsSortOrder.Expiration)
			ProfessionsFrame.OrdersPage:SetSortOrder(ProfessionsSortOrder.Expiration) -- Can't specify descending
			C_Timer.After(0.5, function()
				if app.OrderState ~= app.Enum.OrderState.Idle and not C_CraftingOrders.GetClaimedOrder() then
					app.OrderState = app.Enum.OrderState.Idle
					app:Debug("app.Enum.OrderState.Idle 3")
				end

				app.Flag.ReloadingOrders = app.Flag.ReloadingOrders + 1
				if (ProfessionsFrame.OrdersPage.BrowseFrame.OrderList.LoadingSpinner:IsShown() or ProfessionsFrame.OrdersPage.BrowseFrame.OrderList.ResultsText:IsShown()) and app.Flag.ReloadingOrders < 6 then
					sortOrders()
				else
					app.Flag.ReloadingOrders = 0
				end
			end)
		end

		hooksecurefunc(ProfessionsFrame.OrdersPage.BrowseFrame.NpcOrdersButton, "SetTabSelected", function()
			if app.Settings["enhancedOrders"] and ProfessionsFrame.OrdersPage.BrowseFrame.NpcOrdersButton.isSelected then
				app.TrackOrdersButton:Show()
				sortOrders()
			else
				app.TrackOrdersButton:Hide()
			end
		end)

		ProfessionsFrame.OrdersPage:HookScript("OnShow", function()
			if app.Settings["enhancedOrders"] and ProfessionsFrame.OrdersPage.BrowseFrame.NpcOrdersButton.isSelected then
				sortOrders()
			end
		end)

		local _, classFilename = UnitClass("player")
		local _, _, _, classColor = GetClassColor(classFilename)
		local charName = "|c" .. classColor .. UnitName("player") .. "-" .. GetNormalizedRealmName() .. "|R"

		app.TrackOrdersSettings = CreateFrame("Frame", nil, ProfessionsFrame, "BasicFrameTemplate")
		app.TrackOrdersSettings:SetFrameStrata("DIALOG")
		app.TrackOrdersSettings:SetPoint("TOPLEFT", app.TrackOrdersSettingsButton, "TOPRIGHT", 6, 0)
		app.TrackOrdersSettings:EnableMouse(true) -- Stop OnEnter for the frames below from triggering
		app.TrackOrdersSettings:Hide()
		app.TrackOrdersSettings.TitleText:SetText(app.NameLong)

		local text0 = app.TrackOrdersSettings:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text0:SetPoint("TOPLEFT", app.TrackOrdersSettings, "TOPLEFT", 10, -30)
		text0:SetJustifyH("LEFT")
		text0:SetText(L.ORDERS_SET_CRITERIA .. "\n" .. L.ORDERS_COST_NEED)

		local text1 = app.TrackOrdersSettings:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text1:SetPoint("TOPLEFT", text0, "BOTTOMLEFT", 0, -10)
		text1:SetJustifyH("LEFT")
		text1:SetText(L.ORDERS_MAX_COST_KNOWLEDGE)

		local editbox1 = CreateFrame("EditBox", nil, app.TrackOrdersSettings, "InputBoxTemplate")
		editbox1:SetSize(40,20)
		editbox1:SetPoint("TOPLEFT", text1, "BOTTOMLEFT", 4, -4)
		editbox1:SetAutoFocus(false)
		editbox1:SetCursorPosition(0)
		editbox1:SetText(app.Settings["craftingOrders"].knowledgeCost)
		editbox1:SetJustifyH("RIGHT")
		editbox1:SetTextInsets(0, 3, 0, 0)
		editbox1:SetScript("OnEditFocusLost", function(self)
			app.Settings["craftingOrders"].knowledgeCost = math.floor(tonumber(self:GetText()) or app.Settings["craftingOrders"].knowledgeCost)
			self:SetText(app.Settings["craftingOrders"].knowledgeCost)
		end)
		editbox1:SetScript("OnEnterPressed", function(self)
			self:ClearFocus()
		end)
		editbox1:SetScript("OnEscapePressed", function(self)
			self:SetText(app.Settings["craftingOrders"].knowledgeCost)
		end)
		app:SetBorder(editbox1, -6, 1, 2, -1)

		local gold1 = CreateFrame("Button", nil, app.TrackOrdersSettings)
		gold1:SetPoint("LEFT", editbox1, "RIGHT", 6, 0)
		gold1:SetSize(16, 16)
		local texture = gold1:CreateTexture(nil, "ARTWORK")
		texture:SetAllPoints(gold1)
		texture:SetAtlas("auctionhouse-icon-coin-gold", true)

		local function isSelected(index)
			if ProfessionShoppingList_CharacterData.Queue.Knowledge[index] == nil then
				ProfessionShoppingList_CharacterData.Queue.Knowledge[index] = true
			end
			return ProfessionShoppingList_CharacterData.Queue.Knowledge[index]
		end
		local function setSelected(index)
			ProfessionShoppingList_CharacterData.Queue.Knowledge[index] = not ProfessionShoppingList_CharacterData.Queue.Knowledge[index]
		end
		function listStyleGenerator(owner, rootDescription)
			rootDescription:CreateTitle(string.format(L.ORDERS_TRACK_ON, charName))
			local professions = {}
			for tradeSkillLineID, info in pairs(app.ProfessionKnowledge) do
				local professionInfo = C_TradeSkillUI.GetProfessionInfoBySkillLineID(tradeSkillLineID)
				if professionInfo.skillLevel > 0 and not info.gathering then
					table.insert(professions, { tradeSkillLineID = tradeSkillLineID, professionName = professionInfo.professionName })
				end
			end
			table.sort(professions, function(a, b) return a.tradeSkillLineID < b.tradeSkillLineID end)
			for _, profession in ipairs(professions) do
				rootDescription:CreateCheckbox(profession.professionName, isSelected, setSelected, profession.tradeSkillLineID)
			end
		end
		app.TrackOrdersSettings.KnowledgeDropdown = CreateFrame("DropdownButton", nil, app.TrackOrdersSettings, "WowStyle1DropdownTemplate")
		app.TrackOrdersSettings.KnowledgeDropdown:SetWidth(120)
		app.TrackOrdersSettings.KnowledgeDropdown:SetPoint("LEFT", gold1, "RIGHT", 10, 0)
		app.TrackOrdersSettings.KnowledgeDropdown:SetupMenu(listStyleGenerator)
		app.TrackOrdersSettings.KnowledgeDropdown:OverrideText(TRADE_SKILLS)
		app:SetBorder(app.TrackOrdersSettings.KnowledgeDropdown, -1, 1, 1, -1)

		local text2 = app.TrackOrdersSettings:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text2:SetPoint("TOPLEFT", text1, "BOTTOMLEFT", 0, -30)
		text2:SetJustifyH("LEFT")
		text2:SetText(L.ORDERS_MAX_COST_ARTISAN)

		local editbox2 = CreateFrame("EditBox", nil, app.TrackOrdersSettings, "InputBoxTemplate")
		editbox2:SetSize(40,20)
		editbox2:SetPoint("TOPLEFT", text2, "BOTTOMLEFT", 4, -4)
		editbox2:SetAutoFocus(false)
		editbox2:SetCursorPosition(0)
		editbox2:SetText(app.Settings["craftingOrders"].artisanCost)
		editbox2:SetJustifyH("RIGHT")
		editbox2:SetTextInsets(0, 3, 0, 0)
		editbox2:SetScript("OnEditFocusLost", function(self)
			app.Settings["craftingOrders"].artisanCost = math.floor(tonumber(self:GetText()) or app.Settings["craftingOrders"].artisanCost)
			self:SetText(app.Settings["craftingOrders"].artisanCost)
		end)
		editbox2:SetScript("OnEnterPressed", function(self)
			self:ClearFocus()
		end)
		editbox2:SetScript("OnEscapePressed", function(self)
			self:SetText(app.Settings["craftingOrders"].artisanCost)
		end)
		app:SetBorder(editbox2, -6, 1, 2, -1)

		local gold2 = CreateFrame("Button", nil, app.TrackOrdersSettings)
		gold2:SetPoint("LEFT", editbox2, "RIGHT", 6, 0)
		gold2:SetSize(16, 16)
		local texture = gold2:CreateTexture(nil, "ARTWORK")
		texture:SetAllPoints(gold2)
		texture:SetAtlas("auctionhouse-icon-coin-gold", true)

		local text3 = app.TrackOrdersSettings:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text3:SetPoint("TOPLEFT", text2, "BOTTOMLEFT", 0, -30)
		text3:SetJustifyH("LEFT")
		text3:SetText(L.ORDERS_MAX_COST_PAYOUT)

		local editbox3 = CreateFrame("EditBox", nil, app.TrackOrdersSettings, "InputBoxTemplate")
		editbox3:SetSize(40,20)
		editbox3:SetPoint("TOPLEFT", text3, "BOTTOMLEFT", 4, -4)
		editbox3:SetAutoFocus(false)
		editbox3:SetCursorPosition(0)
		editbox3:SetText(app.Settings["craftingOrders"].payoutCost)
		editbox3:SetJustifyH("RIGHT")
		editbox3:SetTextInsets(0, 3, 0, 0)
		editbox3:SetScript("OnEditFocusLost", function(self)
			app.Settings["craftingOrders"].payoutCost = math.floor(tonumber(self:GetText()) or app.Settings["craftingOrders"].payoutCost)
			self:SetText(app.Settings["craftingOrders"].payoutCost)
		end)
		editbox3:SetScript("OnEnterPressed", function(self)
			self:ClearFocus()
		end)
		editbox3:SetScript("OnEscapePressed", function(self)
			self:SetText(app.Settings["craftingOrders"].payoutCost)
		end)
		app:SetBorder(editbox3, -6, 1, 2, -1)

		local gold3 = CreateFrame("Button", nil, app.TrackOrdersSettings)
		gold3:SetPoint("LEFT", editbox3, "RIGHT", 6, 0)
		gold3:SetSize(16, 16)
		local texture = gold3:CreateTexture(nil, "ARTWORK")
		texture:SetAllPoints(gold3)
		texture:SetAtlas("auctionhouse-icon-coin-gold", true)

		local checkbox1 = CreateFrame("CheckButton", nil, app.TrackOrdersSettings, "ChatConfigCheckButtonTemplate")
		checkbox1:SetPoint("TOPLEFT", text3, "BOTTOMLEFT", -3, -26)
		checkbox1.Text:SetText(L.ORDERS_TRACK_AFTER_RESET)
		checkbox1.Text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		checkbox1.Text:SetPoint("LEFT", checkbox1, "RIGHT")
		checkbox1:SetChecked(app.Settings["craftingOrders"].trackReset)
		checkbox1:SetScript("OnClick", function(self)
			app.Settings["craftingOrders"].trackReset = self:GetChecked()
		end)

		local text4 = app.TrackOrdersSettings:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text4:SetPoint("LEFT", text3)
		text4:SetPoint("TOP", checkbox1, "BOTTOM", 0, -4)
		text4:SetJustifyH("LEFT")
		text4:SetText(L.ORDERS_TRACK_CONCENTRATION)

		local checkbox2 = CreateFrame("CheckButton", nil, app.TrackOrdersSettings, "ChatConfigCheckButtonTemplate")
		checkbox2:SetPoint("TOPLEFT", text4, "BOTTOMLEFT", -3, -2)
		checkbox2.Text:SetText(charName)
		checkbox2.Text:SetPoint("LEFT", checkbox2, "RIGHT")
		checkbox2:SetChecked(ProfessionShoppingList_CharacterData.Queue.TrackConcentration)
		checkbox2:SetScript("OnClick", function(self)
			ProfessionShoppingList_CharacterData.Queue.TrackConcentration = self:GetChecked()
		end)

		app.TrackOrdersSettings:SetFlattensRenderLayers(true)
		app.TrackOrdersSettings:SetSize(text0:GetStringWidth() + 20, 235)
		app.TrackOrdersSettings:SetScript("OnShow", function()
			RunNextFrame(function()
				app.TrackOrdersSettings:SetHeight(math.abs(checkbox2:GetBottom() - app.TrackOrdersSettings:GetTop()) + 6)
			end)
		end)
	end
end

---------------------
-- CRAFTING ORDERS --
---------------------

-- When opening the crafting orders window
app.Event:Register("CRAFTINGORDERS_SHOW_CUSTOMER", function()
	app:CreateCraftingOrdersAssets()
end)

-- When opening a recipe in the crafting orders window
EventRegistry:RegisterCallback("ProfessionsCustomerOrders.RecipeSelected", function(_, itemID, recipeID, abilityID)
	app:RegisterRecipe(recipeID)
	app.SelectedRecipe.PlaceOrder = { recipeID = recipeID, recraft = false, recipeType = C_TradeSkillUI.GetRecipeSchematic(recipeID,false).recipeType }
	app:UpdateAssets()
end)

-- When opening the recrafting category in the crafting orders window
EventRegistry:RegisterCallback("ProfessionsCustomerOrders.RecraftCategorySelected", function()
	app.SelectedRecipe.PlaceOrder = { recipeID = 0, recraft = true, recipeType = 0 }
	app:UpdateAssets()
end)

-- When a recipe is selected (or rather, when any spell is loaded, but this is the only way to grab the recipeID for placing a recrafting order)
app.Event:Register("SPELL_DATA_LOAD_RESULT", function(spellID, success)
	if not InCombatLockdown() and app.SelectedRecipe and app.SelectedRecipe.PlaceOrder and app.SelectedRecipe.PlaceOrder.recraft and ProfessionShoppingList_Library[spellID] then
		app.SelectedRecipe.PlaceOrder.recipeID = spellID
		app:UpdateAssets()
	end
end)

-- When closing the crafting orders window
app.Event:Register("CRAFTINGORDERS_HIDE_CUSTOMER", function()
	app.SelectedRecipe.PlaceOrder = { recipeID = 0, recraft = false, recipeType = 0 }
end)

-- When fulfilling an order
app.Event:Register("CRAFTINGORDERS_FULFILL_ORDER_RESPONSE", function(result, orderID)
	if result ~= 0 then return end
	for k, v in pairs(ProfessionShoppingList_Data.Recipes) do
		if tonumber(string.match(k, ":(%d+):")) == orderID then
			if app.OrderInfo and app.OrderInfo[k] then
				app.OrderInfo[k] = nil
			end

			if app.Settings["removeCraft"] then
				api:UntrackRecipe(k, 1)

				local next = next
				if next(ProfessionShoppingList_Data.Recipes) == nil and app.Settings["closeWhenDone"] then
					app.Window:Hide()
				end
			end

			break
		end
	end
end)

------------------
-- QUICK ORDERS --
------------------

-- If placing a crafting order through PSL
app.Event:Register("CRAFTINGORDERS_ORDER_PLACEMENT_RESPONSE", function(result)
	if app.Flag.QuickOrder >= 1 then
		if result == 29 then
			app:Print(L.ERROR_REAGENTS)
			return
		elseif result == 34 then
			app:Print(L.ERROR_WARBANK)
			return
		elseif result == 37 then
			app:Print(L.ERROR_GUILD)
			return
		elseif result == 40 then
			app:Print(L.ERROR_RECIPIENT)
			return
		end

		ProfessionShoppingList_CharacterData.Orders["last"] = app.QuickOrderRecipeID

		local recipeName = L.NOLASTORDER
		if ProfessionShoppingList_CharacterData.Orders["last"] ~= nil and ProfessionShoppingList_CharacterData.Orders["last"] ~= 0 then
			app.RepeatQuickOrderTooltip.Reagents = L.FALSE
			if app.Settings["useLocalReagents"] then
				app.RepeatQuickOrderTooltip.Reagents = L.TRUE
			end
			app.RepeatQuickOrderTooltip.Text = L.QUICKORDER_REPEAT_TOOLTIP .. "\n" .. L.RECIPIENT .. ": " .. ProfessionShoppingList_CharacterData.Orders[ProfessionShoppingList_CharacterData.Orders["last"]] .. "\n" .. L.LOCALREAGENTS_LABEL .. ": " .. app.RepeatQuickOrderTooltip.Reagents
			recipeName = C_TradeSkillUI.GetRecipeSchematic(ProfessionShoppingList_CharacterData.Orders["last"], false).name
		end
		app:UpdateButton(app.RepeatQuickOrderButton, recipeName)

		if app.Flag.QuickOrder > 0 then
			app.Flag.QuickOrder = 0
		end
	end
end)

-----------------------
-- ORDER ADJUSTMENTS --
-----------------------

app.Event:Register("TRADE_SKILL_SHOW", function()
	if not InCombatLockdown() then
		if C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
			app:CreateProfessionsOrdersAssets()
		end
	end
end)

app.Event:Register("CRAFTINGORDERS_UPDATE_ORDER_COUNT", function(orderType, numOrders)
	if ProfessionsFrame.OrdersPage:IsShown() then
		local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
		if skillLineID and not app.ProfessionKnowledge[skillLineID] then
			local profInfo = C_TradeSkillUI.GetChildProfessionInfos()
			if profInfo and profInfo[1] and profInfo[1].professionID then
				C_TradeSkillUI.SetProfessionChildSkillLineID(profInfo[1].professionID)
			end
		end
	end

	if app.Settings["enhancedOrders"] and numOrders >= 1 and not app.OrderAdjustments then
		app.OrderAdjustments = app.OrderAdjustments or {}
		app.OrderIcons = app.OrderIcons or {}
		app.OrderInfo = app.OrderInfo or {}

		local function OnFrameInitialized(_, v, data)
			if app.OrderState ~= app.Enum.OrderState.Idle then
				app.OrderState = app.Enum.OrderState.Idle
				app:Debug("app.Enum.OrderState.Idle 4")
				if app.OrdersQueue and app.OrdersQueue:IsShown() then
					app:UpdateOrdersQueue()
				end
			end

			if v and data and v.cells then
				if not data.option or not data.option.orderID then return end
				app.OrderAdjustments[v] = app.OrderAdjustments[v] or {}

				local key = "order:" .. data.option.orderID .. ":" .. data.option.spellID

				local function doTheThing()
					local recipeInfo = C_TradeSkillUI.GetRecipeInfo(data.option.spellID)
					app.OrderInfo[key] = {
						view = v.option,
						learned = recipeInfo.learned,
						spellID = data.option.spellID,
						skillLineID = C_TradeSkillUI.GetProfessionInfoByRecipeID(data.option.spellID).professionID,
						orderID = data.option.orderID,
						isRecraft = data.option.isRecraft,
						expirationTime = data.option.expirationTime,
						knowledge = {},
						artisan = 0,
						payout = 0,
						profit = 0,
						concentrationCost = 0,
					}

					-- Needed reagents
					v.cells[4].Text:Hide()
					v.cells[4]:EnableMouse(false)

					local neededReagents = {}
					local providedReagents = {}
					local concReagents = {}
					for k, v in ipairs(data.option.reagents) do
						if v.reagentInfo.reagent.itemID then
							providedReagents[v.reagentInfo.reagent.itemID] = v.reagentInfo.quantity
						end
					end

					for _, v in ipairs(C_TradeSkillUI.GetRecipeSchematic(data.option.spellID, false).reagentSlotSchematics) do
						local provided = false
						for _, j in ipairs(v.reagents) do
							if providedReagents[j.itemID] then
								if v.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent then
									table.insert(concReagents, { reagent = { itemID = j.itemID }, dataSlotIndex = v.dataSlotIndex, quantity = v.quantityRequired })
								end
								provided = true
								break
							end
						end

						if not provided and v.required then
							local _, itemLink, _, _, _, _, _, _, _, fileID, _, _, _, bindType = C_Item.GetItemInfo(v.reagents[1].itemID)
							if not itemLink then
								app:CacheItem(v.reagents[1].itemID)
								C_Timer.After(0.1, doTheThing)
								return
							end
							table.insert(neededReagents, { icon = fileID, link = itemLink, itemID = v.reagents[1].itemID, count = v.quantityRequired, bindType = bindType })
							if v.dataSlotType == Enum.TradeskillSlotDataType.ModifiedReagent then
								table.insert(concReagents, { reagent = { itemID = v.reagents[1].itemID }, dataSlotIndex = v.dataSlotIndex, quantity = v.quantityRequired })
							end
						end
					end

					if not app.OrderAdjustments[v].reagent then app.OrderAdjustments[v].reagent = {} end
					for i, button in ipairs(app.OrderAdjustments[v].reagent) do
						button:Hide()
					end

					for i, reagent in pairs(neededReagents) do
						if not app.OrderAdjustments[v].reagent[i] then
							app.OrderAdjustments[v].reagent[i] = CreateFrame("Button", nil, v, "UIPanelButtonTemplate")
							app.OrderAdjustments[v].reagent[i]:SetWidth(20)
							app.OrderAdjustments[v].reagent[i]:SetHeight(20)
							app.OrderAdjustments[v].reagent[i]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
							app.OrderAdjustments[v].reagent[i].Text = app.OrderAdjustments[v].reagent[i]:CreateFontString(nil, "ARTWORK", "GameFontNormalOutline")
							app.OrderAdjustments[v].reagent[i].Text:SetJustifyH("RIGHT")
							app.OrderAdjustments[v].reagent[i].Text:SetTextScale(0.9)
						end
						app.OrderAdjustments[v].reagent[i]:Show()
						app.OrderAdjustments[v].reagent[i]:SetPoint("BOTTOMLEFT", v.cells[4], "BOTTOMLEFT", -26+i*22, 0)
						app.OrderAdjustments[v].reagent[i]:SetScript("OnEnter", function(self)
							GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
							GameTooltip:SetHyperlink(reagent.link)
							GameTooltip:Show()
						end)
						app.OrderAdjustments[v].reagent[i]:SetScript("OnLeave", function()
							GameTooltip:Hide()
						end)
						app.OrderAdjustments[v].reagent[i]:SetNormalTexture(reagent.icon)
						app.OrderAdjustments[v].reagent[i].Text:SetPoint("BOTTOMRIGHT", app.OrderAdjustments[v].reagent[i], "BOTTOMRIGHT")
						if reagent.count and reagent.count > 1 then
							app.OrderAdjustments[v].reagent[i].Text:SetText("|cffFFFFFF" .. reagent.count)
						else
							app.OrderAdjustments[v].reagent[i].Text:SetText("")
						end
					end

					-- Concentration icon
					if not app.OrderAdjustments[v].conc then
						app.OrderAdjustments[v].conc = CreateFrame("Button", nil, v, "UIPanelButtonTemplate")
						app.OrderAdjustments[v].conc:SetWidth(20)
						app.OrderAdjustments[v].conc:SetHeight(20)
						app.OrderAdjustments[v].conc:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
						app.OrderAdjustments[v].conc.Text = app.OrderAdjustments[v].conc:CreateFontString(nil, "ARTWORK", "GameFontNormalOutline")
						app.OrderAdjustments[v].conc.Text:SetJustifyH("RIGHT")
						app.OrderAdjustments[v].conc.Text:SetTextScale(0.7)
						app.OrderAdjustments[v].conc.Text:SetPoint("BOTTOMRIGHT", app.OrderAdjustments[v].conc, "BOTTOMRIGHT", 2, 0)
						app.OrderAdjustments[v].conc:SetNormalTexture(5747318)
					end
					app.OrderAdjustments[v].conc:SetPoint("BOTTOMLEFT", v.cells[4], "BOTTOMLEFT", -26, 0)
					app.OrderAdjustments[v].conc:Hide()

					local concInfo = C_TradeSkillUI.GetCraftingOperationInfo(app.OrderInfo[key].spellID, concReagents, nil, false)
					if concInfo.craftingQuality < data.option.minQuality then
						app.OrderInfo[key].concentrationCost = concInfo.concentrationCost

						app.OrderAdjustments[v].conc.Text:SetText(concInfo.concentrationCost)
						app.OrderAdjustments[v].conc:Show()
						app.OrderAdjustments[v].conc:SetScript("OnEnter", function(self)
							GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
							GameTooltip:SetText(concInfo.concentrationCost .. " " .. PROFESSIONS_CRAFTING_STAT_CONCENTRATION)
							GameTooltip:Show()
						end)
						app.OrderAdjustments[v].conc:SetScript("OnLeave", function()
							GameTooltip:Hide()
						end)
					end

					-- Nudge duration to the right
					v.cells[5].Text:SetPoint("BOTTOMRIGHT", v.cells[5], -15, 0)

					-- Order profit
					if C_AddOns.IsAddOnLoaded("Auctionator") then -- Requires Auctionator
						v.cells[3].TipMoneyDisplayFrame:Hide()

						local calculations = {}

						-- Grab the costs for crafting this order
						local needScan = false
						for _, reagent in pairs(neededReagents) do
							if reagent.count > 0 then
								local prices = {}
								table.insert(prices, Auctionator.API.v1.GetAuctionPriceByItemID(app.Name, reagent.itemID))
								if ProfessionShoppingList_Cache.ReagentTiers[reagent.itemID] and ProfessionShoppingList_Cache.ReagentTiers[reagent.itemID].one then
									table.insert(prices, Auctionator.API.v1.GetAuctionPriceByItemID(app.Name, ProfessionShoppingList_Cache.ReagentTiers[reagent.itemID].one))
								end
								if ProfessionShoppingList_Cache.ReagentTiers[reagent.itemID] and ProfessionShoppingList_Cache.ReagentTiers[reagent.itemID].two then
									table.insert(prices, Auctionator.API.v1.GetAuctionPriceByItemID(app.Name, ProfessionShoppingList_Cache.ReagentTiers[reagent.itemID].two))
								end
								if ProfessionShoppingList_Cache.ReagentTiers[reagent.itemID] and ProfessionShoppingList_Cache.ReagentTiers[reagent.itemID].three then
									table.insert(prices, Auctionator.API.v1.GetAuctionPriceByItemID(app.Name, ProfessionShoppingList_Cache.ReagentTiers[reagent.itemID].three))
								end

								local min = 10000000000
								for _, value in ipairs(prices) do
									if value < min then
										min = value
									end
								end

								if reagent.bindType ~= 0 then min = 0 end
								if min == 10000000000 then needScan = true end

								local itemLink = reagent.link:gsub("%s*|A:.-|a%s*", "")
								table.insert(calculations, {type = "cost", icon = reagent.icon, link = itemLink, quantity = reagent.count, amount = min * reagent.count})
							end
						end

						local function addRewards(rewardItemOrCurrency, reward)
							if rewardItemOrCurrency then
								if rewardItemOrCurrency.type == "payout" then
									app.OrderInfo[key].payout = app.OrderInfo[key].payout + 1
								elseif rewardItemOrCurrency.type == "artisan" then
									app.OrderInfo[key].artisan = app.OrderInfo[key].artisan + reward.count
								elseif rewardItemOrCurrency.type == "knowledge1" then
									app.OrderInfo[key].knowledge[app.OrderInfo[key].skillLineID] = (app.OrderInfo[key].knowledge[app.OrderInfo[key].skillLineID] or 0) + 1
									app.OrderInfo[key].artisan = app.OrderInfo[key].artisan + 5
								elseif rewardItemOrCurrency.type == "knowledge2" then
									app.OrderInfo[key].knowledge[app.OrderInfo[key].skillLineID] = (app.OrderInfo[key].knowledge[app.OrderInfo[key].skillLineID] or 0) + 2
									app.OrderInfo[key].artisan = app.OrderInfo[key].artisan + 10
								end
							end
						end
						-- Grab the rewards for crafting this order
						table.insert(calculations, {type = "reward", icon = 133785, link = PROFESSIONS_COLUMN_HEADER_TIP, quantity = 0, amount = math.floor((data.option.tipAmount - data.option.consortiumCut) / 100 + 0.5) * 100})
						for _, reward in pairs(data.option.npcOrderRewards) do
							if reward.itemLink then
								local _, itemLink, _, _, _, _, _, _, _, fileID = C_Item.GetItemInfo(reward.itemLink)
								local itemID = C_Item.GetItemInfoInstant(reward.itemLink)
								if not itemLink then
									app:CacheItem(itemID)
									C_Timer.After(0.1, doTheThing)
									return
								end
								table.insert(calculations, {type = "reward", icon = fileID, link = itemLink, quantity = 0, amount = Auctionator.API.v1.GetAuctionPriceByItemLink(app.Name, itemLink)})
								local rewardItem = app.CraftingOrderRewards.items[itemID]
								addRewards(rewardItem, reward)
							elseif reward.currencyType then
								local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(reward.currencyType)
								local currencyLink = C_CurrencyInfo.GetCurrencyLink(reward.currencyType, reward.count)
								table.insert(calculations, {type = "reward", icon = currencyInfo.iconFileID, link = currencyLink, quantity = 0})
								local rewardCurrency = app.CraftingOrderRewards.currency[reward.currencyType]
								addRewards(rewardCurrency, reward)
							end
						end

						-- Do maths
						local commissionResult = 0
						local allProvided = true
						for _, entry in ipairs(calculations) do
							if entry.type == "cost" and entry.amount then
								commissionResult = commissionResult - entry.amount
								allProvided = false
							elseif entry.type == "reward" and entry.amount then
								commissionResult = commissionResult + entry.amount
							end
						end
						app.OrderInfo[key].profit = commissionResult
						local roundedCommissionResult = (commissionResult >= 0 and math.floor((commissionResult + 5000) / 10000) or math.ceil((commissionResult - 5000) / 10000)) * 10000
						local _, itemLink = C_Item.GetItemInfo(data.option.itemID)

						-- Replace the commission price text with an actual profit calculation
						if not app.OrderAdjustments[v].rewardText then
							app.OrderAdjustments[v].rewardText = v:CreateFontString(nil, "ARTWORK", "GameFontNormal")
							app.OrderAdjustments[v].rewardText:SetJustifyH("RIGHT")
						end
						app.OrderAdjustments[v].rewardText:SetPoint("TOPLEFT", v.cells[3])
						app.OrderAdjustments[v].rewardText:SetPoint("BOTTOMRIGHT", v.cells[3], -10, 0)

						if needScan then
							app.OrderAdjustments[v].rewardText:SetText(app:Colour(L.ORDERS_SCAN_NEEDED))
						elseif roundedCommissionResult < 0 then
							app.OrderAdjustments[v].rewardText:SetText("|cffFF0000- " .. C_CurrencyInfo.GetCoinTextureString(-roundedCommissionResult))
						elseif allProvided then
							app.OrderAdjustments[v].rewardText:SetText("|cff008000" .. C_CurrencyInfo.GetCoinTextureString(roundedCommissionResult))
						else
							app.OrderAdjustments[v].rewardText:SetText(C_CurrencyInfo.GetCoinTextureString(roundedCommissionResult))
						end
						app.OrderAdjustments[v].rewardText:SetScript("OnEnter", function()
							GameTooltip:SetOwner(app.OrderAdjustments[v].rewardText, "ANCHOR_BOTTOMRIGHT")
							GameTooltip:ClearLines()

							if needScan then
								GameTooltip:AddLine(L.ORDERS_DO_SCAN)
							else
								-- Header
								if commissionResult >= 0 then
									GameTooltip:AddDoubleLine(CreateSimpleTextureMarkup(app.Icon) .. " " .. TOTAL, C_CurrencyInfo.GetCoinTextureString(commissionResult))
								else
									GameTooltip:AddDoubleLine(CreateSimpleTextureMarkup(app.Icon) .. " " .. TOTAL, "|cffFF0000- " .. C_CurrencyInfo.GetCoinTextureString(-commissionResult))
								end
								GameTooltip:AddLine(" ")

								-- Costs
								for _, entry in ipairs(calculations) do
									if entry.type == "cost" then
										GameTooltip:AddDoubleLine(CreateSimpleTextureMarkup(entry.icon) .. " " .. entry.link .. " ×" .. entry.quantity , "|cffFF0000- " .. C_CurrencyInfo.GetCoinTextureString(entry.amount))
									end
								end
								GameTooltip:AddLine(" ")

								-- Rewards
								for _, entry in ipairs(calculations) do
									if entry.type == "reward" and entry.amount then
										GameTooltip:AddDoubleLine(CreateSimpleTextureMarkup(entry.icon) .. " " .. entry.link, C_CurrencyInfo.GetCoinTextureString(entry.amount))
									elseif entry.type == "reward" then
										GameTooltip:AddDoubleLine(CreateSimpleTextureMarkup(entry.icon) .. " " .. entry.link, "-")
									end
								end
							end

							GameTooltip:Show()
						end)
						app.OrderAdjustments[v].rewardText:SetScript("OnLeave", function()
							GameTooltip:Hide()
						end)
					end

					-- Order rewards
					v.cells[3].RewardIcon:Hide()
					v.cells[3].RewardsContainer:Hide()

					local rewards = {}
					table.insert(rewards, {icon = 133785, link = CRAFTING_ORDER_FINAL_TIP .. " " .. C_CurrencyInfo.GetCoinTextureString(math.floor((data.option.tipAmount - data.option.consortiumCut) / 100 + 0.5) * 100)})
					for _, reward in pairs(data.option.npcOrderRewards) do
						if reward.itemLink then
							local _, itemLink, _, _, _, _, _, _, _, fileID = C_Item.GetItemInfo(reward.itemLink)
							if not itemLink then
								local itemID = C_Item.GetItemInfoInstant(reward.itemLink)
								app:CacheItem(itemID)
								C_Timer.After(0.1, doTheThing)
								return
							end
							table.insert(rewards, {icon = fileID, link = itemLink, count = reward.count})
						elseif reward.currencyType then
							local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(reward.currencyType)
							local currencyLink = C_CurrencyInfo.GetCurrencyLink(reward.currencyType, reward.count)
							table.insert(rewards, {icon = currencyInfo.iconFileID, link = currencyLink, count = reward.count})
						end
					end

					if not app.OrderAdjustments[v].reward then app.OrderAdjustments[v].reward = {} end
					for i, button in ipairs(app.OrderAdjustments[v].reward) do
						button:Hide()
					end

					for i, reward in ipairs(rewards) do
						if not app.OrderAdjustments[v].reward[i] then
							app.OrderAdjustments[v].reward[i] = CreateFrame("Button", nil, v, "UIPanelButtonTemplate")
							app.OrderAdjustments[v].reward[i]:SetWidth(20)
							app.OrderAdjustments[v].reward[i]:SetHeight(20)
							app.OrderAdjustments[v].reward[i]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
							app.OrderAdjustments[v].reward[i].Text = app.OrderAdjustments[v].reward[i]:CreateFontString(nil, "ARTWORK", "GameFontNormalOutline")
							app.OrderAdjustments[v].reward[i].Text:SetJustifyH("RIGHT")
							app.OrderAdjustments[v].reward[i].Text:SetTextScale(0.9)
						end
						app.OrderAdjustments[v].reward[i]:Show()
						app.OrderAdjustments[v].reward[i]:SetPoint("BOTTOMLEFT", v.cells[3], "BOTTOMLEFT", -50+i*22, 0)
						app.OrderAdjustments[v].reward[i]:SetScript("OnEnter", function(self)
							GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
							if i == 1 then
								GameTooltip:SetText(reward.link)
							else
								GameTooltip:SetHyperlink(reward.link)
							end
							GameTooltip:Show()
						end)
						app.OrderAdjustments[v].reward[i]:SetScript("OnLeave", function()
							GameTooltip:Hide()
						end)
						app.OrderAdjustments[v].reward[i]:SetNormalTexture(reward.icon)
						app.OrderAdjustments[v].reward[i].Text:SetPoint("BOTTOMRIGHT", app.OrderAdjustments[v].reward[i], "BOTTOMRIGHT")
						if reward.count and reward.count > 1 then
							app.OrderAdjustments[v].reward[i].Text:SetText("|cffFFFFFF" .. reward.count)
						else
							app.OrderAdjustments[v].reward[i].Text:SetText("")
						end
					end

					-- Recipe icons
					if not app.OrderAdjustments[v].tracked then
						app.OrderAdjustments[v].tracked = v:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
						app.OrderAdjustments[v].tracked:SetJustifyH("RIGHT")
						app.OrderAdjustments[v].tracked:SetText(app.IconReady)

						app.OrderAdjustments[v].unlearned = v:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
						app.OrderAdjustments[v].unlearned:SetJustifyH("RIGHT")
						app.OrderAdjustments[v].unlearned:SetText(app.IconNotReady)

						app.OrderAdjustments[v].firstCraft = CreateFrame("Frame", nil, v)
						app.OrderAdjustments[v].firstCraft:SetSize(17, 23)
						local texture = app.OrderAdjustments[v].firstCraft:CreateTexture(nil, "ARTWORK")
						texture:SetAllPoints(app.OrderAdjustments[v].firstCraft)
						texture:SetAtlas("Professions_Icon_FirstTimeCraft", true)
					end

					app.OrderAdjustments[v].key = key
					app.OrderAdjustments[v].recipeID = data.option.spellID
					app.OrderAdjustments[v].tracked:SetPoint("RIGHT", v.cells[1], -10, 0)
					app.OrderAdjustments[v].unlearned:SetPoint("RIGHT", v.cells[1], -10, 0)
					app.OrderAdjustments[v].firstCraft:SetPoint("RIGHT", v.cells[1], -12, 0)
					app.OrderAdjustments[v].tracked:Hide()
					app.OrderAdjustments[v].unlearned:Hide()
					app.OrderAdjustments[v].firstCraft:Hide()

					if ProfessionShoppingList_Data.Recipes[key] then
						app.OrderAdjustments[v].tracked:Show()
					elseif not recipeInfo.learned then
						app.OrderAdjustments[v].unlearned:Show()
					elseif recipeInfo.firstCraft then
						app.OrderAdjustments[v].firstCraft:Show()
						app.OrderInfo[key].knowledge[app.OrderInfo[key].skillLineID] = (app.OrderInfo[key].knowledge[app.OrderInfo[key].skillLineID] or 0) + 1
					end
				end
				RunNextFrame(doTheThing)

				local originalOnClick = v:GetScript("OnClick")
				v:SetScript("OnClick", function(self, button, down)
					if IsShiftKeyDown() then
						if ProfessionShoppingList_Data.Recipes[key] then
							api:UntrackRecipe(key, 1)
						else
							api:TrackRecipe(data.option.spellID, 1, data.option.isRecraft, data.option.orderID)
						end
					else
						originalOnClick(self, button, down)
					end
				end)

				-- Fix "attempted to iterate a forbidden table" error when PlayerCastingBarFrame:IsAttachedToPlayerFrame() is enabled (thank you AcidWeb and Foxlit!)
				function ProfessionsFrame.OrdersPage.OrderView:SetOverrideCastBarActive() end
			end
		end

		ScrollUtil.AddInitializedFrameCallback(ProfessionsFrame.OrdersPage.BrowseFrame.OrderList.ScrollBox, OnFrameInitialized, nil, true)
	end
end)

app.Event:Register("TRADE_SKILL_CLOSE", function()
	if app.TrackOrdersSettings then app.TrackOrdersSettings:Hide() end
end)
