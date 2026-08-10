----------------------------------------
-- Transmog Loot Helper: Settings.lua --
----------------------------------------

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
		local itemID = app:GetTooltipItem(tooltip, itemData)
		if not itemID then return end
		app.TooltipItemID = itemID

		if app.Settings["showTooltip"] then
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
				tooltip:AddLine(CreateSimpleTextureMarkup(app.Icon) .. " " .. reagentAmountHave .. "/" .. reagentAmountNeed .. " (" .. math.max(0,reagentAmountNeed-reagentAmountHave) .. " " .. L.MORE_NEEDED .. ")")
			end

			if app.Settings["showCraftTooltip"] or app.Settings["showCraftCostTooltip"] then
				local recipeID
				for k, v in pairs(ProfessionShoppingList_Library) do
					if type(v) ~= "number" and v.itemID == itemID then -- No clue why these non-table values are here, tbh
						recipeID = k
						break
					end
				end

				if recipeID then
					local totalCost = 0
					if app.Settings["showCraftCostTooltip"] and app.Flag.IsAuctionAddonLoaded and ProfessionShoppingList_Library[recipeID].reagents then
						for _, reagent in ipairs(ProfessionShoppingList_Library[recipeID].reagents) do
							local reagentCost = {}
							for _, reagentVar in ipairs(reagent.reagents) do
								if reagentVar.itemID then
									local cost = app:ItemValue(reagentVar.itemID)
									if cost > 0 then
										table.insert(reagentCost, cost)
									end
								end
							end
							totalCost = totalCost + (((#reagentCost > 0 and math.min(unpack(reagentCost))) or 0) * reagent.quantityRequired)
						end
						totalCost = math.ceil(totalCost / 10000) * 10000
					end

					local tradeskillID, learned
					if app.Settings["showCraftTooltip"] then
						tradeskillID = ProfessionShoppingList_Library[recipeID].tradeskillID
						learned = ProfessionShoppingList_Library[recipeID].learned
					end

					if app.Settings["showCraftTooltip"] then
						if not emptyLine then
							tooltip:AddLine(" ")
						end
						local learnedString = learned and L.RECIPE_LEARNED or L.RECIPE_UNLEARNED
						local icon = app.IconProfession[tradeskillID] or app.IconProfession[999]
						local name = C_TradeSkillUI.GetTradeSkillDisplayName(tradeskillID)
						if app.Settings["showCraftCostTooltip"] and totalCost > 0 then
							tooltip:AddDoubleLine(CreateSimpleTextureMarkup(app.Icon) .. " " .. L.MADE_WITH .. "  " .. icon .. " " .. name .. " (" .. learnedString .. ")", GetMoneyString(totalCost, true))
						else
							tooltip:AddLine(CreateSimpleTextureMarkup(app.Icon) .. " " .. L.MADE_WITH .. "  " .. icon .. " " .. name .. " (" .. learnedString .. ")")
						end
					elseif app.Settings["showCraftCostTooltip"] and totalCost > 0 then
						if not emptyLine then
							tooltip:AddLine(" ")
						end
						tooltip:AddDoubleLine(CreateSimpleTextureMarkup(app.Icon) .. " " .. L.CRAFTING_COST, GetMoneyString(totalCost, true))
					end
				end
			end
		end
	end
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
end

-- MoneyFrame taint fix, courtesy of Galehad's MoneyFrameFix
function SetTooltipMoney(frame, money, type, prefixText, suffixText)
	frame:AddLine((prefixText or "") .. "  " .. GetCoinTextureString(money) .. " " .. (suffixText or ""), 1, 1, 1)
end
