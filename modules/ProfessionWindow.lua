----------------------------------------------------
-- Profession Shopping List: ProfessionWindow.lua --
----------------------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales
local api = app.api

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not ProfessionShoppingList_Data.Pets then ProfessionShoppingList_Data.Pets = {} end

		app.Flag["tradeskillAssets"] = false
	end
end)

-----------------------
-- PROFESSION WINDOW --
-----------------------

-- Create assets
function app.CreateTradeskillAssets()
	-- Hide and disable existing tracking buttons
	ProfessionsFrame.CraftingPage.SchematicForm.TrackRecipeCheckbox:SetAlpha(0)
	ProfessionsFrame.CraftingPage.SchematicForm.TrackRecipeCheckbox:EnableMouse(false)
	ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.TrackRecipeCheckbox:SetAlpha(0)
	ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.TrackRecipeCheckbox:EnableMouse(false)

	-- Create the profession UI track button
	if not app.TrackProfessionButton then
		app.TrackProfessionButton = app.Button(ProfessionsFrame.CraftingPage, L.TRACK)
		app.TrackProfessionButton:SetPoint("TOPRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, "TOPRIGHT", -5, -6)
		app.TrackProfessionButton:SetScript("OnClick", function()
			app.TrackRecipe(app.SelectedRecipe.Profession.recipeID, 1, app.SelectedRecipe.Profession.recraft)
		end)
	end

	-- Create the profession UI quantity editbox
	local function ebRecipeQuantityUpdate(self, newValue)
		-- Get the entered number cleanly
		newValue = math.floor(self:GetNumber())
		-- If the value is positive, change the number of recipes tracked
		if newValue >= 0 then
			app.UntrackRecipe(app.SelectedRecipe.Profession.recipeID, 0)
			if newValue > 0 then
				app.TrackRecipe(app.SelectedRecipe.Profession.recipeID, newValue, app.SelectedRecipe.Profession.recraft)
			end
		end
	end
	if not app.RecipeQuantityBox then
		app.RecipeQuantityBox = CreateFrame("EditBox", nil, ProfessionsFrame.CraftingPage, "InputBoxTemplate")
		app.RecipeQuantityBox:SetSize(25,20)
		app.RecipeQuantityBox:SetPoint("CENTER", app.TrackProfessionButton, "CENTER", 0, 0)
		app.RecipeQuantityBox:SetPoint("RIGHT", app.TrackProfessionButton, "LEFT", -4, 0)
		app.RecipeQuantityBox:SetAutoFocus(false)
		app.RecipeQuantityBox:SetText(0)
		app.RecipeQuantityBox:SetCursorPosition(0)
		app.RecipeQuantityBox:SetScript("OnEditFocusGained", function(self, newValue)
			app.TrackProfessionButton:Disable()
			app.UntrackProfessionButton:Disable()
		end)
		app.RecipeQuantityBox:SetScript("OnEditFocusLost", function(self, newValue)
			ebRecipeQuantityUpdate(self, newValue)
			app.TrackProfessionButton:Enable()
			if type(newValue) == "number" and newValue >= 1 then
				app.UntrackProfessionButton:Enable()
			end
		end)
		app.RecipeQuantityBox:SetScript("OnEnterPressed", function(self, newValue)
			ebRecipeQuantityUpdate(self, newValue)
			self:ClearFocus()
		end)
		app.RecipeQuantityBox:SetScript("OnEscapePressed", function(self, newValue)
			self:SetText(ProfessionShoppingList_Data.Recipes[app.SelectedRecipe.Profession.recipeID].quantity)
		end)
		app.Border(app.RecipeQuantityBox, -6, 1, 2, -2)
	end

	-- Create the profession UI untrack button
	if not app.UntrackProfessionButton then
		app.UntrackProfessionButton = app.Button(ProfessionsFrame.CraftingPage, L.UNTRACK)
		app.UntrackProfessionButton:SetPoint("TOP", app.TrackProfessionButton, "TOP", 0, 0)
		app.UntrackProfessionButton:SetPoint("RIGHT", app.RecipeQuantityBox, "LEFT", -8, 0)
		app.UntrackProfessionButton:SetFrameStrata("HIGH")
		app.UntrackProfessionButton:SetScript("OnClick", function()
			app.UntrackRecipe(app.SelectedRecipe.Profession.recipeID, 1)

			-- Show window
			app.Show()
		end)
	end

	-- Create the rank editbox for SL legendary recipes
	if not app.ShadowlandsRankBox then
		app.ShadowlandsRankBox = CreateFrame("EditBox", nil, ProfessionsFrame.CraftingPage, "InputBoxTemplate")
		app.ShadowlandsRankBox:SetSize(25,20)
		app.ShadowlandsRankBox:SetPoint("CENTER", app.RecipeQuantityBox, "CENTER", 0, 0)
		app.ShadowlandsRankBox:SetPoint("TOP", app.RecipeQuantityBox, "BOTTOM", 0, -4)
		app.ShadowlandsRankBox:SetAutoFocus(false)
		app.ShadowlandsRankBox:SetCursorPosition(0)
		app.ShadowlandsRankBox:Hide()
		app.Border(app.ShadowlandsRankBox, -6, 1, 2, -2)
	end
	if not app.ShadowlandsRankText then
		app.ShadowlandsRankText = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.ShadowlandsRankText:SetPoint("RIGHT", app.ShadowlandsRankBox, "LEFT", -10, 0)
		app.ShadowlandsRankText:SetJustifyH("LEFT")
		app.ShadowlandsRankText:SetText(L.RANK .. ":")
		app.ShadowlandsRankText:Hide()
	end

	-- Create the Track Unlearned Mogs button
	if not app.TrackNewMogsButton then
		local modeText = ""
		if ProfessionShoppingList_Settings["collectMode"] == 1 then
			modeText = L.MODE_APPEARANCES
		elseif ProfessionShoppingList_Settings["collectMode"] == 2 then
			modeText = L.MODE_SOURCES
		end

		app.TrackNewMogsButton = app.Button(ProfessionsFrame.CraftingPage, L.BUTTON_TRACKNEW)
		app.TrackNewMogsButton:SetPoint("TOPLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 0, -4)
		app.TrackNewMogsButton:SetFrameStrata("HIGH")
		app.TrackNewMogsButton:SetScript("OnClick", function()
			local recipes = app.GetVisibleRecipes()

			StaticPopupDialogs["TRACK_NEW_MOGS"] = {
				text = app.NameLong .. "\n\n" .. L.TRACK_NEW1 .. " " .. #recipes .. " " .. L.TRACK_NEW2 .. "\n" .. modeText .. ".\n\n" .. L.TRACK_NEW3 .. "\n" .. L.CONFIRMATION,
				button1 = YES,
				button2 = NO,
				OnAccept = function()
					app.TrackUnlearnedMog()
				end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				showAlert = true,
			}
			StaticPopup_Show("TRACK_NEW_MOGS")
		end)
		app.TrackNewMogsButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L.CURRENT_SETTING .. " " .. modeText)
			GameTooltip:Show()
		end)
		app.TrackNewMogsButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		-- Move the button if CraftScan or TestFlight + a price source is enabled, because we're nice
		if C_AddOns.IsAddOnLoaded("CraftScan") or
		(C_AddOns.IsAddOnLoaded("TestFlight") and (C_AddOns.IsAddOnLoaded("TradeSkillMaster") or C_AddOns.IsAddOnLoaded("Auctionator") or C_AddOns.IsAddOnLoaded("RECrystallize") or C_AddOns.IsAddOnLoaded("OribosExchange") or C_AddOns.IsAddOnLoaded("Auctioneer"))) or
		C_AddOns.IsAddOnLoaded("Mass_Salvage_Assist") then
			app.TrackNewMogsButton:ClearAllPoints()
			app.TrackNewMogsButton:SetPoint("CENTER", app.UntrackProfessionButton, "CENTER", 0, 0)
			app.TrackNewMogsButton:SetPoint("RIGHT", app.UntrackProfessionButton, "LEFT", -3, 0)
		end
	end

	-- Create Cooking Fire button
	if not app.CookingFireButton then
		app.CookingFireButton = CreateFrame("Button", "CookingFireButton", ProfessionsFrame.CraftingPage, "SecureActionButtonTemplate")
		app.CookingFireButton:SetWidth(40)
		app.CookingFireButton:SetHeight(40)
		app.CookingFireButton:SetNormalTexture(135805)
		app.CookingFireButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		app.CookingFireButton:SetPoint("BOTTOMRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMRIGHT", -5, 4)
		app.CookingFireButton:SetFrameStrata("HIGH")
		app.CookingFireButton:RegisterForClicks("AnyDown", "AnyUp")
		app.CookingFireButton:SetAttribute("type", "spell")
		app.CookingFireButton:SetAttribute("spell1", 818)
		app.CookingFireButton:SetAttribute("unit1", "player")
		app.CookingFireButton:SetAttribute("spell2", 818)
		app.CookingFireButton:Hide()
		app.CookingFireButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L.BUTTON_COOKINGFIRE)
			GameTooltip:Show()
		end)
		app.CookingFireButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		app.Border(app.CookingFireButton, -1, 2, 2, -1)

		app.CookingFireCooldown = CreateFrame("Cooldown", "CookingFireCooldown", app.CookingFireButton, "CooldownFrameTemplate")
		app.CookingFireCooldown:SetAllPoints(app.CookingFireButton)
		app.CookingFireCooldown:SetSwipeColor(1, 1, 1)

	end

	-- Create Chef's Hat button
	if not app.ChefsHatButton then
		app.ChefsHatButton = CreateFrame("Button", "ChefsHatButton", ProfessionsFrame.CraftingPage, "SecureActionButtonTemplate")
		app.ChefsHatButton:SetWidth(40)
		app.ChefsHatButton:SetHeight(40)
		app.ChefsHatButton:SetNormalTexture(236571)
		app.ChefsHatButton:GetNormalTexture():SetDesaturated(true)
		app.ChefsHatButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		app.ChefsHatButton:SetPoint("BOTTOMRIGHT", app.CookingFireButton, "BOTTOMLEFT", -3, 0)
		app.ChefsHatButton:SetFrameStrata("HIGH")
		app.ChefsHatButton:RegisterForClicks("AnyDown", "AnyUp")
		app.ChefsHatButton:SetAttribute("type1", "toy")
		app.ChefsHatButton:SetAttribute("toy", 134020)
		app.ChefsHatButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L.BUTTON_CHEFSHAT .. " " .. (C_Item.GetItemInfo(134020) or "Chef's Hat"))
			GameTooltip:Show()
		end)
		app.ChefsHatButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		app.Border(app.ChefsHatButton, -1, 2, 2, -1)

		app.ChefsHatCooldown = CreateFrame("Cooldown", "ChefsHatCooldown", app.ChefsHatButton, "CooldownFrameTemplate")
		app.ChefsHatCooldown:SetAllPoints(app.ChefsHatButton)
		app.ChefsHatCooldown:SetSwipeColor(1, 1, 1)
	end

	-- Create Thermal Anvil button
	if not app.ThermalAnvilButton then
		app.ThermalAnvilButton = CreateFrame("Button", "ThermalAnvilButton", ProfessionsFrame.CraftingPage, "SecureActionButtonTemplate")
		app.ThermalAnvilButton:SetWidth(40)
		app.ThermalAnvilButton:SetHeight(40)
		app.ThermalAnvilButton:SetNormalTexture(136241)
		app.ThermalAnvilButton:GetNormalTexture():SetDesaturated(true)
		app.ThermalAnvilButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		app.ThermalAnvilButton:SetPoint("BOTTOMRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMRIGHT", -5, 4)
		app.ThermalAnvilButton:SetFrameStrata("HIGH")
		app.ThermalAnvilButton:RegisterForClicks("AnyDown", "AnyUp")
		app.ThermalAnvilButton:SetAttribute("type1", "macro")
		app.ThermalAnvilButton:SetAttribute("macrotext1", "/use item:87216")
		app.ThermalAnvilButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L.BUTTON_THERMALANVIL .. " " .. (C_Item.GetItemInfo(87216) or "Thermal Anvil"))
			GameTooltip:Show()
		end)
		app.ThermalAnvilButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		app.Border(app.ThermalAnvilButton, -1, 2, 2, -1)

		app.ThermalAnvilCooldown = CreateFrame("Cooldown", "ThermalAnvilCooldown", app.ThermalAnvilButton, "CooldownFrameTemplate")
		app.ThermalAnvilCooldown:SetAllPoints(app.ThermalAnvilButton)
		app.ThermalAnvilCooldown:SetSwipeColor(1, 1, 1)

		app.ThermalAnvilCharges = app.ThermalAnvilButton:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.ThermalAnvilCharges:SetPoint("BOTTOMRIGHT", app.ThermalAnvilButton, "BOTTOMRIGHT", 0, 0)
		app.ThermalAnvilCharges:SetJustifyH("RIGHT")
		if not C_Item.IsItemDataCachedByID(87216) then local item = Item:CreateFromItemID(87216) end
		local anvilCharges = C_Item.GetItemCount(87216, false, true, false, false)
		app.ThermalAnvilCharges:SetText(anvilCharges)
	end

	-- Create Alvin the Anvil button
	if not app.AlvinButton then
		app.AlvinButton = CreateFrame("Button", "AlvinButton", ProfessionsFrame.CraftingPage, "SecureActionButtonTemplate")
		app.AlvinButton:SetWidth(40)
		app.AlvinButton:SetHeight(40)
		app.AlvinButton:SetNormalTexture(1020356)
		app.AlvinButton:GetNormalTexture():SetDesaturated(true)
		app.AlvinButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		app.AlvinButton:SetPoint("BOTTOMRIGHT", app.ThermalAnvilButton, "BOTTOMLEFT", -3, 0)
		app.AlvinButton:SetFrameStrata("HIGH")
		app.AlvinButton:RegisterForClicks("AnyDown", "AnyUp")
		app.AlvinButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L.BUTTON_ALVIN)
			GameTooltip:Show()
		end)
		app.AlvinButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		app.Border(app.AlvinButton, -1, 2, 2, -1)

		app.AlvinCooldown = CreateFrame("Cooldown", "AlvinCooldown", app.AlvinButton, "CooldownFrameTemplate")
		app.AlvinCooldown:SetAllPoints(app.AlvinButton)
		app.AlvinCooldown:SetSwipeColor(1, 1, 1)
	end

	-- Create Lil' Ragnaros button
	if not app.RagnarosButton then
		app.RagnarosButton = CreateFrame("Button", "RagnarosButton", ProfessionsFrame.CraftingPage, "SecureActionButtonTemplate")
		app.RagnarosButton:SetWidth(40)
		app.RagnarosButton:SetHeight(40)
		app.RagnarosButton:SetNormalTexture(254652)
		app.RagnarosButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		app.RagnarosButton:SetPoint("BOTTOMRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMRIGHT", -5, 4)
		app.RagnarosButton:SetFrameStrata("HIGH")
		app.RagnarosButton:RegisterForClicks("AnyDown", "AnyUp")
		app.RagnarosButton:Hide()
		app.RagnarosButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText("|cffFFFFFF" .. L.BUTTON_COOKINGPET)
			GameTooltip:Show()
		end)
		app.RagnarosButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		app.Border(app.RagnarosButton, -1, 2, 2, -1)

		app.RagnarosCooldown = CreateFrame("Cooldown", "RagnarosCooldown", app.RagnarosButton, "CooldownFrameTemplate")
		app.RagnarosCooldown:SetAllPoints(app.RagnarosButton)
		app.RagnarosCooldown:SetSwipeColor(1, 1, 1)
	end

	-- Create Pierre button
	if not app.PierreButton then
		app.PierreButton = CreateFrame("Button", "PierreButton", ProfessionsFrame.CraftingPage, "SecureActionButtonTemplate")
		app.PierreButton:SetWidth(40)
		app.PierreButton:SetHeight(40)
		app.PierreButton:SetNormalTexture(798062)
		app.PierreButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		app.PierreButton:SetPoint("BOTTOMRIGHT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMRIGHT", -5, 4)
		app.PierreButton:SetFrameStrata("HIGH")
		app.PierreButton:RegisterForClicks("AnyDown", "AnyUp")
		app.PierreButton:Hide()
		app.PierreButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText("|cffFFFFFF" .. L.BUTTON_COOKINGPET)
			GameTooltip:Show()
		end)
		app.PierreButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		app.Border(app.PierreButton, -1, 2, 2, -1)

		app.PierreCooldown = CreateFrame("Cooldown", "PierreCooldown", app.PierreButton, "CooldownFrameTemplate")
		app.PierreCooldown:SetAllPoints(app.PierreButton)
		app.PierreCooldown:SetSwipeColor(1, 1, 1)
	end

	-- Create Lightforged Draenei Lightforge button
	if not app.LightforgeButton then
		app.LightforgeButton = CreateFrame("Button", "LightforgeButton", ProfessionsFrame.CraftingPage, "SecureActionButtonTemplate")
		app.LightforgeButton:SetWidth(40)
		app.LightforgeButton:SetHeight(40)
		app.LightforgeButton:SetNormalTexture(1723995)
		app.LightforgeButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
		app.LightforgeButton:SetPoint("BOTTOMRIGHT", app.AlvinButton, "BOTTOMLEFT", -3, 0)
		app.LightforgeButton:SetFrameStrata("HIGH")
		app.LightforgeButton:RegisterForClicks("AnyDown", "AnyUp")
		app.LightforgeButton:SetAttribute("type", "spell")
		app.LightforgeButton:SetAttribute("spell", 259930)
		app.LightforgeButton:Hide()
		app.LightforgeButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(L.BUTTON_LIGHTFORGE .. " " .. (C_Spell.GetSpellInfo(259930).name or "Forge of Light"))
			GameTooltip:Show()
		end)
		app.LightforgeButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		app.Border(app.LightforgeButton, -1, 2, 2, -1)

		app.LightforgeCooldown = CreateFrame("Cooldown", "LightforgeCooldown", app.LightforgeButton, "CooldownFrameTemplate")
		app.LightforgeCooldown:SetAllPoints(app.LightforgeButton)
		app.LightforgeCooldown:SetSwipeColor(1, 1, 1)
	end

	-- Create Classic Milling info
	if not app.MillingClassic then
		app.MillingClassic = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingClassic:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingClassic:SetJustifyH("LEFT")
		app.MillingClassic:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_CLASSIC)
	end

	-- Create The Burning Crusade Milling info
	if not app.MillingTheBurningCrusade then
		app.MillingTheBurningCrusade = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingTheBurningCrusade:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingTheBurningCrusade:SetJustifyH("LEFT")
		app.MillingTheBurningCrusade:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_TBC)
	end

	-- Create Wrath of the Lich King Milling info
	if not app.MillingWrathOfTheLichKing then
		app.MillingWrathOfTheLichKing = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingWrathOfTheLichKing:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingWrathOfTheLichKing:SetJustifyH("LEFT")
		app.MillingWrathOfTheLichKing:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_WOTLK)
	end

	-- Create Cataclysm Milling info
	if not app.MillingCataclysm then
		app.MillingCataclysm = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingCataclysm:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingCataclysm:SetJustifyH("LEFT")
		app.MillingCataclysm:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_CATA)
	end

	-- Create Mists of Pandaria Milling info
	if not app.MillingMistsOfPandaria then
		app.MillingMistsOfPandaria = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingMistsOfPandaria:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingMistsOfPandaria:SetJustifyH("LEFT")
		app.MillingMistsOfPandaria:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_MOP)
	end

	-- Create Warlords of Draenor Milling info
	if not app.MillingWarlordsOfDraenor then
		app.MillingWarlordsOfDraenor = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingWarlordsOfDraenor:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingWarlordsOfDraenor:SetJustifyH("LEFT")
		app.MillingWarlordsOfDraenor:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_WOD)
	end

	-- Create Legion Milling info
	if not app.MillingLegion then
		app.MillingLegion = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingLegion:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingLegion:SetJustifyH("LEFT")
		app.MillingLegion:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_LEGION)
	end

	-- Create Battle for Azeroth Milling info
	if not app.MillingBattleForAzeroth then
		app.MillingBattleForAzeroth = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingBattleForAzeroth:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingBattleForAzeroth:SetJustifyH("LEFT")
		app.MillingBattleForAzeroth:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_BFA)
	end

	-- Create Shadowlands Milling info
	if not app.MillingShadowlands then
		app.MillingShadowlands = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingShadowlands:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingShadowlands:SetJustifyH("LEFT")
		app.MillingShadowlands:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_SL)
	end

	-- Create Dragonflight Milling info
	if not app.MillingDragonflight then
		app.MillingDragonflight = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingDragonflight:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingDragonflight:SetJustifyH("LEFT")
		app.MillingDragonflight:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_DF)
	end

	-- Create The War Within Milling info
	if not app.MillingTheWarWithin then
		app.MillingTheWarWithin = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.MillingTheWarWithin:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.MillingTheWarWithin:SetJustifyH("LEFT")
		app.MillingTheWarWithin:SetText(app.Colour(L.MILLING_INFO) .. "\n|cffFFFFFF" .. L.MILLING_TWW)
	end

	-- Create The War Within Thaumaturgy info
	if not app.ThaumaturgyTheWarWithin then
		app.ThaumaturgyTheWarWithin = ProfessionsFrame.CraftingPage.SchematicForm:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.ThaumaturgyTheWarWithin:SetPoint("BOTTOMLEFT", ProfessionsFrame.CraftingPage.SchematicForm, "BOTTOMLEFT", 35, 50)
		app.ThaumaturgyTheWarWithin:SetJustifyH("LEFT")
		app.ThaumaturgyTheWarWithin:SetText(app.Colour(L.THAUMATURGY_INFO) .. "\n|cffFFFFFF" .. L.THAUMATURGY_TWW)
	end

	-- Append an (un)track button to the RMB-menu
	if not app.RightClickOrderMenu then
		Menu.ModifyMenu("MENU_PROFESSIONS_CRAFTER_ORDER", function(ownerRegion, rootDescription, contextData)
			-- Append a new section to the end of the menu
			rootDescription:CreateDivider()
			-- rootDescription:CreateTitle(app.NameLong)

			-- Decide if we need to create a track or untrack option
			local key = "order:" .. ownerRegion.rowData.option.orderID .. ":" .. ownerRegion.rowData.option.spellID

			if ProfessionShoppingList_Data.Recipes[key] then
				rootDescription:CreateButton(app.IconPSL .. " " .. L.UNTRACK, function()
					-- Untrack the recipe
					app.UntrackRecipe(key, 1)

					-- Show window
					app.Show()
				end)
			else
				rootDescription:CreateButton(app.IconPSL .. " " .. L.TRACK, function()
					-- Track the recipe
					app.TrackRecipe(ownerRegion.rowData.option.spellID, 1, ownerRegion.rowData.option.isRecraft, ownerRegion.rowData.option.orderID)
				end)
			end
		end)

		app.RightClickOrderMenu = true
	end

	-- Grab the order information when opening a crafting order (THANK YOU PLUSMOUSE <3)
	hooksecurefunc(ProfessionsFrame.OrdersPage, "ViewOrder", function(_, orderDetails)
		app.SelectedRecipe.MakeOrder = orderDetails
		app.UpdateAssets()
	end)

	-- Create the fulfil crafting orders UI (Un)track button
	if not app.TrackMakeOrderButton then
		app.TrackMakeOrderButton = app.Button(ProfessionsFrame.OrdersPage.OrderView.OrderDetails, L.TRACK)
		app.TrackMakeOrderButton:SetPoint("TOPRIGHT", ProfessionsFrame.OrdersPage.OrderView.OrderDetails, "TOPRIGHT", -9, -10)
		app.TrackMakeOrderButton:SetScript("OnClick", function()
			local key = "order:" .. app.SelectedRecipe.MakeOrder.orderID .. ":" .. app.SelectedRecipe.MakeOrder.spellID

			if ProfessionShoppingList_Data.Recipes[key] then
				-- Untrack the recipe
				app.UntrackRecipe(key, 1)

				-- Change button text
				app.TrackMakeOrderButton:SetText(L.TRACK)
				app.TrackMakeOrderButton:SetWidth(app.TrackMakeOrderButton:GetTextWidth()+20)

				-- Show window
				app.Show()
			else
				-- Track the recipe
				app.TrackRecipe(app.SelectedRecipe.MakeOrder.spellID, 1, app.SelectedRecipe.MakeOrder.isRecraft, app.SelectedRecipe.MakeOrder.orderID)

				-- Change button text
				app.TrackMakeOrderButton:SetText(L.UNTRACK)
				app.TrackMakeOrderButton:SetWidth(app.TrackMakeOrderButton:GetTextWidth()+20)
			end
		end)
	end

	-- Overwrite TestFlight's order tracking with our own, so we can account for provided reagents
	if C_AddOns.IsAddOnLoaded("TestFlight") then
		TestFlight.GUI.OrdersPage.SetOrderTracked = function(_, orderDetails, checked)
			local key = "order:" .. orderDetails.orderID .. ":" .. orderDetails.spellID

			if not checked and ProfessionShoppingList_Data.Recipes[key] then
				-- Untrack the recipe
				app.UntrackRecipe(key, 1)

				-- Show window
				app.Show()
			elseif checked and ProfessionShoppingList_Data.Recipes[key] == nil then
				-- Track the recipe
				app.TrackRecipe(orderDetails.spellID, 1, orderDetails.isRecraft, orderDetails.orderID)
			end
		end
	end

	-- Create Concentration info
	if not app.Concentration1 then
		ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount:SetPoint("TOPLEFT", ProfessionsFrame.CraftingPage.ConcentrationDisplay.Icon, "TOPRIGHT", 6, 0)

		app.Concentration1 = ProfessionsFrame.CraftingPage.ConcentrationDisplay:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.Concentration1:SetPoint("TOPLEFT", ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount, "BOTTOMLEFT", 0, 0)
		app.Concentration1:SetJustifyH("LEFT")
	end

	if not app.Concentration2 then
		ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay.Amount:SetPoint("TOPLEFT", ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay.Icon, "TOPRIGHT", 6, 0)

		app.Concentration2 = ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay:CreateFontString("ARTWORK", nil, "GameFontNormal")
		app.Concentration2:SetPoint("TOPLEFT", ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay.Amount, "BOTTOMLEFT", 0, 0)
		app.Concentration2:SetJustifyH("LEFT")
	end

	-- Set the flag for assets created to true
	app.Flag["tradeskillAssets"] = true
end

-- Update assets
function app.UpdateAssets()
	-- Profession window
	if app.Flag["tradeskillAssets"] then
		-- Enable Profession tracking for 1 = Item, 3 = Enchant
		if app.SelectedRecipe.Profession.recipeType == 1 or app.SelectedRecipe.Profession.recipeType == 3 then
			app.TrackProfessionButton:Enable()
			app.RecipeQuantityBox:Enable()
		end

		-- Disable Profession tracking for 2 = Salvage, recipes without reagents
		if app.SelectedRecipe.Profession.recipeType == 2 or C_TradeSkillUI.GetRecipeSchematic(app.SelectedRecipe.Profession.recipeID,false).reagentSlotSchematics[1] == nil then
			app.TrackProfessionButton:Disable()
			app.UntrackProfessionButton:Disable()
			app.RecipeQuantityBox:Disable()
		end

		-- Enable Profession untracking for tracked recipes
		if not ProfessionShoppingList_Data.Recipes[app.SelectedRecipe.Profession.recipeID] or ProfessionShoppingList_Data.Recipes[app.SelectedRecipe.Profession.recipeID].quantity == 0 then
			app.UntrackProfessionButton:Disable()
		else
			app.UntrackProfessionButton:Enable()
		end

		-- Update the Profession quantity editbox
		if ProfessionShoppingList_Data.Recipes[app.SelectedRecipe.Profession.recipeID] then
			app.RecipeQuantityBox:SetText(ProfessionShoppingList_Data.Recipes[app.SelectedRecipe.Profession.recipeID].quantity or 0)
		else
			app.RecipeQuantityBox:SetText(0)
		end

		-- Update the Make Order button
		if app.SelectedRecipe.MakeOrder.orderID and app.SelectedRecipe.MakeOrder.spellID then
			-- Enable/Disable the Make Order button depending on if the recipe is learned
			if app.SelectedRecipe.MakeOrder.spellID and C_TradeSkillUI.GetRecipeInfo(app.SelectedRecipe.MakeOrder.spellID).learned then
				app.TrackMakeOrderButton:Enable()
			else
				app.TrackMakeOrderButton:Disable()
			end

			-- Set the Make Order button to Track or Untrack depending on if the recipe is tracked or not
			local key = "order:" .. app.SelectedRecipe.MakeOrder.orderID .. ":" .. app.SelectedRecipe.MakeOrder.spellID
			if ProfessionShoppingList_Data.Recipes[key] then
				app.TrackMakeOrderButton:SetText(L.UNTRACK)
				app.TrackMakeOrderButton:SetWidth(app.TrackMakeOrderButton:GetTextWidth()+20)
			else
				app.TrackMakeOrderButton:SetText(L.TRACK)
				app.TrackMakeOrderButton:SetWidth(app.TrackMakeOrderButton:GetTextWidth()+20)
			end
		end

		-- Make the Chef's Hat button not desaturated if it can be used
		if PlayerHasToy(134020) then
			app.ChefsHatButton:GetNormalTexture():SetDesaturated(false)
		end

		-- Check how many thermal anvils the player has
		if not C_Item.IsItemDataCachedByID(87216) then local item = Item:CreateFromItemID(87216) end
		local anvilCount = C_Item.GetItemCount(87216, false, false, false, false)
		-- (De)saturate based on that
		if anvilCount >= 1 then
			app.ThermalAnvilButton:GetNormalTexture():SetDesaturated(false)
		else
			app.ThermalAnvilButton:GetNormalTexture():SetDesaturated(true)
		end
		-- Update charges
		local anvilCharges = C_Item.GetItemCount(87216, false, true, false, false)
		app.ThermalAnvilCharges:SetText(anvilCharges)

		-- Cooking Fire button cooldown
		local startTime = C_Spell.GetSpellCooldown(818).startTime
		local duration = C_Spell.GetSpellCooldown(818).duration
		app.CookingFireCooldown:SetCooldown(startTime, duration)

		-- Chef's Hat button cooldown
		startTime, duration = C_Item.GetItemCooldown(134020)
		app.ChefsHatCooldown:SetCooldown(startTime, duration)

		-- Thermal Anvil button cooldown
		startTime, duration = C_Item.GetItemCooldown(87216)
		app.ThermalAnvilCooldown:SetCooldown(startTime, duration)

		-- Make the Alvin the Anvil button not desaturated if it can be used
		if ProfessionShoppingList_Data.Pets["alvin"] and C_PetJournal.PetIsSummonable(ProfessionShoppingList_Data.Pets["alvin"].guid) then
			app.AlvinButton:GetNormalTexture():SetDesaturated(false)
		end

		-- Pet buttons cooldown
		startTime = C_Spell.GetSpellCooldown(61304).startTime
		duration = C_Spell.GetSpellCooldown(61304).duration
		app.AlvinCooldown:SetCooldown(startTime, duration)
		app.RagnarosCooldown:SetCooldown(startTime, duration)
		app.PierreCooldown:SetCooldown(startTime, duration)

		-- Lightforge cooldown
		startTime = C_Spell.GetSpellCooldown(259930).startTime
		duration = C_Spell.GetSpellCooldown(259930).duration
		app.LightforgeCooldown:SetCooldown(startTime, duration)
	end

	-- Crafting orders window
	if app.Flag["craftingOrderAssets"] then
		-- Disable tracking for recrafts without a cached recipe
		if app.SelectedRecipe.PlaceOrder.recraft and app.SelectedRecipe.PlaceOrder.recipeID == 0 then
			app.TrackPlaceOrderButton:Disable()
		else
			app.TrackPlaceOrderButton:Enable()
		end

		-- Disable untracking for untracked recipes
		if not ProfessionShoppingList_Data.Recipes[app.SelectedRecipe.PlaceOrder.recipeID] or ProfessionShoppingList_Data.Recipes[app.SelectedRecipe.PlaceOrder.recipeID].quantity == 0 then
			app.UntrackPlaceOrderButton:Disable()
		else
			app.UntrackPlaceOrderButton:Enable()
		end

		-- Remove the personal order entry if the value is ""
		if ProfessionShoppingList_CharacterData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] == "" then
			ProfessionShoppingList_CharacterData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] = nil
		end

		-- Enable the quick order button if recipe is cached and target are known
		if ProfessionShoppingList_Library[app.SelectedRecipe.PlaceOrder.recipeID] and ProfessionShoppingList_CharacterData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] then
			app.QuickOrderButton:Enable()
		else
			app.QuickOrderButton:Disable()
		end

		-- Update the personal order name textbox
		if ProfessionShoppingList_CharacterData.Orders[app.SelectedRecipe.PlaceOrder.recipeID] then
			app.QuickOrderTargetBox:SetText(ProfessionShoppingList_CharacterData.Orders[app.SelectedRecipe.PlaceOrder.recipeID])
		else
			app.QuickOrderTargetBox:SetText("")
		end
	end

	-- Order adjustments
	if app.OrderAdjustments then
		for _, row in pairs(app.OrderAdjustments) do
			if row.tracked then
				row.tracked:Hide()
				row.unlearned:Hide()
				row.firstCraft:Hide()

				if ProfessionShoppingList_Data.Recipes[row.key] then
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

-- When a tradeskill window is opened
app.Event:Register("TRADE_SKILL_SHOW", function()
	if not InCombatLockdown() then
		if C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
			app.CreateTradeskillAssets()
		end

		local function getGUID(id, name)
			if not ProfessionShoppingList_Data.Pets[name] then
				for i=1, 9999 do
					local petID, speciesID = C_PetJournal.GetPetInfoByIndex(i)
					if speciesID == id and petID then
						ProfessionShoppingList_Data.Pets[name] = {guid = petID, enabled = true}
						break
					elseif speciesID == nil then
						break
					end
				end
			end
		end

		-- ProfessionShoppingList_Data.Pets[name]
		getGUID(297, "ragnaros")
		getGUID(1204, "pierre")
		getGUID(3274, "alvin")

		if app.Flag["tradeskillAssets"] then
			-- Alvin button
			if ProfessionShoppingList_Data.Pets["alvin"] then
				app.AlvinButton:SetAttribute("type1", "macro")
				app.AlvinButton:SetAttribute("macrotext1", "/run C_PetJournal.SummonPetByGUID('" .. ProfessionShoppingList_Data.Pets["alvin"].guid .. "')")
			end

			-- Lil' Ragnaros button
			if ProfessionShoppingList_Data.Pets["ragnaros"] then
				app.RagnarosButton:SetAttribute("type1", "macro")
				app.RagnarosButton:SetAttribute("macrotext1", "/run C_PetJournal.SummonPetByGUID('" .. ProfessionShoppingList_Data.Pets["ragnaros"].guid .. "')")
				app.RagnarosButton:SetAttribute("type2", "macro")
				app.RagnarosButton:SetAttribute("macrotext2", "/run ProfessionShoppingList.SwapCookingPet()")
			end

			-- Pierre button
			if ProfessionShoppingList_Data.Pets["pierre"] then
				app.PierreButton:SetAttribute("type1", "macro")
				app.PierreButton:SetAttribute("macrotext1", "/run C_PetJournal.SummonPetByGUID('" .. ProfessionShoppingList_Data.Pets["pierre"].guid .. "')")
				app.PierreButton:SetAttribute("type2", "macro")
				app.PierreButton:SetAttribute("macrotext2", "/run ProfessionShoppingList.SwapCookingPet()")
			end

			-- Recharge timer
			C_Timer.After(1, function()
				if ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount:GetText() then
					local concentration = string.match(ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount:GetText(), "%d+")

					if concentration then
						-- 250 Concentration per 24 hours
						local timeLeft = math.ceil((1000 - concentration) / 250 * 24)

						app.Concentration1:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r " .. timeLeft .. L.HOURS)
						app.Concentration2:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r " .. timeLeft .. L.HOURS)
					else
						app.Concentration1:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r ?")
						app.Concentration2:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r ?")
					end
				end
			end)
		end
	end
end)

function api.SwapCookingPet()
	-- Only do things if there's something to swap
	if ProfessionShoppingList_Data.Pets["ragnaros"] and ProfessionShoppingList_Data.Pets["pierre"] then
		if ProfessionShoppingList_Data.Pets["ragnaros"].enabled then
			ProfessionShoppingList_Data.Pets["ragnaros"].enabled = false
			app.RagnarosButton:Hide()
			ProfessionShoppingList_Data.Pets["pierre"].enabled = true
			app.PierreButton:Show()
		else
			ProfessionShoppingList_Data.Pets["ragnaros"].enabled = true
			app.RagnarosButton:Show()
			ProfessionShoppingList_Data.Pets["pierre"].enabled = false
			app.PierreButton:Hide()
		end
	end
end

-- When a recipe is selected
app.Event:Register("SPELL_DATA_LOAD_RESULT", function(spellID, success)
	if not InCombatLockdown() then
		-- Recipe-specific assets
		local function recipeAssets()
			if spellID == 444181 then	-- The War Within Thaumaturgy
				app.MillingTheWarWithin:Show()
			else
				app.MillingTheWarWithin:Hide()
			end

			if spellID == 430315 then	-- The War Within Milling
				app.ThaumaturgyTheWarWithin:Show()
			else
				app.ThaumaturgyTheWarWithin:Hide()
			end

			if spellID == 382981 then	-- Dragonflight Milling
				app.MillingDragonflight:Show()
			else
				app.MillingDragonflight:Hide()
			end

			if spellID == 382982 then	-- Shadowlands Milling
				app.MillingShadowlands:Show()
			else
				app.MillingShadowlands:Hide()
			end

			if spellID == 382984 then	-- Battle for Azeroth Milling
				app.MillingBattleForAzeroth:Show()
			else
				app.MillingBattleForAzeroth:Hide()
			end

			if spellID == 382986 then	-- Legion Milling
				app.MillingLegion:Show()
			else
				app.MillingLegion:Hide()
			end

			if spellID == 382987 then	-- Warlords of Draenor Milling
				app.MillingWarlordsOfDraenor:Show()
			else
				app.MillingWarlordsOfDraenor:Hide()
			end

			if spellID == 382988 then	-- Mists of Pandaria Milling
				app.MillingMistsOfPandaria:Show()
			else
				app.MillingMistsOfPandaria:Hide()
			end

			if spellID == 382989 then	-- Cataclysm Milling
				app.MillingCataclysm:Show()
			else
				app.MillingCataclysm:Hide()
			end

			if spellID == 382990 then	-- Wrath of the Lich King Milling
				app.MillingWrathOfTheLichKing:Show()
			else
				app.MillingWrathOfTheLichKing:Hide()
			end

			if spellID == 382991 then	-- The Burning Crusade Milling
				app.MillingTheBurningCrusade:Show()
			else
				app.MillingTheBurningCrusade:Hide()
			end

			if spellID == 382994 then	-- Classic Milling
				app.MillingClassic:Show()
			else
				app.MillingClassic:Hide()
			end

			if app.slLegendaryRecipeIDs[app.SelectedRecipe.Profession.recipeID] then	-- Shadowlands Legendary recipes
				app.ShadowlandsRankText:Show()
				app.ShadowlandsRankBox:Show()
				app.ShadowlandsRankBox:SetText(app.slLegendaryRecipeIDs[app.SelectedRecipe.Profession.recipeID].rank)
			else
				app.ShadowlandsRankText:Hide()
				app.ShadowlandsRankBox:Hide()
			end
		end

		-- Profession buttons
		local function professionButtons()
			-- Show stuff depending on which profession is opened
			local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
			local professionID = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineID).profession

			-- Cooking Fire and Chef's Hat buttons
			if professionID == 5 then
				if ProfessionShoppingList_Data.Pets["ragnaros"] and ProfessionShoppingList_Data.Pets["ragnaros"].enabled then
					app.RagnarosButton:Show()
				elseif ProfessionShoppingList_Data.Pets["pierre"] and ProfessionShoppingList_Data.Pets["pierre"].enabled then
					app.PierreButton:Show()
				else
					app.CookingFireButton:Show()
				end
				app.ChefsHatButton:Show()
			else
				app.CookingFireButton:Hide()
				app.RagnarosButton:Hide()
				app.PierreButton:Hide()
				app.ChefsHatButton:Hide()
			end

			-- Thermal Anvil button
			if professionID == 1 or professionID == 6 or professionID == 8 then
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

		if app.Flag["tradeskillAssets"] then
			recipeAssets()
			professionButtons()
		end
	end
end)

-- When a spell is succesfully cast by the player (for updating profession buttons)
app.Event:Register("UNIT_SPELLCAST_SUCCEEDED", function(unitTarget, castGUID, spellID)
	if not InCombatLockdown() and unitTarget == "player" then
		-- Profession button stuff
		if spellID == 818 or spellID == 67556 or spellID == 126462 or spellID == 279205 or spellID == 259930 then
			C_Timer.After(0.1, function()
				app.UpdateAssets()
			end)
		end
	end
end)