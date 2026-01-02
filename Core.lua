----------------------------------------
-- Profession Shopping List: Core.lua --
----------------------------------------

-- Initialisation
local appName, app = ...	-- Returns the addon name and a unique table
app.locales = {}	-- Localisation table
app.api = {}	-- Our "API" prefix
ProfessionShoppingList = app.api	-- Create a namespace for our "API"
local L = app.locales
local api = app.api

---------------------------
-- WOW API EVENT HANDLER --
---------------------------

app.Event = CreateFrame("Frame")
app.Event.handlers = {}

-- Register the event and add it to the handlers table
function app.Event:Register(eventName, func)
	if not self.handlers[eventName] then
		self.handlers[eventName] = {}
		self:RegisterEvent(eventName)
	end
	table.insert(self.handlers[eventName], func)
end

-- Run all handlers for a given event, when it fires
app.Event:SetScript("OnEvent", function(self, event, ...)
	if self.handlers[event] then
		for _, handler in ipairs(self.handlers[event]) do
			handler(...)
		end
	end
end)

----------------------
-- HELPER FUNCTIONS --
----------------------

-- Fix sequential tables with missing indexes (yes I expect to have to re-use this xD)
function app.FixTable(table)
	local fixedTable = {}
	local index = 1

	for i = 1, #table do
		if table[i] ~= nil then
			fixedTable[index] = table[i]
			index = index + 1
		end
	end

	return fixedTable
end

-- App colour
function app.Colour(string)
	return "|cff3FC7EB" .. string .. "|r"
end

-- Print with addon prefix
function app.Print(...)
	print(app.NameShort .. ":", ...)
end

-- Debug print with addon prefix
function app.Debug(...)
	if ProfessionShoppingList_Settings["debug"] then
		print(app.NameShort .. app.Colour(" Debug") .. ":", ...)
	end
end

-- Pop-up window
function app.Popup(show, text, ...)
	-- Create popup frame
	local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	frame:SetPoint("CENTER")
	frame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:EnableMouse(true)
	if show then
		frame:Show()
	else
		frame:Hide()
	end

	-- Close button
	local close = CreateFrame("Button", "", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
	close:SetScript("OnClick", function()
		frame:Hide()
	end)

	-- Text
	local string = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	string:SetPoint("CENTER", frame, "CENTER", 0, 0)
	string:SetPoint("TOP", frame, "TOP", 0, -15)
	string:SetJustifyH("LEFT")
	string:SetText(text)

	-- Editbox(es)
	local editBoxInputs = { ... }
	local editBoxes = {}
	local last = string

	for i, boxText in ipairs(editBoxInputs) do
		local edit = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
		edit:SetSize(300, 25)
		edit:SetAutoFocus(false)
		edit:SetText(boxText)
		edit:HighlightText()
		edit:SetCursorPosition(0)
		edit:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -10)

		-- Optional: select all text on focus
		edit:SetScript("OnEditFocusGained", function(self)
			self:HighlightText()
		end)

		table.insert(editBoxes, edit)
		last = edit
	end

	-- Resize frame to fit content
	local totalHeight = 30 + string:GetStringHeight() + (#editBoxes * 35)
	local width = math.max(string:GetStringWidth() + 40, 240)
	frame:SetSize(width, totalHeight)

	return frame, editBoxes

	-- frame:SetHeight(string:GetStringHeight()+30)
	-- frame:SetWidth(string:GetStringWidth()+30)

	-- return frame
end

-- Border
function app.Border(parent, a, b, c, d)
	local border = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	border:SetPoint("TOPLEFT", parent, a or 0, b or 0)
	border:SetPoint("BOTTOMRIGHT", parent, c or 0, d or 0)
	border:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		edgeSize = 14,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	border:SetBackdropColor(0, 0, 0, 0)
	border:SetBackdropBorderColor(0.25, 0.78, 0.92)
end

-- Button
function app.Button(parent, text)
	local frame = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	frame:SetText(text)
	frame:SetWidth(frame:GetTextWidth()+20)

	app.Border(frame, 0, 0, 0, -1)
	return frame
end

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		if not ProfessionShoppingList_Cache then ProfessionShoppingList_Cache = {} end
		if not ProfessionShoppingList_CharacterData then ProfessionShoppingList_CharacterData = {} end
		if not ProfessionShoppingList_Data then ProfessionShoppingList_Data = {} end
		if not ProfessionShoppingList_Library then ProfessionShoppingList_Library = {} end

		app.Flag = {}
		app.Flag.VersionCheck = 0

		C_ChatInfo.RegisterAddonMessagePrefix("ProfShopList")

		-- Slash commands
		SLASH_RELOADUI1 = "/rl"
		SlashCmdList.RELOADUI = ReloadUI

		SLASH_ProfessionShoppingList1 = "/psl"
		function SlashCmdList.ProfessionShoppingList(msg, editBox)
			-- Split message into command and rest
			local command, rest = msg:match("^(%S*)%s*(.-)$")

			-- Open settings
			if command == "settings" then
				app.OpenSettings()
			-- Clear list
			elseif command == "clear" then
				app.Clear()
			-- Reset stuff
			elseif command == "reset" then
				app.Reset(rest:match("^(%S*)%s*(.-)$"))
			-- Track recipe
			elseif command == "track" then
				-- Split entered recipeID and recipeQuantity and turn them into real numbers
				local part1, part2 = rest:match("^(%S*)%s*(.-)$")
				local recipeID = tonumber(part1)
				local recipeQuantity = tonumber(part2)

				-- Only run if the recipeID is cached and the quantity is an actual number
				if ProfessionShoppingList_Library[recipeID] then
					if type(recipeQuantity) == "number" and recipeQuantity ~= 0 then
						app.TrackRecipe(recipeID, recipeQuantity)
					else
						app.Print(L.INVALID_RECIPEQUANTITY)
					end
				else
					app.Print(L.INVALID_RECIPEID)
				end
			elseif command == "untrack" then
				-- Split entered recipeID and recipeQuantity and turn them into real numbers
				local part1, part2 = rest:match("^(%S*)%s*(.-)$")
				local recipeID = tonumber(part1)
				local recipeQuantity = tonumber(part2)

				-- Only run if the recipeID is tracked and the quantity is an actual number (with a maximum of the amount of recipes tracked)
				if ProfessionShoppingList_Data.Recipes[recipeID] then
					if part2 == "all" then
						app.UntrackRecipe(recipeID, 0)

						-- Show window
						app.Show()
					elseif type(recipeQuantity) == "number" and recipeQuantity ~= 0 and recipeQuantity <= ProfessionShoppingList_Data.Recipes[recipeID].quantity then
						app.UntrackRecipe(recipeID, recipeQuantity)

						-- Show window
						app.Show()
					else
						app.Print(L.INVALID_RECIPEQUANTITY)
					end
				else
					app.Print(L.INVALID_RECIPE_TRACKED)
				end
			-- Toggle debug mode
			elseif command == "debug" then
				if ProfessionShoppingList_Settings["debug"] then
					ProfessionShoppingList_Settings["debug"] = false
					app.Print(L.DEBUG_DISABLED)
				else
					ProfessionShoppingList_Settings["debug"] = true
					app.Print(L.DEBUG_ENABLED)
				end
			-- No command
			elseif command == "" then
				api.Toggle()
			-- Unlisted command
			else
				-- If achievement string
				local _, check = string.find(command, "\124cffffff00\124Hachievement:")
				if check ~= nil then
					-- Get achievementID, number of criteria, and type of the first criterium
					local achievementID = tonumber(string.match(string.sub(command, 25), "%d+"))
					local numCriteria = GetAchievementNumCriteria(achievementID)
					local _, criteriaType = GetAchievementCriteriaInfo(achievementID, 1, true)

					-- If the asset type is a (crafting) spell
					if criteriaType == 29 then
						-- Make sure that we check the only criteria if numCriteria was evaluated to be 0
						if numCriteria == 0 then numCriteria = 1 end

						-- For each criteria, track the SpellID
						for i = 1, numCriteria, 1 do
							local _, criteriaType, completed, quantity, reqQuantity, _, _, assetID = GetAchievementCriteriaInfo(achievementID, i, true)
							-- If the criteria has not yet been completed
							if completed == false then
								-- Proper quantity, if the info is provided
								local numTrack = 1
								if quantity ~= nil and reqQuantity ~= nil then
									numTrack = reqQuantity - quantity
								end
								-- Add the recipe
								if numTrack >= 1 then
									app.TrackRecipe(assetID, numTrack)
								end
							end
						end
					-- Chromatic Calibration: Cranial Cannons
					elseif achievementID == 18906 then
						for i=1,numCriteria,1 do
							-- Set the update handler to active, to prevent multiple list updates from freezing the game
							app.Flag.ChangingRecipes = true
							-- Until the last one in the series
							if i == numCriteria then
								app.Flag.ChangingRecipes = false
							end

							local _, criteriaType, completed, _, _, _, _, assetID = GetAchievementCriteriaInfo(achievementID, i)

							-- Manually edit the spellIDs, because multiple ranks are eligible (use rank 1)
							if i == 1 then assetID = 198991
							elseif i == 2 then assetID = 198965
							elseif i == 3 then assetID = 198966
							elseif i == 4 then assetID = 198967
							elseif i == 5 then assetID = 198968
							elseif i == 6 then assetID = 198969
							elseif i == 7 then assetID = 198970
							elseif i == 8 then assetID = 198971 end

							-- If the criteria has not yet been completed, add the recipe
							if completed == false then
								app.TrackRecipe(assetID, 1)
							end
						end
					else
						app.Print(L.INVALID_ACHIEVEMENT)
					end
				else
					app.Print(L.INVALID_COMMAND)
				end
			end
		end
	end
end)

-------------------
-- VERSION COMMS --
-------------------

-- Send information to other PSL users
function app.SendAddonMessage(message)
	if IsInRaid(2) or IsInGroup(2) then
		ChatThrottleLib:SendAddonMessage("NORMAL", "ProfShopList", message, "INSTANCE_CHAT")
	elseif IsInRaid() then
		ChatThrottleLib:SendAddonMessage("NORMAL", "ProfShopList", message, "RAID")
	elseif IsInGroup() then
		ChatThrottleLib:SendAddonMessage("NORMAL", "ProfShopList", message, "PARTY")
	end
end

-- When joining a group
app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	local message = "version:" .. C_AddOns.GetAddOnMetadata("ProfessionShoppingList", "Version")
	app.SendAddonMessage(message)
end)

-- When we receive information over the addon comms
app.Event:Register("CHAT_MSG_ADDON", function(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	if prefix == "ProfShopList" then
		-- Version
		local version = text:match("version:(.+)")
		if version then
			if version ~= "@project-version@" then
				local expansion, major, minor, iteration = version:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
				expansion = string.format("%02d", expansion)
				major = string.format("%02d", major)
				minor = string.format("%02d", minor)
				local otherGameVersion = tonumber(expansion .. major .. minor)
				local otherAddonVersion = tonumber(iteration)

				local localVersion = C_AddOns.GetAddOnMetadata("ProfessionShoppingList", "Version")
				if localVersion ~= "@project-version@" then
					expansion, major, minor, iteration = localVersion:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
					expansion = string.format("%02d", expansion)
					major = string.format("%02d", major)
					minor = string.format("%02d", minor)
					local localGameVersion = tonumber(expansion .. major .. minor)
					local localAddonVersion = tonumber(iteration)

					if otherGameVersion > localGameVersion or (otherGameVersion == localGameVersion and otherAddonVersion > localAddonVersion) then
						if GetServerTime() - app.Flag.VersionCheck > 600 then
							app.Print(L.VERSION_CHECK .. " " .. version)
							app.Flag.VersionCheck = GetServerTime()
						end
					end
				end
			end
		end
	end
end)
