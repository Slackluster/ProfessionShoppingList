------------------------------------------------
-- Profession Shopping List: TrackNewMogs.lua --
------------------------------------------------

-- Initialisation
local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
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

-- Get an item's SourceID (thank you Plusmouse!)
function app:GetSourceID(itemLink)
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
	if sourceID then
		return sourceID
	end

	local _, sourceID = C_TransmogCollection.GetItemInfo((C_Item.GetItemInfoInstant(itemLink)))
	return sourceID
end

-- Check if an item's appearance is collected (thank you Plusmouse!)
function api:IsAppearanceCollected(itemLink)
	assert(self == api, "Call ProfessionShoppingList:IsAppearanceCollected(), not ProfessionShoppingList.IsAppearanceCollected()")

	local sourceID = app:GetSourceID(itemLink)
	if not sourceID then
		if app:GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) then
			return false
		else
			return true	-- Should be nil if the item does not have an appearance, but for our purposes this is fine
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

-- Check if an item's source is collected (thank you Plusmouse!)
function api:IsSourceCollected(itemLink)
	assert(self == api, "Call ProfessionShoppingList:IsSourceCollected(), not ProfessionShoppingList.IsSourceCollected()")

	local sourceID = app:GetSourceID(itemLink)
	if not sourceID then
		if app:GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) or app:GetTransmogText(itemLink, TRANSMOGRIFY_TOOLTIP_ITEM_UNKNOWN_APPEARANCE_KNOWN) then
			return false
		else
			return true	-- Should be nil if the item does not have an appearance, but for our purposes this is fine
		end
	else
		return C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
	end
end

-- Get all visible recipes
function app:GetVisibleRecipes(targetTable)
	-- If no table is provided, create a new one
	targetTable = targetTable or {}

	local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
	local targetTable = C_TradeSkillUI.GetFilteredRecipeIDs()
	-- If we're not searching for any recipes
	if C_TradeSkillUI.GetRecipeItemNameFilter() == "" then
		for k = #targetTable, 1, -1 do
			-- If the recipe is NYI, or does not belong to our currently visible expansion
			if app.nyiRecipes[k] or not C_TradeSkillUI.IsRecipeInSkillLine(targetTable[k], skillLineID) then
				-- Remove it
				table.remove(targetTable, k)
			end
		end
	end

	return targetTable
end

function app:TrackUnlearnedMogs()
	-- Set the update handler to active, to prevent multiple list updates from freezing the game
	app.Flag.ChangingRecipes = true

	local recipes = app:GetVisibleRecipes()

	-- Start a count
	local added = 0

	for i, recipeID in pairs(recipes) do
		-- Grab the output itemID
		local itemID = C_TradeSkillUI.GetRecipeSchematic(recipeID, false).outputItemID

		-- Cache the item, if there is an output item
		if itemID then
			local item = Item:CreateFromItemID(itemID)

			-- And when the item is cached
			item:ContinueOnItemLoad(function()
				-- Get item link
				local _, itemLink = C_Item.GetItemInfo(itemID)

				-- If the appearance is unlearned, track the recipe (taking our collection mode into account)
				if not api:IsAppearanceCollected(itemLink) or (ProfessionShoppingList_Settings["collectMode"] == 2 and not api:IsSourceCollected(itemLink)) then
					app:TrackRecipe(recipeID, 1)
					added = added + 1
				end

				-- If this is our last iteration, set update handler to false and force an update, and let the user know what we did
				if i == #recipes then
					app.Flag.ChangingRecipes = false
					app:UpdateRecipes()
					app:Print(L.ADDED_RECIPES1 .. " " .. added .. " " .. L.ADDED_RECIPES2 .. ".")
				end
			end)
		end
	end
end
