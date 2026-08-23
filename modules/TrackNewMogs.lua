------------------------------------------------
-- Profession Shopping List: TrackNewMogs.lua --
------------------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Tooltip = {}
		app.Flag.ChangingRecipes = false
	end
end)

--------------------
-- TRACK NEW MOGS --
--------------------

function app:GetTransmogText(itemLinkie, searchString)
	local cvar = C_CVar.GetCVarInfo("missingTransmogSourceInItemTooltips")
	if cvar ~= "1" then C_CVar.SetCVar("missingTransmogSourceInItemTooltips", 1) end
	local tooltip = app.Tooltip[itemLinkie] or C_TooltipInfo.GetHyperlink(itemLinkie)
	app.Tooltip[itemLinkie] = tooltip
	if cvar ~= "1" then C_CVar.SetCVar("missingTransmogSourceInItemTooltips", cvar) end

	if tooltip and tooltip["lines"] then
		for k, v in ipairs(tooltip["lines"]) do
			if v["leftText"] and v["leftText"]:find(searchString) then
				return true
			end
		end
	end
	return false
end

function app:GetSourceID(itemLink) -- Thank you Plusmouse!
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
	if sourceID then
		return sourceID
	end

	local _, sourceID = C_TransmogCollection.GetItemInfo((C_Item.GetItemInfoInstant(itemLink)))
	return sourceID
end

function api:IsAppearanceCollected(itemLink, sourceID) -- Thank you Plusmouse!
	assert(self == api, "Call ProfessionShoppingList:IsAppearanceCollected(), not ProfessionShoppingList.IsAppearanceCollected()")

	local sourceID = sourceID or app:GetSourceID(itemLink)
	if not sourceID then
		if app:GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) then
			return false
		else
			return true
		end
	else
		local subClass = select(7, C_Item.GetItemInfoInstant(itemLink))
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		local allSources = C_TransmogCollection.GetAllAppearanceSources(sourceInfo.visualID)
		if #allSources == 0 then
			allSources = {sourceID}
		end

		local anyCollected = false
		for _, alternateSourceID in ipairs(allSources) do
			local altInfo = C_TransmogCollection.GetSourceInfo(alternateSourceID)
			local altSubClass = select(7, C_Item.GetItemInfoInstant(altInfo.itemID))
			if altInfo.isCollected and altSubClass == subClass then
				anyCollected = true
				break
			end
		end
		return anyCollected
	end
end

function api:IsSourceCollected(itemLink, sourceID) -- Thank you Plusmouse!
	assert(self == api, "Call ProfessionShoppingList:IsSourceCollected(), not ProfessionShoppingList.IsSourceCollected()")

	local sourceID = sourceID or app:GetSourceID(itemLink)
	if not sourceID then
		if app:GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) or app:GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) then
			return false
		else
			return true
		end
	else
		return C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
	end
end

function app:GetVisibleRecipes(targetTable)
	targetTable = targetTable or {}

	local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
	local targetTable = C_TradeSkillUI.GetFilteredRecipeIDs()
	if C_TradeSkillUI.GetRecipeItemNameFilter() == "" then
		for k = #targetTable, 1, -1 do
			if app.nyiRecipes[k] or not C_TradeSkillUI.IsRecipeInSkillLine(targetTable[k], skillLineID) then
				table.remove(targetTable, k)
			end
		end
	end

	return targetTable
end

function app:TrackUnlearnedMogs()
	app.Flag.ChangingRecipes = true
	local visibleRecipes = app:GetVisibleRecipes()
	local recipes = {}
	local added = 0

	for _, recipeID in ipairs(visibleRecipes) do
		local itemID = C_TradeSkillUI.GetRecipeSchematic(recipeID, false).outputItemID
		if itemID then
			table.insert(recipes, { recipeID = recipeID, itemID = itemID })
		end
	end

	for i, recipe in ipairs(recipes) do
		local item = Item:CreateFromItemID(recipe.itemID)
		item:ContinueOnItemLoad(function()
			local _, itemLink = C_Item.GetItemInfo(recipe.itemID)
			if not api:IsAppearanceCollected(itemLink) or (app.Settings["collectMode"] == 2 and not api:IsSourceCollected(itemLink)) then
				api:TrackRecipe(recipe.recipeID, 1)
				added = added + 1
			end

			if i == #recipes then
				RunNextFrame(function()
					app.Flag.ChangingRecipes = false
					app:UpdateRecipes()
					app:Print(string.format(L.ADDED_RECIPES, #visibleRecipes, "|cffEDBD21" .. (app.Settings["collectMode"] == 1 and L.MODE_APPEARANCES or L.MODE_SOURCES) .. "|R", added))
				end)
			end
		end)
	end
end
