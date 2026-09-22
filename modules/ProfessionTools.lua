---------------------------------------------------
-- Profession Shopping List: ProfessionTools.lua --
---------------------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

-- When the addon is fully loaded, actually run the components
app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.CharData.profTools = app.CharData.profTools or {}
	end
end)

----------------------
-- PROFESSION TOOLS --
----------------------

function app:CreateProfToolsAssets()
	if not app.Settings.enhancedOrders or app.ProfessionToolOrders1 then return end

	local function createProfToolFrame(type, parent)
		local frame = CreateFrame("ItemButton", nil, parent)
		frame:SetSize(40, 40)
		frame.bg = frame:CreateTexture(nil, "BACKGROUND")
		frame.bg:SetAllPoints()
		frame.bg:SetAtlas("bags-item-slot64")
		frame.equipped = frame:CreateTexture(nil, "BACKGROUND")
		frame.equipped:SetSize(54, 54)
		frame.equipped:SetPoint("CENTER")
		frame.equipped:SetAtlas("bags-newitem")
		frame.equipped:Hide()

		frame:SetScript("OnEnter", function(self)
			local string = L.PROFTOOL_AUTOEQUIP .. "\n"
			if type == "default" then
				string = string .. L.PROFTOOL_DEFAULT .. "\n"
			elseif type == "orders" then
				string = string .. L.PROFTOOL_ORDERS .. "\n"
			end
			if frame:GetItem() then
				string = string .. L.PROFTOOL_MOUSE
			else
				string = string .. L.PROFTOOL_DRAG
			end

			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(string)
			GameTooltip:Show()

			local itemLink = self:GetItemLink()
			if itemLink then
				ShoppingTooltip1:SetOwner(UIParent, "ANCHOR_NONE")
				ShoppingTooltip1:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT")
				ShoppingTooltip1:SetHyperlink(itemLink)
				ShoppingTooltip1:SetScale(0.9)
				ShoppingTooltip1:Show()
			end
		end)
		frame:SetScript("OnLeave", function()
			GameTooltip:Hide()
			ShoppingTooltip1:Hide()
		end)

		local function equipItem(typeToEquip)
			local professionID = ProfessionsFrame.CraftingPage.professionInfo.profession
			local itemLocation = C_Item.GetItemLocation(app.CharData.profTools[professionID][typeToEquip])
			if C_Item.DoesItemExist(itemLocation) and itemLocation:IsBagAndSlot() then
				ClearCursor()
				C_Container.PickupContainerItem(itemLocation.bagID, itemLocation.slotIndex)
				AutoEquipCursorItem()
			end
		end

		local function unequipItem(unequippedType)
			local professionID = ProfessionsFrame.CraftingPage.professionInfo.profession
			if not app.CharData.profTools[professionID].default and not app.CharData.profTools[professionID].orders then
				local slot = C_TradeSkillUI.GetProfessionSlots(professionID)[1]
				if slot then
					local action = EquipmentManager_UnequipItemInSlot(slot)
					if action and not IsInventoryItemLocked(action.invSlot) then
						app.Flag.UnequippingTool = true
						ClearCursor()
						PickupInventoryItem(action.invSlot)
						EquipmentManager_PutItemInInventory(action)
						C_Timer.After(1, function()
							app.Flag.UnequippingTool = false
						end)
					end
				end
			elseif frame.equipped:IsShown() then
				local typeToEquip
				if unequippedType == "default" then
					typeToEquip = "orders"
				elseif unequippedType == "orders" then
					typeToEquip = "default"
				end
				equipItem(typeToEquip)
			end
		end

		local function grabCursorItem()
			local professionID = ProfessionsFrame.CraftingPage.professionInfo.profession
			local itemLocation = C_Cursor.GetCursorItem()
			if itemLocation then
				local itemGUID = C_Item.GetItemGUID(itemLocation)
				app.CharData.profTools[professionID][type] = itemGUID
				local slot = C_TradeSkillUI.GetProfessionSlots(professionID)[1]
				if not GetInventoryItemLink("player", slot) then
					equipItem(type)
				end
				app:UpdateProfToolsAssets()
			end
			ClearCursor()
		end

		frame:SetScript("OnReceiveDrag", grabCursorItem)

		frame:SetScript("OnClick", function(self, button)
			local professionID = ProfessionsFrame.CraftingPage.professionInfo.profession
			if button == "LeftButton" then
				if app.CharData.profTools[professionID][type] then
					equipItem(type)
				else
					grabCursorItem()
				end
			elseif button == "RightButton" then
				app.CharData.profTools[professionID][type] = nil
				ShoppingTooltip1:Hide()
				unequipItem(type)
			end
			app:UpdateProfToolsAssets()
		end)

		return frame
	end

	app.ProfessionToolOrders1 = createProfToolFrame("orders", ProfessionsFrame.CraftingPage, 20)
	app.ProfessionToolOrders1:SetPoint("TOPRIGHT", ProfessionsFrame.CraftingPage, -5, -29)
	app.ProfessionToolDefault1 = createProfToolFrame("default", ProfessionsFrame.CraftingPage, 20)
	app.ProfessionToolDefault1:SetPoint("RIGHT", app.ProfessionToolOrders1, "LEFT", -2, 0)

	ProfessionsFrame.CraftingPage.Prof0ToolSlot:SetAllPoints(app.ProfessionToolDefault1)
	ProfessionsFrame.CraftingPage.Prof1ToolSlot:SetAllPoints(app.ProfessionToolDefault1)
	ProfessionsFrame.CraftingPage.FishingToolSlot:SetAllPoints(app.ProfessionToolDefault1)
	ProfessionsFrame.CraftingPage.CookingToolSlot:SetAllPoints(app.ProfessionToolDefault1)
	ProfessionsFrame.CraftingPage.RankBar:SetWidth(ProfessionsFrame.CraftingPage.RankBar:GetWidth() - 20)
	ProfessionsFrame.CraftingPage.RankBar.Background:SetWidth(ProfessionsFrame.CraftingPage.RankBar.Background:GetWidth() - 25)
	ProfessionsFrame.CraftingPage.RankBar.Border:SetWidth(ProfessionsFrame.CraftingPage.RankBar.Border:GetWidth() - 25)
	ProfessionsFrame.CraftingPage.RankBar.Fill:SetWidth(ProfessionsFrame.CraftingPage.RankBar.Fill:GetWidth() - 25)

	app.ProfessionToolOrders2 = createProfToolFrame("orders", ProfessionsFrame.OrdersPage, 40)
	app.ProfessionToolOrders2:SetPoint("TOPRIGHT", ProfessionsFrame.OrdersPage, -5, -29)
	app.ProfessionToolDefault2 = createProfToolFrame("default", ProfessionsFrame.OrdersPage, 40)
	app.ProfessionToolDefault2:SetPoint("RIGHT", app.ProfessionToolOrders2, "LEFT", -2, 0)

	ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay.Background:SetPoint("TOPLEFT", ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay.OrdersRemaining, -8, -2)
	ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay.Background:SetPoint("BOTTOMRIGHT", ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay.OrdersRemaining, 8, 2)
	ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay:ClearAllPoints()
	ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay:SetPoint("RIGHT", app.ProfessionToolDefaul2, "LEFT", 6, 0)
end

function app:UpdateProfToolsAssets()
	local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
	if not app.Settings.enhancedOrders or not skillLineID or skillLineID == 0 then return end
	local professionID = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineID).profession

	if professionID == 4 or professionID == 5 or professionID == 6 or professionID == 10 or professionID == 11 or professionID == 14 then
		app.ProfessionToolOrders1:Hide()
		app.ProfessionToolDefault1:Hide()
	else
		ProfessionsFrame.CraftingPage.Prof0ToolSlot:Hide()
		ProfessionsFrame.CraftingPage.Prof1ToolSlot:Hide()
		app.ProfessionToolOrders1:Show()
		app.ProfessionToolDefault1:Show()
	end

	if professionID == 4 or professionID == 5 or professionID == 6 or professionID == 10 or professionID == 11 or professionID == 14 then return end
	app.CharData.profTools[professionID] = app.CharData.profTools[professionID] or {}

	if not app.CharData.profTools[professionID].default and not app.CharData.profTools[professionID].orders then
		local slot = C_TradeSkillUI.GetProfessionSlots(professionID)[1]
		local itemLocation = ItemLocation:CreateFromEquipmentSlot(slot)
		if itemLocation and itemLocation:IsValid() and not app.Flag.UnequippingTool then
			app.CharData.profTools[professionID].default = C_Item.GetItemGUID(itemLocation)
		end
	end

	local function update(frameName, type)
		local frame = app[frameName]

		frame.equipped:Hide()
		if app.CharData.profTools[professionID][type] then
			local itemGUID = app.CharData.profTools[professionID][type]
			local itemLink = C_Item.GetItemLink(C_Item.GetItemLocation(itemGUID))
			frame:SetItem(itemLink)

			local slot = C_TradeSkillUI.GetProfessionSlots(professionID)[1]
			local slotItemLocation = ItemLocation:CreateFromEquipmentSlot(slot)
			if slotItemLocation and C_Item.DoesItemExist(slotItemLocation) and C_Item.GetItemGUID(slotItemLocation) == itemGUID then
				frame.equipped:Show()
			end
		else
			frame:SetItem(nil)
		end
	end
	update("ProfessionToolOrders1", "orders")
	update("ProfessionToolOrders2", "orders")
	update("ProfessionToolDefault1", "default")
	update("ProfessionToolDefault2", "default")
end

function app:EquipProfTool(type)
	local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
	if not app.Settings.enhancedOrders or not skillLineID or skillLineID == 0 then return end
	local professionID = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineID).profession
	if professionID == 4 or professionID == 5 or professionID == 6 or professionID == 10 or professionID == 11 or professionID == 14 then return end
	app.CharData.profTools[professionID] = app.CharData.profTools[professionID] or {}
	if not (app.CharData.profTools[professionID].default and app.CharData.profTools[professionID].orders) then return end

	if app.CharData.profTools[professionID][type] then
		local itemLocation = C_Item.GetItemLocation(app.CharData.profTools[professionID][type])
		if C_Item.DoesItemExist(itemLocation) and itemLocation:IsBagAndSlot() then
			C_Container.PickupContainerItem(itemLocation.bagID, itemLocation.slotIndex)
			AutoEquipCursorItem()
		end
	end
end

app.Event:Register("TRADE_SKILL_SHOW", function()
	app:CreateProfToolsAssets()

	local function updateAssets()
		local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
		if not skillLineID or skillLineID == 0 then
			RunNextFrame(updateAssets)
			return
		else
			app:UpdateProfToolsAssets()
		end
	end
	updateAssets()
end)

app.Event:Register("TRADE_SKILL_CLOSE", function()
	app:EquipProfTool("default")
end)

app.Event:Register("CRAFTINGORDERS_CAN_REQUEST", function()
	app:EquipProfTool("orders")
end)

EventRegistry:RegisterCallback("ProfessionsFrame.TabSet", function(...)
	local _, _, tabID = ...
	if tabID == 1 then
		app:EquipProfTool("default")
	elseif tabID == 3 then
		app:EquipProfTool("orders")
	end
end)

app.Event:Register("PROFESSION_EQUIPMENT_CHANGED", function(skillLineID, isTool)
	app:UpdateProfToolsAssets()
end)
