------------------------------------------------
-- Profession Shopping List: AuctionHouse.lua --
------------------------------------------------

local appName, app = ...
local api = app.api

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName ~= appName then return end

	app.Flag.AuctionHouseIsOpen = false
end)

-----------------
-- LINK SEARCH --
-----------------

app.Event:Register("AUCTION_HOUSE_SHOW", function(addOnName, containsBindings)
	app.Flag.AuctionHouseIsOpen = true
	C_Timer.After(0.5, function()
		if not app.Flag.AuctionatorHook and C_AddOns.IsAddOnLoaded("Auctionator") and AuctionatorShoppingFrame then
			AuctionatorShoppingFrame:HookScript("OnShow", function()
				if not app.Flag.ShoppingListCreated then
					app:CreateShoppingList()
				end
			end)
			app:CreateShoppingList()
			app.Flag.AuctionatorHook = true
		end
	end)
end)

app.Event:Register("AUCTION_HOUSE_CLOSED", function(addOnName, containsBindings)
	app.Flag.AuctionHouseIsOpen = false
	app.Flag.ShoppingListCreated = false
	app.PendingCommodityPurchase = nil
	if C_AddOns.IsAddOnLoaded("Auctionator") and Auctionator.Shopping.ListManager:GetIndexForName("PSL") then
		Auctionator.Shopping.ListManager:Delete("PSL")
	end
end)

function app:SendLinkToSearch(itemLink)
	if app.Flag.AuctionHouseIsOpen then
		local query = { sorts = { sortOrder = Enum.AuctionHouseSortOrder.Price, reverseSort = false }, filters = {}, searchString = C_Item.GetItemInfo(itemLink) or itemLink }
		C_AuctionHouse.SendBrowseQuery(query)
	elseif ProfessionsCustomerOrdersFrame and ProfessionsCustomerOrdersFrame:IsVisible() then
		ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.SearchBox:SetText(C_Item.GetItemInfo(itemLink))
		ProfessionsCustomerOrdersFrame.BrowseOrders:StartSearch(false)
	end
end

------------------------
-- AUCTIONATOR IMPORT --
------------------------

function app:CreateShoppingList(export)
	local shoppingList = {}
	for reagentID, reagentAmount in pairs(app.ReagentQuantities) do
		if type(reagentID) == "number" then -- Ignore tracked gold and currency costs
			if not app.Cache.ReagentTiers[reagentID] then
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
				for k, v in pairs(app.Cache.SimulatedRecipes) do
					for k2, v2 in pairs(v) do
						simulatedReagents[k2] = v2
					end
				end

				local reagentQuality
				local preMidnight = app.Cache.ReagentTiers[reagentID].three ~= 0
				local noQuality = app.Cache.ReagentTiers[reagentID].two == 0
				if simulatedReagents[reagentID] then
					if app.Cache.ReagentTiers[reagentID].three == reagentID then
						reagentQuality = 3
					elseif app.Cache.ReagentTiers[reagentID].two == reagentID then
						reagentQuality = 2
					elseif preMidnight or noQuality then
						reagentQuality = ""
					else
						reagentQuality = 1
					end
				elseif app.Settings.reagentQuality == 1 or noQuality then
					reagentQuality = ""
				elseif app.Settings.reagentQuality == 2 then
					reagentQuality = preMidnight and 3 or 2
				end

				local reagentCount = app:GetReagentCount(reagentID)
				reagentCount = math.max(0, reagentAmount - reagentCount)

				for k, v in pairs(app.Data.Recipes) do
					if app.Library[k] and app.Library[k].itemID == reagentID then
						reagentCount = 0
					end
				end

				if reagentCount > 0 then
					table.insert(shoppingList, { name = itemName, itemID = reagentID, quality = reagentQuality, quantity = reagentCount })
				end
			end
		end
	end

	local next = next
	if export then
		if export == "tsm" and next(shoppingList) ~= nil then
			local searchString = {}
			for _, item in ipairs(shoppingList) do
				table.insert(searchString, "i:" .. item.itemID .. "/x" .. item.quantity)
			end
			return table.concat(searchString, ";")
		end
	elseif C_AddOns.IsAddOnLoaded("Auctionator") then
		app.Flag.ShoppingListCreated = true
		if next(shoppingList) ~= nil then
			local searchString = {}
			for _, item in ipairs(shoppingList) do
				table.insert(searchString, Auctionator.API.v1.ConvertToSearchString(app.Name, { searchString = item.name, isExact = true, categoryKey = "", tier = item.quality, quantity = item.quantity}))
			end
			Auctionator.API.v1.CreateShoppingList(app.Name, "PSL", searchString)
		elseif Auctionator.Shopping.ListManager:GetIndexForName("PSL") then
			Auctionator.Shopping.ListManager:Delete("PSL")
		end
	end
end

if C_AuctionHouse and C_AuctionHouse.ConfirmCommoditiesPurchase then
	hooksecurefunc(C_AuctionHouse, "ConfirmCommoditiesPurchase", function(itemID, quantity)
		if type(itemID) == "number" and type(quantity) == "number" and quantity > 0 then
			app.PendingCommodityPurchase = { itemID = itemID, quantity = quantity }
		end
	end)
end

app.Event:Register("COMMODITY_PURCHASE_FAILED", function()
	app.PendingCommodityPurchase = nil
end)

app.Event:Register("COMMODITY_PURCHASE_SUCCEEDED", function()
	local purchased = app.PendingCommodityPurchase
	app.PendingCommodityPurchase = nil
	if not purchased or not C_AddOns.IsAddOnLoaded("Auctionator") or not Auctionator.Shopping.ListManager:GetIndexForName("PSL") then
		return
	end

	local item = Item:CreateFromItemID(purchased.itemID)
	item:ContinueOnItemLoad(function()
		if not Auctionator.Shopping.ListManager:GetIndexForName("PSL") then return end

		local ok, items = pcall(Auctionator.API.v1.GetShoppingListItems, app.Name, "PSL")
		if not ok or type(items) ~= "table" then return end

		local itemName = item:GetItemName() or C_Item.GetItemNameByID(purchased.itemID)
		if not itemName or itemName == "" then return end

		local itemTier = C_TradeSkillUI and C_TradeSkillUI.GetItemReagentQualityByItemInfo and C_TradeSkillUI.GetItemReagentQualityByItemInfo(purchased.itemID) or nil

		local matchedRaw, matchedTerms, matchPriority
		for _, raw in ipairs(items) do
			local okTerm, terms = pcall(Auctionator.API.v1.ConvertFromSearchString, app.Name, raw)
			if okTerm and type(terms) == "table" and terms.searchString == itemName then
				local priority
				if terms.tier ~= nil and itemTier ~= nil and terms.tier == itemTier then
					priority = 1
				elseif terms.tier == nil then
					priority = 2
				elseif app.Settings.includeHigher == 1 and itemTier ~= nil and itemTier > terms.tier then
					priority = 3
				end
				if priority and (not matchPriority or priority < matchPriority) then
					matchedRaw, matchedTerms, matchPriority = raw, terms, priority
					if priority == 1 then break end
				end
			end
		end

		if not matchedRaw or not matchedTerms then return end

		local remaining = (tonumber(matchedTerms.quantity) or 0) - purchased.quantity
		if remaining > 0 then
			matchedTerms.quantity = remaining
			matchedTerms.categoryKey = matchedTerms.categoryKey or ""
			matchedTerms.tier = matchedTerms.tier or ""
			local okNew, newRaw = pcall(Auctionator.API.v1.ConvertToSearchString, app.Name, matchedTerms)
			if okNew and type(newRaw) == "string" then
				pcall(Auctionator.API.v1.AlterShoppingListItem, app.Name, "PSL", matchedRaw, newRaw)
			end
		else
			pcall(Auctionator.API.v1.DeleteShoppingListItem, app.Name, "PSL", matchedRaw)
		end
	end)
end)

function api:GetTSMSearchString()
	assert(self == api, "Call ProfessionShoppingList:GetTSMSearchString(), not ProfessionShoppingList.GetTSMSearchString()")

	return app:CreateShoppingList("tsm")
end
