--------------------------------------------
-- Profession Shopping List: Settings.lua --
--------------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not ProfessionShoppingList_Settings then ProfessionShoppingList_Settings = {} end
		if ProfessionShoppingList_Settings["hide"] == nil then ProfessionShoppingList_Settings["hide"] = false end
		if ProfessionShoppingList_Settings["windowPosition"] == nil then ProfessionShoppingList_Settings["windowPosition"] = { ["left"] = 1295, ["bottom"] = 836, ["width"] = 200, ["height"] = 200, } end
		if ProfessionShoppingList_Settings["pcWindowPosition"] == nil then ProfessionShoppingList_Settings["pcWindowPosition"] = ProfessionShoppingList_Settings["windowPosition"] end
		if ProfessionShoppingList_Settings["windowLocked"] == nil then ProfessionShoppingList_Settings["windowLocked"] = false end
		if ProfessionShoppingList_Settings["debug"] == nil then ProfessionShoppingList_Settings["debug"] = false end
		if ProfessionShoppingList_Settings["useLocalReagents"] == nil then ProfessionShoppingList_Settings["useLocalReagents"] = false end

		app.Settings()

		-- LEGACY
		if ProfessionShoppingList_Settings["backpackCount"] or ProfessionShoppingList_Settings["queueSound"] or ProfessionShoppingList_Settings["handyNotes"] or ProfessionShoppingList_Settings["underminePrices"] or ProfessionShoppingList_Settings["showTokenPrice"] or ProfessionShoppingList_Settings["tokyoDrift"] then
			ProfessionShoppingList_Settings["backpackCount"] = nil
			ProfessionShoppingList_Settings["queueSound"] = nil
			ProfessionShoppingList_Settings["handyNotes"] = nil
			ProfessionShoppingList_Settings["underminePrices"] = nil
			ProfessionShoppingList_Settings["showTokenPrice"] = nil
			ProfessionShoppingList_Settings["tokyoDrift"] = nil

			local link = "|cff00ccff|Hurl:https://wowhead.com|h[Click to Copy Link]|h|r"
			app.Popup(true, "Hello dear user!\n\nI see you were using one of these tweaks that " .. app.NameLong .. " offered:\n- Split Backpack Count\n- Queue Sound\n- HandyNotes Fix\n- Oribos Exchange Fix\n- Show WoW Token price\n- Tokyo Drift\n\nThese tweaks have moved to a new, separate addon: " .. app.Colour("Tag's Trivial Tweaks") .. "!\nPlease seek it out on CurseForge, Wago, or GitHub.\n\nThank you for using my addon!", "https://www.curseforge.com/wow/addons/tags-trivial-tweaks", "https://addons.wago.io/addons/ttt", "https://github.com/Sluimerstand/TagsTrivialTweaks")
		elseif ProfessionShoppingList_Settings["vendorAll"] or ProfessionShoppingList_Settings["catalystButton"] then
			ProfessionShoppingList_Settings["vendorAll"] = nil
			ProfessionShoppingList_Settings["catalystButton"] = nil

			local link = "|cff00ccff|Hurl:https://wowhead.com|h[Click to Copy Link]|h|r"
			app.Popup(true, "Hello dear user!\n\nI see you were using one of these tweaks that " .. app.NameLong .. " offered:\n- Set Vendor filter to 'All'\n- Instant Catalyst Button\n\nThese features have moved to another addon of mine: " .. app.Colour("Transmog Loot Helper") .. "!\nPlease seek it out on CurseForge, Wago, or GitHub.\n\nThank you for using my addon!", "https://www.curseforge.com/wow/addons/transmog-loot-helper", "https://addons.wago.io/addons/tlh", "https://github.com/Sluimerstand/TransmogLootHelper")
		end
	end
end)

-----------
-- RESET --
-----------

-- Reset SavedVariables
function app.Reset(arg)
	if arg == "settings" then
		ProfessionShoppingList_Settings = {}
		app.Print(L.RESET_DONE, L.REQUIRES_RELOAD)
	elseif arg == "library" then
		ProfessionShoppingList_Library = {}
		app.Print(L.RESET_DONE)
	elseif arg == "cache" then
		app.Clear()
		ProfessionShoppingList_Cache = nil
		app.Print(L.RESET_DONE, L.REQUIRES_RELOAD)
	elseif arg == "character" then
		ProfessionShoppingList_CharacterData = nil
		app.Print(L.RESET_DONE, L.REQUIRES_RELOAD)
	elseif arg == "all" then
		app.Clear()
		ProfessionShoppingList_Settings = nil
		ProfessionShoppingList_Data = nil
		ProfessionShoppingList_Library = nil
		ProfessionShoppingList_Cache = nil
		ProfessionShoppingList_CharacterData = nil
		app.Print(L.RESET_DONE, L.REQUIRES_RELOAD)
	elseif arg == "pos" then
		-- Set the window size and position back to default
		ProfessionShoppingList_Settings["windowPosition"] = { ["left"] = GetScreenWidth()/2-100, ["bottom"] = GetScreenHeight()/2-100, ["width"] = 200, ["height"] = 200, }
		ProfessionShoppingList_Settings["pcWindowPosition"] = ProfessionShoppingList_Settings["windowPosition"]

		-- Show the window, which will also set its size and position
		app.Show()
	else
		app.Print(L.INVALID_RESET_ARG .. "\n " .. app.Colour("settings") .. ", " .. app.Colour("library") .. ", " .. app.Colour("cache") .. ", " .. app.Colour("character") .. ", " .. app.Colour("all") .. ", " .. app.Colour("pos"))
	end
end

--------------
-- SETTINGS --
--------------

-- Open settings
function app.OpenSettings()
	Settings.OpenToCategory(app.Category:GetID())
end

-- Addon Compartment click
function ProfessionShoppingList_Click(self, button)
	if button == "LeftButton" then
		app.Toggle()
	elseif button == "RightButton" then
		app.OpenSettings()
	end
end

-- Addon Compartment enter
function ProfessionShoppingList_Enter(self, button)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(type(self) ~= "string" and self or button, "ANCHOR_LEFT")
	GameTooltip:AddLine(app.NameLong .. "\n" .. L.SETTINGS_TOOLTIP)
	GameTooltip:Show()
end

-- Addon Compartment leave
function ProfessionShoppingList_Leave()
	GameTooltip:Hide()
end

-- Settings and minimap icon
function app.Settings()
	-- Minimap button
	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("ProfessionShoppingList", {
		type = "data source",
		text = app.NameLong,
		icon = "Interface\\AddOns\\ProfessionShoppingList\\assets\\psl_icon",

		OnClick = function(self, button)
			if button == "LeftButton" then
				app.Toggle()
			elseif button == "RightButton" then
				app.OpenSettings()
			end
		end,

		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine(app.NameLong .. "\n" .. L.SETTINGS_TOOLTIP)
		end,
	})

	local icon = LibStub("LibDBIcon-1.0", true)
	icon:Register("ProfessionShoppingList", miniButton, ProfessionShoppingList_Settings)

	if ProfessionShoppingList_Settings["minimapIcon"] then
		ProfessionShoppingList_Settings["hide"] = false
		icon:Show("ProfessionShoppingList")
	else
		ProfessionShoppingList_Settings["hide"] = true
		icon:Hide("ProfessionShoppingList")
	end

	-- Settings page
	local category, layout = Settings.RegisterVerticalLayoutCategory(app.Name)
	Settings.RegisterAddOnCategory(category)
	app.Category = category

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(C_AddOns.GetAddOnMetadata(appName, "Version")))

	local variable, name, tooltip = "minimapIcon", L.SETTINGS_MINIMAP_TITLE, L.SETTINGS_MINIMAP_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		if ProfessionShoppingList_Settings["minimapIcon"] then
			ProfessionShoppingList_Settings["hide"] = false
			icon:Show("ProfessionShoppingList")
		else
			ProfessionShoppingList_Settings["hide"] = true
			icon:Hide("ProfessionShoppingList")
		end
	end)

	local variable, name, tooltip = "showRecipeCooldowns", L.SETTINGS_COOLDOWNS_TITLE, L.SETTINGS_COOLDOWNS_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app.UpdateRecipes()
	end)

	local variable, name, tooltip = "showWindowCooldown", L.SETTINGS_COOLDOWNSWINDOW_TITLE, L.SETTINGS_COOLDOWNSWINDOW_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return ProfessionShoppingList_Settings["showRecipeCooldowns"] end)

	local variable, name, tooltip = "showTooltip", L.SETTINGS_TOOLTIP_TITLE, L.SETTINGS_TOOLTIP_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "showCraftTooltip", L.SETTINGS_CRAFTTOOLTIP_TITLE, L.SETTINGS_CRAFTTOOLTIP_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, true)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return ProfessionShoppingList_Settings["showTooltip"] end)

	local variable, name, tooltip = "reagentQuality", L.SETTINGS_REAGENTQUALITY_TITLE, L.SETTINGS_REAGENTQUALITY_TOOLTIP
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, "|A:Professions-ChatIcon-Quality-Tier1:17:15::1|a" .. L.SETTINGS_REAGENTTIER .. " 1")
		container:Add(2, "|A:Professions-ChatIcon-Quality-Tier2:17:15::1|a" .. L.SETTINGS_REAGENTTIER .. " 2")
		container:Add(3, "|A:Professions-ChatIcon-Quality-Tier3:17:15::1|a" .. L.SETTINGS_REAGENTTIER .. " 3")
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Number, name, 1)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)
	setting:SetValueChangedCallback(function()
		C_Timer.After(0.5, function() app.UpdateRecipes() end) -- Toggling this setting seems buggy? This fixes it. :)
	end)

	local variable, name, tooltip = "includeHigher", L.SETTINGS_INCLUDEHIGHER_TITLE, L.SETTINGS_INCLUDEHIGHER_TOOLTIP
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, L.SETTINGS_INCLUDE .. " |A:Professions-ChatIcon-Quality-Tier3:17:15::1|a " .. L.SETTINGS_REAGENTTIER .. " 3 & " .. "|A:Professions-ChatIcon-Quality-Tier2:17:15::1|a " .. L.SETTINGS_REAGENTTIER .. " 2")
		container:Add(2, L.SETTINGS_ONLY_INCLUDE .. " |A:Professions-ChatIcon-Quality-Tier2:17:15::1|a " .. L.SETTINGS_REAGENTTIER .. " 2")
		container:Add(3, L.SETTINGS_DONT_INCLUDE)
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Number, name, 1)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)
	setting:SetValueChangedCallback(function()
		C_Timer.After(0.5, function() app.UpdateRecipes() end) -- Toggling this setting seems buggy? This fixes it. :)
	end)

	local variable, name, tooltip = "collectMode", L.SETTINGS_COLLECTMODE_TITLE, L.SETTINGS_COLLECTMODE_TOOLTIP
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, L.SETTINGS_APPEARANCES_TITLE, L.SETTINGS_APPEARANCES_TEXT)
		container:Add(2, L.SETTINGS_SOURCES_TITLE, L.SETTINGS_SOURCES_TEXT)
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Number, name, 1)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)

	local variable, name, tooltip = "enhancedOrders", L.SETTINGS_ENHANCEDORDERS_TITLE, L.SETTINGS_ENHANCEDORDERS_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "quickOrderDuration", L.SETTINGS_QUICKORDER_TITLE, L.SETTINGS_QUICKORDER_TOOLTIP
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(0, L.SETTINGS_DURATION_SHORT)
		container:Add(1, L.SETTINGS_DURATION_MEDIUM)
		container:Add(2, L.SETTINGS_DURATION_LONG)
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Number, name, 0)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.SETTINGS_HEADER_TRACK))

	local variable, name, tooltip = "helpTooltips", L.SETTINGS_HELP_TITLE, L.SETTINGS_HELP_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, true)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "pcWindows", L.SETTINGS_PERSONALWINDOWS_TITLE, L.SETTINGS_PERSONALWINDOWS_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, false)
	Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "pcRecipes", L.SETTINGS_PERSONALRECIPES_TITLE, L.SETTINGS_PERSONALRECIPES_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, false)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		app.UpdateRecipes()
	end)

	local variable, name, tooltip = "showRemaining", L.SETTINGS_SHOWREMAINING_TITLE, L.SETTINGS_SHOWREMAINING_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, false)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		C_Timer.After(0.5, function() app.UpdateRecipes() end) -- Toggling this setting seems buggy? This fixes it. :)
	end)

	local variable, name, tooltip = "removeCraft", L.SETTINGS_REMOVECRAFT_TITLE, L.SETTINGS_REMOVECRAFT_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "closeWhenDone", L.SETTINGS_CLOSEWHENDONE_TITLE, L.SETTINGS_CLOSEWHENDONE_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return ProfessionShoppingList_Settings["removeCraft"] end)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.SETTINGS_HEADER_INFO))

	local variable, name, tooltip = "", L.SETTINGS_SLASHCOMMANDS_TITLE, L.SETTINGS_SLASHCOMMANDS_TOOLTIP
	local function GetOptions()
		local container = Settings.CreateControlTextContainer()
		container:Add(1, "/psl", L.SETTINGS_SLASH_TOGGLE)
		container:Add(2, "/psl reset pos", L.SETTINGS_SLASH_RESETPOS)
		container:Add(3, "/psl reset " .. app.Colour("arg"), L.SETTINGS_SLASH_RESET)
		container:Add(4, "/psl settings", L.WINDOW_BUTTON_SETTINGS .. ".")
		container:Add(5, "/psl clear", L.WINDOW_BUTTON_CLEAR)
		container:Add(6, "/psl track " .. app.Colour(L.SETTINGS_SLASH_RECIPEID .. " " .. L.SETTINGS_SLASH_QUANTITY), L.SETTINGS_SLASH_TRACK)
		container:Add(7, "/psl untrack " .. app.Colour(L.SETTINGS_SLASH_RECIPEID .. " " .. L.SETTINGS_SLASH_QUANTITY), L.SETTINGS_SLASH_UNTRACK)
		container:Add(8, "/psl untrack " .. app.Colour(L.SETTINGS_SLASH_RECIPEID) .. " all", L.SETTINGS_SLASH_UNTRACKALL)
		container:Add(9, "/psl " .. app.Colour("[" .. L.SETTINGS_SLASH_CRAFTINGACHIE .. "]"), L.SETTINGS_SLASH_TRACKACHIE)
		return container:GetData()
	end
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Number, name, 1)
	Settings.CreateDropdown(category, setting, GetOptions, tooltip)
end
