----------------------------------------
-- Transmog Loot Helper: Settings.lua --
----------------------------------------

-- Initialisation
local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app:AddTooltipInfo()
	end
end)

--------------
-- TOOLTIPS --
--------------

-- Tooltip information
function app:AddTooltipInfo()
	local function OnTooltipSetItem(tooltip, itemData)
		if ProfessionShoppingList_Settings["showTooltip"] then
			local _, itemLink, itemID
			if itemData and itemData.id then
				itemID = itemData.id
				itemLink = C_Item.GetItemInfo(itemID)
			elseif tooltip.GetItem then
				_, itemLink, itemID = tooltip:GetItem()
			else
				_, itemLink, itemID = TooltipUtil.GetDisplayedItem(GameTooltip)
			end

			if not itemLink and itemID then return end
			app.TooltipItemID = itemID

			local reagentID1 = 0
			local reagentID2 = 0
			local reagentID3 = 0
			local reagentAmountNeed = 0
			local reagentAmountNeed1 = 0
			local reagentAmountNeed2 = 0
			local reagentAmountNeed3 = 0

			if ProfessionShoppingList_Cache.ReagentTiers[itemID] then
				if ProfessionShoppingList_Cache.ReagentTiers[itemID].one ~= 0 then
					reagentID1 = ProfessionShoppingList_Cache.ReagentTiers[itemID].one
					reagentAmountNeed1 = app.ReagentQuantities[ProfessionShoppingList_Cache.ReagentTiers[itemID].one] or 0
				end
				if ProfessionShoppingList_Cache.ReagentTiers[itemID].two ~= 0 then
					reagentID2 = ProfessionShoppingList_Cache.ReagentTiers[itemID].two
					reagentAmountNeed2 = app.ReagentQuantities[ProfessionShoppingList_Cache.ReagentTiers[itemID].two] or 0
				end
				if ProfessionShoppingList_Cache.ReagentTiers[itemID].three ~= 0 then
					reagentID3 = ProfessionShoppingList_Cache.ReagentTiers[itemID].three
					reagentAmountNeed3 = app.ReagentQuantities[ProfessionShoppingList_Cache.ReagentTiers[itemID].three] or 0
				end
			end

			if itemID == reagentID3 then
				reagentAmountNeed = reagentAmountNeed1 + reagentAmountNeed2 + reagentAmountNeed3
			elseif itemID == reagentID2 then
				reagentAmountNeed = reagentAmountNeed1 + reagentAmountNeed2
			elseif itemID == reagentID1 then
				reagentAmountNeed = reagentAmountNeed1
			end

			local emptyLine = false
			if reagentAmountNeed > 0 then
				local reagentAmountHave = app:GetReagentCount(itemID)
				tooltip:AddLine(" ")
				emptyLine = true
				tooltip:AddLine(app.IconPSL .. " " .. reagentAmountHave .. "/" .. reagentAmountNeed .. " (" .. math.max(0,reagentAmountNeed-reagentAmountHave) .. " " .. L.MORE_NEEDED .. ")")
			end

			if ProfessionShoppingList_Settings["showCraftTooltip"] then
				for k, v in pairs(ProfessionShoppingList_Library) do
					if type(v) ~= "number" and v.itemID == itemID then	-- No clue why these non-table values are here, tbh
						if emptyLine == false then
							tooltip:AddLine(" ")
						end
						local tradeskillID = v.tradeskillID
						if not app.IconProfession[v.tradeskillID] then tradeskillID = 999 end
						if v.learned and v.tradeskillID then
							tooltip:AddLine(app.IconPSL .. " " .. L.MADE_WITH .. "  " .. app.IconProfession[tradeskillID] .. " " .. C_TradeSkillUI.GetTradeSkillDisplayName(v.tradeskillID) .. " (" .. L.RECIPE_LEARNED .. ")")
						elseif v.tradeskillID then
							tooltip:AddLine(app.IconPSL .. " " .. L.MADE_WITH .. "  " .. app.IconProfession[tradeskillID] .. " " .. C_TradeSkillUI.GetTradeSkillDisplayName(v.tradeskillID) .. " (" .. L.RECIPE_UNLEARNED .. ")")
						end
						break
					end
				end
			end
		end
	end
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
end
