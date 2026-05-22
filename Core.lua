----------------------------------------
-- Profession Shopping List: Core.lua --
----------------------------------------

local appName, app = ...
app.locales = {}
app.api = {}
ProfessionShoppingList = app.api
local api = app.api
local L = app.locales

---------------------------
-- WOW API EVENT HANDLER --
---------------------------

app.Event = CreateFrame("Frame")
app.Event.handlers = {}

function app.Event:Register(eventName, func)
	if not self.handlers[eventName] then
		self.handlers[eventName] = {}
		self:RegisterEvent(eventName)
	end
	table.insert(self.handlers[eventName], func)
end

app.Event:SetScript("OnEvent", function(self, event, ...)
	if self.handlers[event] then
		for _, handler in ipairs(self.handlers[event]) do
			handler(...)
		end
	end
end)

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		ProfessionShoppingList_Cache = ProfessionShoppingList_Cache or {}
		ProfessionShoppingList_CharacterData = ProfessionShoppingList_CharacterData or {}
		ProfessionShoppingList_Data = ProfessionShoppingList_Data or {}
		ProfessionShoppingList_Library = ProfessionShoppingList_Library or {}

		app.Flag = {}
		app.Enum = {}

		C_ChatInfo.RegisterAddonMessagePrefix(app.NamePrefix)
		app:CreateSlashCommands()
	end
end)

-------------------
-- VERSION COMMS --
-------------------

function app:SendAddonMessage(message)
	if IsInRaid(2) or IsInGroup(2) then
		ChatThrottleLib:SendAddonMessage("NORMAL", app.NamePrefix, message, "INSTANCE_CHAT")
	elseif IsInRaid() then
		ChatThrottleLib:SendAddonMessage("NORMAL", app.NamePrefix, message, "RAID")
	elseif IsInGroup() then
		ChatThrottleLib:SendAddonMessage("NORMAL", app.NamePrefix, message, "PARTY")
	end
end

app.Event:Register("GROUP_ROSTER_UPDATE", function(category, partyGUID)
	local message = "version:" .. C_AddOns.GetAddOnMetadata(appName, "Version")
	app:SendAddonMessage(message)
end)

app.Event:Register("CHAT_MSG_ADDON", function(prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID)
	if prefix == app.NamePrefix then
		local version = text:match("version:(.+)")
		if version and not app.Flag.VersionCheck then
			local expansion, major, minor, iteration = version:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
			if expansion then
				expansion = string.format("%02d", expansion)
				major = string.format("%02d", major)
				minor = string.format("%02d", minor)
				local otherGameVersion = tonumber(expansion .. major .. minor)
				local otherAddonVersion = tonumber(iteration)

				local localVersion = C_AddOns.GetAddOnMetadata(appName, "Version")
				local expansion2, major2, minor2, iteration2 = localVersion:match("v(%d+)%.(%d+)%.(%d+)%-(%d+)")
				if expansion2 then
					expansion2 = string.format("%02d", expansion2)
					major2 = string.format("%02d", major2)
					minor2 = string.format("%02d", minor2)
					local localGameVersion = tonumber(expansion2 .. major2 .. minor2)
					local localAddonVersion = tonumber(iteration2)

					if otherGameVersion > localGameVersion or (otherGameVersion == localGameVersion and otherAddonVersion > localAddonVersion) then
						app:Print(L.NEW_VERSION_AVAILABLE, version)
						app.Flag.VersionCheck = true
					end
				end
			end
		end
	end
end)

--------------------
-- SLASH COMMANDS --
--------------------

function app:CreateSlashCommands()
	SLASH_RELOADUI1 = "/rl"
	SlashCmdList.RELOADUI = ReloadUI

	SLASH_ProfessionShoppingList1 = "/psl"
	function SlashCmdList.ProfessionShoppingList(msg, editBox)
		local command, rest = msg:match("^(%S*)%s*(.-)$")

		if command == "settings" then
			app:OpenSettings()
		elseif command == "clear" then
			app:Clear()
		elseif command == "reset" then
			app:Reset(rest:match("^(%S*)%s*(.-)$"))
		elseif command == "track" then
			local part1, part2 = rest:match("^(%S*)%s*(.-)$")
			local recipeID = tonumber(part1)
			local recipeQuantity = tonumber(part2)

			if ProfessionShoppingList_Library[recipeID] then
				if type(recipeQuantity) == "number" and recipeQuantity ~= 0 then
					api:TrackRecipe(recipeID, recipeQuantity)
				else
					app:Print(L.INVALID_RECIPEQUANTITY)
				end
			else
				app:Print(L.INVALID_RECIPEID)
			end
		elseif command == "untrack" then
			local part1, part2 = rest:match("^(%S*)%s*(.-)$")
			local recipeID = tonumber(part1)
			local recipeQuantity = tonumber(part2)

			if ProfessionShoppingList_Data.Recipes[recipeID] then
				if part2 == "all" then
					api:UntrackRecipe(recipeID, 0)

					app:ShowWindow()
				elseif type(recipeQuantity) == "number" and recipeQuantity ~= 0 and recipeQuantity <= ProfessionShoppingList_Data.Recipes[recipeID].quantity then
					api:UntrackRecipe(recipeID, recipeQuantity)

					app:ShowWindow()
				else
					app:Print(L.INVALID_RECIPEQUANTITY)
				end
			else
				app:Print(L.INVALID_RECIPE_TRACKED)
			end
		elseif command == "debug" then
			if app.Settings["debug"] then
				app.Settings["debug"] = false
				app:Print(L.DEBUG_DISABLED)
			else
				app.Settings["debug"] = true
				app:Print(L.DEBUG_ENABLED)
			end
		elseif command == "" then
			api:ToggleWindow()
		else
			local _, check = string.find(command, "\124cffffff00\124Hachievement:")
			if check ~= nil then
				local achievementID = tonumber(string.match(string.sub(command, 25), "%d+"))
				local numCriteria = GetAchievementNumCriteria(achievementID)
				local _, criteriaType = GetAchievementCriteriaInfo(achievementID, 1, true)

				if criteriaType == 29 then -- Crafting spell
					if numCriteria == 0 then numCriteria = 1 end -- Make sure that we check the only criteria if numCriteria was evaluated to be 0

					for i = 1, numCriteria, 1 do
						local _, criteriaType, completed, quantity, reqQuantity, _, _, assetID = GetAchievementCriteriaInfo(achievementID, i, true)
						if completed == false then
							local numTrack = 1
							if quantity ~= nil and reqQuantity ~= nil then
								numTrack = reqQuantity - quantity
							end
							if numTrack >= 1 then
								api:TrackRecipe(assetID, numTrack)
							end
						end
					end
				elseif achievementID == 18906 then -- Chromatic Calibration: Cranial Cannons
					for i = 1, numCriteria, 1 do
							app.Flag.ChangingRecipes = true
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

						if completed == false then
							api:TrackRecipe(assetID, 1)
						end
					end
				else
					app:Print(L.INVALID_ACHIEVEMENT)
				end
			else
				app:Print(L.INVALID_COMMAND)
			end
		end
	end
end

function app:Reset(arg)
	if arg == "settings" then
		app.Settings = {}
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
		app.Settings = nil
		ProfessionShoppingList_Data = nil
		ProfessionShoppingList_Library = nil
		ProfessionShoppingList_Cache = nil
		ProfessionShoppingList_CharacterData = nil
		app:Print(L.RESET_DONE, L.REQUIRES_RELOAD)
	elseif arg == "pos" then
		app.Settings["windowPosition"] = { ["left"] = GetScreenWidth()/2-100, ["bottom"] = GetScreenHeight()/2-100, ["width"] = 200, ["height"] = 200, }
		app.Settings["pcWindowPosition"] = app.Settings["windowPosition"]

		app:ShowWindow()
	else
		app:Print(L.INVALID_RESET_ARG .. "\n " .. app:Colour("settings") .. ", " .. app:Colour("library") .. ", " .. app:Colour("cache") .. ", " .. app:Colour("character") .. ", " .. app:Colour("all") .. ", " .. app:Colour("pos"))
	end
end

-----------------------
-- ADDON COMPARTMENT --
-----------------------

function ProfessionShoppingList_Click(self, button)
	if button == "LeftButton" then
		api:ToggleWindow()
	elseif button == "RightButton" then
		app:OpenSettings()
	end
end

function ProfessionShoppingList_Enter(self, button)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(type(self) ~= "string" and self or button, "ANCHOR_LEFT")
	GameTooltip:AddLine(L.SETTINGS_TOOLTIP)
	GameTooltip:Show()
end

function ProfessionShoppingList_Leave()
	GameTooltip:Hide()
end

----------------------
-- HELPER FUNCTIONS --
----------------------

function app:Colour(string)
	return "|cff3FC7EB" .. string .. "|r"
end

function app:Debug(...)
	if app.Settings["debug"] then
		print(app.NameShort .. app:Colour(" Debug") .. ":", ...)
	end
end

function app:Print(...)
	print(app.NameShort .. ":", ...)
end

function app:SetBorder(parent, a, b, c, d)
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

function app:MakeButton(parent, text, name)
	local frame = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
	frame:SetText(text)
	frame:SetWidth(frame:GetTextWidth()+20)

	app:SetBorder(frame, 0, 0, 0, -1)
	return frame
end

function app:FixTable(table)
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
