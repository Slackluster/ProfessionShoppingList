----------------------------------------------------
-- Profession Shopping List: ProfessionWindow.lua --
----------------------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Data.Pets = app.Data.Pets or {}
	end
end)

-----------------------
-- PROFESSION WINDOW --
-----------------------

function app:CreateTradeskillAssets()
	if app.Flag.TradeskillAssets then return end

	ProfessionsFrame.CraftingPage.SchematicForm.TrackRecipeCheckbox:SetAlpha(0)
	ProfessionsFrame.CraftingPage.SchematicForm.TrackRecipeCheckbox:EnableMouse(false)
	if app.Retail then
		ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.TrackRecipeCheckbox:SetAlpha(0)
		ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.TrackRecipeCheckbox:EnableMouse(false)
	end

	app.TrackProfessionButton = app:MakeButton(ProfessionsFrame.CraftingPage, L.TRACK)
	if app.Retail then
		app.TrackProfessionButton:SetPoint("TOPRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, -5, -6)
	elseif app.Forever then
		app.TrackProfessionButton:SetPoint("TOPRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, -7, -8)
	end
	app.TrackProfessionButton:SetScript("OnClick", function()
		api:TrackRecipe(app.SelectedRecipe.Profession.recipeID, 1, app.SelectedRecipe.Profession.recraft)
	end)

	local function ebRecipeQuantityUpdate(self, newValue)
		newValue = math.floor(self:GetNumber())
		if newValue >= 0 then
			api:UntrackRecipe(app.SelectedRecipe.Profession.recipeID, 0)
			if newValue > 0 then
				api:TrackRecipe(app.SelectedRecipe.Profession.recipeID, newValue, app.SelectedRecipe.Profession.recraft)
			end
		end
	end
	app.RecipeQuantityBox = CreateFrame("EditBox", nil, ProfessionsFrame.CraftingPage, "InputBoxTemplate")
	app.RecipeQuantityBox:SetSize(25,20)
	app.RecipeQuantityBox:SetPoint("CENTER", app.TrackProfessionButton, "CENTER")
	app.RecipeQuantityBox:SetPoint("RIGHT", app.TrackProfessionButton, "LEFT", -4, 0)
	app.RecipeQuantityBox:SetAutoFocus(false)
	app.RecipeQuantityBox:SetText(0)
	app.RecipeQuantityBox:SetCursorPosition(0)
	app.RecipeQuantityBox:SetScript("OnEditFocusGained", function(self, newValue)
		self:HighlightText()
		app.TrackProfessionButton:Disable()
		app.UntrackProfessionButton:Disable()
	end)
	app.RecipeQuantityBox:SetScript("OnEditFocusLost", function(self, newValue)
		ebRecipeQuantityUpdate(self, newValue)
		app.TrackProfessionButton:Disable()
		app.UntrackProfessionButton:Disable()
		C_Timer.After(1, function()
			app.TrackProfessionButton:Enable()
			if type(newValue) == "number" and newValue >= 1 then
				app.UntrackProfessionButton:Enable()
			end
		end)
	end)
	app.RecipeQuantityBox:SetScript("OnEnterPressed", function(self, newValue)
		ebRecipeQuantityUpdate(self, newValue)
		self:ClearFocus()
	end)
	app.RecipeQuantityBox:SetScript("OnEscapePressed", function(self, newValue)
		self:SetText(app.Data.Recipes[app.SelectedRecipe.Profession.recipeID].quantity)
		self:ClearFocus()
	end)
	app:SetBorder(app.RecipeQuantityBox, -6, 1, 2, -2)

	app.UntrackProfessionButton = app:MakeButton(ProfessionsFrame.CraftingPage, L.UNTRACK)
	app.UntrackProfessionButton:SetPoint("TOP", app.TrackProfessionButton, "TOP")
	app.UntrackProfessionButton:SetPoint("RIGHT", app.RecipeQuantityBox, "LEFT", -8, 0)
	app.UntrackProfessionButton:SetFrameStrata("HIGH")
	app.UntrackProfessionButton:SetScript("OnClick", function()
		api:UntrackRecipe(app.SelectedRecipe.Profession.recipeID, 1)
		app:ShowWindow()
	end)

	app.RecipeDifficultyText = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString(nil, "ARTWORK", "SystemFont_Shadow_Med2_Outline")
	app.RecipeDifficultyText:SetPoint("RIGHT", app.UntrackProfessionButton, "LEFT", 0, 0)
	app.RecipeDifficultyText:SetJustifyH("RIGHT")
	app.RecipeDifficultyText:Hide()

	local function makeButton(textureFile, tooltipText)
		local frame = CreateFrame("Button", nil, ProfessionsFrame.CraftingPage, "SecureActionButtonTemplate")
		frame:SetWidth(40)
		frame:SetHeight(40)
		frame:SetNormalTexture(textureFile)
		frame:GetNormalTexture():SetDesaturated(true)
		frame:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		frame:SetFrameStrata("HIGH")
		frame:RegisterForClicks("AnyDown", "AnyUp")
		frame:Hide()
		frame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(tooltipText())
			GameTooltip:Show()
		end)
		frame:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		app:SetBorder(frame, -1, 2, 2, -1)
		return frame
	end

	local function makeCooldownFrame(parentButton)
		local frame = CreateFrame("Cooldown", nil, parentButton, "CooldownFrameTemplate")
		frame:SetAllPoints(parentButton)

		return frame
	end

	app.CookingFireButton = makeButton(135805, function() return app.IconLMB .. "|cffFFFFFF: " .. (C_Spell.GetSpellInfo(818).name or "") .. "\n" .. app.IconRMB .. ": " .. L.TARGET end)
	app.CookingFireButton:SetPoint("BOTTOMRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMRIGHT", -5, 4)
	app.CookingFireButton:SetAttribute("type", "spell")
	app.CookingFireButton:SetAttribute("spell1", 818)
	app.CookingFireButton:SetAttribute("unit1", "player")
	app.CookingFireButton:SetAttribute("spell2", 818)
	app.CookingFireButton.Cooldown = makeCooldownFrame(app.CookingFireButton)

	if app.Retail then
		app.ShadowlandsRankBox = CreateFrame("EditBox", nil, ProfessionsFrame.CraftingPage, "InputBoxTemplate")
		app.ShadowlandsRankBox:SetSize(25,20)
		app.ShadowlandsRankBox:SetPoint("CENTER", app.RecipeQuantityBox, "CENTER")
		app.ShadowlandsRankBox:SetPoint("TOP", app.RecipeQuantityBox, "BOTTOM", 0, -4)
		app.ShadowlandsRankBox:SetAutoFocus(false)
		app.ShadowlandsRankBox:SetCursorPosition(0)
		app.ShadowlandsRankBox:Hide()
		app:SetBorder(app.ShadowlandsRankBox, -6, 1, 2, -2)

		app.ShadowlandsRankText = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		app.ShadowlandsRankText:SetPoint("RIGHT", app.ShadowlandsRankBox, "LEFT", -10, 0)
		app.ShadowlandsRankText:SetJustifyH("LEFT")
		app.ShadowlandsRankText:SetText(L.RANK .. ":")
		app.ShadowlandsRankText:Hide()

		app.TrackNewMogsButton = app:MakeButton(ProfessionsFrame.CraftingPage, L.TRACK_NEW)
		app.TrackNewMogsButton:SetPoint("TOPLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 0, -4)
		app.TrackNewMogsButton:SetFrameStrata("HIGH")
		app.TrackNewMogsButton:SetScript("OnClick", function()
			app:TrackUnlearnedMogs()
		end)
		app.TrackNewMogsButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L.CURRENT_SETTING .. " " .. (app.Settings.collectMode == 1 and L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES))
			GameTooltip:Show()
		end)
		app.TrackNewMogsButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		if ((C_AddOns.IsAddOnLoaded("CraftScan") or C_AddOns.IsAddOnLoaded("TestFlight")) and app.Flag.IsAuctionAddonLoaded)
		or C_AddOns.IsAddOnLoaded("Mass_Salvage_Assist") then
			app.TrackNewMogsButton:ClearAllPoints()
			app.TrackNewMogsButton:SetPoint("CENTER", app.UntrackProfessionButton, "CENTER")
			app.TrackNewMogsButton:SetPoint("RIGHT", app.UntrackProfessionButton, "LEFT", -3, 0)
		end

		app.ChefsHatButton = makeButton(236571, function() return app.IconLMB .. "|cffFFFFFF: " .. (C_Item.GetItemInfo(134020) or "") end)
		app.ChefsHatButton:SetPoint("BOTTOMRIGHT", app.CookingFireButton, "BOTTOMLEFT", -3, 0)
		app.ChefsHatButton:SetAttribute("type1", "toy")
		app.ChefsHatButton:SetAttribute("toy", 134020)
		app.ChefsHatButton.Cooldown = makeCooldownFrame(app.ChefsHatButton)

		app.ThermalAnvilButton = makeButton(136241, function() return app.IconLMB .. "|cffFFFFFF: " .. (C_Item.GetItemInfo(87216) or "") end)
		app.ThermalAnvilButton:SetPoint("BOTTOMRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMRIGHT", -5, 4)
		app.ThermalAnvilButton:SetAttribute("type1", "macro")
		app.ThermalAnvilButton:SetAttribute("macrotext1", "/use item:87216")
		app.ThermalAnvilButton.Cooldown = makeCooldownFrame(app.ThermalAnvilButton)
		app.ThermalAnvilButton.Charges = app.ThermalAnvilButton:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		app.ThermalAnvilButton.Charges:SetPoint("BOTTOMRIGHT", app.ThermalAnvilButton, "BOTTOMRIGHT")
		app.ThermalAnvilButton.Charges:SetJustifyH("RIGHT")
		app.ThermalAnvilButton.Charges:SetText(C_Item.GetItemCount(87216, false, true, false, false) or 0)

		app.AlvinButton = makeButton(1020356, function() return app.IconLMB .. "|cffFFFFFF: " .. (C_Item.GetItemInfo(191886) or "") end)
		app.AlvinButton:SetPoint("BOTTOMRIGHT", app.ThermalAnvilButton, "BOTTOMLEFT", -3, 0)
		app.AlvinButton.Cooldown = makeCooldownFrame(app.AlvinButton)

		app.RagnarosButton = makeButton(254652, function() return app.IconLMB .. "|cffFFFFFF: " .. (C_Item.GetItemInfo(68385) or "") .. "\n" .. app.IconRMB .. ": " .. L.SWITCH_AVAILABLE_PETS end)
		app.RagnarosButton:SetPoint("BOTTOMRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMRIGHT", -5, 4)
		app.RagnarosButton.Cooldown = makeCooldownFrame(app.RagnarosButton)

		app.PierreButton = makeButton(798062, function() return app.IconLMB .. "|cffFFFFFF: " .. (C_Item.GetItemInfo(94903) or "") .. "\n" .. app.IconRMB .. ": " .. L.SWITCH_AVAILABLE_PETS end)
		app.PierreButton:SetPoint("BOTTOMRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMRIGHT", -5, 4)
		app.PierreButton.Cooldown = makeCooldownFrame(app.PierreButton)

		app.LightforgeButton = makeButton(1723995, function() return app.IconLMB .. "|cffFFFFFF: " .. C_Spell.GetSpellInfo(259930).name end)
		app.LightforgeButton:SetPoint("BOTTOMRIGHT", app.AlvinButton, "BOTTOMLEFT", -3, 0)
		app.LightforgeButton:SetAttribute("type", "spell")
		app.LightforgeButton:SetAttribute("spell", 259930)
		app.LightforgeButton.Cooldown = makeCooldownFrame(app.LightforgeButton)

		for i = 1, 12 do
			local line = "RecipeInformation" .. string.format("%02d", i)
			local prevLine = "RecipeInformation" .. string.format("%02d", i - 1)
			app[line] = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			if i == 1 then
				app[line]:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, 20, 20)
			else
				app[line]:SetPoint("BOTTOMLEFT", app[prevLine], "TOPLEFT", 0, 3)
			end
			app[line]:SetPoint("RIGHT", ProfessionsFrame.CraftingPage.SchematicForm, -20, 0)
			app[line]:SetTextColor(WHITE_FONT_COLOR.r, WHITE_FONT_COLOR.g, WHITE_FONT_COLOR.b)
			app[line]:SetJustifyH("LEFT")
			app[line]:SetIndentedWordWrap(true)
		end

		Menu.ModifyMenu("MENU_PROFESSIONS_CRAFTER_ORDER", function(ownerRegion, rootDescription, contextData)
			rootDescription:CreateDivider()

			local key = "order:" .. ownerRegion.rowData.option.orderID .. ":" .. ownerRegion.rowData.option.spellID
			if app.Data.Recipes[key] then
				rootDescription:CreateButton(CreateSimpleTextureMarkup(app.Icon) .. " " .. app:Colour(L.UNTRACK), function()
					api:UntrackRecipe(key, 1)
				end)
			else
				rootDescription:CreateButton(CreateSimpleTextureMarkup(app.Icon) .. " " .. app:Colour(L.TRACK), function()
					api:TrackRecipe(ownerRegion.rowData.option.spellID, 1, ownerRegion.rowData.option.isRecraft, ownerRegion.rowData.option.orderID)
				end)
			end
		end)

		hooksecurefunc(ProfessionsFrame.OrdersPage, "ViewOrder", function(_, orderDetails) -- Thank you, Plusmouse!
			app.SelectedRecipe.MakeOrder = orderDetails
			app:UpdateAssets()
		end)

		app.TrackMakeOrderButton = app:MakeButton(ProfessionsFrame.OrdersPage.OrderView.OrderDetails, L.TRACK)
		app.TrackMakeOrderButton:SetPoint("TOPRIGHT", ProfessionsFrame.OrdersPage.OrderView.OrderDetails, "TOPRIGHT", -9, -10)
		app.TrackMakeOrderButton:SetScript("OnClick", function()
			local key = "order:" .. app.SelectedRecipe.MakeOrder.orderID .. ":" .. app.SelectedRecipe.MakeOrder.spellID
			if app.Data.Recipes[key] then
				api:UntrackRecipe(key, 1)
				app:UpdateButton(app.TrackMakeOrderButton, L.TRACK)
				app:ShowWindow()
			else
				api:TrackRecipe(app.SelectedRecipe.MakeOrder.spellID, 1, app.SelectedRecipe.MakeOrder.isRecraft, app.SelectedRecipe.MakeOrder.orderID)
				app:UpdateButton(app.TrackMakeOrderButton, L.UNTRACK)
			end
		end)

		if C_AddOns.IsAddOnLoaded("TestFlight") then
			TestFlight.GUI.OrdersPage.SetOrderTracked = function(_, orderDetails, checked)
				local key = "order:" .. orderDetails.orderID .. ":" .. orderDetails.spellID
				if not checked and app.Data.Recipes[key] then
					api:UntrackRecipe(key, 1)
					app:ShowWindow()
				elseif checked and app.Data.Recipes[key] == nil then
					api:TrackRecipe(orderDetails.spellID, 1, orderDetails.isRecraft, orderDetails.orderID)
				end
			end
		end

		ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount:SetPoint("TOPLEFT", ProfessionsFrame.CraftingPage.ConcentrationDisplay.Icon, "TOPRIGHT", 6, 0)
		app.Concentration1 = ProfessionsFrame.CraftingPage.ConcentrationDisplay:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		app.Concentration1:SetPoint("TOPLEFT", ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount, "BOTTOMLEFT")
		app.Concentration1:SetJustifyH("LEFT")

		ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay.Amount:SetPoint("TOPLEFT", ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay.Icon, "TOPRIGHT", 6, 0)
		app.Concentration2 = ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		app.Concentration2:SetPoint("TOPLEFT", ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay.Amount, "BOTTOMLEFT")
		app.Concentration2:SetJustifyH("LEFT")
	end

	app.Flag.TradeskillAssets = true
end

function app:UpdateAssets()
	if InCombatLockdown() then return end

	if app.Flag.TradeskillAssets then
		if app.SelectedRecipe.Profession.recipeType == 1 or app.SelectedRecipe.Profession.recipeType == 3 then
			app.TrackProfessionButton:Enable()
			app.RecipeQuantityBox:Enable()
		end

		if app.SelectedRecipe.Profession.recipeType == 2 or C_TradeSkillUI.GetRecipeSchematic(app.SelectedRecipe.Profession.recipeID,false).reagentSlotSchematics[1] == nil then
			app.TrackProfessionButton:Disable()
			app.UntrackProfessionButton:Disable()
			app.RecipeQuantityBox:Disable()
		end

		if not app.Data.Recipes[app.SelectedRecipe.Profession.recipeID] or app.Data.Recipes[app.SelectedRecipe.Profession.recipeID].quantity == 0 then
			app.UntrackProfessionButton:Disable()
		else
			app.UntrackProfessionButton:Enable()
		end

		if app.Data.Recipes[app.SelectedRecipe.Profession.recipeID] then
			app.RecipeQuantityBox:SetText(app.Data.Recipes[app.SelectedRecipe.Profession.recipeID].quantity or 0)
		else
			app.RecipeQuantityBox:SetText(0)
		end

		if app.Retail then
			if app.SelectedRecipe.MakeOrder.orderID and app.SelectedRecipe.MakeOrder.spellID then
				if app.SelectedRecipe.MakeOrder.spellID and C_TradeSkillUI.GetRecipeInfo(app.SelectedRecipe.MakeOrder.spellID).learned then
					app.TrackMakeOrderButton:Enable()
				else
					app.TrackMakeOrderButton:Disable()
				end

				local key = "order:" .. app.SelectedRecipe.MakeOrder.orderID .. ":" .. app.SelectedRecipe.MakeOrder.spellID
				if app.Data.Recipes[key] then
					app:UpdateButton(app.TrackMakeOrderButton, L.UNTRACK)
				else
					app:UpdateButton(app.TrackMakeOrderButton, L.TRACK)
				end
			end

			if PlayerHasToy(134020) then
				app.ChefsHatButton:GetNormalTexture():SetDesaturated(false)
			end

			if not C_Item.IsItemDataCachedByID(87216) then local item = Item:CreateFromItemID(87216) end
			local anvilCount = C_Item.GetItemCount(87216, false, false, false, false) or 0
			if anvilCount >= 1 then
				app.ThermalAnvilButton:GetNormalTexture():SetDesaturated(false)
			else
				app.ThermalAnvilButton:GetNormalTexture():SetDesaturated(true)
			end
			local anvilCharges = C_Item.GetItemCount(87216, false, true, false, false) or 0
			app.ThermalAnvilButton.Charges:SetText(anvilCharges)
		end

		local cooldown = C_Spell.GetSpellCooldown(818)
		app.CookingFireButton.Cooldown:SetCooldown(cooldown.startTime, cooldown.duration)

		if app.Retail then
			local startTime, duration = C_Item.GetItemCooldown(134020)
			app.ChefsHatButton.Cooldown:SetCooldown(startTime, duration)

			startTime, duration = C_Item.GetItemCooldown(87216)
			app.ThermalAnvilButton.Cooldown:SetCooldown(startTime, duration)

			if app.Data.Pets.ragnaros and C_PetJournal.PetIsSummonable(app.Data.Pets.ragnaros.guid) then
				app.RagnarosButton:GetNormalTexture():SetDesaturated(false)
			end
			if app.Data.Pets.pierre and C_PetJournal.PetIsSummonable(app.Data.Pets.pierre.guid) then
				app.PierreButton:GetNormalTexture():SetDesaturated(false)
			end
			if app.Data.Pets.alvin and C_PetJournal.PetIsSummonable(app.Data.Pets.alvin.guid) then
				app.AlvinButton:GetNormalTexture():SetDesaturated(false)
			end

			cooldown = C_Spell.GetSpellCooldown(61304)
			app.AlvinButton.Cooldown:SetCooldown(cooldown.startTime, cooldown.duration)
			app.RagnarosButton.Cooldown:SetCooldown(cooldown.startTime, cooldown.duration)
			app.PierreButton.Cooldown:SetCooldown(cooldown.startTime, cooldown.duration)

			cooldown = C_Spell.GetSpellCooldown(259930)
			app.LightforgeButton.Cooldown:SetCooldown(cooldown.startTime, cooldown.duration)
		end
	end

	if app.Flag.CraftingOrderAssets then
		if app.SelectedRecipe.PlaceOrder.recraft and app.SelectedRecipe.PlaceOrder.recipeID == 0 then
			app.TrackPlaceOrderButton:Disable()
		else
			app.TrackPlaceOrderButton:Enable()
		end

		if not app.Data.Recipes[app.SelectedRecipe.PlaceOrder.recipeID] or app.Data.Recipes[app.SelectedRecipe.PlaceOrder.recipeID].quantity == 0 then
			app.UntrackPlaceOrderButton:Disable()
		else
			app.UntrackPlaceOrderButton:Enable()
		end

		if app.CharData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] == "" then
			app.CharData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] = nil
		end

		if app.Library[app.SelectedRecipe.PlaceOrder.recipeID] and app.CharData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] then
			app.QuickOrderButton:Enable()
		else
			app.QuickOrderButton:Disable()
		end

		if app.CharData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] then
			app.QuickOrderTargetBox:SetText(app.CharData.Orders[app.SelectedRecipe.PlaceOrder.recipeID])
		else
			app.QuickOrderTargetBox:SetText("")
		end
	end

	if app.OrderAdjustments then
		for _, row in pairs(app.OrderAdjustments) do
			if row.tracked then
				row.tracked:Hide()
				row.unlearned:Hide()
				row.firstCraft:Hide()

				if app.Data.Recipes[row.key] then
					row.tracked:Show()
				elseif not C_TradeSkillUI.GetRecipeInfo(row.recipeID).learned then
					row.unlearned:Show()
				elseif C_TradeSkillUI.GetRecipeInfo(row.recipeID).firstCraft then
					row.firstCraft:Show()
				end
			end
		end
	end
end

app.Event:Register("TRADE_SKILL_SHOW", function()
	if InCombatLockdown() or not C_AddOns.IsAddOnLoaded("Blizzard_Professions") then return end

	app:CreateTradeskillAssets()

	if app.Settings.filterOptionalReagents then
		function Professions.GenerateItemsFromEligibleItemSlots(reagents, filterAvailable)
			local items = {}
			local maxFindCount = 1
			for index, reagent in ipairs(Professions.FilterReagentsByItemID(reagents)) do
				local itemID = reagent.itemID
				local foundItems = Professions.FindItemsInInventorySlots(itemID, maxFindCount)
				if not app.Settings.filterOptionalReagents or not filterAvailable or (itemID ~= 247719 and itemID ~= 247725 and itemID ~= 260630) then
					tAppendAll(items, foundItems)
				end

				if not filterAvailable and #foundItems == 0 then
					table.insert(items, Item:CreateFromItemID(itemID))
				end
			end
			return items
		end
	end

	local function getGUID(id, name)
		if not app.Data.Pets[name] then
			for i=1, 9999 do
				local petID, speciesID = C_PetJournal.GetPetInfoByIndex(i)
				if speciesID == id and petID then
					app.Data.Pets[name] = {guid = petID, enabled = true}
					break
				elseif speciesID == nil then
					break
				end
			end
		end
	end
	getGUID(297, "ragnaros")
	getGUID(1204, "pierre")
	getGUID(3274, "alvin")

	if app.Flag.TradeskillAssets and app.Retail then
		if app.Data.Pets.alvin then
			app.AlvinButton:SetAttribute("type1", "macro")
			app.AlvinButton:SetAttribute("macrotext1", "/run C_PetJournal.SummonPetByGUID(\"" .. app.Data.Pets.alvin.guid .. "\")")
		end

		if app.Data.Pets.ragnaros then
			app.RagnarosButton:SetAttribute("type1", "macro")
			app.RagnarosButton:SetAttribute("macrotext1", "/run C_PetJournal.SummonPetByGUID(\"" .. app.Data.Pets.ragnaros.guid .. "\")")
			app.RagnarosButton:SetAttribute("type2", "macro")
			app.RagnarosButton:SetAttribute("macrotext2", "/run ProfessionShoppingList:SwapCookingPet()")
		end

		if app.Data.Pets.pierre then
			app.PierreButton:SetAttribute("type1", "macro")
			app.PierreButton:SetAttribute("macrotext1", "/run C_PetJournal.SummonPetByGUID(\"" .. app.Data.Pets.pierre.guid .. "\")")
			app.PierreButton:SetAttribute("type2", "macro")
			app.PierreButton:SetAttribute("macrotext2", "/run ProfessionShoppingList:SwapCookingPet()")
		end

		C_Timer.After(1, function()
			if ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount:GetText() then
				local concentration = string.match(ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount:GetText(), "%d+")
				if concentration then
					local timeLeft = math.ceil((1000 - concentration) / 250 * 24) -- 250 Concentration per 24 hours
					app.Concentration1:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r " .. timeLeft .. L.HOURS)
					app.Concentration2:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r " .. timeLeft .. L.HOURS)
				else
					app.Concentration1:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r ?")
					app.Concentration2:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r ?")
				end
			end
		end)
	end
end)

function api:SwapCookingPet()
	assert(self == api, "Call ProfessionShoppingList:SwapCookingPet(), not ProfessionShoppingList.SwapCookingPet()")
	if InCombatLockdown() or not app.Retail then return end

	if app.Data.Pets.ragnaros and app.Data.Pets.pierre then
		if app.Data.Pets.ragnaros.enabled then
			app.Data.Pets.ragnaros.enabled = false
			app.RagnarosButton:Hide()
			app.Data.Pets.pierre.enabled = true
			app.PierreButton:Show()
		else
			app.Data.Pets.ragnaros.enabled = true
			app.RagnarosButton:Show()
			app.Data.Pets.pierre.enabled = false
			app.PierreButton:Hide()
		end
	end
end

EventRegistry:RegisterCallback("ProfessionsRecipeListMixin.Event.OnRecipeSelected", function(_, recipeInfo)
	if InCombatLockdown() or not app.Flag.TradeskillAssets then return end

	local recipeID = recipeInfo.recipeID
	local recipeDif = app.RecipeDifficulty[recipeID]
	if recipeDif and recipeDif.trivial ~= 1 then
		app.RecipeDifficultyText:SetText("|cffFF8040" .. (recipeDif.optimal or "")  .. "|r |cffFFFF00" .. (recipeDif.medium or "")  .. "|r |cff40BF40" .. (recipeDif.easy or "")  .. "|r |cff808080" .. (recipeDif.trivial or "")  .. "|r")
		app.RecipeDifficultyText:Show()
	else
		app.RecipeDifficultyText:Hide()
	end

	if app.Retail then
		local function setRecipeInformation()
			local function item(itemID, colon)
				local _, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemID)
				if not itemLink then
					Item:CreateFromItemID(itemID):ContinueOnItemLoad(setRecipeInformation)
					return ""
				end
				return " " .. CreateSimpleTextureMarkup(itemTexture) .. itemLink:gsub(" |A:Professions%-ChatIcon%-Quality%-.-|a", "") .. ((colon and HEADER_COLON .. " ") or " ")
			end

			for i = 1, 12 do
				local line = "RecipeInformation" .. string.format("%02d", i)
				app[line]:SetText("")
			end

			if recipeID == 430315 then -- The War Within Thaumaturgy
				app.RecipeInformation04:SetText(app:Colour(L.THAUMATURGY_INFORMATION))
				app.RecipeInformation03:SetText(item(211803, true) .. item(210933) .. item(212667) .. item(210799) .. item(210802))
				app.RecipeInformation02:SetText(item(211802, true) .. item(210930) .. item(210796) .. item(219946) .. item(228231))
				app.RecipeInformation01:SetText(item(211804, true) .. item(210808) .. item(210805) .. item(210936) .. item(212664))
			elseif recipeID == 1269575 then -- Midnight Milling
				app.RecipeInformation05:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation04:SetText(item(245803, true) .. item(236776))
				app.RecipeInformation03:SetText(item(245866, true) .. item(236778))
				app.RecipeInformation02:SetText(item(245864, true) .. item(236770))
				app.RecipeInformation01:SetText(item(245807, true) .. item(236761))
			elseif recipeID == 444181 then -- The War Within Milling
				app.RecipeInformation05:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation04:SetText(item(224803, true) .. item(210805))
				app.RecipeInformation03:SetText(item(222612, true) .. item(210799))
				app.RecipeInformation02:SetText(item(224800, true) .. item(210802))
				app.RecipeInformation01:SetText(item(222618, true) .. item(210796))
			elseif recipeID == 382981 then -- Dragonflight Milling
				app.RecipeInformation05:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation04:SetText(item(198418, true) .. item(191464))
				app.RecipeInformation03:SetText(item(198415, true) .. item(191470))
				app.RecipeInformation02:SetText(item(198412, true) .. item(191467))
				app.RecipeInformation01:SetText(item(198421, true) .. item(191460))
			elseif recipeID == 382982 then -- Shadowlands Milling
				app.RecipeInformation04:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation03:SetText(item(175788, true) .. item(171315))
				app.RecipeInformation02:SetText(item(173057, true) .. item(169701) .. item(168586) .. item(170554))
				app.RecipeInformation01:SetText(item(173056, true) .. item(169701) .. item(168589) .. item(168583))
			elseif recipeID == 382984 then -- Battle for Azeroth Milling
				app.RecipeInformation04:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation03:SetText(item(153669, true) .. "10%, 30% " .. L.FROM .. " " .. item(152510))
				app.RecipeInformation02:SetText(item(153636, true) .. "25%")
				app.RecipeInformation01:SetText(item(153635, true) .. "75%")
			elseif recipeID == 382986 then -- Legion Milling
				app.RecipeInformation03:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation02:SetText(item(129034, true) .. "10%, 80% " .. L.FROM .. " " .. item(124106))
				app.RecipeInformation01:SetText(item(129032, true) .. "90%")
			elseif recipeID == 382987 then -- Warlords of Draenor Milling
				app.RecipeInformation02:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation01:SetText(item(114931, true) .. "100%")
			elseif recipeID == 382988 then -- Mists of Pandaria Milling
				app.RecipeInformation03:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation02:SetText(item(79253, true) .. "25%, 50% " .. L.FROM .. " " .. item(79011))
				app.RecipeInformation01:SetText(item(79251, true) .. "100%")
			elseif recipeID == 382989 then -- Cataclysm Milling
				app.RecipeInformation03:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation02:SetText(item(61980, true) .. "25%, 50% " .. L.FROM .. " " .. item(52987).. item(52988))
				app.RecipeInformation01:SetText(item(61979, true) .. "100%")
			elseif recipeID == 382990 then -- Wrath of the Lich King Milling
				app.RecipeInformation03:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation02:SetText(item(43109, true) .. "25%")
				app.RecipeInformation01:SetText(item(39343, true) .. "100%")
			elseif recipeID == 382991 then -- The Burning Crusade Milling
				app.RecipeInformation03:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation02:SetText(item(43108, true) .. "25%")
				app.RecipeInformation01:SetText(item(39342, true) .. "100%")
			elseif recipeID == 382994 then -- Classic Milling
				app.RecipeInformation12:SetText(app:Colour(L.MILLING_INFORMATION))
				app.RecipeInformation11:SetText(item(43107, true) .. "25% " .. L.FROM .. " " .. item(13464) .. item(13463) .. item(13465) .. item(13466) .. item(13467))
				app.RecipeInformation10:SetText(item(39341, true) .. "75% " .. L.FROM .. " " .. item(13464) .. item(13463) .. item(13465) .. item(13466) .. item(13467))
				app.RecipeInformation09:SetText(item(43106, true) .. "25% " .. L.FROM .. " " .. item(4625) .. item(8831) .. item(8838) .. item(8839) .. item(8845) .. item(8846))
				app.RecipeInformation08:SetText(item(39340, true) .. "75% " .. L.FROM .. " " .. item(4625) .. item(8831) .. item(8838) .. item(8839) .. item(8845) .. item(8846))
				app.RecipeInformation07:SetText(item(43105, true) .. "25% " .. L.FROM .. " " .. item(3818) .. item(3821) .. item(3358) .. item(3819))
				app.RecipeInformation06:SetText(item(39339, true) .. "75% " .. L.FROM .. " " .. item(3818) .. item(3821) .. item(3358) .. item(3819))
				app.RecipeInformation05:SetText(item(43104, true) .. "25% " .. L.FROM .. " " .. item(3355) .. item(3369) .. item(3356) .. item(3357))
				app.RecipeInformation04:SetText(item(39338, true) .. "75% " .. L.FROM .. " " .. item(3355) .. item(3369) .. item(3356) .. item(3357))
				app.RecipeInformation03:SetText(item(43103, true) .. "25% " .. L.FROM .. " " .. item(785) .. item(2450) .. item(2452) .. item(2453) .. item(3820))
				app.RecipeInformation02:SetText(item(39334, true) .. "75% " .. L.FROM .. " " .. item(785) .. item(2450) .. item(2452) .. item(2453) .. item(3820))
				app.RecipeInformation01:SetText(item(39151, true) .. "100% " .. L.FROM .. " " .. item(2447) .. item(765) .. item(2449))
			end
		end
		setRecipeInformation()

		if app.slLegendaryRecipeIDs[app.SelectedRecipe.Profession.recipeID] then
			app.ShadowlandsRankText:Show()
			app.ShadowlandsRankBox:Show()
			app.ShadowlandsRankBox:SetText(app.slLegendaryRecipeIDs[app.SelectedRecipe.Profession.recipeID].rank)
		else
			app.ShadowlandsRankText:Hide()
			app.ShadowlandsRankBox:Hide()
		end
	end

	local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
	local professionID = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineID).profession
	if professionID == Enum.Profession.Cooking then
		if app.Data.Pets.ragnaros and app.Data.Pets.ragnaros.enabled then
			app.RagnarosButton:Show()
		elseif app.Data.Pets.pierre and app.Data.Pets.pierre.enabled then
			app.PierreButton:Show()
		else
			app.CookingFireButton:Show()
		end
		app.ChefsHatButton:Show()
	else
		app.CookingFireButton:Hide()
		if app.Retail then
			app.RagnarosButton:Hide()
			app.PierreButton:Hide()
			app.ChefsHatButton:Hide()
		end
	end
	if app.Retail then
		if professionID == Enum.Profession.Blacksmithing or professionID == Enum.Profession.Mining or professionID == Enum.Profession.Engineering then
			app.ThermalAnvilButton:Show()
			app.AlvinButton:Show()
			local _, _, raceID = UnitRace("player")
			if raceID == 30 then
				app.LightforgeButton:Show()
			end
		else
			app.ThermalAnvilButton:Hide()
			app.AlvinButton:Hide()
			app.LightforgeButton:Hide()
		end
	end
end)

EventRegistry:RegisterCallback("Professions.RecipeSelected", function() -- The other callback is too quick for this to properly take, and this one only exists in Forever
	if InCombatLockdown() or not app.Forever then return end

	ProfessionsFrame.CraftingPage.SchematicForm.OutputText:SetPoint("LEFT", ProfessionsFrame.CraftingPage.SchematicForm.OutputIcon, "RIGHT", 16, 8)
end)

app.Event:Register("UNIT_SPELLCAST_SUCCEEDED", function(unitTarget, castGUID, spellID)
	if InCombatLockdown() or unitTarget ~= "player" then return end

	if spellID == 818 or spellID == 67556 or spellID == 126462 or spellID == 279205 or spellID == 259930 then
		C_Timer.After(0.1, function()
			app:UpdateAssets()
		end)
	end
end)
