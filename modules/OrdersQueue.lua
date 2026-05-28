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
		app.OrdersQueue = CreateFrame("Frame", nil, ProfessionsFrame.OrdersPage, "BasicFrameTemplate")
		app.OrdersQueue:SetFrameStrata("DIALOG")
		app.OrdersQueue:EnableMouse(true) -- Stop OnEnter for the frames below from triggering
		app.OrdersQueue:SetSize(220, 100)
		app.OrdersQueue:SetPoint("CENTER", ProfessionsFrame.OrdersPage.BrowseFrame.OrderList)
		app.OrdersQueue:Hide()
		app.OrdersQueue.TitleText:SetText(app.NameLong)

		app.OrdersQueue.Button = app:MakeButton(app.OrdersQueue, "", "ProfessionShoppingList_OrdersQueueButton")
		app.OrdersQueue.Button:SetPoint("TOP", app.OrdersQueue, 0, -30)
		app.OrdersQueue.Button:SetText(L.ORDERSQUEUE_NEXT)

		app.OrdersQueue.Status = app.OrdersQueue:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		app.OrdersQueue.Status:SetPoint("TOP", app.OrdersQueue.Button, 0, -30)
		app.OrdersQueue.Status:SetJustifyH("CENTER")
		app.OrdersQueue.Status:SetText(L.LOADING)

		app.OrdersQueue:SetFlattensRenderLayers(true)
		app.OrdersQueue:SetScript("OnShow", function()
			RunNextFrame(function()
				app:UpdateOrdersQueue()
				app.OrdersQueue:SetHeight(math.abs(app.OrdersQueue.Status:GetBottom() - app.OrdersQueue:GetTop()) + 12)
			end)
		end)

		app.QueueOrdersButton = app:MakeButton(app.TrackOrdersButton, L.ORDERSQUEUE_QUEUE)
		app.QueueOrdersButton:SetPoint("LEFT", app.TrackOrdersButton, "RIGHT", 28, 0)
		app.QueueOrdersButton:SetScript("OnClick", function()
			if not app.OrdersQueue:IsShown() then
				app.OrdersQueue:Show()
			else
				app.OrdersQueue:Hide()
			end
		end)

		if C_AddOns.IsAddOnLoaded("DialogKey_Numy") then
			DialogKeyAPI:RegisterAddonFrame(DialogKeyAPI.Enum.FrameType.CraftingOrder, app.OrdersQueue.Button)
		end
	end
end

function app:UpdateOrdersQueue()
	local professionID = C_TradeSkillUI.GetProfessionInfoBySkillLineID(C_TradeSkillUI.GetProfessionChildSkillLineID()).profession
	app.OrderState = app.OrderState or app.Enum.OrderState.Idle

	C_Timer.After(0.2, function()
		if app.OrderState == app.Enum.OrderState.Idle then
			local numOrders = 0
			app.QueuedOrder = {}
			for key, recipe in pairs(ProfessionShoppingList_Data.Recipes) do
				if recipe and recipe.professionID == professionID and recipe.orderID and app.OrderInfo[key].view.orderType == Enum.CraftingOrderType.Npc then
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
			local oldText = app.OrdersQueue.Status:GetText()
			app.OrdersQueue.Button:SetText(L.ORDERSQUEUE_CRAFT)
			app.OrdersQueue.Button:SetWidth(app.OrdersQueue.Button:GetTextWidth()+20)
			app.OrdersQueue.Button:SetScript("OnClick", function()
				if not ProfessionsFrame.OrdersPage.OrderView.CreateButton:IsEnabled() then
					local errorReason
					if C_TradeSkillUI.GetRecipeCooldown(ProfessionsFrame.OrdersPage.OrderView.order.spellID) then
						errorReason = PROFESSIONS_RECIPE_COOLDOWN
					elseif not ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.transaction:HasMetAllRequirements() then
						errorReason = PROFESSIONS_INSUFFICIENT_REAGENTS
					elseif ProfessionsFrame.OrdersPage.OrderView.order.minQuality then
						local qualityInfo = ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.Details:GetProjectedQualityInfo()
						if qualityInfo and ProfessionsFrame.OrdersPage.OrderView.order.minQuality > qualityInfo.quality then
							local requiredQualityInfo = C_TradeSkillUI.GetRecipeItemQualityInfo(ProfessionsFrame.OrdersPage.OrderView.order.spellID, ProfessionsFrame.OrdersPage.OrderView.order.minQuality)
							errorReason = PROFESSIONS_CRAFTING_FORM_MIN_QUALITY .. Professions.GetChatIconMarkupForQuality(requiredQualityInfo, true)
						end
					else
						errorReason = GUILD_RENAME_ERROR_UNKNOWN
					end
					app.OrdersQueue.Status:SetText(errorReason)
					app.OrdersQueue.Status:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
				else
					app.OrdersQueue.Status:SetText(oldText)
					app.OrdersQueue.Status:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
				end
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
	end)
end

app.Event:Register("TRADE_SKILL_CLOSE", function()
	if app.OrdersQueue then app.OrdersQueue:Hide() end
end)

app.Event:Register("TRADE_SKILL_SHOW", function()
	if not InCombatLockdown() then
		if C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
			app:CreateOrdersQueue()
			if not app.OrdersHook1 then
				hooksecurefunc(ProfessionsFrame.OrdersPage, "ViewOrder", function(_, orderDetails)
					app.OrderState = app.Enum.OrderState.Opened
					app:Debug("app.Enum.OrderState.Opened 1")
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
	if app.OrdersQueue and app.OrdersQueue:IsShown() then
		RunNextFrame(function()
			if ProfessionsFrame.OrdersPage.OrderView.CompleteOrderButton:IsShown() then
				app.OrderState = app.Enum.OrderState.Created
				app:Debug("app.Enum.OrderState.Created 1")
			elseif C_CraftingOrders.GetClaimedOrder() and app.OrderState ~= app.Enum.OrderState.Created then
				app.OrderState = app.Enum.OrderState.Claimed
				app:Debug("app.Enum.OrderState.Claimed 1")
			end
			app:UpdateOrdersQueue()
		end)
	end
end)

app.Event:Register("UNIT_SPELLCAST_START", function(unitTarget, castGUID, spellID, castBarID)
	if unitTarget == "player" and app.OrdersQueue and app.OrdersQueue:IsShown() and spellID == app.QueuedOrder.recipeID and app.OrderState ~= app.Enum.OrderState.Created then
		app.OrderState = app.Enum.OrderState.Crafting
		app:Debug("app.Enum.OrderState.Crafting 1")
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("UNIT_SPELLCAST_STOP", function(unitTarget, castGUID, spellID, castBarID)
	C_Timer.After(1, function()
		if unitTarget == "player" and app.OrdersQueue and app.OrdersQueue:IsShown() and spellID == app.QueuedOrder.recipeID and app.OrderState ~= app.Enum.OrderState.Created then
			app.OrderState = app.Enum.OrderState.Claimed
			app:Debug("app.Enum.OrderState.Claimed 2")
			app:UpdateOrdersQueue()
		end
	end)
end)

app.Event:Register("UNIT_SPELLCAST_INTERRUPTED", function(unitTarget, castGUID, spellID, castBarID)
	if unitTarget == "player" and app.OrdersQueue and app.OrdersQueue:IsShown() and spellID == app.QueuedOrder.recipeID and app.OrderState ~= app.Enum.OrderState.Created then
		app.OrderState = app.Enum.OrderState.Claimed
		app:Debug("app.Enum.OrderState.Claimed 3")
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("TRADE_SKILL_ITEM_CRAFTED_RESULT", function(data)
	if app.OrdersQueue and app.OrdersQueue:IsShown() then
		app.OrderState = app.Enum.OrderState.Created
		app:Debug("app.Enum.OrderState.Created 2")
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("CRAFTINGORDERS_FULFILL_ORDER_RESPONSE", function(result, orderID)
	if app.OrdersQueue and app.OrdersQueue:IsShown() and result == 0 then
		app.OrderState = app.Enum.OrderState.Idle
		app:Debug("app.Enum.OrderState.Idle 1")
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("CRAFTINGORDERS_RELEASE_ORDER_RESPONSE", function(result, orderID)
	if app.OrdersQueue and app.OrdersQueue:IsShown() then
		app.OrderState = app.Enum.OrderState.Idle
		app:Debug("app.Enum.OrderState.Idle 2")
		app:UpdateOrdersQueue()
	end
end)
