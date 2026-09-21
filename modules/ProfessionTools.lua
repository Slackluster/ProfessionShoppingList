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
	if not app.Settings["enhancedOrders"] or app.ProfessionToolOrders then return end

	local function createProfToolFrame(type)
		local frame = CreateFrame("ItemButton", nil, ProfessionsFrame.OrdersPage)
		frame:SetSize(40, 40)
		frame.bg = frame:CreateTexture(nil, "BACKGROUND")
		frame.bg:SetAllPoints()
		frame.bg:SetAtlas("bags-item-slot64")
		frame.equipped = frame:CreateTexture(nil, "BACKGROUND")
		frame.equipped:SetSize(55, 56)
		frame.equipped:SetPoint("CENTER", -1, 0)
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

		local function grabCursorItem()
			local itemLocation = C_Cursor.GetCursorItem()
			if itemLocation then
				local itemGUID = C_Item.GetItemGUID(itemLocation)
				app.CharData.profTools[type] = itemGUID
				app:UpdateProfToolsAssets()
			end
			ClearCursor()
		end

		frame:SetScript("OnReceiveDrag", grabCursorItem)

		frame:SetScript("OnClick", function(self, button)
			if button == "LeftButton" then
				if app.CharData.profTools[type] then
					local itemLocation = C_Item.GetItemLocation(app.CharData.profTools[type])
					if C_Item.DoesItemExist(itemLocation) and itemLocation:IsBagAndSlot() then
						C_Container.PickupContainerItem(itemLocation.bagID, itemLocation.slotIndex)
						AutoEquipCursorItem()
					end
				else
					grabCursorItem()
				end
			elseif button == "RightButton" then
				app.CharData.profTools[type] = nil
				ShoppingTooltip1:Hide()
			end
			app:UpdateProfToolsAssets()
		end)

		return frame
	end

	app.ProfessionToolOrders = createProfToolFrame("orders")
	app.ProfessionToolOrders:SetPoint("TOPRIGHT", ProfessionsFrame.OrdersPage, -8, -28)

	app.ProfessionToolDefault = createProfToolFrame("default")
	app.ProfessionToolDefault:SetPoint("RIGHT", app.ProfessionToolOrders, "LEFT", -10, 0)

	ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay.Background:SetPoint("TOPLEFT", ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay.OrdersRemaining, -8, -2)
	ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay.Background:SetPoint("BOTTOMRIGHT", ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay.OrdersRemaining, 8, 2)
	ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay:ClearAllPoints()
	ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay:SetPoint("RIGHT", app.ProfessionToolDefault, "LEFT", 6, 0)
end

function app:UpdateProfToolsAssets()
	if not app.Settings["enhancedOrders"] then return end

	local function update(frameName, type)
		local frame = app[frameName]

		frame.equipped:Hide()
		if app.CharData.profTools[type] then
			local itemGUID = app.CharData.profTools[type]
			local itemLink = C_Item.GetItemLink(C_Item.GetItemLocation(itemGUID))
			frame:SetItem(itemLink)

			for _, slot in pairs({ 20, 23 }) do
				local slotItemLocation = ItemLocation:CreateFromEquipmentSlot(slot)
				if slotItemLocation and C_Item.DoesItemExist(slotItemLocation) and C_Item.GetItemGUID(slotItemLocation) == itemGUID then
					frame.equipped:Show()
				end
			end
		else
			frame:SetItem(nil)
		end
	end
	update("ProfessionToolOrders", "orders")
	update("ProfessionToolDefault", "default")
end

function app:EquipProfTool(type)
	if not app.Settings["enhancedOrders"] then return end

	if app.CharData.profTools[type] then
		local itemLocation = C_Item.GetItemLocation(app.CharData.profTools[type])
		if C_Item.DoesItemExist(itemLocation) and itemLocation:IsBagAndSlot() then
			C_Container.PickupContainerItem(itemLocation.bagID, itemLocation.slotIndex)
			AutoEquipCursorItem()
		end
	end
end

app.Event:Register("TRADE_SKILL_SHOW", function()
	app:CreateProfToolsAssets()
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
