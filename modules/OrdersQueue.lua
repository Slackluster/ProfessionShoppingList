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
		app.QueuedOrders = {}
	end
end)

------------------
-- ORDERS QUEUE --
------------------

function app:CreateOrdersQueueFrame()
	if not app.OrdersQueueFrame then
		app.OrdersQueueFrame = CreateFrame("Frame", nil, ProfessionsFrame.OrdersPage, "DefaultPanelTemplate")
		app.OrdersQueueFrame:SetFrameStrata("DIALOG")
		app.OrdersQueueFrame:EnableMouse(true) -- Stop OnEnter for the frames below from triggering
		app.OrdersQueueFrame:SetSize(220, 100)
		app.OrdersQueueFrame:SetPoint("CENTER", ProfessionsFrame.OrdersPage.BrowseFrame.OrderList)
		app.OrdersQueueFrame:Hide()
		app.OrdersQueueFrame.TitleContainer.TitleText:SetText(app.NameLong)
		app.OrdersQueueFrame.CloseButton = CreateFrame("Button", nil, app.OrdersQueueFrame, "UIPanelCloseButton")
		app.OrdersQueueFrame.CloseButton:SetPoint("TOPRIGHT", app.OrdersQueueFrame)
		app.OrdersQueueFrame.CloseButton:SetScript("OnClick", function()
			app.OrdersQueueFrame:Hide()
		end)

		app.OrdersQueueFrame.Button = app:MakeButton(app.OrdersQueueFrame, "", "ProfessionShoppingList_OrdersQueueButton")
		app.OrdersQueueFrame.Button:SetPoint("TOP", app.OrdersQueueFrame, 0, -30)
		app:UpdateButton(app.OrdersQueueFrame.Button, AUCTION_HOUSE_REFRESH_BUTTON_TOOLTIP)
		app.OrdersQueueFrame.Button:SetScript("OnClick", function()
			app:UpdateOrdersQueue()
		end)

		app.OrdersQueueFrame.Status = app.OrdersQueueFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		app.OrdersQueueFrame.Status:SetPoint("TOP", app.OrdersQueueFrame.Button, 0, -30)
		app.OrdersQueueFrame.Status:SetJustifyH("CENTER")
		app.OrdersQueueFrame.Status:SetText(L.LOADING)

		app.OrdersQueueFrame.Warning = CreateFrame("Button", nil, app.OrdersQueueFrame)
		app.OrdersQueueFrame.Warning:SetPoint("RIGHT", app.OrdersQueueFrame.Bg)
		app.OrdersQueueFrame.Warning:SetSize(48, 48)
		app.OrdersQueueFrame.Warning.Texture = app.OrdersQueueFrame.Warning:CreateTexture(nil, "ARTWORK")
		app.OrdersQueueFrame.Warning.Texture:SetAllPoints(app.OrdersQueueFrame.Warning)
		app.OrdersQueueFrame.Warning.Texture:SetAtlas("Ping_Wheel_Icon_Warning", true)
		app.OrdersQueueFrame.Warning.Animation = app.OrdersQueueFrame.Warning:CreateAnimationGroup()
			local fadeOut = app.OrdersQueueFrame.Warning.Animation:CreateAnimation("Alpha")
			fadeOut:SetFromAlpha(1)
			fadeOut:SetToAlpha(0.4)
			fadeOut:SetDuration(1)
			fadeOut:SetStartDelay(2)
			fadeOut:SetOrder(1)
			local fadeIn = app.OrdersQueueFrame.Warning.Animation:CreateAnimation("Alpha")
			fadeIn:SetFromAlpha(0.4)
			fadeIn:SetToAlpha(1)
			fadeIn:SetDuration(1)
			fadeIn:SetOrder(2)
		app.OrdersQueueFrame.Warning.Animation:SetLooping("REPEAT")
		app.OrdersQueueFrame.Warning.Text = ""
		app.OrdersQueueFrame.Warning:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(app.OrdersQueueFrame.Warning.Text)
			GameTooltip:Show()
		end)
		app.OrdersQueueFrame.Warning:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		app.OrdersQueueFrame.Warning:Hide()

		app.OrdersQueueFrame:SetFlattensRenderLayers(true)
		app.OrdersQueueFrame:SetScript("OnShow", function()
			RunNextFrame(function()
				app.OrdersQueueFrame:SetHeight(math.abs(app.OrdersQueueFrame.Status:GetBottom() - app.OrdersQueueFrame:GetTop()) + 12)
				app:UpdateOrdersQueue()
			end)
		end)

		app.QueueOrdersButton = app:MakeButton(app.TrackOrdersButton, L.ORDERSQUEUE_QUEUE)
		app.QueueOrdersButton:SetPoint("LEFT", app.TrackOrdersButton, "RIGHT", 28, 0)
		app.QueueOrdersButton:SetScript("OnClick", function()
			if not app.OrdersQueueFrame:IsShown() then
				app.OrdersQueueFrame:Show()
			else
				app.OrdersQueueFrame:Hide()
			end
		end)

		if C_AddOns.IsAddOnLoaded("DialogKey_Numy") then
			DialogKeyAPI:RegisterAddonFrame(DialogKeyAPI.Enum.FrameType.CraftingOrder, app.OrdersQueueFrame.Button)
		end
	end
end

function app:UpdateOrdersQueue()
	local skillLineID = C_TradeSkillUI.GetProfessionChildSkillLineID()
	local professionID = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineID).profession
	local concID = C_TradeSkillUI.GetConcentrationCurrencyID(skillLineID)
	app.OrderState = app.OrderState or app.Enum.OrderState.Idle

	app.OrdersQueueFrame.Button:SetScript("OnClick", function() end)
	C_Timer.After(0.2, function()
		local questID
		if app.ProfessionKnowledge[skillLineID] then
			for _, source in pairs(app.ProfessionKnowledge[skillLineID]) do
				if source.type == "weeklyQuest" and type(source.quest) == "number" then
					questID = source.quest
					break
				end
			end
		end
		if questID and not C_QuestLog.IsQuestFlaggedCompleted(questID) and not C_QuestLog.IsOnQuest(questID) then
			app.OrdersQueueFrame.Warning.Text = "|cffFFFFFF" .. string.format(L.ORDERSQUEUE_WARNING_QUEST, ("|R|Hquest:0|h[%s]|h"):format(C_QuestLog.GetTitleForQuestID(questID)))
			app.OrdersQueueFrame.Warning:Show()
			app.OrdersQueueFrame.Warning.Animation:Play()
		elseif not app.Flag.HaveAllReagents then
			app.OrdersQueueFrame.Warning.Text = L.ORDERSQUEUE_WARNING_REAGENTS
			app.OrdersQueueFrame.Warning:Show()
			app.OrdersQueueFrame.Warning.Animation:Play()
		else
			app.OrdersQueueFrame.Warning.Text = ""
			app.OrdersQueueFrame.Warning:Hide()
			app.OrdersQueueFrame.Warning.Animation:Stop()
		end

		if app.OrderState == app.Enum.OrderState.Idle then
			app.QueuedOrders = {}

			local trackedType = 9
			if ProfessionsFrame.OrdersPage.BrowseFrame.NpcOrdersButton.isSelected then
				trackedType = Enum.CraftingOrderType.Npc
			elseif ProfessionsFrame.OrdersPage.BrowseFrame.PersonalOrdersButton.isSelected then
				trackedType = Enum.CraftingOrderType.Personal
			end

			for key, recipe in pairs(ProfessionShoppingList_Data.Recipes) do
				if recipe and recipe.professionID == professionID and recipe.orderID and app.OrderInfo[key] and app.OrderInfo[key].view.orderType == trackedType and C_CurrencyInfo.GetCurrencyInfo(concID).quantity > app.OrderInfo[key].concentrationCost then
					table.insert(app.QueuedOrders, app.OrderInfo[key])
				end
			end

			table.sort(app.QueuedOrders, function(a, b) return a.expirationTime < b.expirationTime end)

			app.OrdersQueueFrame.Status:SetText(L.ORDERSQUEUE_QUEUED .. " " .. #app.QueuedOrders)
			if #app.QueuedOrders == 0 then
				app.OrdersQueueFrame.Button:Disable()
			else
				app.OrdersQueueFrame.Button:Enable()
			end

			app:UpdateButton(app.OrdersQueueFrame.Button, L.ORDERSQUEUE_NEXT)
			app.OrdersQueueFrame.Button:SetScript("OnClick", function()
				ProfessionsFrame.OrdersPage:ViewOrder(app.QueuedOrders[1].view)
			end)
		elseif app.OrderState == app.Enum.OrderState.Opened then
			app:UpdateButton(app.OrdersQueueFrame.Button, L.ORDERSQUEUE_CLAIM)
			app.OrdersQueueFrame.Button:SetScript("OnClick", function()
				C_CraftingOrders.ClaimOrder(app.QueuedOrders[1].orderID, professionID)
			end)
		elseif app.OrderState == app.Enum.OrderState.Claimed then
			local oldText = app.OrdersQueueFrame.Status:GetText()
			app:UpdateButton(app.OrdersQueueFrame.Button, L.ORDERSQUEUE_CRAFT)
			app.OrdersQueueFrame.Button:SetScript("OnClick", function()
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
					app.OrdersQueueFrame.Status:SetText(errorReason)
					app.OrdersQueueFrame.Status:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
				else
					app.OrdersQueueFrame.Status:SetText(oldText)
					app.OrdersQueueFrame.Status:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
				end
				ProfessionsFrame.OrdersPage.OrderView.CreateButton:Click()
			end)
		elseif app.OrderState == app.Enum.OrderState.Crafting then
			app:UpdateButton(app.OrdersQueueFrame.Button, L.ORDERSQUEUE_CRAFTING)
			app.OrdersQueueFrame.Button:SetScript("OnClick", function() end)
		elseif app.OrderState == app.Enum.OrderState.Created then
			if not C_CraftingOrders.GetClaimedOrder() then
				app.OrderState = app.Enum.OrderState.Idle
				app:UpdateOrdersQueue()
				return
			end
			C_Timer.After(0.1, function()
				app:UpdateButton(app.OrdersQueueFrame.Button, L.ORDERSQUEUE_COMPLETE)
				app.OrdersQueueFrame.Button:SetScript("OnClick", function()
					C_CraftingOrders.FulfillOrder(app.QueuedOrders[1].orderID, "", professionID)
					app:Debug("Fulfill")
				end)
			end)
		end
	end)
end

app.Event:Register("TRADE_SKILL_CLOSE", function()
	if app.OrdersQueueFrame then app.OrdersQueueFrame:Hide() end
end)

app.Event:Register("TRADE_SKILL_SHOW", function()
	if not InCombatLockdown() then
		if C_AddOns.IsAddOnLoaded("Blizzard_Professions") then
			app:CreateOrdersQueueFrame()
			if not app.OrdersHook1 then
				hooksecurefunc(ProfessionsFrame.OrdersPage, "ViewOrder", function(_, orderDetails)
					if app.OrderState == app.Enum.OrderState.Idle then
						app.OrderState = app.Enum.OrderState.Opened
						app:Debug("app.Enum.OrderState.Opened 1")
						if app.OrdersQueueFrame:IsShown() then
							app:UpdateOrdersQueue()
						end
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
	if app.OrdersQueueFrame and app.OrdersQueueFrame:IsShown() then
		C_Timer.After(0.2, function()
			if ProfessionsFrame.OrdersPage.OrderView.CompleteOrderButton:IsShown() then
				app.OrderState = app.Enum.OrderState.Created
				app:Debug("app.Enum.OrderState.Created 1")
			elseif app.OrderState ~= app.Enum.OrderState.Created then
				app.OrderState = app.Enum.OrderState.Claimed
				app:Debug("app.Enum.OrderState.Claimed 1")
			end
			app:UpdateOrdersQueue()
		end)
	end
end)

app.Event:Register("CRAFTINGORDERS_CLAIM_ORDER_RESPONSE", function(result, orderID)
	if app.OrdersQueueFrame and app.OrdersQueueFrame:IsShown() and result == Enum.CraftingOrderResult.MissingOrder then
		local key = "order:" .. orderID .. ":" .. app.QueuedOrders[1].spellID
		app.OrderInfo[key] = nil
		ProfessionShoppingList_Data.Recipes[key] = nil
		table.remove(app.OrdersQueueFrame, 1)
		app:UpdateRecipes()
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("UNIT_SPELLCAST_START", function(unitTarget, castGUID, spellID, castBarID)
	if unitTarget == "player" and #app.QueuedOrders > 0 and spellID == app.QueuedOrders[1].spellID and app.OrderState ~= app.Enum.OrderState.Created then
		app.OrderState = app.Enum.OrderState.Crafting
		app:Debug("app.Enum.OrderState.Crafting 1")
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("UNIT_SPELLCAST_STOP", function(unitTarget, castGUID, spellID, castBarID)
	C_Timer.After(1, function()
		if unitTarget == "player" and #app.QueuedOrders > 0 and spellID == app.QueuedOrders[1].spellID and app.OrderState ~= app.Enum.OrderState.Created and app.OrderState ~= app.Enum.OrderState.Idle and C_CraftingOrders.GetClaimedOrder() then
			app.OrderState = app.Enum.OrderState.Claimed
			app:Debug("app.Enum.OrderState.Claimed 2")
			app:UpdateOrdersQueue()
		end
	end)
end)

app.Event:Register("UNIT_SPELLCAST_INTERRUPTED", function(unitTarget, castGUID, spellID, castBarID)
	if unitTarget == "player" and #app.QueuedOrders > 0 and spellID == app.QueuedOrders[1].spellID and app.OrderState ~= app.Enum.OrderState.Created and app.OrderState ~= app.Enum.OrderState.Idle and C_CraftingOrders.GetClaimedOrder() then
		app.OrderState = app.Enum.OrderState.Claimed
		app:Debug("app.Enum.OrderState.Claimed 3")
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("TRADE_SKILL_ITEM_CRAFTED_RESULT", function(data)
	if app.OrdersQueueFrame and app.OrdersQueueFrame:IsShown() then
		app.OrderState = app.Enum.OrderState.Created
		app:Debug("app.Enum.OrderState.Created 2")
		app:UpdateOrdersQueue()
	end
end)

app.Event:Register("CRAFTINGORDERS_FULFILL_ORDER_RESPONSE", function(result, orderID)
	app:Debug(result)
	if app.QueuedOrders[1] and orderID ~= app.QueuedOrders[1].orderID then return end
	if app.OrdersQueueFrame and app.OrdersQueueFrame:IsShown() and result == Enum.CraftingOrderResult.NotCrafted then
		app.OrderState = app.Enum.OrderState.Claimed
		app:Debug("app.Enum.OrderState.Claimed (not crafted)")
	elseif app.OrdersQueueFrame and app.OrdersQueueFrame:IsShown() and result == Enum.CraftingOrderResult.Ok then
		app.OrderState = app.Enum.OrderState.Idle
		app:Debug("app.Enum.OrderState.Idle (fulfilled)")
	elseif app.OrdersQueueFrame and app.OrdersQueueFrame:IsShown() and result ~= Enum.CraftingOrderResult.Ok then
		app.OrderState = app.Enum.OrderState.Created
		app:Debug("app.Enum.OrderState.Created (not fulfilled)")
	end
	app:UpdateOrdersQueue()
end)

app.Event:Register("CRAFTINGORDERS_RELEASE_ORDER_RESPONSE", function(result, orderID)
	if app.OrdersQueueFrame and app.OrdersQueueFrame:IsShown() then
		app.OrderState = app.Enum.OrderState.Idle
		app:Debug("app.Enum.OrderState.Idle 2")
		app:UpdateOrdersQueue()
	end
end)
