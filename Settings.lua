--------------------------------------------
-- Profession Shopping List: Settings.lua --
--------------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales
local api = app.api

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

		app:CreateLinkCopiedFrame()
		app:CreateSettings()

		-- Midnight cleanup
		if ProfessionShoppingList_Settings["backpackCount"] ~= nil then ProfessionShoppingList_Settings["backpackCount"] = nil end
		if ProfessionShoppingList_Settings["queueSound"] ~= nil then ProfessionShoppingList_Settings["queueSound"] = nil end
		if ProfessionShoppingList_Settings["handyNotes"] ~= nil then ProfessionShoppingList_Settings["handyNotes"] = nil end
		if ProfessionShoppingList_Settings["underminePrices"] ~= nil then ProfessionShoppingList_Settings["underminePrices"] = nil end
		if ProfessionShoppingList_Settings["showTokenPrice"] ~= nil then ProfessionShoppingList_Settings["showTokenPrice"] = nil end
		if ProfessionShoppingList_Settings["tokyoDrift"] ~= nil then ProfessionShoppingList_Settings["tokyoDrift"] = nil end
	end
end)

-----------
-- RESET --
-----------

-- Reset SavedVariables
function app:Reset(arg)
	if arg == "settings" then
		ProfessionShoppingList_Settings = {}
		app:Print(L.RESET_DONE, L.REQUIRES_RELOAD)
	elseif arg == "library" then
		ProfessionShoppingList_Library = {}
		app:Print(L.RESET_DONE)
	elseif arg == "cache" then
		app:Clear()
		ProfessionShoppingList_Cache = nil
		app:Print(L.RESET_DONE, L.REQUIRES_RELOAD)
	elseif arg == "character" then
		ProfessionShoppingList_CharacterData = nil
		app:Print(L.RESET_DONE, L.REQUIRES_RELOAD)
	elseif arg == "all" then
		app:Clear()
		ProfessionShoppingList_Settings = nil
		ProfessionShoppingList_Data = nil
		ProfessionShoppingList_Library = nil
		ProfessionShoppingList_Cache = nil
		ProfessionShoppingList_CharacterData = nil
		app:Print(L.RESET_DONE, L.REQUIRES_RELOAD)
	elseif arg == "pos" then
		-- Set the window size and position back to default
		ProfessionShoppingList_Settings["windowPosition"] = { ["left"] = GetScreenWidth()/2-100, ["bottom"] = GetScreenHeight()/2-100, ["width"] = 200, ["height"] = 200, }
		ProfessionShoppingList_Settings["pcWindowPosition"] = ProfessionShoppingList_Settings["windowPosition"]

		-- Show the window, which will also set its size and position
		app:ShowWindow()
	else
		app:Print(L.INVALID_RESET_ARG .. "\n " .. app:Colour("settings") .. ", " .. app:Colour("library") .. ", " .. app:Colour("cache") .. ", " .. app:Colour("character") .. ", " .. app:Colour("all") .. ", " .. app:Colour("pos"))
	end
end

--------------
-- SETTINGS --
--------------

-- Open settings
function app:OpenSettings()
	Settings.OpenToCategory(app.Settings:GetID())
end

-- Addon Compartment click
function ProfessionShoppingList_Click(self, button)
	if button == "LeftButton" then
		api:ToggleWindow()
	elseif button == "RightButton" then
		app:OpenSettings()
	end
end

-- Addon Compartment enter
function ProfessionShoppingList_Enter(self, button)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(type(self) ~= "string" and self or button, "ANCHOR_LEFT")
	GameTooltip:AddLine(L.SETTINGS_TOOLTIP)
	GameTooltip:Show()
end

-- Addon Compartment leave
function ProfessionShoppingList_Leave()
	GameTooltip:Hide()
end

-- Settings and minimap icon
function app:CreateSettings()
	-- Minimap button
	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("ProfessionShoppingList", {
		type = "data source",
		text = app.NameLong,
		icon = "Interface\\AddOns\\ProfessionShoppingList\\assets\\icon.png",

		OnClick = function(self, button)
			if button == "LeftButton" then
				api:ToggleWindow()
			elseif button == "RightButton" then
				app:OpenSettings()
			end
		end,

		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine(L.SETTINGS_TOOLTIP)
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
	app.Settings = category

	ProfessionShoppingList_SettingsTextMixin = {}
	function ProfessionShoppingList_SettingsTextMixin:Init(initializer)
		local data = initializer:GetData()
		self.LeftText:SetTextToFit(data.leftText)
		self.MiddleText:SetTextToFit(data.middleText)
		self.RightText:SetTextToFit(data.rightText)
	end

	local data = { leftText = L.SETTINGS_VERSION .. " |cffFFFFFF" .. C_AddOns.GetAddOnMetadata(appName, "Version") }
	local text = layout:AddInitializer(Settings.CreateElementInitializer("ProfessionShoppingList_SettingsText", data))
	function text:GetExtent()
		return 14
	end

	local data = { leftText = L.SETTINGS_SUPPORT_TEXTLONG }
	local text = layout:AddInitializer(Settings.CreateElementInitializer("ProfessionShoppingList_SettingsText", data))
	function text:GetExtent()
		return 28 + select(2, string.gsub(data.leftText, "\n", "")) * 12
	end

	StaticPopupDialogs["PROFESSIONSHOPPINGLIST_URL"] = {
		text = L.SETTINGS_URL_COPY,
		button1 = CLOSE,
		whileDead = true,
		hasEditBox = true,
		editBoxWidth = 240,
		OnShow = function(dialog, data)
			dialog:ClearAllPoints()
			dialog:SetPoint("CENTER", UIParent)

			local editBox = dialog.GetEditBox and dialog:GetEditBox() or dialog.editBox
			editBox:SetText(data)
			editBox:SetAutoFocus(true)
			editBox:HighlightText()
			editBox:SetScript("OnEditFocusLost", function()
				editBox:SetFocus()
			end)
			editBox:SetScript("OnEscapePressed", function()
				dialog:Hide()
			end)
			editBox:SetScript("OnTextChanged", function()
				editBox:SetText(data)
				editBox:HighlightText()
			end)
			editBox:SetScript("OnKeyUp", function(self, key)
				if (IsControlKeyDown() and (key == "C" or key == "X")) then
					dialog:Hide()
					app.LinkCopiedFrame:Show()
					app.LinkCopiedFrame:SetAlpha(1)
					app.LinkCopiedFrame.animation:Play()
				end
			end)
		end,
	}
	local function onSupportButtonClick()
		StaticPopup_Show("PROFESSIONSHOPPINGLIST_URL", nil, nil, "https://buymeacoffee.com/Slackluster")
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_SUPPORT_TEXT, L.SETTINGS_SUPPORT_BUTTON, onSupportButtonClick, L.SETTINGS_SUPPORT_DESC, true))

	local function onHelpButtonClick()
		StaticPopup_Show("PROFESSIONSHOPPINGLIST_URL", nil, nil, "https://discord.gg/hGvF59hstx")
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_HELP_TEXT, L.SETTINGS_HELP_BUTTON, onHelpButtonClick, L.SETTINGS_HELP_DESC, true))

	local function onIssuesButtonClick()
		StaticPopup_Show("PROFESSIONSHOPPINGLIST_URL", nil, nil, "https://github.com/slackluster/ProfessionShoppingList/issues")
	end
	layout:AddInitializer(CreateSettingsButtonInitializer(L.SETTINGS_ISSUES_TEXT, L.SETTINGS_ISSUES_BUTTON, onIssuesButtonClick, L.SETTINGS_ISSUES_DESC, true))

	ProfessionShoppingList_SettingsExpandMixin = CreateFromMixins(SettingsExpandableSectionMixin)

	function ProfessionShoppingList_SettingsExpandMixin:Init(initializer)
		SettingsExpandableSectionMixin.Init(self, initializer)
		self.data = initializer.data
	end

	function ProfessionShoppingList_SettingsExpandMixin:OnExpandedChanged(expanded)
		SettingsInbound.RepairDisplay()
	end

	function ProfessionShoppingList_SettingsExpandMixin:CalculateHeight()
		return 24
	end

	function ProfessionShoppingList_SettingsExpandMixin:OnExpandedChanged(expanded)
		self:EvaluateVisibility(expanded)
        SettingsInbound.RepairDisplay()
	end

	function ProfessionShoppingList_SettingsExpandMixin:EvaluateVisibility(expanded)
		if expanded then
			self.Button.Right:SetAtlas("Options_ListExpand_Right_Expanded", TextureKitConstants.UseAtlasSize)
		else
			self.Button.Right:SetAtlas("Options_ListExpand_Right", TextureKitConstants.UseAtlasSize)
		end
	end

	local function createExpandableSection(layout, name)
		local initializer = CreateFromMixins(SettingsExpandableSectionInitializer)
		local data = { name = name, expanded = false }

		initializer:Init("ProfessionShoppingList_SettingsExpandTemplate", data)
		initializer.GetExtent = ScrollBoxFactoryInitializerMixin.GetExtent

		layout:AddInitializer(initializer)

		return initializer, function()
			return initializer.data.expanded
		end
	end

	local expandInitializer, isExpanded = createExpandableSection(layout, L.SETTINGS_KEYSLASH_TITLE)

		local action = "PSL_TOGGLEWINDOW"
		local bindingIndex = C_KeyBindings.GetBindingIndex(action)
		local initializer = CreateKeybindingEntryInitializer(bindingIndex, true)
		local keybind = layout:AddInitializer(initializer)
		keybind:AddShownPredicate(isExpanded)

		local data = { leftText = "|cffFFFFFF"
			.. "/psl" .. "\n\n"
			.. "/psl reset pos" .. "\n\n"
			.. "/psl reset " .. app:Colour("arg") .. "\n\n"
			.. "/psl settings" .. "\n\n"
			.. "/psl clear" .. "\n\n"
			.. "/psl track " .. app:Colour(L.SETTINGS_SLASH_RECIPEID .. " " .. L.SETTINGS_SLASH_QUANTITY) .. "\n\n"
			.. "/psl untrack " .. app:Colour(L.SETTINGS_SLASH_RECIPEID .. " " .. L.SETTINGS_SLASH_QUANTITY) .. "\n\n"
			.. "/psl untrack " .. app:Colour(L.SETTINGS_SLASH_RECIPEID) .. "\n\n"
			.. "/psl " .. app:Colour("[" .. L.SETTINGS_SLASH_CRAFTINGACHIE .. "]"),
		middleText =
			L.SETTINGS_SLASH_TOGGLE .. "\n\n" ..
			L.SETTINGS_SLASH_RESETPOS .. "\n\n" ..
			L.SETTINGS_SLASH_RESET .. "\n\n" ..
			L.WINDOW_BUTTON_SETTINGS .. "\n\n" ..
			L.WINDOW_BUTTON_CLEAR .. "\n\n" ..
			L.SETTINGS_SLASH_TRACK .. "\n\n" ..
			L.SETTINGS_SLASH_UNTRACK .. "\n\n" ..
			L.SETTINGS_SLASH_UNTRACKALL .. "\n\n" ..
			L.SETTINGS_SLASH_TRACKACHIE
		}
		local text = layout:AddInitializer(Settings.CreateElementInitializer("ProfessionShoppingList_SettingsText", data))
		function text:GetExtent()
			return 28 + select(2, string.gsub(data.leftText, "\n", "")) * 12
		end
		text:AddShownPredicate(isExpanded)

	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.GENERAL))

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
		app:UpdateRecipes()
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
		C_Timer.After(0.5, function() app:UpdateRecipes() end) -- Toggling this setting seems buggy? This fixes it. :)
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
		C_Timer.After(0.5, function() app:UpdateRecipes() end) -- Toggling this setting seems buggy? This fixes it. :)
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
		app:UpdateRecipes()
	end)

	local variable, name, tooltip = "showRemaining", L.SETTINGS_SHOWREMAINING_TITLE, L.SETTINGS_SHOWREMAINING_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, false)
	Settings.CreateCheckbox(category, setting, tooltip)
	setting:SetValueChangedCallback(function()
		C_Timer.After(0.5, function() app:UpdateRecipes() end) -- Toggling this setting seems buggy? This fixes it. :)
	end)

	local variable, name, tooltip = "removeCraft", L.SETTINGS_REMOVECRAFT_TITLE, L.SETTINGS_REMOVECRAFT_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, true)
	local parentSetting = Settings.CreateCheckbox(category, setting, tooltip)

	local variable, name, tooltip = "closeWhenDone", L.SETTINGS_CLOSEWHENDONE_TITLE, L.SETTINGS_CLOSEWHENDONE_TOOLTIP
	local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, ProfessionShoppingList_Settings, Settings.VarType.Boolean, name, false)
	local subSetting = Settings.CreateCheckbox(category, setting, tooltip)
	subSetting:SetParentInitializer(parentSetting, function() return ProfessionShoppingList_Settings["removeCraft"] end)
end

function app:CreateLinkCopiedFrame()
	app.LinkCopiedFrame= CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	app.LinkCopiedFrame:SetPoint("CENTER")
	app.LinkCopiedFrame:SetFrameStrata("TOOLTIP")
	app.LinkCopiedFrame:SetHeight(1)
	app.LinkCopiedFrame:SetWidth(1)
	app.LinkCopiedFrame:Hide()

	local string = app.LinkCopiedFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	string:SetPoint("CENTER", app.LinkCopiedFrame, "CENTER", 0, 0)
	string:SetPoint("TOP", app.LinkCopiedFrame, "TOP", 0, 0)
	string:SetJustifyH("CENTER")
	string:SetText(app.IconReady .. " " .. L.SETTINGS_URL_COPIED)

	app.LinkCopiedFrame.animation = app.LinkCopiedFrame:CreateAnimationGroup()
	local fadeOut = app.LinkCopiedFrame.animation:CreateAnimation("Alpha")
	fadeOut:SetFromAlpha(1)
	fadeOut:SetToAlpha(0)
	fadeOut:SetDuration(1)
	fadeOut:SetStartDelay(1)
	fadeOut:SetSmoothing("IN_OUT")
	app.LinkCopiedFrame.animation:SetToFinalAlpha(true)
	app.LinkCopiedFrame.animation:SetScript("OnFinished", function()
		app.LinkCopiedFrame:Hide()
	end)
end
