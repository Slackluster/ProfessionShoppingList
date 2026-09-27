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
		app.Settings.hide = app.Settings.hide or false
		app.Settings.windowPosition = app.Settings.windowPosition or { left = 1295, bottom = 836, width = 200, height = 200, }
		app.Settings.pcWindowPosition = app.Settings.pcWindowPosition or app.Settings.windowPosition
		app.Settings.windowLocked = app.Settings.windowLocked or false
		app.Settings.debug = app.Settings.debug or false
		app.Settings.useLocalReagents = app.Settings.useLocalReagents or false
		app.Settings.seen = app.Settings.seen or {}

		app:CreateMinimapButton()
		app:CreateSettings()

		-- Midnight cleanup
		app.Settings.midClean1 = nil
	end
end)

--------------
-- SETTINGS --
--------------

function app:OpenSettings()
	if InCombatLockdown() then
		app:Print(ERR_AFFECTING_COMBAT .. ".")
	else
		Settings.OpenToCategory(app.SettingsCategory:GetID())
	end
end

function app:CreateMinimapButton()
	local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject(app.NameLong, {
		type = "data source",
		text = app.NameLong,
		icon = app.Icon,

		OnClick = ProfessionShoppingList_Click,
		OnEnter = ProfessionShoppingList_Enter,
		OnLeave = ProfessionShoppingList_Leave,
	})

	app.MinimapIcon = LibStub("LibDBIcon-1.0", true)
	app.MinimapIcon:Register(appName, miniButton, app.Settings)

	function app:ToggleMinimapIcon()
		if app.Settings.minimapIcon then
			app.Settings.hide = false
			app.MinimapIcon:Show(appName)
		else
			app.Settings.hide = true
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
	text:SetText(app.IconReady .. " " .. L.LINK_COPIED)

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
		text = L.CTRL_C_COPY,
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

		SettingsPanel.Container.SettingsList.Header.Title:SetText(CreateSimpleTextureMarkup(app.Icon, 16, 16) .. " " .. app.NameLong)
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

	local function addNewTag(initializer)
		initializer.data.newTagID = appName
		app.HasNewFeatures = true
	end

	local function showNewTag(self) -- Thank you, R41Z0R!
		if self.data and self.data.newTagID and self.data.newTagID == appName then
			self.NewFeature:SetShown(true)
		end
	end
	hooksecurefunc(SettingsCheckboxControlMixin, "Init", showNewTag)
	hooksecurefunc(SettingsDropdownControlMixin, "Init", showNewTag)
	hooksecurefunc(SettingsCheckboxDropdownControlMixin, "Init", showNewTag)

	hooksecurefunc(SettingsPanel, "DisplayCategory", function(self, category)
		if category == app.SettingsCategory then
			app.Settings.seen[app.Version] = true
		end
	end)

	local function showNewCategoryTag(self)
		if app.HasNewFeatures and not app.Settings.seen[app.Version] then
			local data = self:GetData()
			if data and data.data and data.data.category and data.data.category.ID == app.SettingsCategory:GetID() then
				self.NewFeature:SetShown(true)
			end
		end
	end
	hooksecurefunc(SettingsCategoryListButtonMixin, "Init", showNewCategoryTag)

	local function button(name, buttonName, description, func)
		layout:AddInitializer(CreateSettingsButtonInitializer(name, buttonName, func, description, true))
	end

	local function checkbox(variable, name, description, default, callback, parentSetting, parentCheckbox, isNew)
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

		if isNew then addNewTag(checkbox) end

		return setting, checkbox
	end

	local function checkboxDropdown(cbVariable, cbName, description, cbDefaultValue, ddVariable, ddDefaultValue, options, callback, isNew)
		local cbSetting = Settings.RegisterAddOnSetting(category, appName .. "_" .. cbVariable, cbVariable, app.Settings, type(cbDefaultValue), cbName, cbDefaultValue)
		local ddSetting = Settings.RegisterAddOnSetting(category, appName .. "_" .. ddVariable, ddVariable, app.Settings, type(ddDefaultValue), "", ddDefaultValue)
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

		if isNew then addNewTag(initializer) end
	end

	local function dropdown(variable, name, description, default, options, callback, isNew)
		local setting = Settings.RegisterAddOnSetting(category, appName .. "_" .. variable, variable, app.Settings, type(default), name, default)
		local function GetOptions()
			local container = Settings.CreateControlTextContainer()
			for _, option in ipairs(options) do
				container:Add(option.value, option.name, option.description)
			end
			return container:GetData()
		end

		local initializer = Settings.CreateDropdown(category, setting, GetOptions, description)

		if callback then
			setting:SetValueChangedCallback(callback)
		end

		if isNew then addNewTag(initializer) end
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

	text(L.VERSION .. " |cffFFFFFF" .. app.Version, nil, nil, 14)
	text(L.SUPPORT_TEXTLONG1 .. "\n" .. L.SUPPORT_TEXTLONG2)
	button(L.SUPPORT, L.BUY_ME_A_COFFEE, L.THANK_YOU, function() StaticPopup_Show("PROFESSIONSHOPPINGLIST_URL", nil, nil, "https://buymeacoffee.com/Slackluster") end)
	button(L.FEEDBACK_AND_HELP, L.DISCORD, L.JOIN_DISCORD_SERVER, function() StaticPopup_Show("PROFESSIONSHOPPINGLIST_URL", nil, nil, "https://discord.gg/hGvF59hstx") end)

	local _, isExpanded = expandableHeader(L.KEYBINDINGS_AND_SLASH_COMMANDS)

		keybind("PSL_TOGGLEWINDOW", isExpanded)

		local leftText = { "|cffFFFFFF" ..
			"/psl",
			"/psl reset pos",
			"/psl reset",
			"/psl settings",
			"/psl clear",
			"/psl track " .. app:Colour(L.RECIPEID .. " " .. L.QUANTITY),
			"/psl untrack " .. app:Colour(L.RECIPEID .. " " .. L.QUANTITY),
			"/psl untrack " .. app:Colour(L.RECIPEID),
			"/psl " .. app:Colour("[" .. L.CRAFTING_ACHIEVEMENT .. "]"),
			"/psl " .. app:Colour("[" .. L.ITEMLINK_OR_ITEMID .. "]") }
		local middleText = {
			L.TOGGLE_TRACKING_WINDOW,
			L.RESET_WINDOW_POSITION,
			L.RESET_SAVED_DATA,
			L.OPEN_SETTINGS,
			L.CLEAR_TRACKED_RECIPES,
			L.TRACK_RECIPE,
			L.UNTRACK_RECIPE,
			L.UNTRACK_RECIPE_ALL,
			L.TRACK_ACHIEVEMENT_RECIPES,
			L.TRACK_REAGENT_RECIPES }
		leftText = table.concat(leftText, "\n\n")
		middleText = table.concat(middleText, "\n\n")
		text(leftText, middleText, nil, nil, isExpanded)

	header(L.GENERAL)

	checkbox("minimapIcon", L.SHOW_MINIMAP_ICON, string.format(L.SHOW_MINIMAP_ICON_DESC, app.NameShort), true, function() app:ToggleMinimapIcon() end)

	local parentSetting, parentCheckbox = checkbox("showRecipeCooldowns", L.TRACK_RECIPE_COOLDOWNS, L.TRACK_RECIPE_COOLDOWNS_DESC, true, function() app:UpdateRecipes() end)

	checkbox("showWindowCooldown", L.SHOW_WINDOW_WHEN_READY, L.SHOW_WINDOW_WHEN_READY_DESC, false, nil, parentSetting, parentCheckbox)

	local parentSetting, parentCheckbox = checkbox("showTooltip", L.SHOW_TOOLTIP_INFORMATION, L.SHOW_TOOLTIP_INFORMATION_DESC, true)

	checkbox("showCraftTooltip", L.SHOW_CRAFTING_INFORMATION, L.SHOW_CRAFTING_INFORMATION_DESC, true, nil, parentSetting, parentCheckbox)

	checkbox("showCraftCostTooltip", L.SHOW_CRAFTING_COST, L.SHOW_CRAFTING_COST_DESC, true, nil, parentSetting, parentCheckbox, true)

	if app.Retail then

	dropdown("reagentQuality", L.MINIMUM_REAGENT_QUALITY, L.MINIMUM_REAGENT_QUALITY_DESC, 1, {
		{ value = 1, name = "|A:Professions-ChatIcon-Quality-12-Tier1:24:24::1|a|A:Professions-ChatIcon-Quality-Tier1:20:18::1|a  " .. L.LOW, description = nil },
		{ value = 2, name = "|A:Professions-ChatIcon-Quality-12-Tier2:24:24::1|a|A:Professions-ChatIcon-Quality-Tier3:20:18::1|a  " .. L.HIGH, description = nil },
	}, function() C_Timer.After(0.5, function() app:UpdateRecipes() end) end)

	dropdown("includeHigher", L.INCLUDE_HIGHER_QUALITY, L.INCLUDE_HIGHER_QUALITY_DESC, 1, {
		{ value = 1, name = L.INCLUDE_HIGHER_QUALITIES_YES, description = nil },
		{ value = 2, name = L.INCLUDE_HIGHER_QUALITIES_NO, description = nil },
	}, function() C_Timer.After(0.5, function() app:UpdateRecipes() end) end)

	dropdown("collectMode", L.COLLECTION_MODE, string.format(L.COLLECTION_MODE_DESC, app:Colour(L.TRACK_NEW)), 1, {
		{ value = 1, name = L.APPEARANCES, description = L.APPEARANCES_SETTING_DESC },
		{ value = 2, name = L.APPEARANCES_SOURCES, description = L.APPEARANCES_SOURCES_SETTING_DESC },
	})

	header(L.PROFESSION_WINDOW)

	checkbox("filterOptionalReagents", L.FILTER_OPTIONAL_REAGENTS, string.format(L.FILTER_OPTIONAL_REAGENTS_DESC, "\"" .. PROFESSIONS_HIDE_UNOWNED_REAGENTS .. "\""), true, nil, nil, nil, true)

	checkbox("spendToNextPerk", L.SPEND_TO_NEXT_PERK, L.SPEND_TO_NEXT_PERK_DESC, true)

	checkbox("enhancedOrders", L.ENHANCED_ORDERS, L.ENHANCED_ORDERS_DESC .. "\n\n|cffFF0000" .. L.REQUIRES_RELOAD, true)

	dropdown("quickOrderDuration", L.QUICK_ORDER_DURATION, L.QUICK_ORDER_DURATION_DESC, 0, {
		{ value = 0, name = L.QUICK_ORDER_DURATION_SHORT, description = nil },
		{ value = 1, name = L.QUICK_ORDER_DURATION_MEDIUM, description = nil },
		{ value = 2, name = L.QUICK_ORDER_DURATION_LONG, description = nil },
	})

	end

	header(L.TRACKING_WINDOW)

	checkbox("helpTooltips", L.SHOW_HELP_TOOLTIPS, L.SHOW_HELP_TOOLTIPS_DESC, true)

	checkbox("pcWindows", L.WINDOW_POSITION_PER_CHAR, L.WINDOW_POSITION_PER_CHAR_DESC, false)

	checkbox("pcRecipes", L.TRACK_RECIPES_PER_CHAR, L.TRACK_RECIPES_PER_CHAR_DESC, false, function() app:UpdateRecipes() end)

	checkbox("showRemaining", L.SHOW_REMAINING_REAGENTS, L.SHOW_REMAINING_REAGENTS_DESC, false, function() C_Timer.After(0.5, function() app:UpdateRecipes() end) end)

	local parentSetting, parentCheckbox = checkbox("removeCraft", L.UNTRACK_ON_CRAFT, L.UNTRACK_ON_CRAFT_DESC, true)

	checkbox("closeWhenDone", L.CLOSE_WINDOW_WHEN_DONE, L.CLOSE_WINDOW_WHEN_DONE_DESC, false, nil, parentSetting, parentCheckbox)
end
