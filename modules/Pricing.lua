-------------------------------------------
-- Profession Shopping List: Pricing.lua --
-------------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Cache.Commodities = app.Cache.Commodities or {}
	end
end)

----------------
-- AH PRICING --
----------------

function app:ItemValue(itemID)
	if not itemID or itemID == 0 then return 0 end

	local realmPrice = {}
	local regionPrice = {}
	if C_AddOns.IsAddOnLoaded("TradeSkillMaster") then
		table.insert(realmPrice, { price = TSM_API.GetCustomPriceValue("DBMinBuyout", "i:" .. itemID) or 0, age = -1 })
		table.insert(regionPrice, { price = TSM_API.GetCustomPriceValue("DBRegionMarketAvg", "i:" .. itemID) or 0, age = -1 })
	end
	if C_AddOns.IsAddOnLoaded("Auctionator") then
		table.insert(realmPrice, { price = Auctionator.API.v1.GetAuctionPriceByItemID(app.Name, itemID) or 0, age = Auctionator.API.v1.GetAuctionAgeByItemID(app.Name, itemID) or 99 })
	end
	if C_AddOns.IsAddOnLoaded("OribosExchange") then
		local oeData = {}
		OEMarketInfo(itemID, oeData)
		table.insert(realmPrice, { price = oeData.market or 0, age = (oeData.age and oeData.age / 60 / 60 / 24) or 99 })
		table.insert(regionPrice, { price = oeData.region or 0, age = (oeData.age and oeData.age / 60 / 60 / 24) or 99 })
	end

	if app.Cache.Commodities and app.Cache.Commodities[itemID] then
		for _, value in ipairs(realmPrice) do
			table.insert(regionPrice, value)
		end
		realmPrice = {}
	end

	table.sort(realmPrice, function(a, b) return a.age < b.age end)
	table.sort(regionPrice, function(a, b) return a.age < b.age end)
	for _, value in ipairs(realmPrice) do
		if value.price > 0 then
			return value.price
		end
	end
	for _, value in ipairs(regionPrice) do
		if value.price > 0 then
			return value.price
		end
	end
	return 0
end

function app:MarkItemAsCommodity(commodityItemID)
	if commodityItemID then
		app.Cache.Commodities[commodityItemID] = true
	else
		for bag = -4, 16 do
			local slots = C_Container.GetContainerNumSlots(bag)
			if slots and slots > 0 then
				for bagSlot = 1, slots do
					local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, bagSlot)
					if itemLocation and C_Item.DoesItemExist(itemLocation) then
						local commodityStatus = C_AuctionHouse.GetItemCommodityStatus(itemLocation)
						if commodityStatus == Enum.ItemCommodityStatus.Commodity then
							local itemID = C_Item.GetItemID(itemLocation)
							app.Cache.Commodities[itemID] = true
						end
					end
				end
			end
		end
	end
end

app.Event:Register("COMMODITY_PURCHASED", function(itemID, quantity)
	app:MarkItemAsCommodity(itemID)
end)

app.Event:Register("COMMODITY_SEARCH_RESULTS_ADDED", function(itemID)
	app:MarkItemAsCommodity(itemID)
end)

app.Event:Register("COMMODITY_SEARCH_RESULTS_UPDATED", function(itemID)
	app:MarkItemAsCommodity(itemID)
end)

app.Event:Register("BANKFRAME_OPENED", function()
	C_Timer.After(2, function()
		app:MarkItemAsCommodity()
	end)
end)

app.Event:Register("TRADE_SKILL_SHOW", function()
	app:MarkItemAsCommodity()
end)
