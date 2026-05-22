-----------------------------------------------
-- Profession Shopping List: OrdersQueue.lua --
-----------------------------------------------

local appName, app = ...
local api = app.api
local L = app.locales

-------------
-- ON LOAD --
-------------

-- When the addon is fully loaded, actually run the components
app.Event:Register("ADDON_LOADED", function(addOnName, containsBindings)
	if addOnName == appName then
		app.Enum.OrderState = {
			Idle = 0,
			Opened = 1,
			Claimed = 2,
			Crafting = 3,
			Created = 4,
		}
	end
end)

------------------
-- ORDERS QUEUE --
------------------

function app:CreateOrdersQueue()
	if not app.OrdersQueue then
		app.OrdersQueue = CreateFrame("Frame", "", ProfessionsFrame.OrdersPage, "BasicFrameTemplate")
		app.OrdersQueue:SetFrameStrata("DIALOG")
		app.OrdersQueue:EnableMouse(true) -- Stop OnEnter for the frames below from triggering
		app.OrdersQueue:SetSize(220, 100)
		app.OrdersQueue:SetPoint("CENTER", ProfessionsFrame.OrdersPage.BrowseFrame.OrderList)
		app.OrdersQueue:Hide()
		app.OrdersQueue.TitleText:SetText(app.NameLong)

		app.OrdersQueue.Button = app:MakeButton(app.OrdersQueue, "", "PSLOrdersQueueButton")
		app.OrdersQueue.Button:SetPoint("TOP", app.OrdersQueue, 0, -30)

		app.OrdersQueue.Status = app.OrdersQueue:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		app.OrdersQueue.Status:SetPoint("TOP", app.OrdersQueue.Button, 0, -30)
		app.OrdersQueue.Status:SetJustifyH("CENTER")

		app.OrdersQueue:SetFlattensRenderLayers(true)
		app.OrdersQueue:SetScript("OnShow", function()
			RunNextFrame(function()
				app:UpdateOrdersQueue()
				app.OrdersQueue:SetHeight(math.abs(app.OrdersQueue.Status:GetBottom() - app.OrdersQueue:GetTop()) + 12)
			end)
		end)

		app.QueueOrdersButton = app:MakeButton(app.TrackOrdersButton, L.ORDERSQUEUE_QUEUE)
		app.QueueOrdersButton:SetPoint("LEFT", app.TrackOrdersSettingsButton, "RIGHT", 2, 0)
		app.QueueOrdersButton:SetScript("OnClick", function()
			if C_AddOns.IsAddOnLoaded("DialogKey_Numy") then
				if DialogKeyNumyDB then
					DialogKeyNumyDB.handleCraftingOrders = false
					if DialogKeyNumyDB.customFrames and not DialogKeyNumyDB.customFrames.PSLOrdersQueueButton then
						DialogKeyNS:AddToWatchlist("PSLOrdersQueueButton")
					end
				end
			end
			if not app.OrdersQueue:IsShown() then
				app.OrdersQueue:Show()
			else
				app.OrdersQueue:Hide()
			end
		end)
	end
end

function app:UpdateOrdersQueue()
	local professionID = C_TradeSkillUI.GetProfessionInfoBySkillLineID(C_TradeSkillUI.GetProfessionChildSkillLineID()).profession

	if app.OrderState == app.Enum.OrderState.Idle then
		local numOrders = 0
		app.QueuedOrder = {}
		for key, recipe in pairs(ProfessionShoppingList_Data.Recipes) do
			if recipe.professionID == professionID and string.sub(key, 1, 6) == "order:" then
				if not app.QueuedOrder.key then
					app.QueuedOrder.key = key
					app.QueuedOrder.orderID = recipe.orderID
					app.QueuedOrder.recipeID = recipe.recipeID
				end
				numOrders = numOrders + 1
			end
		end

		app.OrdersQueue.Status:SetText(L.ORDERSQUEUE_QUEUED .. " " .. numOrders)
		if numOrders == 0 then
			app.OrdersQueue.Button:Disable()
		else
			app.OrdersQueue.Button:Enable()
		end

		app.OrdersQueue.Button:SetText(L.ORDERSQUEUE_NEXT)
		app.OrdersQueue.Button:SetWidth(app.OrdersQueue.Button:GetTextWidth()+20)
		app.OrdersQueue.Button:SetScript("OnClick", function()
			ProfessionsFrame.OrdersPage:ViewOrder(app.OrderInfo[app.QueuedOrder.key].view)
		end)
	elseif app.OrderState == app.Enum.OrderState.Opened then
		app.OrdersQueue.Button:SetText(L.ORDERSQUEUE_CLAIM)
		app.OrdersQueue.Button:SetWidth(app.OrdersQueue.Button:GetTextWidth()+20)
		app.OrdersQueue.Button:SetScript("OnClick", function()
			C_CraftingOrders.ClaimOrder(app.QueuedOrder.orderID, professionID)
		end)
	elseif app.OrderState == app.Enum.OrderState.Claimed then
		app.OrdersQueue.Button:SetText(L.ORDERSQUEUE_CRAFT)
		app.OrdersQueue.Button:SetWidth(app.OrdersQueue.Button:GetTextWidth()+20)
		app.OrdersQueue.Button:SetScript("OnClick", function()
			ProfessionsFrame.OrdersPage.OrderView.CreateButton:Click()
		end)
	elseif app.OrderState == app.Enum.OrderState.Crafting then
		app.OrdersQueue.Button:SetText(L.ORDERSQUEUE_CRAFTING)
		app.OrdersQueue.Button:SetWidth(app.OrdersQueue.Button:GetTextWidth()+20)
		app.OrdersQueue.Button:SetScript("OnClick", function() end)
	elseif app.OrderState == app.Enum.OrderState.Created then
		app.OrdersQueue.Button:SetText(L.ORDERSQUEUE_COMPLETE)
		app.OrdersQueue.Button:SetWidth(app.OrdersQueue.Button:GetTextWidth()+20)
		app.OrdersQueue.Button:SetScript("OnClick", function()
			C_CraftingOrders.FulfillOrder(app.QueuedOrder.orderID, "", professionID)
		end)
	end
end

app.Event:Register("TRADE_SKILL_CLOSE", function()
	app.OrdersQueue:Hide()
end)

app.Event:Register("TRADE_SKILL_SHOW", function()
	if not InCombatLockdown() then
		if C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
			app:CreateOrdersQueue()
			if not app.OrdersHook1 then
				hooksecurefunc(ProfessionsFrame.OrdersPage, "ViewOrder", function(_, orderDetails)
					app.OrderState = app.Enum.OrderState.Opened
					if app.OrdersQueue:IsShown() then
						app:UpdateOrdersQueue()
					end
				end)
				ProfessionsFrame.OrdersPage.OrderView.CreateButton:HookScript("OnClick", function()
					if StaticPopup1:IsShown() then
						StaticPopup1Button1:Click()
						app:UpdateOrdersQueue()
					end
				end)
				app.OrdersHook1 = true
			end
		end
	end
end)

app.Event:Register("CRAFTINGORDERS_CLAIMED_ORDER_UPDATED", function(orderID)
	if app.OrdersQueue:IsShown() then
		if C_CraftingOrders.GetClaimedOrder() and app.OrderState ~= app.Enum.OrderState.Created then
			app.OrderState = app.Enum.OrderState.Claimed
		end
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("UNIT_SPELLCAST_START", function(unitTarget, castGUID, spellID, castBarID)
	if unitTarget == "player" and app.OrdersQueue and app.OrdersQueue:IsShown() and spellID == app.QueuedOrder.recipeID then
		app.OrderState = app.Enum.OrderState.Crafting
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("UNIT_SPELLCAST_STOP", function(unitTarget, castGUID, spellID, castBarID)
	C_Timer.After(1, function()
		if unitTarget == "player" and app.OrdersQueue and app.OrdersQueue:IsShown() and spellID == app.QueuedOrder.recipeID and app.OrderState ~= app.Enum.OrderState.Created then
			app.OrderState = app.Enum.OrderState.Claimed
			app:UpdateOrdersQueue()
		end
	end)
end)

app.Event:Register("UNIT_SPELLCAST_INTERRUPTED", function(unitTarget, castGUID, spellID, castBarID)
	if unitTarget == "player" and app.OrdersQueue and app.OrdersQueue:IsShown() and spellID == app.QueuedOrder.recipeID and app.OrderState ~= app.Enum.OrderState.Created then
		app.OrderState = app.Enum.OrderState.Claimed
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("TRADE_SKILL_ITEM_CRAFTED_RESULT", function(data)
	if app.OrdersQueue:IsShown() and app.OrderState then
		app.OrderState = app.Enum.OrderState.Created
		app:UpdateOrdersQueue()
	end
end)
