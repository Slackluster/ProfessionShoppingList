--------------------------------------------------
-- Profession Shopping List: TrackingWindow.lua --
--------------------------------------------------

-- Initialisation
local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not ProfessionShoppingList_Data.Recipes then ProfessionShoppingList_Data.Recipes = {} end
		if not ProfessionShoppingList_Data.Cooldowns then ProfessionShoppingList_Data.Cooldowns = {} end

		if not ProfessionShoppingList_Cache.ReagentTiers then ProfessionShoppingList_Cache.ReagentTiers = {} end
		if not ProfessionShoppingList_Cache.Reagents then ProfessionShoppingList_Cache.Reagents = {} end
		if not ProfessionShoppingList_Cache.FakeRecipes then ProfessionShoppingList_Cache.FakeRecipes = {} end
		if not ProfessionShoppingList_Cache.SimulatedRecipes then ProfessionShoppingList_Cache.SimulatedRecipes = {} end

		if not ProfessionShoppingList_CharacterData.Recipes then ProfessionShoppingList_CharacterData.Recipes = {} end
		if not ProfessionShoppingList_CharacterData.Orders then ProfessionShoppingList_CharacterData.Orders = {} end

		ProfessionShoppingList_Settings["tabOpened"] = ProfessionShoppingList_Settings["tabOpened"] or false
		if ProfessionShoppingList_Settings["pcRecipes"] then
			ProfessionShoppingList_Data.Recipes = ProfessionShoppingList_CharacterData.Recipes
		end

		app.Hidden = CreateFrame("Frame")
		app.ReagentQuantities = {}
		app.SelectedRecipe = {}
		app.SelectedRecipe.Profession = { recipeID = 0, recraft = false, recipeType = 0 }
		app.SelectedRecipe.PlaceOrder = { recipeID = 0, recraft = false, recipeType = 0 }
		app.SelectedRecipe.MakeOrder = {}
		app.Rows = {}
		app.Rows.Recipe = {}
		app.Rows.Reagent = {}
		app.Rows.Cooldown = {}
		app.Rows.CooldownWidth = 0
		app.Rows.ReagentWidth = 0
		app.SimAddons = {"CraftSim", "TestFlight"}

		app:CreateWindow()
		local function refreshCooldowns()
			app:UpdateCooldowns()
			C_Timer.After(60, refreshCooldowns)
		end
		refreshCooldowns()

		-- Legacy compatibility
		if ProfessionShoppingList_Cache.CraftSimRecipes then
			ProfessionShoppingList_Cache.SimulatedRecipes = ProfessionShoppingList_Cache.CraftSimRecipes
			ProfessionShoppingList_Cache.CraftSimRecipes = nil
		end
	end
end)

---------------------
-- TRACKING WINDOW --
---------------------

-- Create the main window
function app:CreateWindow()
	-- Create popup frame
	app.Window = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	app.Window:SetPoint("CENTER")
	app.Window:SetFrameStrata("MEDIUM")
	app.Window:SetFrameLevel(200)
	app.Window:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	app.Window:SetBackdropColor(0, 0, 0, 1)
	app.Window:SetBackdropBorderColor(0.25, 0.78, 0.92)
	app.Window:EnableMouse(true)
	app.Window:SetMovable(true)
	app.Window:SetClampedToScreen(true)
	app.Window:SetResizable(true)
	app.Window:SetResizeBounds(140, 140)
	app.Window:RegisterForDrag("LeftButton")
	app.Window:SetScript("OnDragStart", function()
		app:MoveWindow()
	end)
	app.Window:SetScript("OnDragStop", function()
		app:SaveWindow()
	end)
	app.Window:SetScript("OnMouseUp", function()
		app.Window:StopMovingOrSizing()
	end)
	app.Window:SetScript("OnHide", function()
		app.Window:StopMovingOrSizing()
	end)
	app.Window:Hide()

	-- Resize corner
	app.Window.Corner = CreateFrame("Button", nil, app.Window)
	app.Window.Corner:EnableMouse("true")
	app.Window.Corner:SetPoint("BOTTOMRIGHT")
	app.Window.Corner:SetSize(16,16)
	app.Window.Corner:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
	app.Window.Corner:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	app.Window.Corner:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	app.Window.Corner:SetScript("OnMouseDown", function()
		app.Window:StartSizing("BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:Hide()
		ShoppingTooltip1:Hide()
	end)
	app.Window.Corner:SetScript("OnMouseUp", function()
		app:SaveWindow()
	end)
	app.Window.Corner:SetScript("OnEnter", function()
		app:ShowWindowTooltip(L.WINDOW_BUTTON_CORNER, nil, nil, "bottom")
	end)
	app.Window.Corner:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Close button
	app.CloseButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.CloseButton:SetPoint("TOPRIGHT", app.Window, "TOPRIGHT", 2, 2)
	app.CloseButton:SetScript("OnClick", function()
		app.Window:Hide()
	end)
	app.CloseButton:SetScript("OnEnter", function()
		app:ShowWindowTooltip(L.WINDOW_BUTTON_CLOSE, nil, nil, "top")
	end)
	app.CloseButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Lock button
	function app:LockWindow()
		app.Window.Corner:Hide()
		app.LockButton:Hide()
		app.UnlockButton:Show()
		ProfessionShoppingList_Settings["windowLocked"] = true
	end

	app.LockButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.LockButton:SetPoint("TOPRIGHT", app.CloseButton, "TOPLEFT", -2, 0)
	app.LockButton:SetNormalTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.LockButton:GetNormalTexture():SetTexCoord(183/256, 219/256, 1/128, 39/128)
	app.LockButton:SetDisabledTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.LockButton:GetDisabledTexture():SetTexCoord(183/256, 219/256, 41/128, 79/128)
	app.LockButton:SetPushedTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.LockButton:GetPushedTexture():SetTexCoord(183/256, 219/256, 81/128, 119/128)
	app.LockButton:SetScript("OnClick", function() app:LockWindow() end)
	app.LockButton:SetScript("OnEnter", function()
		app:ShowWindowTooltip(L.WINDOW_BUTTON_LOCK, nil, nil, "top")
	end)
	app.LockButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Unlock button
	function app:UnlockWindow()
		app.Window.Corner:Show()
		app.LockButton:Show()
		app.UnlockButton:Hide()
		ProfessionShoppingList_Settings["windowLocked"] = false
	end

	app.UnlockButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.UnlockButton:SetPoint("TOPRIGHT", app.CloseButton, "TOPLEFT", -2, 0)
	app.UnlockButton:SetNormalTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.UnlockButton:GetNormalTexture():SetTexCoord(148/256, 184/256, 1/128, 39/128)
	app.UnlockButton:SetDisabledTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.UnlockButton:GetDisabledTexture():SetTexCoord(148/256, 184/256, 41/128, 79/128)
	app.UnlockButton:SetPushedTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.UnlockButton:GetPushedTexture():SetTexCoord(148/256, 184/256, 81/128, 119/128)
	app.UnlockButton:SetScript("OnClick", function() app:UnlockWindow() end)
	app.UnlockButton:SetScript("OnEnter", function()
		app:ShowWindowTooltip(L.WINDOW_BUTTON_UNLOCK, nil, nil, "top")
	end)
	app.UnlockButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	if ProfessionShoppingList_Settings["windowLocked"] then
		app:LockWindow()
	else
		app:UnlockWindow()
	end

	-- Settings button
	app.SettingsButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.SettingsButton:SetPoint("TOPRIGHT", app.LockButton, "TOPLEFT", -2, 0)
	app.SettingsButton:SetNormalTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.SettingsButton:GetNormalTexture():SetTexCoord(112/256, 148/256, 1/128, 39/128)
	app.SettingsButton:SetDisabledTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.SettingsButton:GetDisabledTexture():SetTexCoord(112/256, 148/256, 41/128, 79/128)
	app.SettingsButton:SetPushedTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.SettingsButton:GetPushedTexture():SetTexCoord(112/256, 148/256, 81/128, 119/128)
	app.SettingsButton:SetScript("OnClick", function()
		app:OpenSettings()
	end)
	app.SettingsButton:SetScript("OnEnter", function()
		app:ShowWindowTooltip(L.WINDOW_BUTTON_SETTINGS, nil, nil, "top")
	end)
	app.SettingsButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Clear button
	app.ClearButton = CreateFrame("Button", "", app.Window, "UIPanelCloseButton")
	app.ClearButton:SetPoint("TOPRIGHT", app.SettingsButton, "TOPLEFT", -2, 0)
	app.ClearButton:SetNormalTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.ClearButton:GetNormalTexture():SetTexCoord(1/256, 37/256, 1/128, 39/128)
	app.ClearButton:SetDisabledTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.ClearButton:GetDisabledTexture():SetTexCoord(1/256, 37/256, 41/128, 79/128)
	app.ClearButton:SetPushedTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.ClearButton:GetPushedTexture():SetTexCoord(1/256, 37/256, 81/128, 119/128)
	app.ClearButton:SetScript("OnClick", function()
		StaticPopupDialogs["PSL_CLEAR_RECIPES"] = {
			text = app.NameLong .. "\n\n" .. L.CLEAR_CONFIRMATION .. "\n" .. L.CONFIRMATION,
			button1 = YES,
			button2 = NO,
			OnAccept = function()
				app:Clear()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			showAlert = true,
		}
		StaticPopup_Show("PSL_CLEAR_RECIPES")
	end)
	app.ClearButton:SetScript("OnEnter", function()
		app:ShowWindowTooltip(L.WINDOW_BUTTON_CLEAR, nil, nil, "top")
	end)
	app.ClearButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- Auctionator button
	app.AuctionatorButton = CreateFrame("Button", "pslOptionAuctionatorButton", app.Window, "UIPanelCloseButton")
	app.AuctionatorButton:SetPoint("TOPRIGHT", app.ClearButton, "TOPLEFT", -2, 0)
	app.AuctionatorButton:SetNormalTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.AuctionatorButton:GetNormalTexture():SetTexCoord(219/256, 255/256, 1/128, 39/128)
	app.AuctionatorButton:SetDisabledTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.AuctionatorButton:GetDisabledTexture():SetTexCoord(219/256, 255/256, 41/128, 79/128)
	app.AuctionatorButton:SetPushedTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
	app.AuctionatorButton:GetPushedTexture():SetTexCoord(219/256, 255/256, 81/128, 119/128)
	app.AuctionatorButton:SetScript("OnClick", function()
		app:UpdateRecipes()
		app:CreateShoppingList()
	end)
	app.AuctionatorButton:SetScript("OnEnter", function(self)
		app:ShowWindowTooltip(L.WINDOW_BUTTON_AUCTIONATOR, nil, nil, "top")
	end)
	app.AuctionatorButton:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	-- ScrollFrame inside the popup frame
	local scrollFrame = CreateFrame("ScrollFrame", nil, app.Window, "ScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", app.Window, 7, -6)
	scrollFrame:SetPoint("BOTTOMRIGHT", app.Window, -22, 6)
	scrollFrame:Show()

	scrollFrame.ScrollBar.Back:Hide()
	scrollFrame.ScrollBar.Forward:Hide()
	scrollFrame.ScrollBar:ClearAllPoints()
	scrollFrame.ScrollBar:SetPoint("TOP", scrollFrame, 0, -3)
	scrollFrame.ScrollBar:SetPoint("RIGHT", scrollFrame, 13, 0)
	scrollFrame.ScrollBar:SetPoint("BOTTOM", scrollFrame, 0, -16)

	-- ScrollChild inside the ScrollFrame
	local scrollChild = CreateFrame("Frame", nil, scrollFrame)
	scrollFrame:SetScrollChild(scrollChild)
	scrollChild:SetWidth(1)	-- This is automatically defined, so long as the attribute exists at all
	scrollChild:SetHeight(1)	-- This is automatically defined, so long as the attribute exists at all
	scrollChild:SetAllPoints(scrollFrame)
	scrollChild:Show()
	scrollFrame:SetScript("OnVerticalScroll", function() scrollChild:SetPoint("BOTTOMRIGHT", scrollFrame) end)
	app.Window.Child = scrollChild
	app.Window.ScrollFrame = scrollFrame
end

-- Move the main window
function app:MoveWindow()
	if ProfessionShoppingList_Settings["windowLocked"] then
		-- Highlight the Unlock button
		app.UnlockButton:LockHighlight()
	else
		-- Start moving the window, and hide any visible tooltips
		GameTooltip:ClearLines()
		GameTooltip:Hide()
		ShoppingTooltip1:Hide()
		app.Window:StartMoving()
	end
end

-- Save the main window position and size
function app:SaveWindow()
	if app.Tab and app.Tab.IsShown then return end

	-- Stop highlighting the unlock button
	app.UnlockButton:UnlockHighlight()

	-- Stop moving or resizing the window
	app.Window:StopMovingOrSizing()

	-- Get the window properties
	local left = app.Window:GetLeft()
	local bottom = app.Window:GetBottom()
	local width, height = app.Window:GetSize()

	-- Save the window position and size
	ProfessionShoppingList_Settings["windowPosition"] = { ["left"] = left, ["bottom"] = bottom, ["width"] = width, ["height"] = height, }
	ProfessionShoppingList_Settings["pcWindowPosition"] = ProfessionShoppingList_Settings["windowPosition"]
end

-- Window tooltip show
function app:ShowWindowTooltip(text, hyperlink, secondary, position)
	GameTooltip:SetOwner(app.Window, "ANCHOR_NONE")

	if hyperlink then
		GameTooltip:SetHyperlink(text)
	else
		GameTooltip:SetText(text)
	end

	if position and position == "top" then
		GameTooltip:SetPoint("BOTTOM", app.Window, "TOP", 0, 0)
	elseif position and position == "bottom" then
		GameTooltip:SetPoint("TOP", app.Window, "BOTTOM", 0, 0)
	elseif (app.Tab and app.Tab.IsShown) or GetScreenWidth()/2-ProfessionShoppingList_Settings["windowPosition"].width/2-app.Window:GetLeft() >= 0 then
		GameTooltip:SetPoint("LEFT", app.Window, "RIGHT", 0, 0)
	else
		GameTooltip:SetPoint("RIGHT", app.Window, "LEFT", 0, 0)
	end
	GameTooltip:Show()

	if secondary and ProfessionShoppingList_Settings["helpTooltips"] then
		ShoppingTooltip1:SetOwner(UIParent, "ANCHOR_NONE")
		if (app.Tab and app.Tab.IsShown) or GetScreenWidth()/2-ProfessionShoppingList_Settings["windowPosition"].width/2-app.Window:GetLeft() >= 0 then
			ShoppingTooltip1:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 0, 0)
		else
			ShoppingTooltip1:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", 0, 0)
		end
		ShoppingTooltip1:SetText(secondary)
		ShoppingTooltip1:SetScale(0.9)
		ShoppingTooltip1:Show()
	end
end

-- Update numbers tracked
function app:UpdateNumbers()
	-- Update reagents tracked
	for reagentID, amount in pairs(app.ReagentQuantities) do
		local itemLink, fileID, icon

		if not ProfessionShoppingList_Cache.Reagents[reagentID] then
			-- Cache item
			app:CacheItem(reagentID)

			if not C_Item.IsItemDataCachedByID(reagentID) then
				app:Debug("app.UpdateNumbers(" .. reagentID .. ")")

				C_Item.RequestLoadItemDataByID(reagentID)
				local item = Item:CreateFromItemID(reagentID)

				item:ContinueOnItemLoad(function()
					app:UpdateNumbers()
				end)

				return
			end
		else
			-- Read the info from the cache
			itemLink = ProfessionShoppingList_Cache.Reagents[reagentID].link
			icon = ProfessionShoppingList_Cache.Reagents[reagentID].icon
		end

		local itemAmount = ""
		local itemIcon = "|T"..ProfessionShoppingList_Cache.Reagents[reagentID].icon..":0|t"

		if type(reagentID) == "number" then
			-- Get needed/owned number of reagents
			local reagentAmountHave = app:GetReagentCount(reagentID)

			-- Make stuff grey and add a checkmark if 0 are needed
			if math.max(0,amount-reagentAmountHave) == 0 then
				itemIcon = app.IconReady
				itemAmount = "|cff9d9d9d"
				itemLink = string.gsub(itemLink, "cnIQ0", "cnIQ0") -- Poor
				itemLink = string.gsub(itemLink, "cnIQ1", "cnIQ0") -- Common
				itemLink = string.gsub(itemLink, "cnIQ2", "cnIQ0") -- Uncommon
				itemLink = string.gsub(itemLink, "cnIQ3", "cnIQ0") -- Rare
				itemLink = string.gsub(itemLink, "cnIQ4", "cnIQ0") -- Epic
				itemLink = string.gsub(itemLink, "cnIQ5", "cnIQ0") -- Legendary
				itemLink = string.gsub(itemLink, "cnIQ6", "cnIQ0") -- Artifact
			-- Make the icon an arrow if it is a subreagent, but not at 0 needed
			else
				for k, v in pairs(ProfessionShoppingList_Data.Recipes) do
					local lookupReagentID = reagentID
					if ProfessionShoppingList_Cache.ReagentTiers[reagentID] then lookupReagentID = ProfessionShoppingList_Cache.ReagentTiers[reagentID].one end

					if ProfessionShoppingList_Library[k] and ProfessionShoppingList_Library[k].itemID == lookupReagentID then
						itemIcon = app.IconArrow
						-- Add a non-functional colour to be replaced with the quality colour, so we can sort it separately
						itemLink = "|cffFF0000|r" .. itemLink
						break
					end
				end
			end

			-- Set the displayed amount based on settings
			if ProfessionShoppingList_Settings["showRemaining"] == false then
				itemAmount = itemAmount .. reagentAmountHave .. "/" .. amount
			else
				itemAmount = itemAmount .. math.max(0,amount-reagentAmountHave)
			end
		elseif reagentID == "gold" then
			-- Set the colour of both strings and the icon
			itemIcon = app.IconProfession[0]
			local colour = ""
			if math.max(0,amount-GetMoney()) == 0 then
				itemIcon = app.IconReady
				colour = "|cff9d9d9d"
				itemLink = colour .. itemLink
			end

			-- Set the displayed amount based on settings
			if ProfessionShoppingList_Settings["showRemaining"] == false then
				itemAmount = colour .. C_CurrencyInfo.GetCoinTextureString(amount)
			else
				itemAmount = colour .. C_CurrencyInfo.GetCoinTextureString(math.max(0,amount-GetMoney()))
			end
		elseif string.find(reagentID, "currency") then
			local number = string.gsub(reagentID, "currency:", "")
			local quantity = C_CurrencyInfo.GetCurrencyInfo(tonumber(number)).quantity

			-- Set the colour of both strings and the icon
			if math.max(0,amount-quantity) == 0 then
				itemIcon = app.IconReady
				itemAmount = "|cff9d9d9d"
				itemLink = string.gsub(itemLink, "cnIQ0", "cnIQ0") -- Poor
				itemLink = string.gsub(itemLink, "cnIQ1", "cnIQ0") -- Common
				itemLink = string.gsub(itemLink, "cnIQ2", "cnIQ0") -- Uncommon
				itemLink = string.gsub(itemLink, "cnIQ3", "cnIQ0") -- Rare
				itemLink = string.gsub(itemLink, "cnIQ4", "cnIQ0") -- Epic
				itemLink = string.gsub(itemLink, "cnIQ5", "cnIQ0") -- Legendary
				itemLink = string.gsub(itemLink, "cnIQ6", "cnIQ0") -- Artifact
			end

			-- Set the displayed amount based on settings
			if ProfessionShoppingList_Settings["showRemaining"] == false then
				itemAmount = itemAmount .. quantity .. "/" .. amount
			else
				itemAmount = itemAmount .. math.max(0,amount-quantity)
			end
		end

		-- Push the info to the window
		if app.Rows.Reagent then
			for i, row in pairs(app.Rows.Reagent) do
				if row:GetID() == reagentID or (reagentID == "gold" and row.text1:GetText() == L.GOLD) then
					row.icon:SetText(itemIcon)
					row.text1:SetText(itemLink)
					row.text2:SetText(itemAmount)
					app.Rows.ReagentWidth = math.max(row.icon:GetStringWidth()+row.text1:GetStringWidth()+row.text2:GetStringWidth(), app.Rows.ReagentWidth)
				elseif string.find(reagentID, "currency") then
					local number = string.gsub(reagentID, "currency:", "")
					local name = C_CurrencyInfo.GetCurrencyLink(tonumber(number))
					if name == row.text1:GetText() then
						row.icon:SetText(itemIcon)
						row.text1:SetText(itemLink)
						row.text2:SetText(itemAmount)
						app.Rows.ReagentWidth = math.max(row.icon:GetStringWidth()+row.text1:GetStringWidth()+row.text2:GetStringWidth(), app.Rows.ReagentWidth)
					end
				end
			end
		end
	end

	local customSortList = {
		-- Needed reagents
		"|cnIQ6",				-- Artifact
		"|cnIQ5",				-- Legendary
		"|cnIQ4",				-- Epic
		"|cnIQ3",				-- Rare
		"|cnIQ2",				-- Uncommon
		"|cnIQ1",				-- Common
		-- Subreagents
		"|cffFF0000|r|cnIQ6",	-- Artifact
		"|cffFF0000|r|cnIQ5",	-- Legendary
		"|cffFF0000|r|cnIQ4",	-- Epic
		"|cffFF0000|r|cnIQ3",	-- Rare
		"|cffFF0000|r|cnIQ2",	-- Uncommon
		"|cffFF0000|r|cnIQ1",	-- Common
		-- Collected reagents
		"|cnIQ0",				-- Poor (quantity 0)
	}

	local function customSort(a, b)
		for _, v in ipairs(customSortList) do
			local indexA = string.find(a.link, v, 1, true)
			local indexB = string.find(b.link, v, 1, true)

			if indexA == 1 and indexB ~= 1 then
				return true
			elseif indexA ~= 1 and indexB == 1 then
				return false
			end
		end

		-- If custom sort index is the same, compare alphabetically
		return string.gsub(a.link, ".-(:%|h)", "") < string.gsub(b.link, ".-(:%|h)", "")
	end

	if app.Rows.Recipe then
		if #app.Rows.Recipe >= 1 then
			for i, row in ipairs(app.Rows.Recipe) do
				if i == 1 then
					row:SetPoint("TOPLEFT", app.Window.Recipes, "BOTTOMLEFT")
					row:SetPoint("TOPRIGHT", app.Window.Recipes, "BOTTOMRIGHT")
				else
					local offset = -16*(i-1)
					row:SetPoint("TOPLEFT", app.Window.Recipes, "BOTTOMLEFT", 0, offset)
					row:SetPoint("TOPRIGHT", app.Window.Recipes, "BOTTOMRIGHT", 0, offset)
				end
			end
		end
	end

	if app.Rows.Reagent then
		if #app.Rows.Reagent >= 1 then
			local reagentsSorted = {}
			for _, row in pairs(app.Rows.Reagent) do
				table.insert(reagentsSorted, {["row"] = row, ["link"] = row.text1:GetText()})
			end
			table.sort(reagentsSorted, customSort)

			for i, info in ipairs(reagentsSorted) do
				if i == 1 then
					info.row:SetPoint("TOPLEFT", app.Window.Reagents, "BOTTOMLEFT")
					info.row:SetPoint("TOPRIGHT", app.Window.Reagents, "BOTTOMRIGHT")
				else
					local offset = -16*(i-1)
					info.row:SetPoint("TOPLEFT", app.Window.Reagents, "BOTTOMLEFT", 0, offset)
					info.row:SetPoint("TOPRIGHT", app.Window.Reagents, "BOTTOMRIGHT", 0, offset)
				end
			end
		end
	end

	-- Enable or disable the clear button when appropriate
	local next = next
	if next(ProfessionShoppingList_Data.Recipes) == nil then
		app.ClearButton:Disable()
	else
		app.ClearButton:Enable()
	end
end

-- Update cooldown numbers
function app:UpdateCooldowns()
	app.Rows.CooldownWidth = 0
	if app.Rows.Cooldown then
		if #app.Rows.Cooldown >= 1 then
			for i, row in ipairs(app.Rows.Cooldown) do
				local rowID = row:GetID()
				if ProfessionShoppingList_Data.Cooldowns[rowID] then
					local cooldownRemaining = ProfessionShoppingList_Data.Cooldowns[rowID].start + ProfessionShoppingList_Data.Cooldowns[rowID].cooldown - GetServerTime()
					local days, hours, minutes

					days = math.floor(cooldownRemaining/(60*60*24))
					hours = math.floor((cooldownRemaining - (days*60*60*24))/(60*60))
					minutes = math.floor((cooldownRemaining - ((days*60*60*24) + (hours*60*60)))/60)

					if cooldownRemaining <= 0 then
						row.text2:SetText(L.READY)
					elseif cooldownRemaining < 60*60 then
						row.text2:SetText(minutes .. L.MINUTES)
					elseif cooldownRemaining < 60*60*24 then
						row.text2:SetText(hours .. L.HOURS .. " " .. minutes .. L.MINUTES)
					else
						row.text2:SetText(days .. L.DAYS .. " " .. hours .. L.HOURS .. " " .. minutes .. L.MINUTES)
					end
				end

				app.Rows.CooldownWidth = math.max(row.icon:GetStringWidth()+row.text1:GetStringWidth()+row.text2:GetStringWidth(), app.Rows.CooldownWidth)
			end
		end
	end
end

-- Update recipes and reagents tracked
function app:UpdateRecipes()
	-- Set personal recipes to be the same as global recipes
	ProfessionShoppingList_CharacterData.Recipes = ProfessionShoppingList_Data.Recipes

	-- Recalculate reagents tracked
	if app.Flag.ChangingRecipes == false then
		app.ReagentQuantities = {}

		for recipeID, recipeInfo in pairs(ProfessionShoppingList_Data.Recipes) do
			-- Normal recipes
			if type(recipeID) == "number" then
				app:GetReagents(app.ReagentQuantities, recipeID, recipeInfo.quantity, recipeInfo.recraft)
			-- Patron orders
			elseif ProfessionShoppingList_Cache.FakeRecipes[recipeID] and string.sub(recipeID, 1, 6) == "order:" then
				app:GetReagents(app.ReagentQuantities, recipeID, recipeInfo.quantity, recipeInfo.recraft)
			-- Guild/Personal orders
			elseif string.sub(recipeID, 1, 6) == "order:" then
				app:GetReagents(app.ReagentQuantities, recipeID, recipeInfo.quantity, recipeInfo.recraft)
			-- Vendor items
			elseif ProfessionShoppingList_Cache.FakeRecipes[recipeID] and string.sub(recipeID, 1, 7) == "vendor:" then
				-- Add gold costs
				if ProfessionShoppingList_Cache.FakeRecipes[recipeID].costCopper > 0 then
					if app.ReagentQuantities["gold"] == nil then app.ReagentQuantities["gold"] = 0 end
					app.ReagentQuantities["gold"] = app.ReagentQuantities["gold"] + ( ProfessionShoppingList_Cache.FakeRecipes[recipeID].costCopper * ProfessionShoppingList_Data.Recipes[recipeID].quantity )
				end
				-- Add item costs
				for reagentID, reagentAmount in pairs(ProfessionShoppingList_Cache.FakeRecipes[recipeID].costItems) do
					if app.ReagentQuantities[reagentID] == nil then app.ReagentQuantities[reagentID] = 0 end
					app.ReagentQuantities[reagentID] = app.ReagentQuantities[reagentID] + ( reagentAmount * ProfessionShoppingList_Data.Recipes[recipeID].quantity )
				end
				-- Add currency costs
				for currencyID, currencyAmount in pairs(ProfessionShoppingList_Cache.FakeRecipes[recipeID].costCurrency) do
					local key = "currency:" .. currencyID
					if app.ReagentQuantities[key] == nil then app.ReagentQuantities[key] = 0 end
					app.ReagentQuantities[key] = app.ReagentQuantities[key] + ( currencyAmount * ProfessionShoppingList_Data.Recipes[recipeID].quantity )
				end
			end
		end

		local rowNo = 0
		local showRecipes = true
		local maxLength1 = 0
		local maxLength2 = 0
		local maxLength3 = 0

		-- Move the existing rows to the Nether
		if app.Rows.Recipe then
			for i, row in pairs(app.Rows.Recipe) do
				row:SetParent(app.Hidden)
				row:Hide()
			end
		end
		if app.Rows.Reagent then
			for i, row in pairs(app.Rows.Reagent) do
				row:SetParent(app.Hidden)
				row:Hide()
			end
		end
		if app.Rows.Cooldown then
			for i, row in pairs(app.Rows.Cooldown) do
				row:SetParent(app.Hidden)
				row:Hide()
			end
		end

		-- And clear our rows entirely
		app.Rows.Recipe = {}
		app.Rows.Reagent = {}
		app.Rows.Cooldown = {}

		if not app.Window.Recipes then
			app.Window.Recipes = CreateFrame("Button", nil, app.Window.Child)
			app.Window.Recipes:SetSize(0,16)
			app.Window.Recipes:SetPoint("TOPLEFT", app.Window.Child, -1, 0)
			app.Window.Recipes:SetPoint("RIGHT", app.Window.Child)
			app.Window.Recipes:RegisterForDrag("LeftButton")
			app.Window.Recipes:SetHighlightAtlas("Options_List_Active", "ADD")
			app.Window.Recipes:SetScript("OnDragStart", function() app:MoveWindow()	end)
			app.Window.Recipes:SetScript("OnDragStop", function() app:SaveWindow() end)

			local recipes1 = app.Window.Recipes:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			recipes1:SetPoint("LEFT", app.Window.Recipes)
			recipes1:SetScale(1.1)
			app.RecipeHeader = recipes1
		end

		app.Window.Recipes:SetScript("OnClick", function(self)
			local children = {self:GetChildren()}

			if showRecipes then
				for _, child in ipairs(children) do child:Hide() end
				app.Window.Reagents:SetPoint("TOPLEFT", app.Window.Recipes, "BOTTOMLEFT", 0, -2)
				showRecipes = false
			else
				for _, child in ipairs(children) do child:Show() end
				local offset = -2
				if #app.Rows.Recipe >= 1 then offset = -16*#app.Rows.Recipe end
				app.Window.Reagents:SetPoint("TOPLEFT", app.Window.Recipes, "BOTTOMLEFT", 0, offset)
				showRecipes = true
			end
		end)

		local customSortList = {
			"|cnIQ6",	-- Artifact
			"|cnIQ5",	-- Legendary
			"|cnIQ4",	-- Epic
			"|cnIQ3",	-- Rare
			"|cnIQ2",	-- Uncommon
			"|cnIQ1",	-- Common
			"|cnIQ0",	-- Poor (quantity 0)
		}

		-- Custom comparison function based on the beginning of the string (Vibecoded)
		local function customSort(a, b)
			for _, v in ipairs(customSortList) do
				local indexA = string.find(a.link, v, 1, true)
				local indexB = string.find(b.link, v, 1, true)

				if indexA == 1 and indexB ~= 1 then
					return true
				elseif indexA ~= 1 and indexB == 1 then
					return false
				end
			end

			-- If custom sort index is the same, compare alphabetically
			return string.gsub(a.link, ".-(:%|h)", "") < string.gsub(b.link, ".-(:%|h)", "")
		end

		-- Group and sort recipes and vendor items
		local recipesSorted1 = {}
		local recipesSorted2 = {}

		for k, v in pairs(ProfessionShoppingList_Data.Recipes) do
			if type(k) == "number" then
				recipesSorted1[#recipesSorted1+1] = {recipeID = k, recraft = v.recraft, quantity = v.quantity, link = v.link}
			else
				recipesSorted2[#recipesSorted2+1] = {recipeID = k, recraft = v.recraft, quantity = v.quantity, link = v.link}
			end
		end

		table.sort(recipesSorted1, customSort)
		table.sort(recipesSorted2, customSort)

		-- Combine the sorted entries into a combined table
		local recipesSorted = {}

		for _, key in ipairs(recipesSorted1) do
			table.insert(recipesSorted, key)
		end
		for _, key in ipairs(recipesSorted2) do
			table.insert(recipesSorted, key)
		end

		for _i, recipeInfo in ipairs(recipesSorted) do
			rowNo = rowNo + 1

			local row = CreateFrame("Button", nil, app.Window.Recipes)
			row:SetSize(0,16)
			row:SetHighlightAtlas("Options_List_Active", "ADD")
			row:RegisterForDrag("LeftButton")
			row:RegisterForClicks("AnyUp")
			row:SetScript("OnDragStart", function() app:MoveWindow() end)
			row:SetScript("OnDragStop", function() app:SaveWindow() end)
			row:SetScript("OnEnter", function()
				app:ShowWindowTooltip(recipeInfo.link, true, L.WINDOW_TOOLTIP_RECIPES)
			end)
			row:SetScript("OnLeave", function()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
				ShoppingTooltip1:ClearLines()
				ShoppingTooltip1:Hide()
			end)
			row:SetScript("OnClick", function(self, button)
				-- Right-click on recipe amount
				if button == "RightButton" then
					-- Untrack the recipe
					if IsControlKeyDown() then
						app:UntrackRecipe(recipeInfo.recipeID, 0)
					else
						app:UntrackRecipe(recipeInfo.recipeID, 1)
					end
				-- Left-click on recipe
				elseif button == "LeftButton" then
					-- If Shift is held also
					if IsShiftKeyDown() then
						-- Try write link to chat
						ChatFrameUtil.InsertLink(recipeInfo.link)
						app:SearchAH(recipeInfo.link)
					-- If Control is held also
					elseif IsControlKeyDown() and type(recipeInfo.recipeID) == "number" then
							C_TradeSkillUI.SetRecipeItemNameFilter("")	-- Clear search filter, which can interfere
							C_TradeSkillUI.OpenRecipe(recipeInfo.recipeID)
					-- If Alt is held also
					elseif IsAltKeyDown() and type(recipeInfo.recipeID) == "number" then
						C_TradeSkillUI.SetRecipeItemNameFilter("")	-- Clear search filter, which can interfere
						C_TradeSkillUI.OpenRecipe(recipeInfo.recipeID)
						-- Make sure the tradeskill frame is loaded
						if C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
							C_TradeSkillUI.CraftRecipe(recipeInfo.recipeID, ProfessionShoppingList_Data.Recipes[recipeInfo.recipeID].quantity)
						end
					end
				end
			end)

			app.Rows.Recipe[rowNo] = row

			local tradeskill = 999
			if ProfessionShoppingList_Cache.FakeRecipes[recipeInfo.recipeID] then
				tradeskill = ProfessionShoppingList_Cache.FakeRecipes[recipeInfo.recipeID].tradeskillID
			elseif ProfessionShoppingList_Library[recipeInfo.recipeID] then
				tradeskill = ProfessionShoppingList_Library[recipeInfo.recipeID].tradeskillID or 999
			end

			local icon1 = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			icon1:SetPoint("LEFT", row)
			icon1:SetScale(1.2)
			icon1:SetText(app.IconProfession[tradeskill])

			local text2 = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			text2:SetPoint("CENTER", icon1)
			text2:SetPoint("RIGHT", app.Window.Child)
			text2:SetJustifyH("RIGHT")
			text2:SetTextColor(1, 1, 1)
			text2:SetText(recipeInfo.quantity)

			local text1 = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			text1:SetPoint("LEFT", icon1, "RIGHT", 3, 0)
			text1:SetPoint("RIGHT", text2, "LEFT")
			text1:SetTextColor(1, 1, 1)
			text1:SetText(recipeInfo.link)
			text1:SetJustifyH("LEFT")
			text1:SetWordWrap(false)

			maxLength1 = math.max(icon1:GetStringWidth()+text1:GetStringWidth()+text2:GetStringWidth(), maxLength1)
		end

		local rowNo2 = 0
		local showReagents = true

		if not app.Window.Reagents then
			app.Window.Reagents = CreateFrame("Button", nil, app.Window.Child)
			app.Window.Reagents:SetSize(0,16)
			app.Window.Reagents:SetPoint("RIGHT", app.Window.Child)
			app.Window.Reagents:RegisterForDrag("LeftButton")
			app.Window.Reagents:SetHighlightAtlas("Options_List_Active", "ADD")
			app.Window.Reagents:SetScript("OnDragStart", function() app:MoveWindow() end)
			app.Window.Reagents:SetScript("OnDragStop", function() app:SaveWindow() end)

			local reagents1 = app.Window.Reagents:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			reagents1:SetPoint("LEFT", app.Window.Reagents)
			reagents1:SetText(L.WINDOW_HEADER_REAGENTS)
			reagents1:SetScale(1.1)
			app.ReagentHeader = reagents1
		end
		if rowNo == 0 then
			app.Window.Reagents:SetPoint("TOPLEFT", app.Window.Recipes, "BOTTOMLEFT", 0, -2)
		else
			app.Window.Reagents:SetPoint("TOPLEFT", app.Window.Recipes, "BOTTOMLEFT", 0, rowNo*-16)
		end
		app.Window.Reagents:SetScript("OnClick", function(self)
			local children = {self:GetChildren()}

			if showReagents then
				for _, child in ipairs(children) do child:Hide() end
				app.Window.Cooldowns:SetPoint("TOPLEFT", app.Window.Reagents, "BOTTOMLEFT", 0, -2)
				showReagents = false
			else
				for _, child in ipairs(children) do child:Show() end
				local offset = -2
				if #app.Rows.Reagent >= 1 then offset = -16*#app.Rows.Reagent end
				app.Window.Cooldowns:SetPoint("TOPLEFT", app.Window.Reagents, "BOTTOMLEFT", 0, offset)
				showReagents = true
			end
		end)

		local reagentsSorted = {}
		for k, v in pairs(app.ReagentQuantities) do
			if not ProfessionShoppingList_Cache.Reagents[k] then
				-- Cache item
				app:CacheItem(k)

				if not C_Item.IsItemDataCachedByID(k) then
					app:Debug("app.UpdateRecipes(" .. k .. ")")

					C_Item.RequestLoadItemDataByID(k)
					local item = Item:CreateFromItemID(k)

					item:ContinueOnItemLoad(function()
						app:UpdateRecipes()
					end)

					return
				end
			end
			reagentsSorted[#reagentsSorted+1] = {reagentID = k, quantity = v, icon = ProfessionShoppingList_Cache.Reagents[k].icon, link = ProfessionShoppingList_Cache.Reagents[k].link}
		end

		for _, reagentInfo in ipairs(reagentsSorted) do
			rowNo2 = rowNo2 + 1

			local row = CreateFrame("Button", nil, app.Window.Reagents, "", reagentInfo.reagentID)
			row:SetSize(0,16)
			row:SetHighlightAtlas("Options_List_Active", "ADD")
			row:RegisterForDrag("LeftButton")
			row:SetScript("OnDragStart", function() app:MoveWindow() end)
			row:SetScript("OnDragStop", function() app:SaveWindow() end)
			row:SetScript("OnEnter", function()
				app:ShowWindowTooltip(reagentInfo.link, true, L.WINDOW_TOOLTIP_REAGENTS)
			end)
			row:SetScript("OnLeave", function()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
				ShoppingTooltip1:ClearLines()
				ShoppingTooltip1:Hide()
			end)
			row:SetScript("OnClick", function(self, button)
				local function trackSubreagent(recipeID, itemID)
					-- Define the amount of recipes to be tracked
					local quantityMade = C_TradeSkillUI.GetRecipeSchematic(recipeID, false).quantityMin
					local amount = math.max(0, math.ceil((app.ReagentQuantities[itemID] - app:GetReagentCount(itemID)) / quantityMade))
					if ProfessionShoppingList_Data.Recipes[recipeID] then amount = math.max(0, (amount - ProfessionShoppingList_Data.Recipes[recipeID].quantity)) end

					-- Track the recipe (don't track if 0)
					if amount > 0 then app:TrackRecipe(recipeID, amount) end
				end

				-- Control+click on reagent
				if button == "LeftButton" and IsControlKeyDown() then
					-- Get itemIDs
					local itemID = reagentInfo.reagentID

					-- Get possible recipeIDs
					local recipeIDs = {}
					local no = 0

					for recipe, recipeInfo in pairs(ProfessionShoppingList_Library) do
						if type(recipeInfo) ~= "number" then	-- Because of old ProfessionShoppingList_Library
							local lookupItemID = itemID
							if ProfessionShoppingList_Cache.ReagentTiers[itemID] then lookupItemID = ProfessionShoppingList_Cache.ReagentTiers[itemID].one end

							if recipeInfo.itemID == lookupItemID and not app.nyiRecipes[recipe] then
								no = no + 1
								recipeIDs[no] = recipe
							end
						end
					end

					-- If there is only one possible recipe, use that
					if no == 1 then
						trackSubreagent(recipeIDs[1], itemID)
					-- If there is more than one possible recipe, provide options
					elseif no > 1 then
						-- Create popup frame
						local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
						f:SetPoint("CENTER")
						f:SetBackdrop({
							bgFile = "Interface/Tooltips/UI-Tooltip-Background",
							edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
							edgeSize = 16,
							insets = { left = 4, right = 4, top = 4, bottom = 4 },
						})
						f:SetBackdropColor(0, 0, 0, 1)
						f:EnableMouse(true)
						f:SetMovable(true)
						f:RegisterForDrag("LeftButton")
						f:SetScript("OnDragStart", function(self, button) self:StartMoving() end)
						f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
						f:Show()

						-- Close button
						local close = CreateFrame("Button", "pslOptionCloseButton", f, "UIPanelCloseButton")
						close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -1)
						close:SetScript("OnClick", function()
							f:Hide()
						end)

						-- Text
						local pslOptionText = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
						pslOptionText:SetPoint("CENTER", f, "CENTER", 0, 0)
						pslOptionText:SetPoint("TOP", f, "TOP", 0, -10)
						pslOptionText:SetJustifyH("CENTER")
						pslOptionText:SetText("|cffFFFFFF" .. L.SUBREAGENTS1 .. ":\n" .. reagentInfo.link .. "\n\n" .. L.SUBREAGENTS2 .. ":")

						-- Text
						local pslOption1 = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
						pslOption1:SetPoint("LEFT", f, "LEFT", 10, 0)
						pslOption1:SetPoint("TOP", pslOptionText, "BOTTOM", 0, -40)
						pslOption1:SetWidth(200)
						pslOption1:SetJustifyH("LEFT")
						pslOption1:SetText("|cffFFFFFF")

						-- Get reagents #1
						local reagentsTable = {}
						app:GetReagents(reagentsTable, recipeIDs[1], 1, false)

						-- Create text #1
						for reagentID, reagentAmount in pairs(reagentsTable) do
							-- Get info
							local function getInfo()
								-- Cache item
								if not C_Item.IsItemDataCachedByID(reagentID) then
									app:Debug("getInfo(" .. reagentID .. ")")

									C_Item.RequestLoadItemDataByID(reagentID)
									local item = Item:CreateFromItemID(reagentID)

									item:ContinueOnItemLoad(function()
										getInfo()
									end)

									return
								end

								-- Get item info
								local itemName, itemLink = C_Item.GetItemInfo(reagentID)

								-- Add text
								pslOption1:SetText(pslOption1:GetText() .. reagentAmount .. "× " .. itemLink .. "\n")
							end
							getInfo()
						end

						-- Button #1
						local pslOptionButton1 = app:MakeButton(f, C_TradeSkillUI.GetRecipeSchematic(recipeIDs[1], false).name)
						pslOptionButton1:SetPoint("BOTTOM", pslOption1, "TOP", 0, 5)
						pslOptionButton1:SetPoint("CENTER", pslOption1, "CENTER", 0, 0)
						pslOptionButton1:SetScript("OnClick", function()
							trackSubreagent(recipeIDs[1], itemID)

							-- Hide the subreagents window
							f:Hide()
						end)

						-- If two options
						if no >= 2 then
							-- Adjust popup frame
							f:SetSize(430, 205)

							-- Text
							local pslOption2 = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
							pslOption2:SetPoint("LEFT", pslOption1, "RIGHT", 10, 0)
							pslOption2:SetPoint("TOP", pslOption1, "TOP", 0, 0)
							pslOption2:SetWidth(200)
							pslOption2:SetJustifyH("LEFT")
							pslOption2:SetText("|cffFFFFFF")

							-- Get reagents #2
							local reagentsTable = {}
							app:GetReagents(reagentsTable, recipeIDs[2], 1, false)

							-- Create text #2
							for reagentID, reagentAmount in pairs(reagentsTable) do
								-- Get info
								local function getInfo()
									-- Cache item
									if not C_Item.IsItemDataCachedByID(reagentID) then
										app:Debug("getInfo(" .. reagentID .. ")")

										C_Item.RequestLoadItemDataByID(reagentID)
										local item = Item:CreateFromItemID(reagentID)

										item:ContinueOnItemLoad(function()
											getInfo()
										end)

										return
									end

									-- Get item info
									local itemName, itemLink = C_Item.GetItemInfo(reagentID)

									-- Add text
									pslOption2:SetText(pslOption2:GetText() .. reagentAmount .. "× " .. itemLink .. "\n")
								end
								getInfo()
							end

							-- Button #2
							local pslOptionButton2 = app:MakeButton(f, C_TradeSkillUI.GetRecipeSchematic(recipeIDs[2], false).name)
							pslOptionButton2:SetPoint("BOTTOM", pslOption2, "TOP", 0, 5)
							pslOptionButton2:SetPoint("CENTER", pslOption2, "CENTER", 0, 0)
							pslOptionButton2:SetScript("OnClick", function()
								trackSubreagent(recipeIDs[2], itemID)

								-- Hide the subreagents window
								f:Hide()
							end)
						end

						-- If three options
						if no >= 3 then
							-- Adjust popup frame
							f:SetSize(640, 200)

							-- Text
							local pslOption3 = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
							pslOption3:SetPoint("LEFT", pslOption1, "RIGHT", 220, 0)
							pslOption3:SetPoint("TOP", pslOption1, "TOP", 0, 0)
							pslOption3:SetWidth(200)
							pslOption3:SetJustifyH("LEFT")
							pslOption3:SetText("|cffFFFFFF")

							-- Get reagents #3
							local reagentsTable = {}
							app:GetReagents(reagentsTable, recipeIDs[3], 1, false)

							-- Create text #3
							for reagentID, reagentAmount in pairs(reagentsTable) do
								-- Get info
								local function getInfo()
									-- Cache item
									if not C_Item.IsItemDataCachedByID(reagentID) then
										app:Debug("getInfo(" .. reagentID .. ")")

										C_Item.RequestLoadItemDataByID(reagentID)
										local item = Item:CreateFromItemID(reagentID)

										item:ContinueOnItemLoad(function()
											getInfo()
										end)

										return
									end

									-- Get item info
									local itemName, itemLink = C_Item.GetItemInfo(reagentID)

									-- Add text
									pslOption3:SetText(pslOption3:GetText() .. reagentAmount .. "× " .. itemLink .. "\n")
								end
								getInfo()
							end

							-- Button #3
							local pslOptionButton3 = app:MakeButton(f, C_TradeSkillUI.GetRecipeSchematic(recipeIDs[3], false).name)
							pslOptionButton3:SetPoint("BOTTOM", pslOption3, "TOP", 0, 5)
							pslOptionButton3:SetPoint("CENTER", pslOption3, "CENTER", 0, 0)
							pslOptionButton3:SetScript("OnClick", function()
								trackSubreagent(recipeIDs[3], itemID)

								-- Hide the subreagents window
								f:Hide()
							end)
						end

						-- If four options
						if no >= 4 then
							-- Adjust popup frame
							f:SetSize(640, 335)

							-- Text
							local pslOption4 = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
							pslOption4:SetPoint("LEFT", pslOption1, "LEFT", 0, 0)
							pslOption4:SetPoint("TOP", pslOption1, "TOP", 0, -130)
							pslOption4:SetWidth(200)
							pslOption4:SetJustifyH("LEFT")
							pslOption4:SetText("|cffFFFFFF")

							-- Get reagents #4
							local reagentsTable = {}
							app:GetReagents(reagentsTable, recipeIDs[4], 1, false)

							-- Create text #4
							for reagentID, reagentAmount in pairs(reagentsTable) do
								-- Get info
								local function getInfo()
									-- Cache item
									if not C_Item.IsItemDataCachedByID(reagentID) then
										app:Debug("getInfo(" .. reagentID .. ")")

										C_Item.RequestLoadItemDataByID(reagentID)
										local item = Item:CreateFromItemID(reagentID)

										item:ContinueOnItemLoad(function()
											getInfo()
										end)

										return
									end

									-- Get item info
									local itemName, itemLink = C_Item.GetItemInfo(reagentID)

									-- Add text
									pslOption4:SetText(pslOption4:GetText() .. reagentAmount .. "× " .. itemLink .. "\n")
								end
								getInfo()
							end

							-- Button #4
							local pslOptionButton4 = app:MakeButton(f, C_TradeSkillUI.GetRecipeSchematic(recipeIDs[4], false).name)
							pslOptionButton4:SetPoint("BOTTOM", pslOption4, "TOP", 0, 5)
							pslOptionButton4:SetPoint("CENTER", pslOption4, "CENTER", 0, 0)
							pslOptionButton4:SetScript("OnClick", function()
								trackSubreagent(recipeIDs[4], itemID)

								-- Hide the subreagents window
								f:Hide()
							end)
						end

						-- If five options
						if no >= 5 then
							-- Text
							local pslOption5 = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
							pslOption5:SetPoint("LEFT", pslOption1, "RIGHT", 10, 0)
							pslOption5:SetPoint("TOP", pslOption1, "TOP", 0, -130)
							pslOption5:SetWidth(200)
							pslOption5:SetJustifyH("LEFT")
							pslOption5:SetText("|cffFFFFFF")

							-- Get reagents #5
							local reagentsTable = {}
							app:GetReagents(reagentsTable, recipeIDs[5], 1, false)

							-- Create text #5
							for reagentID, reagentAmount in pairs(reagentsTable) do
								-- Get info
								local function getInfo()
									-- Cache item
									if not C_Item.IsItemDataCachedByID(reagentID) then
										app:Debug("getInfo(" .. reagentID .. ")")

										C_Item.RequestLoadItemDataByID(reagentID)
										local item = Item:CreateFromItemID(reagentID)

										item:ContinueOnItemLoad(function()
											getInfo()
										end)

										return
									end

									-- Get item info
									local itemName, itemLink = C_Item.GetItemInfo(reagentID)

									-- Add text
									pslOption5:SetText(pslOption5:GetText() .. reagentAmount .. "× " .. itemLink .. "\n")
								end
								getInfo()
							end

							-- Button #5
							local pslOptionButton5 = app:MakeButton(f, C_TradeSkillUI.GetRecipeSchematic(recipeIDs[5], false).name)
							pslOptionButton5:SetPoint("BOTTOM", pslOption5, "TOP", 0, 5)
							pslOptionButton5:SetPoint("CENTER", pslOption5, "CENTER", 0, 0)
							pslOptionButton5:SetScript("OnClick", function()
								trackSubreagent(recipeIDs[5], itemID)

								-- Hide the subreagents window
								f:Hide()
							end)
						end

						-- If six options
						if no >= 6 then
							-- Text
							local pslOption6 = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
							pslOption6:SetPoint("LEFT", pslOption1, "RIGHT", 220, 0)
							pslOption6:SetPoint("TOP", pslOption1, "TOP", 0, -130)
							pslOption6:SetWidth(200)
							pslOption6:SetJustifyH("LEFT")
							pslOption6:SetText("|cffFFFFFF")

							-- Get reagents #6
							local reagentsTable = {}
							app:GetReagents(reagentsTable, recipeIDs[6], 1, false)

							-- Create text #6
							for reagentID, reagentAmount in pairs(reagentsTable) do
								-- Get info
								local function getInfo()
									-- Cache item
									if not C_Item.IsItemDataCachedByID(reagentID) then
										app:Debug("getInfo(" .. reagentID .. ")")

										C_Item.RequestLoadItemDataByID(reagentID)
										local item = Item:CreateFromItemID(reagentID)

										item:ContinueOnItemLoad(function()
											getInfo()
										end)

										return
									end

									-- Get item info
									local itemName, itemLink = C_Item.GetItemInfo(reagentID)

									-- Add text
									pslOption6:SetText(pslOption6:GetText() .. reagentAmount .. "× " .. itemLink .. "\n")
								end
								getInfo()
							end

							-- Button #6
							local pslOptionButton6 = app:MakeButton(f, C_TradeSkillUI.GetRecipeSchematic(recipeIDs[6], false).name)
							pslOptionButton6:SetPoint("BOTTOM", pslOption6, "TOP", 0, 5)
							pslOptionButton6:SetPoint("CENTER", pslOption6, "CENTER", 0, 0)
							pslOptionButton6:SetScript("OnClick", function()
								trackSubreagent(recipeIDs[6], itemID)

								-- Hide the subreagents window
								f:Hide()
							end)
						end
					end
				-- Activate if Shift+clicking on the reagent
				elseif button == "LeftButton" and IsShiftKeyDown() then
					ChatFrameUtil.InsertLink(reagentInfo.link)
					app:SearchAH(reagentInfo.link)
				end
			end)

			app.Rows.Reagent[rowNo2] = row

			local icon1 = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			icon1:SetPoint("LEFT", row)
			icon1:SetScale(1.2)
			icon1:SetText("|T"..reagentInfo.icon..":0|t")
			row.icon = icon1

			local text2 = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			text2:SetPoint("CENTER", icon1)
			text2:SetPoint("RIGHT", app.Window.Child)
			text2:SetJustifyH("RIGHT")
			text2:SetTextColor(1, 1, 1)
			text2:SetText(reagentInfo.quantity)
			row.text2 = text2

			local text1 = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			text1:SetPoint("LEFT", icon1, "RIGHT", 3, 0)
			text1:SetPoint("RIGHT", text2, "LEFT")
			text1:SetTextColor(1, 1, 1)
			text1:SetText(reagentInfo.link)
			text1:SetJustifyH("LEFT")
			text1:SetWordWrap(false)
			row.text1 = text1

			maxLength2 = math.max(icon1:GetStringWidth()+text1:GetStringWidth()+text2:GetStringWidth(), maxLength2)
		end

		-- Check what is being tracked
		local trackRecipes = false
		local trackItems = false
		for k, v in pairs(ProfessionShoppingList_Data.Recipes) do
			if type(k) == "number" or string.sub(k, 1, 6) == "order:" then
				trackRecipes = true
			else
				trackItems = true
			end
		end

		-- Set the header title accordingly
		if trackRecipes and trackItems then
			app.RecipeHeader:SetText(L.WINDOW_HEADER_RECIPES .. " & " .. L.WINDOW_HEADER_ITEMS .. " (" .. #app.Rows.Recipe .. ")")
			app.ReagentHeader:SetText(L.WINDOW_HEADER_REAGENTS .. " & " .. L.WINDOW_HEADER_COSTS)
		elseif trackRecipes == false and trackItems then
			app.RecipeHeader:SetText(L.WINDOW_HEADER_ITEMS .. " (" .. #app.Rows.Recipe .. ")")
			app.ReagentHeader:SetText(L.WINDOW_HEADER_COSTS)
		else
			if #app.Rows.Recipe == 0 then
				app.RecipeHeader:SetText(L.WINDOW_HEADER_RECIPES)
			else
				app.RecipeHeader:SetText(L.WINDOW_HEADER_RECIPES .. " (" .. #app.Rows.Recipe .. ")")
			end
			app.ReagentHeader:SetText(L.WINDOW_HEADER_REAGENTS)
		end

		local rowNo3 = 0
		local showCooldowns = true

		if not app.Window.Cooldowns then
			app.Window.Cooldowns = CreateFrame("Button", nil, app.Window.Child)
			app.Window.Cooldowns:SetSize(0,16)
			app.Window.Cooldowns:SetPoint("RIGHT", app.Window.Child)
			app.Window.Cooldowns:RegisterForDrag("LeftButton")
			app.Window.Cooldowns:SetHighlightAtlas("Options_List_Active", "ADD")
			app.Window.Cooldowns:SetScript("OnDragStart", function() app:MoveWindow() end)
			app.Window.Cooldowns:SetScript("OnDragStop", function() app:SaveWindow() end)

			local cooldowns1 = app.Window.Cooldowns:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			cooldowns1:SetPoint("LEFT", app.Window.Cooldowns)
			cooldowns1:SetText(L.WINDOW_HEADER_COOLDOWNS)
			cooldowns1:SetScale(1.1)
		end

		local next = next
		if next(ProfessionShoppingList_Data.Cooldowns) == nil or ProfessionShoppingList_Settings["showRecipeCooldowns"] == false then
			app.Window.Cooldowns:Hide()
			showCooldowns = false
		else
			app.Window.Cooldowns:Show()
		end

		local offset = -2
		if rowNo2 >= 1 then offset = -16*#app.Rows.Reagent end
		app.Window.Cooldowns:SetPoint("TOPLEFT", app.Window.Reagents, "BOTTOMLEFT", 0, offset)

		app.Window.Cooldowns:SetScript("OnClick", function(self)
			local children = {self:GetChildren()}

			if showCooldowns then
				for i_, child in ipairs(children) do child:Hide() end
				showCooldowns = false
			else
				for i_, child in ipairs(children) do child:Show() end
				showCooldowns = true
			end
		end)

		local cooldownsSorted = {}
		for k, v in pairs(ProfessionShoppingList_Data.Cooldowns) do
			local timedone = v.start + v.cooldown
			cooldownsSorted[#cooldownsSorted+1] = {id = k, recipeID = v.recipeID, start = v.start, cooldown = v.cooldown, name = v.name, user = v.user, time = timedone, maxCharges = v.maxCharges, charges = v.charges}
		end
		table.sort(cooldownsSorted, function(a, b) return a.time > b.time end)

		for _, cooldownInfo in pairs(cooldownsSorted) do
			rowNo3 = rowNo3 + 1

			local row = CreateFrame("Button", nil, app.Window.Cooldowns, "", cooldownInfo.id)
			row:SetSize(0,16)
			row:SetHighlightAtlas("Options_List_Active", "ADD")
			row:RegisterForDrag("LeftButton")
			row:RegisterForClicks("AnyUp")
			row:SetScript("OnDragStart", function() app:MoveWindow() end)
			row:SetScript("OnDragStop", function() app:SaveWindow() end)
			row:SetScript("OnEnter", function()
				app:ShowWindowTooltip("|cffFFFFFF" .. cooldownInfo.user, false, L.WINDOW_TOOLTIP_COOLDOWNS)
			end)
			row:SetScript("OnLeave", function()
				GameTooltip:ClearLines()
				GameTooltip:Hide()
				ShoppingTooltip1:ClearLines()
				ShoppingTooltip1:Hide()
			end)
			row:SetScript("OnClick", function(self, button)
				if button == "RightButton" and IsShiftKeyDown() then
					table.remove(ProfessionShoppingList_Data.Cooldowns, cooldownInfo.id)
					app:UpdateRecipes()
				elseif button == "LeftButton" then
					-- If Control is held also
					if IsControlKeyDown() then
						C_TradeSkillUI.SetRecipeItemNameFilter("")	-- Clear search filter, which can interfere
						C_TradeSkillUI.OpenRecipe(cooldownInfo.recipeID)
					-- If Alt is held also
					elseif IsAltKeyDown() then
						C_TradeSkillUI.SetRecipeItemNameFilter("")	-- Clear search filter, which can interfere
						C_TradeSkillUI.OpenRecipe(cooldownInfo.recipeID)
						-- Make sure the tradeskill frame is loaded
						if C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
							C_TradeSkillUI.CraftRecipe(cooldownInfo.recipeID)
						end
					end
				end
			end)

			app.Rows.Cooldown[rowNo3] = row
			if rowNo3 == 1 then
				row:SetPoint("TOPLEFT", app.Window.Cooldowns, "BOTTOMLEFT")
				row:SetPoint("TOPRIGHT", app.Window.Cooldowns, "BOTTOMRIGHT")
			else
				row:SetPoint("TOPLEFT", app.Rows.Cooldown[rowNo3-1], "BOTTOMLEFT")
				row:SetPoint("TOPRIGHT", app.Rows.Cooldown[rowNo3-1], "BOTTOMRIGHT")
			end

			local tradeskill = ProfessionShoppingList_Library[cooldownInfo.recipeID].tradeskillID or 999

			local icon1 = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			icon1:SetPoint("LEFT", row)
			icon1:SetScale(1.2)
			icon1:SetText(app.IconProfession[tradeskill])
			row.icon = icon1

			local cooldownRemaining = cooldownInfo.start + cooldownInfo.cooldown - GetServerTime()
			local days, hours, minutes

			days = math.floor(cooldownRemaining/(60*60*24))
			hours = math.floor((cooldownRemaining - (days*60*60*24))/(60*60))
			minutes = math.floor((cooldownRemaining - ((days*60*60*24) + (hours*60*60)))/60)

			local text2 = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			text2:SetPoint("CENTER", icon1)
			text2:SetPoint("RIGHT", app.Window.Child)
			text2:SetJustifyH("RIGHT")
			text2:SetTextColor(1, 1, 1)
			if cooldownRemaining <= 0 then
				text2:SetText(L.READY)
			elseif cooldownRemaining < 60*60 then
				text2:SetText(minutes .. L.MINUTES)
			elseif cooldownRemaining < 60*60*24 then
				text2:SetText(hours .. L.HOURS .. " " .. minutes .. L.MINUTES)
			else
				text2:SetText(days .. L.DAYS .. " " .. hours .. L.HOURS .. " " .. minutes .. L.MINUTES)
			end
			row.text2 = text2

			local text1 = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			text1:SetPoint("LEFT", icon1, "RIGHT", 3, 0)
			text1:SetPoint("RIGHT", text2, "LEFT")
			text1:SetTextColor(1, 1, 1)
			if cooldownInfo.maxCharges > 0 then
				text1:SetText(cooldownInfo.name .. " (" .. cooldownInfo.charges .. "/" .. cooldownInfo.maxCharges .. ")")
			else
				text1:SetText(cooldownInfo.name)
			end
			text1:SetJustifyH("LEFT")
			text1:SetWordWrap(false)
			row.text1 = text1

			maxLength3 = math.max(icon1:GetStringWidth()+text1:GetStringWidth()+text2:GetStringWidth(), maxLength3)
		end

		function app:ResizeWindow(save)
			local windowHeight = 62
			local windowWidth = 0
			if next(ProfessionShoppingList_Data.Cooldowns) == nil or ProfessionShoppingList_Settings["showRecipeCooldowns"] == false then
				windowHeight = windowHeight - 16
			elseif showCooldowns then
				windowHeight = windowHeight + rowNo3 * 16
				windowWidth = math.max(windowWidth, maxLength3, app.Rows.CooldownWidth)
			end
			if showReagents then
				windowHeight = windowHeight + rowNo2 * 16
				windowWidth = math.max(windowWidth, maxLength2, app.Rows.ReagentWidth)
			end
			if showRecipes then
				windowHeight = windowHeight + rowNo * 16
				windowWidth = math.max(windowWidth, maxLength1)
			end
			if showRecipes == false or #ProfessionShoppingList_Data.Recipes < 1 then
				windowHeight = windowHeight + 2	-- Not sure why this is needed, but whatever
			end
			if windowHeight > math.floor(GetScreenHeight()*0.8) then windowHeight = math.floor(GetScreenHeight()*0.8) end
			if windowWidth > math.floor(GetScreenWidth()*0.8) then windowWidth = math.floor(GetScreenWidth()*0.8) end

			app.Window:SetHeight(math.max(140,windowHeight))
			app.Window:SetWidth(math.max(140,windowWidth+40))
			app.Window.ScrollFrame:SetVerticalScroll(0)

			if save then app:SaveWindow() end
		end

		app.Window.Corner:SetScript("OnDoubleClick", function()
			app:ResizeWindow(true)
		end)

		-- Update numbers tracked and assets like buttons
		app:UpdateNumbers()
		app:UpdateAssets()
	end
end

-- Show window and update numbers
function app:ShowWindow()
	if not app.Window:IsShown() then
		app.Window:ClearAllPoints()
		if ProfessionShoppingList_Settings["pcWindows"] then
			app.Window:SetSize(ProfessionShoppingList_Settings["pcWindowPosition"].width, ProfessionShoppingList_Settings["pcWindowPosition"].height)
			app.Window:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", ProfessionShoppingList_Settings["pcWindowPosition"].left, ProfessionShoppingList_Settings["pcWindowPosition"].bottom)
		else
			app.Window:SetSize(ProfessionShoppingList_Settings["windowPosition"].width, ProfessionShoppingList_Settings["windowPosition"].height)
			app.Window:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", ProfessionShoppingList_Settings["windowPosition"].left, ProfessionShoppingList_Settings["windowPosition"].bottom)
		end

		app.Window:Show()
	end

	-- Update numbers
	app:UpdateRecipes()
end

-- Toggle window
function api:ToggleWindow()
	assert(self == api, "Call ProfessionShoppingList:ToggleWindow(), not ProfessionShoppingList.ToggleWindow()")

	if app.Tab and app.Tab.IsShown[0] then return end
	if app.Window:IsShown() then
		app.Window:Hide()
	else
		app:ShowWindow()
	end
end

-- When the player gains currency
app.Event:Register("CHAT_MSG_CURRENCY", function()
	if not InCombatLockdown() then
		-- If any recipes are tracked
		local next = next
		if next(ProfessionShoppingList_Data.Recipes) ~= nil then
			app:UpdateNumbers()
		end
	end
end)

-- When bag changes occur (out of combat)
app.Event:Register("BAG_UPDATE_DELAYED", function()
	if not InCombatLockdown() then
		-- If any recipes are tracked
		local next = next
		if next(ProfessionShoppingList_Data.Recipes) ~= nil then
			app:UpdateNumbers()
		end

		-- If the setting for split reagent bag count is enabled
		if ProfessionShoppingList_Settings["backpackCount"] then
			-- Get number of free bag slots
			local freeSlots1 = C_Container.GetContainerNumFreeSlots(0) + C_Container.GetContainerNumFreeSlots(1) + C_Container.GetContainerNumFreeSlots(2) + C_Container.GetContainerNumFreeSlots(3) + C_Container.GetContainerNumFreeSlots(4)
			local freeSlots2 = C_Container.GetContainerNumFreeSlots(5)

			-- If a reagent bag is equipped
			if C_Container.GetContainerNumSlots(5) ~= 0 then
				-- Replace the bag count text
				MainMenuBarBackpackButtonCount:SetText("(" .. freeSlots1 .. "+" .. freeSlots2 .. ")")
			end
		end
	end
end)

-------------------------
-- TRACKING WINDOW TAB --
-------------------------

function app:CreateTab(frame)
	app.Tab = app.Tab or {}
	app.Tab.IsShown = app.Tab.IsShown or {}
	if app.Tab[frame] then return end

	app.Tab[frame] = CreateFrame("Frame", nil, frame, "ProfessionShoppingList_Tab")

	local function showWindow()
		app:ShowWindow()
		app.Window:ClearAllPoints()
		app.Window:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, -1)
		app.Window:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 0, 0)
		app.Tab[frame]:SetPoint("TOPLEFT", app.Window, "TOPRIGHT", -1, -50)

		app.Tab.IsShown[frame] = true
		app.Tab.IsShown[0] = true
		app.Tab[frame]:SetChecked(true)

		app.CloseButton:Disable()
		app.UnlockButton:Disable()
		app:LockWindow()
	end

	local function hideWindow()
		app.Tab[frame]:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, -52)
		app.Tab.IsShown[frame] = false
		app.Tab.IsShown[0] = false
		api:ToggleWindow()
		app.Tab[frame]:SetChecked(false)

		app.CloseButton:Enable()
		app.UnlockButton:Enable()
		if not ProfessionShoppingList_Settings["windowLocked"] then app:UnlockWindow() end
	end

	local function toggleWindow()
		if app.Tab.IsShown[frame] and ProfessionShoppingList_Settings["tabOpened"] then
			ProfessionShoppingList_Settings["tabOpened"] = false
			hideWindow()
		elseif not app.Tab.IsShown[frame] and not ProfessionShoppingList_Settings["tabOpened"] then
			ProfessionShoppingList_Settings["tabOpened"] = true
			showWindow()
		end
	end

	local function onWindowShow()
		if ProfessionShoppingList_Settings["tabOpened"] and not app.Tab.IsShown[0] then
			showWindow()
		end
	end

	app.Tab[frame]:SetChecked(false)
	app.Tab[frame]:SetCustomOnMouseUpHandler(toggleWindow)

	frame:HookScript("OnShow", function()
		onWindowShow()
	end)
	onWindowShow()

	frame:HookScript("OnHide", function()
		if app.Tab.IsShown[frame] then
			hideWindow()
		end
	end)
end

app.Event:Register("TRADE_SKILL_SHOW", function()
	if C_AddOns.IsAddOnLoaded("Numdelicious_QoL_Tweaks") and NumyQT_DB.modules["ProfessionButtonTab"] then return end

	if ProfessionsFrame then
		app:CreateTab(ProfessionsFrame)
		hooksecurefunc(ProfessionsFrame.CraftingPage.CraftingOutputLog, "FinalizeResultData", function(self)
			if app.Tab and app.Tab.IsShown[0] then
				ProfessionsFrame.CraftingPage.CraftingOutputLog:Cleanup()
				ProfessionsFrame.OrdersPage.OrderView.CraftingOutputLog:Cleanup()
			end
		end)
	end
end)

app.Event:Register("AUCTION_HOUSE_SHOW", function()
	if AuctionHouseFrame then app:CreateTab(AuctionHouseFrame) end
end)

app.Event:Register("CRAFTINGORDERS_SHOW_CUSTOMER", function()
	if ProfessionsCustomerOrdersFrame then app:CreateTab(ProfessionsCustomerOrdersFrame) end
end)

------------------------
-- RECIPE INFORMATION --
------------------------

-- Register a recipe's information
function app:RegisterRecipe(recipeID)
	local item = C_TradeSkillUI.GetRecipeOutputItemData(recipeID).itemID or 0
	local _, _, tradeskill = C_TradeSkillUI.GetTradeSkillLineForRecipe(recipeID)
	local ability = C_TradeSkillUI.GetRecipeInfo(recipeID).skillLineAbilityID

	-- Register if the recipe is known
	local recipeLearned = C_TradeSkillUI.GetRecipeInfo(recipeID).learned

	-- Create the table entry
	if not ProfessionShoppingList_Library[recipeID] or type(ProfessionShoppingList_Library[recipeID]) == "number" then	-- I still have no idea where these number values come from
		ProfessionShoppingList_Library[recipeID] = {}
	end

	-- (Over)write the info
	ProfessionShoppingList_Library[recipeID].itemID = item
	ProfessionShoppingList_Library[recipeID].abilityID = ability
	ProfessionShoppingList_Library[recipeID].tradeskillID = tradeskill

	-- But only update the recipe learned info if it's our own profession window, and it's true (to avoid the recipe marking as unlearned from viewing the same profession on alts)
	if not C_TradeSkillUI.IsTradeSkillLinked() and not C_TradeSkillUI.IsTradeSkillGuild() and recipeLearned then
		ProfessionShoppingList_Library[recipeID].learned = recipeLearned
	end
end

-- When a tradeskill window is opened
app.Event:Register("TRADE_SKILL_SHOW", function()
	if not InCombatLockdown() then
		-- Register all recipes for this profession, on a delay so we give all this info time to load.
		C_Timer.After(2, function()
			for _, recipeID in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do
				app:RegisterRecipe(recipeID)
			end
		end)
	end
end)

-- Save an item to our cache
function app:CacheItem(itemID)
	-- Cache the item by asking the server to give us the info
	local item = Item:CreateFromItemID(itemID)
	app:Debug("app:CacheItem(" .. itemID .. ")")

	-- And when the item is cached
	item:ContinueOnItemLoad(function()
		-- Get item info
		local _, itemLink, _, _, _, _, _, _, _, fileID = C_Item.GetItemInfo(itemID)

		-- Write the info to the cache
		ProfessionShoppingList_Cache.Reagents[itemID] = {link = itemLink, icon = fileID}

		-- Also create a Tier entry, which will not be complete, but will be overwritten with the accurate info if it is available
		if not ProfessionShoppingList_Cache.ReagentTiers[itemID] then
			local quality = C_TradeSkillUI.GetItemReagentQualityByItemInfo(itemID)
			if quality == 3 then
				ProfessionShoppingList_Cache.ReagentTiers[itemID] = { one = 0, two = 0, three = itemID }
			elseif quality == 2 then
				ProfessionShoppingList_Cache.ReagentTiers[itemID] = { one = 0, two = itemID, three = 0 }
			else
				ProfessionShoppingList_Cache.ReagentTiers[itemID] = { one = itemID, two = 0, three = 0 }
			end
		end
	end)
end

-- Get reagents for recipe
function app:GetReagents(reagentVariable, recipeID, recipeQuantity, recraft)
	-- Grab all the reagent info from the API
	local reagentsTable

	-- Check to see if it's a crafting order
	local craftingOrder = false
	local craftingRecipeID = recipeID
	if string.sub(recipeID, 1, 6) == "order:" then
		craftingOrder = true
		recipeID = string.match(recipeID, "^order:%d+:(%d+)")
	end

	-- Exception for SL legendary crafts
	if app.slLegendaryRecipeIDs[recipeID] then
		reagentsTable = C_TradeSkillUI.GetRecipeSchematic(recipeID, false, app.slLegendaryRecipeIDs[recipeID].rank).reagentSlotSchematics
	else
		reagentsTable = C_TradeSkillUI.GetRecipeSchematic(recipeID, recraft or false).reagentSlotSchematics
	end

	-- For every reagent, do
	for numReagent, reagentInfo in pairs(reagentsTable) do
		-- Only check basic reagents, not optional or finishing reagents
		if reagentInfo.reagentType == 1 then
			-- Get (quality tier 1) info
			local reagentID
			local reagentID1 = reagentInfo.reagents[1].itemID or 0
			local reagentID2 = 0
			local reagentID3 = 0
			local reagentAmount = reagentInfo.quantityRequired

			-- Get quality tier 2 info
			if reagentInfo.reagents[2] then
				reagentID2 = reagentInfo.reagents[2].itemID or 0
			end

			-- Get quality tier 3 info
			if reagentInfo.reagents[3] then
				reagentID3 = reagentInfo.reagents[3].itemID or 0
			end

			-- Adjust the numbers for crafting orders
			if craftingOrder and (not ProfessionShoppingList_Data.Recipes[craftingRecipeID] or not ProfessionShoppingList_Data.Recipes[craftingRecipeID].simRecipe) then
				for k, v in pairs(ProfessionShoppingList_Cache.FakeRecipes[craftingRecipeID].reagents) do
					if v.reagentInfo.reagent.itemID == reagentID1 or v.reagentInfo.reagent.itemID == reagentID2 or v.reagentInfo.reagent.itemID == reagentID3 then
						reagentAmount = reagentAmount - v.reagentInfo.quantity
					end
				end
			end

			-- Add the different reagent tiers into ProfessionShoppingList_Cache.ReagentTiers so they can be queried later
			-- No need to check if they already exist, we can just overwrite it
			ProfessionShoppingList_Cache.ReagentTiers[reagentID1] = {one = reagentID1, two = reagentID2, three = reagentID3}
			ProfessionShoppingList_Cache.ReagentTiers[reagentID2] = {one = reagentID1, two = reagentID2, three = reagentID3}
			ProfessionShoppingList_Cache.ReagentTiers[reagentID3] = {one = reagentID1, two = reagentID2, three = reagentID3}

			-- Remove ProfessionShoppingList_Cache.ReagentTiers[0]
			if ProfessionShoppingList_Cache.ReagentTiers[0] then ProfessionShoppingList_Cache.ReagentTiers[0] = nil end

			-- Check which quality reagent to use
			if ProfessionShoppingList_Settings["reagentQuality"] == 3 and reagentID3 ~= 0 then
				reagentID = reagentID3
			elseif ProfessionShoppingList_Settings["reagentQuality"] == 2 and reagentID2 ~= 0 then
				reagentID = reagentID2
			else
				reagentID = reagentID1
			end

			-- Add the reagentID to the reagent cache
			if not ProfessionShoppingList_Cache.Reagents[reagentID] then
				-- Cache item
				app:CacheItem(reagentID)

				if not C_Item.IsItemDataCachedByID(reagentID) then
					app:Debug("app:GetReagents(" .. reagentID .. ")")

					C_Item.RequestLoadItemDataByID(reagentID)
					local item = Item:CreateFromItemID(reagentID)

					item:ContinueOnItemLoad(function()
						app:GetReagents(reagentVariable, craftingRecipeID, recipeQuantity, recraft or false)
					end)

					return
				end
			end

			-- Add the info to the specified variable, if it's not 0 and not a simulated recipe
			if (ProfessionShoppingList_Data.Recipes[craftingRecipeID] and not ProfessionShoppingList_Data.Recipes[craftingRecipeID].simRecipe and reagentAmount > 0) or not ProfessionShoppingList_Data.Recipes[craftingRecipeID] then
				if reagentVariable[reagentID] == nil then reagentVariable[reagentID] = 0 end
				reagentVariable[reagentID] = reagentVariable[reagentID] + ( reagentAmount * recipeQuantity )
			end
		end
	end

	-- Manually insert the reagents if it's a simulated recipe
	if ProfessionShoppingList_Data.Recipes[craftingRecipeID] and ProfessionShoppingList_Data.Recipes[craftingRecipeID].simRecipe then
		for k, v in pairs(ProfessionShoppingList_Cache.SimulatedRecipes[craftingRecipeID]) do
			-- Check if the reagent isn't provided if it's a crafting order
			local providedReagents = {}
			if ProfessionShoppingList_Cache.FakeRecipes[craftingRecipeID] then
				for k, v in pairs(ProfessionShoppingList_Cache.FakeRecipes[craftingRecipeID].reagents) do
					-- Just add all qualities to be thorough, these can't double up within the same recipe anyway
					-- Unless it's a Spark >:(
					if ProfessionShoppingList_Cache.ReagentTiers[v.reagentInfo.reagent.itemID] then
						providedReagents[ProfessionShoppingList_Cache.ReagentTiers[v.reagentInfo.reagent.itemID].one] = v.reagentInfo.quantity
						providedReagents[ProfessionShoppingList_Cache.ReagentTiers[v.reagentInfo.reagent.itemID].two] = v.reagentInfo.quantity
						providedReagents[ProfessionShoppingList_Cache.ReagentTiers[v.reagentInfo.reagent.itemID].three] = v.reagentInfo.quantity
					end
				end
			end

			if not providedReagents[k] then
				if reagentVariable[k] == nil then reagentVariable[k] = 0 end
				reagentVariable[k] = reagentVariable[k] + (v * ProfessionShoppingList_Data.Recipes[craftingRecipeID].quantity)
			end
		end
	end
end

-- Get owned reagent quantity, accounting for reagent quality
function app:GetReagentCount(reagentID)
	local reagentCount = 0

	-- Index simulated reagents, whose quality is not subject to our quality setting
	local simulatedReagents = {}
	for k, v in pairs(ProfessionShoppingList_Cache.SimulatedRecipes) do
		for k2, v2 in pairs(v) do
			simulatedReagents[k2] = v2
		end
	end

	-- Helper functions
	local function tierThree()
		local reagentCount = C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].three, true, false, true, true)
		return reagentCount
	end

	local function tierTwo()
		local reagentCount
		if ProfessionShoppingList_Settings["includeHigher"] == 1 then
			reagentCount = math.max(0, C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].three, true, false, true, true) - (app.ReagentQuantities[ProfessionShoppingList_Cache.ReagentTiers[reagentID].three] or 0)) + C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].two, true, false, true, true)
		elseif ProfessionShoppingList_Settings["includeHigher"] >= 2 then
			reagentCount = C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].two, true, false, true, true)
		end
		return reagentCount
	end

	local function tierOne()
		local reagentCount
		if ProfessionShoppingList_Settings["includeHigher"] == 1 then
			reagentCount = math.max(0, (math.max(0, C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].three, true, false, true, true) - (app.ReagentQuantities[ProfessionShoppingList_Cache.ReagentTiers[reagentID].three] or 0)) + C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].two, true, false, true, true)) - (app.ReagentQuantities[ProfessionShoppingList_Cache.ReagentTiers[reagentID].two] or 0)) + C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].one, true, false, true, true)
		elseif ProfessionShoppingList_Settings["includeHigher"] == 2 then
			reagentCount = math.max(0, C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].two, true, false, true, true) - (app.ReagentQuantities[ProfessionShoppingList_Cache.ReagentTiers[reagentID].two] or 0)) + C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].one, true, false, true, true)
		elseif ProfessionShoppingList_Settings["includeHigher"] == 3 then
			reagentCount = C_Item.GetItemCount(ProfessionShoppingList_Cache.ReagentTiers[reagentID].one, true, false, true, true)
		end
		return reagentCount
	end

	-- Count the right reagents when it's applicable
	if simulatedReagents[reagentID] then
		if ProfessionShoppingList_Cache.ReagentTiers[reagentID] then
			if ProfessionShoppingList_Cache.ReagentTiers[reagentID].three == reagentID then
				reagentCount = tierThree()
			elseif ProfessionShoppingList_Cache.ReagentTiers[reagentID].two == reagentID then
				reagentCount = tierTwo()
			elseif ProfessionShoppingList_Cache.ReagentTiers[reagentID].one == reagentID then
				reagentCount = tierOne()
			end
		else
			reagentCount = C_Item.GetItemCount(reagentID, true, false, true, true)
		end
	-- Use our addon setting if there is no quality specified
	elseif ProfessionShoppingList_Cache.ReagentTiers[reagentID].three ~= 0 and ProfessionShoppingList_Settings["reagentQuality"] == 3 then
		reagentCount = tierThree()
	elseif ProfessionShoppingList_Cache.ReagentTiers[reagentID].two ~= 0 and ProfessionShoppingList_Settings["reagentQuality"] == 2 then
		reagentCount = tierTwo()
	elseif ProfessionShoppingList_Cache.ReagentTiers[reagentID].one ~= 0 and ProfessionShoppingList_Settings["reagentQuality"] == 1 then
		reagentCount = tierOne()
	-- And use this fallback if nothing even matters anymore
	else
		reagentCount = C_Item.GetItemCount(reagentID, true, false, true, true)
	end

	return reagentCount
end

--------------------------------
-- RECIPE (AND ITEM) TRACKING --
--------------------------------

-- Track recipe
function app:TrackRecipe(recipeID, recipeQuantity, recraft, orderID)
	local originalRecipeID = recipeID

	-- 2 = Salvage, recipes without reagents | Disable these, cause they shouldn't be tracked
	if C_TradeSkillUI.GetRecipeSchematic(recipeID,false).recipeType == 2 or C_TradeSkillUI.GetRecipeSchematic(recipeID,false).reagentSlotSchematics[1] == nil then
		return
	end

	-- Adjust the recipeID for SL legendary crafts, if a custom rank is entered
	if app.slLegendaryRecipeIDs[recipeID] then
		local rank = math.floor(app.ShadowlandsRankBox:GetNumber())
		if rank == 1 then
			recipeID = app.slLegendaryRecipeIDs[recipeID].one
		elseif rank == 2 then
			recipeID = app.slLegendaryRecipeIDs[recipeID].two
		elseif rank == 3 then
			recipeID = app.slLegendaryRecipeIDs[recipeID].three
		elseif rank == 4 then
			recipeID = app.slLegendaryRecipeIDs[recipeID].four
		end
	end

	-- Get some basic info
	local recipeType = C_TradeSkillUI.GetRecipeSchematic(recipeID,false).recipeType
	local recipeMin = C_TradeSkillUI.GetRecipeSchematic(recipeID,false).quantityMin
	local recipeMax = C_TradeSkillUI.GetRecipeSchematic(recipeID,false).quantityMax

	-- Add recipe link for crafted items
	local recipeLink

	if recipeType == 1 then
		local itemID = C_TradeSkillUI.GetRecipeSchematic(recipeID,false).outputItemID
		local _, itemLink
		if itemID ~= nil then
			-- Cache item
			if not C_Item.IsItemDataCachedByID(itemID) then
				app:Debug("app:TrackRecipe(" .. itemID .. ")")

				C_Item.RequestLoadItemDataByID(itemID)
				local item = Item:CreateFromItemID(itemID)

				item:ContinueOnItemLoad(function()
					app:TrackRecipe(recipeID, recipeQuantity, recraft or false, orderID)
				end)

				return
			end

			-- Get item info
			_, itemLink = C_Item.GetItemInfo(itemID)
		-- Exception for stuff like Abominable Stitching
		else
			itemLink = C_TradeSkillUI.GetRecipeSchematic(recipeID,false).name
		end

		-- Exceptions for SL legendary crafts
		if app.slLegendaryRecipeIDs[recipeID] then
			itemLink = itemLink .. " (" .. L.RANK .. " " .. app.slLegendaryRecipeIDs[recipeID].rank .. ")" -- Append the rank
		else
			itemLink = string.gsub(itemLink, " |A:Professions%-ChatIcon%-Quality%-Tier1:17:15::1|a", "") -- Remove the quality from the item string
		end

		-- Add quantity
		if recipeMin == recipeMax and recipeMin ~= 1 then
			itemLink = itemLink .. " ×" .. recipeMin
		elseif recipeMin ~= 1 then
			itemLink = itemLink .. " ×" .. recipeMin .. "-" .. recipeMax
		end

		recipeLink = itemLink

	-- Add recipe "link" for enchants
	elseif recipeType == 3 then recipeLink = C_TradeSkillUI.GetRecipeSchematic(recipeID,false).name
	end

	-- Order recipes
	if orderID then
		-- Process Patron Orders
		local ordersTable = C_CraftingOrders.GetCrafterOrders()
		local reagents = {}
		local key

		for i, orderInfo in pairs(ordersTable) do
			if orderID == orderInfo.orderID then
				key = "order:" .. orderID .. ":" .. recipeID

				ProfessionShoppingList_Cache.FakeRecipes[key] = {
					["spellID"] = recipeID,
					["tradeskillID"] = 1,	-- Crafting order
					["reagents"] = orderInfo.reagents
				}

				recipeID = key
			end
		end

		-- Process Personal/Guild Orders
		if not ProfessionShoppingList_Cache.FakeRecipes[key] then
			key = "order:" .. orderID .. ":" .. recipeID

			ProfessionShoppingList_Cache.FakeRecipes[key] = {
				["spellID"] = recipeID,
				["tradeskillID"] = 1,	-- Crafting order
				["reagents"] = app.SelectedRecipe.MakeOrder.reagents
			}

			recipeID = key
		end
	end

	local simRecipe = false
	-- Don't track simulated reagents if CraftSim and Testflight both have their simulation mode active
	-- This would give errors if either addon isn't enabled, but for now app:SimAddonCount() only includes these two anyway
	if app:SimAddonCount() > 1 and CraftSimAPI.GetCraftSim().SIMULATION_MODE.isActive and TestFlight.enabled then
		local addons = ""
		for k, v in pairs(app.SimAddons) do
			if k > 1 then
				addons = addons .. ", "
			end
			addons = addons .. v
		end
		app:Print(L.ERROR_MULTISIM, addons)
	-- List custom reagents for simulated recipes
	elseif app:SimAddonCount() >= 1 then
		if C_AddOns.IsAddOnLoaded("CraftSim") and CraftSimAPI.GetCraftSim().SIMULATION_MODE.isActive then
			-- Grab the reagents it provides
			local simulatedSimulationMode = CraftSimAPI.GetCraftSim().SIMULATION_MODE
			local simulatedRequiredReagents = simulatedSimulationMode.recipeData.reagentData.requiredReagents

			if simulatedRequiredReagents then
				local reagents = {}
				for k, v in pairs(simulatedRequiredReagents) do
					-- For reagents without quality
					if not v.hasQuality then
						reagents[v.items[1].item.itemID] = v.requiredQuantity
					-- For reagents with quality
					else
						for k2, v2 in pairs(v.items) do
							if v2.quantity > 0 then
								reagents[v2.item.itemID] = v2.quantity
							end
						end
					end
				end

				-- Save the reagents into a fake recipe
				simRecipe = true
				ProfessionShoppingList_Cache.SimulatedRecipes[recipeID] = reagents
			else
				app:Print(L.ERROR_CRAFTSIM)
			end
		elseif C_AddOns.IsAddOnLoaded("TestFlight") and TestFlight.enabled then
			local allocationTable
			if ProfessionsCustomerOrdersFrame and ProfessionsCustomerOrdersFrame:IsShown() then
				allocationTable = ProfessionsCustomerOrdersFrame.Form.transaction.allocationTbls
			elseif ProfessionsFrame and ProfessionsFrame:IsShown() and orderID then
				allocationTable = ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.transaction.allocationTbls
			elseif ProfessionsFrame and ProfessionsFrame:IsShown() then
				allocationTable = ProfessionsFrame.CraftingPage.SchematicForm.transaction.allocationTbls
			end

			local reagents = {}
			for k, v in pairs(allocationTable) do
				if v.allocs then
					for k2, v2 in pairs(v.allocs) do
						if v2.reagent then
							reagents[v2.reagent.itemID] = v2.quantity
						end
					end
				end
			end

			-- Save the reagents into a fake recipe
			simRecipe = true
			ProfessionShoppingList_Cache.SimulatedRecipes[recipeID] = reagents
		end
	end

	-- Track recipe
	if not ProfessionShoppingList_Data.Recipes[recipeID] then
		ProfessionShoppingList_Data.Recipes[recipeID] = { quantity = 0, recraft = recraft or false, link = recipeLink, simRecipe = simRecipe }
	end
	ProfessionShoppingList_Data.Recipes[recipeID].quantity = ProfessionShoppingList_Data.Recipes[recipeID].quantity + recipeQuantity

	app:ShowWindow()
end

-- Untrack recipe
function app:UntrackRecipe(recipeID, recipeQuantity)
	if ProfessionShoppingList_Data.Recipes[recipeID] ~= nil then
		-- Clear all recipes if quantity was set to 0
		if recipeQuantity == 0 then ProfessionShoppingList_Data.Recipes[recipeID].quantity = 0 end

		-- Untrack recipe
		ProfessionShoppingList_Data.Recipes[recipeID].quantity = ProfessionShoppingList_Data.Recipes[recipeID].quantity - recipeQuantity

		-- Set numbers to nil if it doesn't exist anymore
		if ProfessionShoppingList_Data.Recipes[recipeID].quantity <= 0 then
			ProfessionShoppingList_Data.Recipes[recipeID] = nil
			ProfessionShoppingList_Cache.SimulatedRecipes[recipeID] = nil
		end
	end

	-- Clear the cache if no recipes are tracked anymore
	local next = next
	if next(ProfessionShoppingList_Data.Recipes) == nil then app:Clear() end

	-- Update numbers
	app:UpdateRecipes()
end

-- Clear everything except the recipe cache
function app:Clear()
	ProfessionShoppingList_Data.Recipes = {}
	ProfessionShoppingList_Cache.Reagents = {}	-- Wasn't needed before, but it is with the new link formatting
	ProfessionShoppingList_Cache.FakeRecipes = {}
	ProfessionShoppingList_Cache.SimulatedRecipes = {}
	app:UpdateRecipes()
	app.Window.ScrollFrame:SetVerticalScroll(0)
end

-- Replace the in-game tracking of shift+clicking a recipe with PSL's
app.Event:Register("TRACKED_RECIPE_UPDATE", function(recipeID, tracked)
	if tracked then
		app:TrackRecipe(recipeID, 1, false)
		C_TradeSkillUI.SetRecipeTracked(recipeID, false, false)
		C_TradeSkillUI.SetRecipeTracked(recipeID, false, true)
	end
end)

-- When a recipe is selected in the tradeskillUI
EventRegistry:RegisterCallback("ProfessionsRecipeListMixin.Event.OnRecipeSelected", function(_, recipeInfo)
	local recipeID = recipeInfo["recipeID"]

	-- Check for ranks
	if recipeInfo.nextRecipeID and C_TradeSkillUI.GetRecipeInfo(recipeInfo.nextRecipeID).learned then
		recipeID = recipeInfo.nextRecipeID
		if C_TradeSkillUI.GetRecipeInfo(recipeInfo.nextRecipeID).nextRecipeID and C_TradeSkillUI.GetRecipeInfo(C_TradeSkillUI.GetRecipeInfo(recipeInfo.nextRecipeID).nextRecipeID).learned then
			recipeID = C_TradeSkillUI.GetRecipeInfo(recipeInfo.nextRecipeID).nextRecipeID
		end
	end

	app.SelectedRecipe.Profession = { recipeID = recipeID, recraft = recipeInfo.isRecraft, recipeType = C_TradeSkillUI.GetRecipeSchematic(recipeID, recipeInfo.isRecraft).recipeType }
	app:UpdateAssets()
end)

-- When selecting a recraft recipe
app.Event:Register("OPEN_RECIPE_RESPONSE", function(recipeID, skillLineID, expansionSkillLineID)
	local recraft = app.SelectedRecipe.Profession.recraft
	app.SelectedRecipe.Profession = { recipeID = recipeID, recraft = recraft, recipeType = C_TradeSkillUI.GetRecipeSchematic(recipeID, recraft).recipeType }
	app:UpdateAssets()
end)

-- When a spell is succesfully cast by the player (for removing crafted recipes)
app.Event:Register("UNIT_SPELLCAST_SUCCEEDED", function(unitTarget, castGUID, spellID)
	if not InCombatLockdown() and unitTarget == "player" then
		-- Run only when crafting a tracked recipe, and if the remove craft option is enabled
		if ProfessionShoppingList_Data.Recipes[spellID] and ProfessionShoppingList_Settings["removeCraft"] then
			-- Remove 1 tracked recipe when it has been crafted (if the option is enabled)
			app:UntrackRecipe(spellID, 1)

			-- Close window if no recipes are left and the option is enabled
			local next = next
			if next(ProfessionShoppingList_Data.Recipes) == nil and ProfessionShoppingList_Settings["closeWhenDone"] and not (app.Tab and app.Tab.IsShown) then
				app.Window:Hide()
			end
		end
	end
end)

-- Count how many supported sim addons are enabled
function app:SimAddonCount()
	local addonCount = 0

	for k, v in pairs(app.SimAddons) do
		if C_AddOns.IsAddOnLoaded(v) then
			addonCount = addonCount + 1
		end
	end

	return addonCount
end

-----------------------
-- COOLDOWN TRACKING --
-----------------------

-- When the user encounters a loading screen
app.Event:Register("PLAYER_ENTERING_WORLD", function(isInitialLogin, isReloadingUi)
	-- Only on initialLoad
	if isInitialLogin then
		-- Check all tracked recipe cooldowns
		for k, recipeInfo in pairs(ProfessionShoppingList_Data.Cooldowns) do
			-- Check the remaining cooldown
			local cooldownRemaining = recipeInfo.start + recipeInfo.cooldown - GetServerTime()

			-- If the recipe is off cooldown
			if cooldownRemaining <= 0 then
				-- Check charges if they exist and return one
				if recipeInfo.maxCharges > 0 and recipeInfo.maxCharges > recipeInfo.charges then
					ProfessionShoppingList_Data.Cooldowns[k].charges = ProfessionShoppingList_Data.Cooldowns[k].charges + 1

					-- And move the reset time if we're not at full charges yet
					if ProfessionShoppingList_Data.Cooldowns[k].charges ~= ProfessionShoppingList_Data.Cooldowns[k].maxCharges then
						ProfessionShoppingList_Data.Cooldowns[k].start = GetServerTime()
						ProfessionShoppingList_Data.Cooldowns[k].cooldown = C_DateAndTime.GetSecondsUntilDailyReset()
					end
				end

				-- If the option to show recipe cooldowns is enabled and all charges are full (or 0 = 0 for recipes without charges)
				if ProfessionShoppingList_Settings["showRecipeCooldowns"] and ProfessionShoppingList_Data.Cooldowns[k].charges == ProfessionShoppingList_Data.Cooldowns[k].maxCharges then
					-- Show the reminder
					app:Print(recipeInfo.name .. " " .. L.READY_TO_CRAFT .. " " .. recipeInfo.user .. ".")

					-- And open the window if that setting is enabled
					if ProfessionShoppingList_Settings["showWindowCooldown"] then
						app:ShowWindow()	-- This can run multiple times, but that doesn't do much harm
					end
				end
			end
		end
	end
end)

-- When a spell is succesfully cast by the player
app.Event:Register("UNIT_SPELLCAST_SUCCEEDED", function(unitTarget, castGUID, spellID)
	if not InCombatLockdown() and unitTarget == "player" then
		-- Run only when the spell cast is a known recipe
		if ProfessionShoppingList_Library[spellID] then
			-- With a delay due to how quickly that info is updated after UNIT_SPELLCAST_SUCCEEDED
			C_Timer.After(0.1, function()
				-- Get character info
				local character = UnitName("player")
				local realm = GetNormalizedRealmName()

				-- Get spell cooldown info
				local recipeName = C_TradeSkillUI.GetRecipeSchematic(spellID, false).name
				local cooldown, isDayCooldown, charges, maxCharges = C_TradeSkillUI.GetRecipeCooldown(spellID)	-- For daily cooldowns, cooldown returns the time until midnight, after relogging it's accurate. isDayCooldown can be used to identify if it should be aligned with daily reset right away.
				local recipeStart = GetServerTime()

				-- Remove shared cooldowns and only leave the last one done
				local function sharedCooldowns(spells)
					for k, v in pairs(spells) do
						if v ~= spellID then
							for k2, v2 in pairs(ProfessionShoppingList_Data.Cooldowns) do
								if v2.recipeID == v and v2.user == character .. "-" .. realm then
									table.remove(ProfessionShoppingList_Data.Cooldowns, k2)
								end
							end
						end
					end
				end

				-- Set timer to 7 days for the Alchemy sac transmutes
				if spellID == 213256 or spellID == 251808 then
					cooldown = 7 * 24 * 60 * 60
				-- Shared cooldowns for Dragonflight Alchemy experimentations
				elseif spellID == 370743 or spellID == 370745 or spellID == 370746 or spellID == 370747 then
					local spells = {370743, 370745, 370746, 370747}
					sharedCooldowns(spells)
				-- Shared cooldowns for The War Within Alchemy experimentations
				elseif spellID == 427174 or spellID == 430345 then
					local spells = {427174, 430345}
					sharedCooldowns(spells)
				-- Daily cooldowns (which return the wrong cooldown info initially)
				elseif isDayCooldown then
					-- Set the cooldown to align with daily reset
					cooldown = C_DateAndTime.GetSecondsUntilDailyReset()
				end

				-- If the spell cooldown exists
				if cooldown then
					-- Fix the cooldown table if necessary
					ProfessionShoppingList_Data.Cooldowns = app:FixTable(ProfessionShoppingList_Data.Cooldowns)

					-- Replace the existing entry if it exists
					local cdExists = false
					for k, v in ipairs(ProfessionShoppingList_Data.Cooldowns) do
						if v.recipeID == spellID and v.user == character .. "-" .. realm then
							ProfessionShoppingList_Data.Cooldowns[k] = {name = recipeName, recipeID = spellID, cooldown = cooldown, start = recipeStart, user = character .. "-" .. realm, charges = charges, maxCharges = maxCharges}
							cdExists = true
						end
					end
					-- Otherwise, create a new entry
					if cdExists == false then
						ProfessionShoppingList_Data.Cooldowns[#ProfessionShoppingList_Data.Cooldowns+1] = {name = recipeName, recipeID = spellID, cooldown = cooldown, start = recipeStart, user = character .. "-" .. realm, charges = charges, maxCharges = maxCharges}
					end
					-- And then update our window
					app:UpdateRecipes()
				end

				-- Recharge timer
				C_Timer.After(1, function()
					if ProfessionsFrame and ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount:GetText() then
						local concentration = string.match(ProfessionsFrame.CraftingPage.ConcentrationDisplay.Amount:GetText(), "%d+")

						if concentration then
							-- 250 Concentration per 24 hours
							local timeLeft = math.ceil((1000 - concentration) / 250 * 24)

							if app.Concentration1 then
								app.Concentration1:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r " .. timeLeft .. L.HOURS)
							end
							if app.Concentration2 then
								app.Concentration2:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r " .. timeLeft .. L.HOURS)
							end
						else
							if app.Concentration1 then
								app.Concentration1:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r ?")
							end
							if app.Concentration2 then
								app.Concentration2:SetText("|cffFFFFFF" .. L.RECHARGED .. ":|r ?")
							end
						end
					end
				end)
			end)
		end
	end
end)
