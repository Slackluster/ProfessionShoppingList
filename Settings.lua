--------------------------------------------
-- Profession Shopping List: Settings.lua --
--------------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		ProfessionShoppingList_Settings = ProfessionShoppingList_Settings or {}
		app.Settings = ProfessionShoppingList_Settings

		app.Settings["hide"] = app.Settings["hide"] or false
		app.Settings["windowPosition"] = app.Settings["windowPosition"] or { ["left"] = 1295, ["bottom"] = 836, ["width"] = 200, ["height"] = 200, }
		app.Settings["pcWindowPosition"] = app.Settings["pcWindowPosition"] or app.Settings["windowPosition"]
		app.Settings["windowLocked"] = app.Settings["windowLocked"] or false
		app.Settings["debug"] = app.Settings["debug"] or false
		app.Settings["useLocalReagents"] = app.Settings["useLocalReagents"] or false

		app:CreateMinimapButton()
		app:CreateSettings()

		-- Midnight cleanup
		app.Settings["midClean1"] = nil
	end
end)

--------------
-- SETTINGS --
--------------

function app:OpenSettings()
	Settings.OpenToCategory(app.SettingsCategory:GetID())
end

function app:CreateMinimapButton()
	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject(app.NameLong, {
		type = "data source",
		text = app.NameLong,
		icon = app.Icon,

		OnClick = ProfessionShoppingList_Click,

		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine(L.SETTINGS_TOOLTIP)
		end,
	})

	app.MinimapIcon = LibStub("LibDBIcon-1.0", true)
	app.MinimapIcon:Register(appName, miniButton, app.Settings)

	function app:ToggleMinimapIcon()
		if app.Settings["minimapIcon"] then
			app.Settings["hide"] = false
			app.MinimapIcon:Show(appName)
		else
			app.Settings["hide"] = true
			app.MinimapIcon:Hide(appName)
		end
	end
	app:ToggleMinimapIcon()
end

function app:CreateSettings()
	-- Helper functions
	app.LinkCopiedFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	app.LinkCopiedFrame:SetPoint("CENTER")
	app.LinkCopiedFrame:SetFrameStrata("TOOLTIP")
	app.LinkCopiedFrame:SetHeight(1)
	app.LinkCopiedFrame:SetWidth(1)
	app.LinkCopiedFrame:Hide()

	local text = app.LinkCopiedFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	text:SetPoint("CENTER", app.LinkCopiedFrame, "CENTER")
	text:SetPoint("TOP", app.LinkCopiedFrame, "TOP")
	text:SetJustifyH("CENTER")
	text:SetText(app.IconReady .. " " .. L.SETTINGS_URL_COPIED)

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
		OnHide = function(dialog)
			local editBox = dialog.GetEditBox and dialog:GetEditBox() or dialog.editBox
			editBox:SetScript("OnEditFocusLost", nil)
			editBox:SetScript("OnEscapePressed", nil)
			editBox:SetScript("OnTextChanged", nil)
			editBox:SetScript("OnKeyUp", nil)
			editBox:SetText("")
		end,
	}

	ProfessionShoppingList_SettingsTextMixin = {}
	function ProfessionShoppingList_SettingsTextMixin:Init(initializer)
		local data = initializer:GetData()
		self.LeftText:SetTextToFit(data.leftText)
		self.MiddleText:SetTextToFit(data.middleText)
		self.RightText:SetTextToFit(data.rightText)
	end

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

	local category, layout

	local function button(name, buttonName, description, func)
		layout:AddInitializer(CreateSettingsButtonInitializer(name, buttonName, func, description, true))
	end

	local function checkbox(variable, name, description, default, callback, parentSetting, parentCheckbox)
		local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, app.Settings, type(default), name, default)
		local checkbox = Settings.CreateCheckbox(category, setting, description)

		if parentSetting and parentCheckbox then
			checkbox:SetParentInitializer(parentCheckbox, function() return parentSetting:GetValue() end)
			if callback then
				parentSetting:SetValueChangedCallback(callback)
			end
		elseif callback then
			setting:SetValueChangedCallback(callback)
		end

		return setting, checkbox
	end

	local function checkboxDropdown(cbVariable, cbName, description, cbDefaultValue, ddVariable, ddDefaultValue, options, callback)
		local cbSetting = Settings.RegisterAddOnSetting(category, appName.."_"..cbVariable, cbVariable, app.Settings, type(cbDefaultValue), cbName, cbDefaultValue)
		local ddSetting = Settings.RegisterAddOnSetting(category, appName.."_"..ddVariable, ddVariable, app.Settings, type(ddDefaultValue), "", ddDefaultValue)
		local function GetOptions()
			local container = Settings.CreateControlTextContainer()
			for _, option in ipairs(options) do
				container:Add(option.value, option.name, option.description)
			end
			return container:GetData()
		end

		local initializer = CreateSettingsCheckboxDropdownInitializer(cbSetting, cbName, description, ddSetting, GetOptions, "")
		layout:AddInitializer(initializer)

		if callback then
			cbSetting:SetValueChangedCallback(callback)
			ddSetting:SetValueChangedCallback(callback)
		end
	end

	local function dropdown(variable, name, description, default, options, callback)
		local setting = Settings.RegisterAddOnSetting(category, appName.."_"..variable, variable, app.Settings, type(default), name, default)
		local function GetOptions()
			local container = Settings.CreateControlTextContainer()
			for _, option in ipairs(options) do
				container:Add(option.value, option.name, option.description)
			end
			return container:GetData()
		end
		Settings.CreateDropdown(category, setting, GetOptions, description)
		if callback then
			setting:SetValueChangedCallback(callback)
		end
	end

	local function expandableHeader(name)
		local initializer = CreateFromMixins(SettingsExpandableSectionInitializer)
		local data = { name = name, expanded = false }

		initializer:Init("ProfessionShoppingList_SettingsExpandTemplate", data)
		initializer.GetExtent = ScrollBoxFactoryInitializerMixin.GetExtent

		layout:AddInitializer(initializer)

		return initializer, function()
			return initializer.data.expanded
		end
	end

	local function header(name)
		layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(name))
	end

	local function keybind(name, isExpanded)
		local action = name
		local bindingIndex = C_KeyBindings.GetBindingIndex(action)
		local initializer = CreateKeybindingEntryInitializer(bindingIndex, true)
		local keybind = layout:AddInitializer(initializer)
		if isExpanded ~= nil then keybind:AddShownPredicate(isExpanded) end
	end

	local function text(leftText, middleText, rightText, customExtent, isExpanded)
		local data = { leftText = leftText, middleText = middleText, rightText = rightText }
		local text = layout:AddInitializer(Settings.CreateElementInitializer("ProfessionShoppingList_SettingsText", data))
		function text:GetExtent()
			if customExtent then return customExtent end
			return 28 + select(2, string.gsub(data.leftText, "\n", "")) * 12
		end
		if isExpanded ~= nil then text:AddShownPredicate(isExpanded) end
	end

	-- Settings
	category, layout = Settings.RegisterVerticalLayoutCategory(app.Name)
	Settings.RegisterAddOnCategory(category)
	app.SettingsCategory = category

	text(L.SETTINGS_VERSION .. " |cffFFFFFF" .. C_AddOns.GetAddOnMetadata(appName, "Version"), nil, nil, 14)
	text(L.SETTINGS_SUPPORT_TEXTLONG)
	button(L.SETTINGS_SUPPORT_TEXT, L.SETTINGS_SUPPORT_BUTTON, L.SETTINGS_SUPPORT_DESC, function() StaticPopup_Show("PROFESSIONSHOPPINGLIST_URL", nil, nil, "https://buymeacoffee.com/Slackluster") end)
	button(L.SETTINGS_HELP_TEXT, L.SETTINGS_HELP_BUTTON, L.SETTINGS_HELP_DESC, function() StaticPopup_Show("PROFESSIONSHOPPINGLIST_URL", nil, nil, "https://discord.gg/hGvF59hstx") end)

	local _, isExpanded = expandableHeader(L.SETTINGS_KEYSLASH_TITLE)

		keybind("PSL_TOGGLEWINDOW", isExpanded)

		local leftText = { "|cffFFFFFF" ..
			"/psl",
			"/psl reset pos",
			"/psl reset " .. app:Colour("arg"),
			"/psl settings",
			"/psl clear",
			"/psl track " .. app:Colour(L.SETTINGS_SLASH_RECIPEID .. " " .. L.SETTINGS_SLASH_QUANTITY),
			"/psl untrack " .. app:Colour(L.SETTINGS_SLASH_RECIPEID .. " " .. L.SETTINGS_SLASH_QUANTITY),
			"/psl untrack " .. app:Colour(L.SETTINGS_SLASH_RECIPEID),
			"/psl " .. app:Colour("[" .. L.SETTINGS_SLASH_CRAFTINGACHIE .. "]") }
		local middleText = {
			L.SETTINGS_SLASH_TOGGLE,
			L.SETTINGS_SLASH_RESETPOS,
			L.SETTINGS_SLASH_RESET,
			L.WINDOW_BUTTON_SETTINGS,
			L.WINDOW_BUTTON_CLEAR,
			L.SETTINGS_SLASH_TRACK,
			L.SETTINGS_SLASH_UNTRACK,
			L.SETTINGS_SLASH_UNTRACKALL,
			L.SETTINGS_SLASH_TRACKACHIE }
		leftText = table.concat(leftText, "\n\n")
		middleText = table.concat(middleText, "\n\n")
		text(leftText, middleText, nil, nil, isExpanded)

	header(L.GENERAL)

	checkbox("minimapIcon", L.SETTINGS_MINIMAP_TITLE, L.SETTINGS_MINIMAP_DESC, true, function() app:ToggleMinimapIcon() end)

	local parentSetting, parentCheckbox = checkbox("showRecipeCooldowns", L.SETTINGS_COOLDOWNS_TITLE, L.SETTINGS_COOLDOWNS_DESC, true, function() app:UpdateRecipes() end)

	checkbox("showWindowCooldown", L.SETTINGS_COOLDOWNSWINDOW_TITLE, L.SETTINGS_COOLDOWNSWINDOW_DESC, false, nil, parentSetting, parentCheckbox)

	local parentSetting, parentCheckbox = checkbox("showTooltip", L.SETTINGS_TOOLTIP_TITLE, L.SETTINGS_TOOLTIP_DESC, true)

	checkbox("showCraftTooltip", L.SETTINGS_CRAFTTOOLTIP_TITLE, L.SETTINGS_CRAFTTOOLTIP_DESC, true, nil, parentSetting, parentCheckbox)

	dropdown("reagentQuality", L.SETTINGS_REAGENTQUALITY_TITLE, L.SETTINGS_REAGENTQUALITY_DESC, 1, {
		{ value = 1, name = "|A:Professions-ChatIcon-Quality-12-Tier1:24:24::1|a|A:Professions-ChatIcon-Quality-Tier1:20:18::1|a  " .. L.LOW, description = nil },
		{ value = 2, name = "|A:Professions-ChatIcon-Quality-12-Tier2:24:24::1|a|A:Professions-ChatIcon-Quality-Tier3:20:18::1|a  " .. L.HIGH, description = nil },
	}, function() C_Timer.After(0.5, function() app:UpdateRecipes() end) end)

	dropdown("includeHigher", L.SETTINGS_INCLUDEHIGHER_TITLE, L.SETTINGS_INCLUDEHIGHER_DESC, 1, {
		{ value = 1, name = L.SETTINGS_INCLUDE, description = nil },
		{ value = 2, name = L.SETTINGS_DONT_INCLUDE, description = nil },
	}, function() C_Timer.After(0.5, function() app:UpdateRecipes() end) end)

	dropdown("collectMode", L.SETTINGS_COLLECTMODE_TITLE, L.SETTINGS_COLLECTMODE_DESC, 1, {
		{ value = 1, name = L.SETTINGS_APPEARANCES_TITLE, description = L.SETTINGS_APPEARANCES_TEXT },
		{ value = 2, name = L.SETTINGS_SOURCES_TITLE, description = L.SETTINGS_SOURCES_TEXT },
	})

	checkbox("spendToNextPerk", L.SETTINGS_SPENDTOPERK_TITLE, L.SETTINGS_SPENDTOPERK_DESC, true)

	checkbox("enhancedOrders", L.SETTINGS_ENHANCEDORDERS_TITLE, L.SETTINGS_ENHANCEDORDERS_DESC, true)

	dropdown("quickOrderDuration", L.SETTINGS_QUICKORDER_TITLE, L.SETTINGS_QUICKORDER_DESC, 0, {
		{ value = 0, name = L.SETTINGS_DURATION_SHORT, description = nil },
		{ value = 1, name = L.SETTINGS_DURATION_MEDIUM, description = nil },
		{ value = 2, name = L.SETTINGS_DURATION_LONG, description = nil },
	})

	header(L.SETTINGS_HEADER_TRACK)

	checkbox("helpTooltips", L.SETTINGS_HELPTOOLTIP_TITLE, L.SETTINGS_HELPTOOLTIP_DESC, true)

	checkbox("pcWindows", L.SETTINGS_PERSONALWINDOWS_TITLE, L.SETTINGS_PERSONALWINDOWS_DESC, false)

	checkbox("pcRecipes", L.SETTINGS_PERSONALRECIPES_TITLE, L.SETTINGS_PERSONALRECIPES_DESC, false, function() app:UpdateRecipes() end)

	checkbox("showRemaining", L.SETTINGS_SHOWREMAINING_TITLE, L.SETTINGS_SHOWREMAINING_DESC, false, function() C_Timer.After(0.5, function() app:UpdateRecipes() end) end)

	local parentSetting, parentCheckbox = checkbox("removeCraft", L.SETTINGS_REMOVECRAFT_TITLE, L.SETTINGS_REMOVECRAFT_DESC, true)

	checkbox("closeWhenDone", L.SETTINGS_CLOSEWHENDONE_TITLE, L.SETTINGS_CLOSEWHENDONE_DESC, false, nil, parentSetting, parentCheckbox)
end
