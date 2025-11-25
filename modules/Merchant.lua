------------------------------------------------
-- Profession Shopping List: Merchant.lua --
------------------------------------------------

-- Initialisation
local appName, app = ...
local L = app.locales
local api = app.api

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Flag.MerchantAssets = false
	end
end)

-----------------------
-- MERCHANT FEATURES --
-----------------------

app.Event:Register("MERCHANT_SHOW", function()
	-- When the user Alt+clicks a vendor item
	local function TrackMerchantItem()
		if IsAltKeyDown() then
			-- Get merchant info
			local merchant = MerchantFrameTitleText:GetText()

			-- Get item info from tooltip
			local itemID = app.TooltipItemID

			-- Get the item index for this vendor
			local vendorIndex = 0
			for index = 1, GetMerchantNumItems() do
				if GetMerchantItemID(index) == itemID then
					vendorIndex = index
					break
				end
			end
			if vendorIndex == 0 then return end

			local itemLink = GetMerchantItemLink(vendorIndex)
			local itemPrice = C_MerchantFrame.GetItemInfo(vendorIndex).price

			-- Add this as a fake recipe
			local key = "vendor:" .. merchant .. ":" .. itemID
			ProfessionShoppingList_Cache.FakeRecipes[key] = {
				["itemID"] = itemID,
				["tradeskillID"] = 0,	-- Vendor item
				["costCopper"] = 0,
				["costItems"] = {},
				["costCurrency"] = {},
			}

			if itemPrice then
				ProfessionShoppingList_Cache.FakeRecipes[key].costCopper = itemPrice
				ProfessionShoppingList_Cache.Reagents["gold"] = {
					icon = app.IconProfession[0],
					link = L.GOLD,
				}
			end

			-- Get the different currencies needed to purchase the item
			for i=1, GetMerchantItemCostInfo(vendorIndex), 1 do
				local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(vendorIndex, i)
				if currencyName and itemLink then
					local currencyID = C_CurrencyInfo.GetCurrencyIDFromLink(itemLink)

					ProfessionShoppingList_Cache.FakeRecipes[key].costCurrency[currencyID] = itemValue
					ProfessionShoppingList_Cache.Reagents["currency:" .. currencyID] = {
						icon = itemTexture,
						link = C_CurrencyInfo.GetCurrencyLink(currencyID),
					}
				elseif itemLink then
					local itemID = GetItemInfoFromHyperlink(itemLink)
					ProfessionShoppingList_Cache.FakeRecipes[key].costItems[itemID] = itemValue
					if not ProfessionShoppingList_Cache.ReagentTiers[itemID] then
						ProfessionShoppingList_Cache.ReagentTiers[itemID] = {
							one = itemID,
							two = 0,
							three = 0,
						}
					end
				end

			end

			-- Track the vendor item as a fake recipe
			if not ProfessionShoppingList_Data.Recipes[key] then ProfessionShoppingList_Data.Recipes[key] = { quantity = 0, link = itemLink} end
			ProfessionShoppingList_Data.Recipes[key].quantity = ProfessionShoppingList_Data.Recipes[key].quantity + 1

			-- Show the window
			app.Show()
		end
	end

	-- Hook the script onto the merchant buttons (once)
	if app.Flag.MerchantAssets == false then
		for i = 1, 99 do	-- Works for addons that expand the vendor frame up to 99 slots
			local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
			if itemButton then
				itemButton:HookScript("OnClick", function() TrackMerchantItem() end)
			end
		end

		app.MerchantButton = CreateFrame("Button", "pslMerchantButton", MerchantFrame, "UIPanelCloseButton")
		app.MerchantButton:SetPoint("TOPRIGHT", MerchantFrameCloseButton, "TOPLEFT", -2, 0)
		app.MerchantButton:SetNormalTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
		app.MerchantButton:GetNormalTexture():SetTexCoord(219/256, 255/256, 1/128, 39/128)
		app.MerchantButton:SetDisabledTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
		app.MerchantButton:GetDisabledTexture():SetTexCoord(219/256, 255/256, 41/128, 79/128)
		app.MerchantButton:SetPushedTexture("Interface\\AddOns\\ProfessionShoppingList\\assets\\buttons.blp")
		app.MerchantButton:GetPushedTexture():SetTexCoord(219/256, 255/256, 81/128, 119/128)
		app.MerchantButton:SetScript("OnClick", function()
			app.Show()	-- Populate app.ReagentQuantities

			for itemID, quantity in pairs(app.ReagentQuantities) do
				if type(itemID) == "number" then
					local vendorIndex = 0
					for index = 1, GetMerchantNumItems() do
						if GetMerchantItemID(index) == itemID then
							vendorIndex = index
							break
						end
					end

					if vendorIndex ~= 0 then
						local need = quantity - app.GetReagentCount(itemID)
						local itemInfo = C_MerchantFrame.GetItemInfo(vendorIndex)
						if need >= 1 and itemInfo.isPurchasable then
							local maxStack = GetMerchantItemMaxStack(vendorIndex)

							while need > 0 do
								local buy = math.min(need, maxStack)
								BuyMerchantItem(vendorIndex, buy)
								need = need - buy
							end
						end
					end
				end
			end

		end)
		app.MerchantButton:SetScript("OnEnter", function(self)
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(app.MerchantButton, "ANCHOR_TOP")
			GameTooltip:AddLine(L.MERCHANT_BUY)
			GameTooltip:Show()
		end)
		app.MerchantButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

		-- Set the flag to true so it doesn't trigger again
		app.Flag.MerchantAssets = true
	end
end)
