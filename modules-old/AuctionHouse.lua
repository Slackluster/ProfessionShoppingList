------------------------------------------------
-- Profession Shopping List: AuctionHouse.lua --
------------------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Flag.AuctionHouseIsOpen = false
	end
end)

-----------------
-- LINK SEARCH --
-----------------

app.Event:Register("AUCTION_HOUSE_SHOW", function(addOnName, containsBindings)
	app.Flag.AuctionHouseIsOpen = true
	app:CreateShoppingList() -- Also update our shopping list whenever we open the AH
end)

app.Event:Register("AUCTION_HOUSE_CLOSED", function(addOnName, containsBindings)
	app.Flag.AuctionHouseIsOpen = false
end)

function app:SearchAH(itemLink)
	if app.Flag.AuctionHouseIsOpen then
		local query = { sorts = { sortOrder = Enum.AuctionHouseSortOrder.Price, reverseSort = false }, filters = {}, searchString = C_Item.GetItemInfo(itemLink) }
		C_AuctionHouse.SendBrowseQuery(query)
	end
end

------------------------
-- AUCTIONATOR IMPORT --
------------------------

function app:CreateShoppingList()
	local loaded, finished = C_AddOns.IsAddOnLoaded("Auctionator")
	if finished then
		C_Timer.After(0.5, function() -- Add a delay because I have no idea how to optimise my addon
			local searchStrings = {}

			for reagentID, reagentAmount in pairs(app.ReagentQuantities) do
				if type(reagentID) == "number" then -- Ignore tracked gold and currency costs
					if not ProfessionShoppingList_Cache.ReagentTiers[reagentID] then
						app:CacheItem(reagentID)
					end

					if not C_Item.IsItemDataCachedByID(reagentID) then
						C_Item.RequestLoadItemDataByID(reagentID)
						local item = Item:CreateFromItemID(reagentID)

						item:ContinueOnItemLoad(function()
							app:CreateShoppingList()
						end)

						return
					end

					local itemName, _, _, _, _, _, _, _, _, _, _, _, _, bindType = C_Item.GetItemInfo(reagentID)
					if not (bindType == Enum.ItemBind.OnAcquire or bindType == Enum.ItemBind.ToWoWAccount or bindType == Enum.ItemBind.ToBnetAccount or bindType == Enum.ItemBind.ToBnetAccountUntilEquipped) then
						local simulatedReagents = {}
						for k, v in pairs(ProfessionShoppingList_Cache.SimulatedRecipes) do
							for k2, v2 in pairs(v) do
								simulatedReagents[k2] = v2
							end
						end

						local reagentQuality
						local preMidnight = ProfessionShoppingList_Cache.ReagentTiers[reagentID].three ~= 0
						local noQuality = ProfessionShoppingList_Cache.ReagentTiers[reagentID].two == 0
						if simulatedReagents[reagentID] then
							if ProfessionShoppingList_Cache.ReagentTiers[reagentID].three == reagentID then
								reagentQuality = 3
							elseif ProfessionShoppingList_Cache.ReagentTiers[reagentID].two == reagentID then
								reagentQuality = 2
							elseif preMidnight or noQuality then
								reagentQuality = ""
							else
								reagentQuality = 1
							end
						elseif app.Settings["reagentQuality"] == 1 or noQuality then
							reagentQuality = ""
						elseif app.Settings["reagentQuality"] == 2 then
							reagentQuality = preMidnight and 3 or 2
						end

						local reagentCount = app:GetReagentCount(reagentID)
						reagentCount = math.max(0, reagentAmount - reagentCount)

						for k, v in pairs(ProfessionShoppingList_Data.Recipes) do
							if ProfessionShoppingList_Library[k] and ProfessionShoppingList_Library[k].itemID == reagentID then
								reagentCount = 0
							end
						end

						if reagentCount > 0 then
							table.insert(searchStrings, Auctionator.API.v1.ConvertToSearchString(app.Name, { searchString = itemName, isExact = true, categoryKey = "", tier = reagentQuality, quantity = reagentCount}))
						end
					end
				end
			end

			local next = next
			if next(searchStrings) ~= nil then
				Auctionator.API.v1.CreateShoppingList(app.Name, "PSL", searchStrings)
			elseif Auctionator.Shopping.ListManager:GetIndexForName("PSL") then
				Auctionator.Shopping.ListManager:Delete("PSL")
			end
		end)
	end
end
