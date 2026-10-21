----------------------------------------
-- Profession Shopping List: zhTW.lua --
----------------------------------------
-- Chinese (Traditional, Taiwan) localisation
-- Translator(s): DDDDDD

if GetLocale() ~= "zhTW" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "%s 有新版本可用：" -- %s becomes the addon name

L.RESET_DONE =                           "資料已成功重置。"
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.DEBUG_ENABLED =                        "除錯模式已啟用"
L.DEBUG_DISABLED =                       "除錯模式已停用"
L.INVALID_PARAMETERS =                   "參數無效"
L.INVALID_COMMAND =                      "指令無效"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. "：" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "開發這個插件需要投入大量的時間與心力。"
L.SUPPORT_TEXTLONG2 =                    "歡迎考慮以金錢支持開發者。"
L.SUPPORT =                              "支持"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "謝謝！"
L.FEEDBACK_AND_HELP =                    "意見回饋與協助"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "加入 Discord 伺服器。"
L.CTRL_C_COPY =                          "按 Ctrl+C 複製："
L.LINK_COPIED =                          "連結已複製到剪貼簿"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & 斜線指令" -- "Keybindings"
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. "：切換視窗"
L.TOGGLE_TRACKING_WINDOW =               "切換追蹤視窗"
L.RESET_WINDOW_POSITION =                "重置追蹤視窗的位置"
L.RESET_SAVED_DATA =                     "重置已儲存的資料"
L.OPEN_SETTINGS =                        "開啟設定"
L.CLEAR_TRACKED_RECIPES =                "清除所有追蹤中的配方"
L.RECIPEID =                             "配方ID"
L.QUANTITY =                             "數量"
L.TRACK_RECIPE =                         "追蹤配方"
L.UNTRACK_RECIPE =                       "取消追蹤配方"
L.UNTRACK_RECIPE_ALL =                   "取消追蹤該配方的全部數量"
L.CRAFTING_ACHIEVEMENT =                 "製作成就"
L.TRACK_ACHIEVEMENT_RECIPES =            "追蹤連結成就所需的配方"
L.ITEMLINK_OR_ITEMID =                   "物品連結或物品ID"
L.TRACK_REAGENT_RECIPES =                "追蹤所有使用此材料的配方"

L.GENERAL =                              GENERAL -- "General"
L.SHOW_MINIMAP_ICON =                    "顯示小地圖圖示"
L.SHOW_MINIMAP_ICON_DESC =               "顯示小地圖圖示。即使停用，仍可從插件選單開啟 %s。" -- %s becomes the addon name
L.TRACK_RECIPE_COOLDOWNS =               "追蹤配方冷卻時間"
L.TRACK_RECIPE_COOLDOWNS_DESC =          "啟用配方冷卻時間的追蹤。冷卻時間會顯示在追蹤視窗中，並在登入時若已就緒，於聊天視窗提醒。"
L.SHOW_WINDOW_WHEN_READY =               "就緒時顯示視窗"
L.SHOW_WINDOW_WHEN_READY_DESC =          "登入時若有冷卻已就緒，除了聊天訊息提醒外，同時開啟追蹤視窗。"
L.SHOW_TOOLTIP_INFORMATION =             "顯示提示資訊"
L.SHOW_TOOLTIP_INFORMATION_DESC =        "在物品提示中顯示你擁有／需要的材料數量。"
L.SHOW_CRAFTING_INFORMATION =            "顯示製作資訊"
L.SHOW_CRAFTING_INFORMATION_DESC =       "顯示裝備是由哪個專業技能製作，以及你的帳號是否已學會該配方。"
L.SHOW_CRAFTING_COST =                   "顯示製作成本"
L.SHOW_CRAFTING_COST_DESC =              "若有相關資訊，顯示製作該物品所需的成本。"
L.MINIMUM_REAGENT_QUALITY =              "最低材料品質"
L.MINIMUM_REAGENT_QUALITY_DESC =         "設定材料需達到的最低品質才會被計入。模擬的結果仍會覆蓋此設定。"
L.LOW =                                  LOW -- "Low"
L.HIGH =                                 HIGH -- "High"
L.INCLUDE_HIGHER_QUALITY =               "包含較高品質"
L.INCLUDE_HIGHER_QUALITY_DESC =          "是否計入較高品質的材料。（例如：計算 1 階材料時，也計入你擁有的 2 階材料。）"
-- L.INCLUDE_HIGHER_QUALITY_DESC2 =         "Higher qualities will be counted automatically if they are cheaper."
L.INCLUDE_HIGHER_QUALITIES_YES =         "包含較高品質"
L.INCLUDE_HIGHER_QUALITIES_NO =          "不包含較高品質"
L.COLLECTION_MODE =                      "收藏模式"
L.COLLECTION_MODE_DESC =                 "設定使用 %s 按鈕時要納入哪些物品。" -- %s becomes "Track New"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_SETTING_DESC =             "僅納入擁有新外觀的物品。"
L.APPEARANCES_SOURCES =                  "來源"
L.APPEARANCES_SOURCES_SETTING_DESC =     "納入新來源的物品，包含已知外觀的新來源。"

L.PROFESSION_WINDOW =                    "專業技能視窗"
L.FILTER_OPTIONAL_REAGENTS =             "篩選選用材料"
L.FILTER_OPTIONAL_REAGENTS_DESC =        "選用材料勾選 %s 時，隱藏可合併的物品。" -- %s becomes "Hide Unavailable"
L.SPEND_TO_NEXT_PERK =                   "花費至下一個特長"
L.SPEND_TO_NEXT_PERK_DESC =              "按住 Shift 並點擊專業知識節點時，會持續投入點數直到解鎖下一個特長。"
L.ENHANCED_ORDERS =                      "強化訂單"
L.ENHANCED_ORDERS_DESC =                 "強化訂單獎勵與佣金的預覽，並為首次製作、尚未學會的配方，以及追蹤中的配方加上圖示。"
L.QUICK_ORDER_DURATION =                 "快速訂單時效"
L.QUICK_ORDER_DURATION_DESC =            "設定快速訂單的刊登時效。"
L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

L.TRACKING_WINDOW =                      "追蹤視窗"
L.SHOW_HELP_TOOLTIPS =                   "顯示操作說明提示"
L.SHOW_HELP_TOOLTIPS_DESC =              "將滑鼠移到追蹤視窗的項目上時，顯示可用的滑鼠操作。"
L.WINDOW_POSITION_PER_CHAR =             "依角色記錄視窗位置"
L.WINDOW_POSITION_PER_CHAR_DESC =        "依角色各自儲存視窗位置，而非整個帳號共用。"
L.TRACK_RECIPES_PER_CHAR =               "依角色追蹤配方"
L.TRACK_RECIPES_PER_CHAR_DESC =          "依角色各自追蹤配方，而非整個帳號共用。"
L.SHOW_REMAINING_REAGENTS =              "顯示剩餘材料"
L.SHOW_REMAINING_REAGENTS_DESC =         "追蹤視窗中只顯示你還需要多少材料，而不是「已有／需要」。"
L.UNTRACK_ON_CRAFT =                     "製作後取消追蹤"
L.UNTRACK_ON_CRAFT_DESC =                "成功製作追蹤中的配方時，移除其中一份。"
L.CLOSE_WINDOW_WHEN_DONE =               "完成後關閉視窗"
L.CLOSE_WINDOW_WHEN_DONE_DESC =          "製作完最後一個追蹤中的配方後，關閉追蹤視窗。"

-- Tracking window
L.CLOSE_WINDOW =                         "關閉視窗"
L.LOCK_WINDOW =                          "鎖定視窗"
L.UNLOCK_WINDOW =                        "解除鎖定視窗"
L.UPDATE_AUCTIONATOR_LIST1 =             "更新 Auctionator 購物清單"
L.UPDATE_AUCTIONATOR_LIST2 =             "開啟拍賣場時，會自動產生購物清單"
L.DOUBLE =                               "雙擊" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "自動調整視窗大小"
L.LINK_RECIPE =                          "連結配方"
L.OPEN_RECIPE =                          "開啟配方"
L.CRAFT_RECIPE =                         "製作此配方"
L.LINK_REAGENT =                         "連結材料"
L.TRACK_RECIPE_SUBREAGENT =              "追蹤用來製作此材料的配方（若有的話）"
L.REMOVE_COOLDOWN_REMINDER =             "移除這個冷卻提醒"

L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.ITEMS =                                ITEMS -- "Items"
L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.COSTS =                                "成本"
L.COOLDOWNS =                            "冷卻時間"
L.CLEAR_CONFIRMATION =                   "這會清除所有配方。"
L.CONFIRMATION =                         "確定要繼續嗎？"
L.SUBREAGENTS1 =                         "有多個配方可以製作 %s" -- %s becomes an item link
L.SUBREAGENTS2 =                         "請選擇下列其中一個："
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
L.MERCHANT_BUY =                         "購買所有追蹤中的材料（若商人有販售）。"

L.READY =                                "已就緒"
L.DAYS =                                 "天"
L.HOURS =                                "小時"
L.MINUTES =                              "分鐘"
L.READY_TO_CRAFT =                       "%s 已可再次製作（角色：%s）" -- %s becomes a recipe name, and character name

L.MORE_NEEDED =                          "還需 %d 個" -- %d becomes a number
L.MADE_WITH =                            "由 %s 製作" -- %s becomes a profession
L.RECIPE_LEARNED =                       "已學會配方"
L.RECIPE_UNLEARNED =                     "尚未學會配方"
L.CRAFTING_COST =                        "製作成本"

-- Profession window
L.TRACK =                                "追蹤"
L.UNTRACK =                              "取消追蹤"
L.RANK =                                 RANK -- "Rank"
L.MILLING_INFORMATION =                  "研磨資訊"
L.THAUMATURGY_INFORMATION =              "奇術資訊"
L.FROM =                                 "來自" -- Preceded by a percentage, followed by an item link
L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
L.SWITCH_AVAILABLE_PETS =                "在可用的寵物之間切換"
L.TRACK_NEW =                            "追蹤新增"
L.CURRENT_SETTING =                      "目前設定："
L.NEW_APPEARANCES =                      "新外觀"
L.NEW_APPEARANCES_AND_SOURCES =          "新外觀與新來源"
L.ADDED_RECIPES =                        "已檢查 %d 個可見配方（%s），共追蹤 %d 個配方。" -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

L.RECHARGED =                            "完全恢復"
L.PROFTOOL_AUTOEQUIP =                   "自動裝備此工具" -- Followed by L.PROFTOOL_FOR
L.PROFTOOL_FOR =                         "用於%s。" -- %s becomes one of the two following phrases
L.PROFTOOL_DEFAULT =                     "一般製作"
L.PROFTOOL_ORDERS =                      "處理訂單"
L.PROFTOOL_DRAG =                        "將工具拖曳到這裡。"
L.PROFTOOL_EQUIP =                       "裝備此工具。"
L.PROFTOOL_REMOVE =                      "移除此工具。"

L.PERKS_UNLOCKED =                       "特長已解鎖"
L.PROFESSION_KNOWLEDGE =                 "知識點數"
L.VENDORS =                              "商人"
L.RENOWN =                               COVENANT_SANCTUM_TAB_RENOWN -- "Renown "
L.WORLD =                                "世界"
L.HIDDEN_PROFESSION_MASTER =             "隱藏的專業大師"
L.WEEKLY =                               WEEKLY -- "Weekly"
L.TREASURE =                             "寶藏"
L.DROP =                                 BATTLE_PET_SOURCE_1 -- "Drop"
L.CATCHUP_KNOWLEDGE =                    "可取得的追趕用知識點數："
L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

L.AUCTION_ADDONS =                       "Auctionator、Oribos Exchange 或 TradeSkillMaster"
L.ORDERS_PRICING_MISSING =               "缺少"
L.ORDERS_PRICING_UPDATE =                "請使用 %s 更新或掃描價格。" -- %s becomes L.AUCTION_ADDONS
L.ORDERS_SET_CRITERIA =                  "設定追蹤訂單的條件。"
L.ORDERS_COST_NEED =                     "成本設定僅在使用以下插件時有效：%s。" -- %s becomes L.AUCTION_ADDONS
L.ORDERS_MAX_COST_KNOWLEDGE =            "每點知識點數的最高成本："
L.ORDERS_MAX_COST_ARTISAN =              "每份工匠貨幣的最高成本：" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "每個獎勵袋的最高成本：" -- This refers to Artisan's Payout bag
L.ORDERS_TRACK_AFTER_RESET =             "追蹤每週重置後出現的訂單"
L.ORDERS_TRACK_CONCENTRATION =           "追蹤會消耗專注的訂單："
L.ORDERS_TRACK_ON =                      "在 %s 上追蹤：" -- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "佇列"
L.ORDERSQUEUE_QUEUED =                   "佇列中的訂單："
L.ORDERSQUEUE_NEXT =                     "下一筆訂單"
L.ORDERSQUEUE_CLAIM =                    "接取訂單"
L.ORDERSQUEUE_CRAFT =                    "製作訂單"
L.ORDERSQUEUE_CRAFTING =                 "製作中..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"
L.ORDERSQUEUE_WARNING_QUEST =            "你尚未接取任務：%s。" -- %s becomes a quest name
L.ORDERSQUEUE_WARNING_REAGENTS =         "你的材料不足以製作所有追蹤中的配方。"

-- Crafting Orders window
L.RECRAFT_TOOLTIP =                      "選擇一件有快取配方的物品即可追蹤。"
L.QUICK_ORDER =                          "快速訂單"
L.QUICKORDER_TOOLTIP1 =                  "立即為指定的接收者建立製作訂單。"
L.QUICKORDER_TOOLTIP2 =                  "使用 %s（全大寫）來建立" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "。" -- "Guild Order", %s becomes "GUILD"
L.QUICKORDER_TOOLTIP3 =                  "使用角色名稱來建立" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "。" -- "Personal Order"
L.QUICKORDER_TOOLTIP4 =                  "接收者會依配方分別儲存。"
L.USE_LOCAL_REAGENTS =                   "使用本地材料"
L.USE_LOCAL_REAGENTS_DESC =              "使用你身上現有的（最低品質）材料。無法自訂要使用哪些材料。"
L.REPEAT_LAST_QUICK_ORDER =              "重複此角色上一次的快速訂單"
L.RECIPIENT =                            "接收者"

L.FALSE =                                "否"
L.TRUE =                                 "是"
L.NO_LAST_QUICK_ORDER_FOUND =            "找不到上一次的快速訂單"
L.ERROR =                                "錯誤："
L.ERROR_CRAFTSIM =                       "無法讀取 CraftSim 的資訊"
L.ERROR_REAGENTS =                       "無法為需要指定材料的物品建立快速訂單"
L.ERROR_WARBANK =                        "無法為存放在戰團銀行的物品建立快速訂單"
L.ERROR_GUILD =                          "不在公會中時，無法建立" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD -- "Guild Order"
L.ERROR_RECIPIENT =                      "指定的接收者無法製作該物品。請輸入有效的接收者名稱"
L.ERROR_MULTISIM =                       "沒有使用任何模擬材料。請只啟用下列支援的插件其中之一："
