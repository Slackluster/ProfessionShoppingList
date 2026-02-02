--------------------------------------------------
-- Profession Shopping List: CraftingOrders.lua --
--------------------------------------------------

-- Initialisation
local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

-- When the addon is fully loaded, actually run the components
app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
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
			app:TrackRecipe(app.SelectedRecipe.PlaceOrder.recipeID, 1, app.SelectedRecipe.PlaceOrder.recraft)
		end)
	end

	-- Create the place crafting orders UI untrack button
	if not app.UntrackPlaceOrderButton then
		app.UntrackPlaceOrderButton = app:MakeButton(ProfessionsCustomerOrdersFrame.Form, L.UNTRACK)
		app.UntrackPlaceOrderButton:SetPoint("TOPLEFT", app.TrackPlaceOrderButton, "TOPRIGHT", 2, 0)
		app.UntrackPlaceOrderButton:SetScript("OnClick", function()
			app:UntrackRecipe(app.SelectedRecipe.PlaceOrder.recipeID, 1)

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
		app.QuickOrderTargetBox:SetPoint("CENTER", app.TrackPlaceOrderButton, "CENTER", 0, 0)
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
					if ProfessionShoppingList_Cache.ReagentTiers[reagentID].three ~= 0 then
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
		if ProfessionShoppingList_Settings["useLocalReagents"] then localReagentsOrder() end

		-- Signal that PSL is currently working on a quick order with tiered local reagents, if applicable
		local next = next
		if next(craftingReagentInfo) ~= nil and ProfessionShoppingList_Settings["useLocalReagents"] then
			app.Flag.QuickOrder = 2
		end

		local orderType = Enum.CraftingOrderType.Personal
		if ProfessionShoppingList_CharacterData.Orders[recipeID] == "GUILD" then
			orderType = Enum.CraftingOrderType.Guild
		end

		local orderInfo = { skillLineAbilityID = ProfessionShoppingList_Library[recipeID].abilityID, orderType = orderType, orderDuration = ProfessionShoppingList_Settings["quickOrderDuration"], tipAmount = 100, customerNotes = "", orderTarget = ProfessionShoppingList_CharacterData.Orders[recipeID], reagentInfos = reagentInfo, craftingReagentItems = craftingReagentInfo }
		C_CraftingOrders.PlaceNewOrder(orderInfo)
	end

	-- Create the place crafting orders personal order button
	if not app.QuickOrderButton then
		app.QuickOrderButton = app:MakeButton(ProfessionsCustomerOrdersFrame.Form, L.QUICKORDER)
		app.QuickOrderButton:SetPoint("CENTER", app.QuickOrderTargetBox, "CENTER", 0, 0)
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
		app.LocalReagentsCheckbox:SetPoint("BOTTOMLEFT", app.QuickOrderButton, "TOPLEFT", 0, 0)
		app.LocalReagentsCheckbox.Text:SetText(L.LOCALREAGENTS_LABEL)
		app.LocalReagentsCheckbox.tooltip = L.LOCALREAGENTS_TOOLTIP
		app.LocalReagentsCheckbox:SetScript("OnClick", function(self)
			ProfessionShoppingList_Settings["useLocalReagents"] = self:GetChecked()

			if ProfessionShoppingList_CharacterData.Orders["last"] ~= nil and ProfessionShoppingList_CharacterData.Orders["last"] ~= 0 then
				app.RepeatQuickOrderTooltip.Reagents = L.FALSE
				if ProfessionShoppingList_Settings["useLocalReagents"] then
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
		app.RepeatQuickOrderButton:SetText(recipeName)
		app.RepeatQuickOrderButton:SetWidth(app.RepeatQuickOrderButton:GetTextWidth()+20)
	end

	-- Create the repeat last crafting order button text
	app.RepeatQuickOrderTooltip.Text = L.QUICKORDER_REPEAT_TOOLTIP

	if ProfessionShoppingList_CharacterData.Orders["last"] ~= nil and ProfessionShoppingList_CharacterData.Orders["last"] ~= 0 and ProfessionShoppingList_CharacterData.Orders[ProfessionShoppingList_CharacterData.Orders["last"]] ~= nil then
		app.RepeatQuickOrderTooltip.Reagents = L.FALSE
		if ProfessionShoppingList_Settings["useLocalReagents"] then
			app.RepeatQuickOrderTooltip.Reagents = L.TRUE
		end
		app.RepeatQuickOrderTooltip.Text = L.QUICKORDER_REPEAT_TOOLTIP .. "\n" .. L.RECIPIENT .. ": " .. ProfessionShoppingList_CharacterData.Orders[ProfessionShoppingList_CharacterData.Orders["last"]] .. "\n" .. L.LOCALREAGENTS_LABEL .. ": " .. app.RepeatQuickOrderTooltip.Reagents
	end

	-- Set the flag for assets created to true
	app.Flag.CraftingOrderAssets = true
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
	if not InCombatLockdown() and app.SelectedRecipe.PlaceOrder.recraft and ProfessionShoppingList_Library[spellID] then
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
	if ProfessionShoppingList_Settings["removeCraft"] then
		for k, v in pairs(ProfessionShoppingList_Data.Recipes) do
			if tonumber(string.match(k, ":(%d+):")) == orderID then
				-- Remove 1 tracked recipe when it has been crafted (if the option is enabled)
				app:UntrackRecipe(k, 1)
				break
			end
		end

		-- Close window if no recipes are left and the option is enabled
		local next = next
		if next(ProfessionShoppingList_Data.Recipes) == nil and ProfessionShoppingList_Settings["closeWhenDone"] then
			app.Window:Hide()
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
			if ProfessionShoppingList_Settings["useLocalReagents"] then
				app.RepeatQuickOrderTooltip.Reagents = L.TRUE
			end
			app.RepeatQuickOrderTooltip.Text = L.QUICKORDER_REPEAT_TOOLTIP .. "\n" .. L.RECIPIENT .. ": " .. ProfessionShoppingList_CharacterData.Orders[ProfessionShoppingList_CharacterData.Orders["last"]] .. "\n" .. L.LOCALREAGENTS_LABEL .. ": " .. app.RepeatQuickOrderTooltip.Reagents
			recipeName = C_TradeSkillUI.GetRecipeSchematic(ProfessionShoppingList_CharacterData.Orders["last"], false).name
		end
		app.RepeatQuickOrderButton:SetText(recipeName)
		app.RepeatQuickOrderButton:SetWidth(app.RepeatQuickOrderButton:GetTextWidth()+20)

		if app.Flag.QuickOrder > 0 then
			app.Flag.QuickOrder = 0
		end
	end
end)

-----------------------
-- ORDER ADJUSTMENTS --
-----------------------

app.Event:Register("CRAFTINGORDERS_UPDATE_ORDER_COUNT", function(orderType, numOrders)
	if ProfessionShoppingList_Settings["enhancedOrders"] and numOrders >= 1 then
		if not app.OrderAdjustments then app.OrderAdjustments = {} end
		if not app.OrderIcons then app.OrderIcons = {} end

		local function OnFrameInitialized(_, v, data)
			local function doTheThing()
				if data and v and v.cells and not C_AddOns.IsAddOnLoaded("PublicOrdersReagentsColumn") then	-- Don't interfere with No Mats, No Make
					if not data.option or not data.option.orderID then return end

					local key = "order:" .. data.option.orderID .. ":" .. data.option.spellID
					if not app.OrderAdjustments[v] then app.OrderAdjustments[v] = {} end

					-- Order profit
					if C_AddOns.IsAddOnLoaded("Auctionator") then	-- Requires Auctionator
						v.cells[3].TipMoneyDisplayFrame:Hide()

						local calculations = {}
						local reagents = {}

						ProfessionShoppingList_Cache.FakeRecipes[key] = {
							["spellID"] = data.option.spellID,
							["tradeskillID"] = 1,	-- Crafting order
							["reagents"] = data.option.reagents
						}
						app:GetReagents(reagents, key, 1, false)

						-- Grab the costs for crafting this order
						local needScan = false
						for reagentID, quantity in pairs(reagents) do
							if quantity > 0 then
								local prices = {}
								table.insert(prices, Auctionator.API.v1.GetAuctionPriceByItemID(app.Name, reagentID))
								if ProfessionShoppingList_Cache.ReagentTiers[reagentID].one then
									table.insert(prices, Auctionator.API.v1.GetAuctionPriceByItemID(app.Name, ProfessionShoppingList_Cache.ReagentTiers[reagentID].one))
								end
								if ProfessionShoppingList_Cache.ReagentTiers[reagentID].two then
									table.insert(prices, Auctionator.API.v1.GetAuctionPriceByItemID(app.Name, ProfessionShoppingList_Cache.ReagentTiers[reagentID].two))
								end
								if ProfessionShoppingList_Cache.ReagentTiers[reagentID].three then
									table.insert(prices, Auctionator.API.v1.GetAuctionPriceByItemID(app.Name, ProfessionShoppingList_Cache.ReagentTiers[reagentID].three))
								end

								local _, itemLink, _, _, _, _, _, _, _, fileID, _, _, _, bindType = C_Item.GetItemInfo(reagentID)
								if not itemLink then
									app:CacheItem(reagentID)
									C_Timer.After(0.1, doTheThing)
									return
								end

								local min = 100000000
								for _, value in ipairs(prices) do
									if value < min then
										min = value
									end
								end

								if bindType ~= 0 then min = 0 end
								if min == 100000000 then needScan = true end

								itemLink = itemLink:gsub("%s*|A:.-|a%s*", "")
								table.insert(calculations, {type = "cost", icon = fileID, link = itemLink, quantity = quantity, amount = min * quantity})
							end
						end

						-- Grab the rewards for crafting this order
						table.insert(calculations, {type = "reward", icon = 133785, link = PROFESSIONS_COLUMN_HEADER_TIP, quantity = 0, amount = math.floor((data.option.tipAmount - data.option.consortiumCut) / 100 + 0.5) * 100})
						for k, reward in pairs(data.option.npcOrderRewards) do
							local _, itemLink, _, _, _, _, _, _, _, fileID = C_Item.GetItemInfo(reward.itemLink)
							if not itemLink then
								local itemID = C_Item.GetItemInfoInstant(reward.itemLink)
								app:CacheItem(itemID)
								C_Timer.After(1, doTheThing)
								return
							end
							table.insert(calculations, {type = "reward", icon = fileID, link = itemLink, quantity = 0, amount = Auctionator.API.v1.GetAuctionPriceByItemLink(app.Name, itemLink)})
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
						local roundedCommissionResult = math.floor((commissionResult + (commissionResult >= 0 and 5000 or -5000)) / 10000) * 10000
						local _, itemLink = C_Item.GetItemInfo(data.option.itemID)

						-- Replace the commission price text with an actual profit calculation
						if not app.OrderAdjustments[v].rewardText then
							app.OrderAdjustments[v].rewardText = v:CreateFontString(nil, "ARTWORK", "GameFontNormal")
							app.OrderAdjustments[v].rewardText:SetJustifyH("RIGHT")
						end
						app.OrderAdjustments[v].rewardText:SetPoint("TOPLEFT", v.cells[3])
						app.OrderAdjustments[v].rewardText:SetPoint("BOTTOMRIGHT", v.cells[3], 10, 0)

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
									GameTooltip:AddDoubleLine(app.IconPSL .. " " .. TOTAL, C_CurrencyInfo.GetCoinTextureString(commissionResult))
								else
									GameTooltip:AddDoubleLine(app.IconPSL .. " " .. TOTAL, "|cffFF0000- " .. C_CurrencyInfo.GetCoinTextureString(-commissionResult))
								end
								GameTooltip:AddLine(" ")

								-- Costs
								for _, entry in ipairs(calculations) do
									if entry.type == "cost" then
										GameTooltip:AddDoubleLine("|T"..entry.icon..":0|t " .. entry.link .. " ×" .. entry.quantity , "|cffFF0000- " .. C_CurrencyInfo.GetCoinTextureString(entry.amount))
									end
								end
								GameTooltip:AddLine(" ")

								-- Rewards
								for _, entry in ipairs(calculations) do
									if entry.type == "reward" and entry.amount then
										GameTooltip:AddDoubleLine("|T"..entry.icon..":0|t " .. entry.link, C_CurrencyInfo.GetCoinTextureString(entry.amount))
									elseif entry.type == "reward" then
										GameTooltip:AddDoubleLine("|T"..entry.icon..":0|t " .. entry.link, "-")
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
						local _, itemLink, _, _, _, _, _, _, _, fileID = C_Item.GetItemInfo(reward.itemLink)
						if not itemLink then
							local itemID = C_Item.GetItemInfoInstant(reward.itemLink)
							app:CacheItem(itemID)
							C_Timer.After(1, doTheThing)
							return
						end
						table.insert(rewards, {icon = fileID, link = itemLink, count = reward.count})
					end

					if not app.OrderAdjustments[v].button then app.OrderAdjustments[v].button = {} end

					for i, button in pairs(app.OrderAdjustments[v].button) do
						button:Hide()
					end

					for i, reward in ipairs(rewards) do
						if not app.OrderAdjustments[v].button[i] then
							app.OrderAdjustments[v].button[i] = CreateFrame("Button", "RewardButton", v, "UIPanelButtonTemplate")
							app.OrderAdjustments[v].button[i]:SetWidth(20)
							app.OrderAdjustments[v].button[i]:SetHeight(20)
							app.OrderAdjustments[v].button[i]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
							app.OrderAdjustments[v].button[i].Text = app.OrderAdjustments[v].button[i]:CreateFontString(nil, "ARTWORK", "GameFontNormalOutline")
							app.OrderAdjustments[v].button[i].Text:SetJustifyH("RIGHT")
							app.OrderAdjustments[v].button[i].Text:SetTextScale(0.9)
						end
						app.OrderAdjustments[v].button[i]:Show()
						app.OrderAdjustments[v].button[i]:SetPoint("BOTTOMLEFT", v.cells[3], "BOTTOMLEFT", -44+i*22, 0)
						app.OrderAdjustments[v].button[i]:SetScript("OnEnter", function(self)
							GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
							if i == 1 then
								GameTooltip:SetText(reward.link)
							else
								GameTooltip:SetHyperlink(reward.link)
							end
							GameTooltip:Show()
						end)
						app.OrderAdjustments[v].button[i]:SetScript("OnLeave", function()
							GameTooltip:Hide()
						end)
						app.OrderAdjustments[v].button[i]:SetNormalTexture(reward.icon)
						app.OrderAdjustments[v].button[i].Text:SetPoint("BOTTOMRIGHT", app.OrderAdjustments[v].button[i], "BOTTOMRIGHT", 0, 0)
						if reward.count and reward.count > 1 then
							app.OrderAdjustments[v].button[i].Text:SetText("|cffFFFFFF" .. reward.count)
						else
							app.OrderAdjustments[v].button[i].Text:SetText("")
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
					elseif not C_TradeSkillUI.GetRecipeInfo(data.option.spellID).learned then
						app.OrderAdjustments[v].unlearned:Show()
					elseif C_TradeSkillUI.GetRecipeInfo(data.option.spellID).firstCraft then
						app.OrderAdjustments[v].firstCraft:Show()
					end
				end
			end

			-- Run our function twice, because gah loading times and shit
			doTheThing()
			C_Timer.After(1, doTheThing)
			C_Timer.After(2, doTheThing)
		end

		ScrollUtil.AddInitializedFrameCallback(ProfessionsFrame.OrdersPage.BrowseFrame.OrderList.ScrollBox, OnFrameInitialized, nil, true)
	end
end)
