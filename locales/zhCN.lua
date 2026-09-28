----------------------------------------
-- Profession Shopping List: zhCN.lua --
----------------------------------------
-- Chinese (Simplified, PRC) localisation
-- Translator(s): cikichen

if GetLocale() ~= "zhCN" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "%s 有新版本可用：" -- %s becomes the addon name

L.RESET_DONE =                           "数据重置成功。"
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.DEBUG_ENABLED =                        "调试模式已启用"
L.DEBUG_DISABLED =                       "调试模式已禁用"
L.INVALID_PARAMETERS =                   "参数无效"
L.INVALID_COMMAND =                      "无效指令"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. "：" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "开发这个插件需要大量的时间和精力。"
L.SUPPORT_TEXTLONG2 =                    "请考虑在经济上支持开发者。"
L.SUPPORT =                              "支持"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "谢谢！"
L.FEEDBACK_AND_HELP =                    "反馈与帮助"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "加入 Discord 服务器。"
L.CTRL_C_COPY =                          "按 Ctrl+C 复制："
L.LINK_COPIED =                          "链接已复制到剪贴板"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & 斜杠命令" -- "Keybindings"
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. "： 切换窗口"
L.TOGGLE_TRACKING_WINDOW =               "切换追踪窗口"
L.RESET_WINDOW_POSITION =                "重置窗口位置"
L.RESET_SAVED_DATA =                     "重置保存的数据"
L.OPEN_SETTINGS =                        "打开设置"
L.CLEAR_TRACKED_RECIPES =                "清除所有追踪的配方"
L.RECIPEID =                             "配方ID"
L.QUANTITY =                             "数量"
L.TRACK_RECIPE =                         "追踪配方"
L.UNTRACK_RECIPE =                       "取消追踪配方"
L.UNTRACK_RECIPE_ALL =                   "取消追踪全部该配方"
L.CRAFTING_ACHIEVEMENT =                 "制造成就"
L.TRACK_ACHIEVEMENT_RECIPES =            "追踪链接成就所需配方"
L.ITEMLINK_OR_ITEMID =                   "物品链接或物品ID"
L.TRACK_REAGENT_RECIPES =                "追踪所有使用此材料的配方"

L.GENERAL =                              GENERAL -- "General"
L.SHOW_MINIMAP_ICON =                    "显示小地图图标"
L.SHOW_MINIMAP_ICON_DESC =               "显示小地图图标。禁用后仍可通过插件菜单访问。" -- %s becomes the addon name
L.TRACK_RECIPE_COOLDOWNS =               "追踪配方冷却"
L.TRACK_RECIPE_COOLDOWNS_DESC =          "启用配方冷却时间追踪。显示在追踪窗口，并在登录时通过聊天提醒就绪冷却。"
L.SHOW_WINDOW_WHEN_READY =               "冷却就绪时显示窗口"
L.SHOW_WINDOW_WHEN_READY_DESC =          "登录时若有冷却就绪，除聊天提醒外同时打开追踪窗口。"
L.SHOW_TOOLTIP_INFORMATION =             "显示提示信息"
L.SHOW_TOOLTIP_INFORMATION_DESC =        "在物品提示中显示拥有/需要的材料数量。"
L.SHOW_CRAFTING_INFORMATION =            "显示制造信息"
L.SHOW_CRAFTING_INFORMATION_DESC =       "在装备提示中显示制造专业及配方是否学会。"
L.SHOW_CRAFTING_COST =                   "显示制造成本"
L.SHOW_CRAFTING_COST_DESC =              "若信息可用，则在提示中显示物品的制造成本。"
L.MINIMUM_REAGENT_QUALITY =              "最低材料品质"
-- L.MINIMUM_REAGENT_QUALITY_DESC =         "Set the minimum quality reagents need to be before they are counted. Simulated results will still override this."
L.LOW =                                  LOW -- "低"
L.HIGH =                                 HIGH -- "高"
L.INCLUDE_HIGHER_QUALITY =               "包含更高品质"
L.INCLUDE_HIGHER_QUALITY_DESC =          "是否统计高品质材料。（例如：在统计1级材料时包含拥有的2级材料。）"
L.INCLUDE_HIGHER_QUALITIES_YES =         "包含更高品质"
L.INCLUDE_HIGHER_QUALITIES_NO =          "不包含更高品质"
L.COLLECTION_MODE =                      "收集模式"
L.COLLECTION_MODE_DESC =                 "设置使用%s按钮时包含的物品类型。" -- %s becomes "Track New"
L.APPEARANCES =                          WARDROBE -- "外观"
L.APPEARANCES_SETTING_DESC =             "仅包含新外观物品。"
L.APPEARANCES_SOURCES =                  "来源"
L.APPEARANCES_SOURCES_SETTING_DESC =     "包含新来源物品（包括已知外观的新来源）。"

L.PROFESSION_WINDOW =                    "专业窗口"
L.FILTER_OPTIONAL_REAGENTS =             "过滤可选材料"
L.FILTER_OPTIONAL_REAGENTS_DESC =        "当「可选材料」勾选 %s 时，隐藏可组合的物品。" -- %s becomes "Hide Unavailable"
L.SPEND_TO_NEXT_PERK =                   "花费至下一专精"
L.SPEND_TO_NEXT_PERK_DESC =              "Shift+点击专业技能知识节点时，自动花费技能点直至获得下一个专精效果。"
L.ENHANCED_ORDERS =                      "增强订单"
L.ENHANCED_ORDERS_DESC =                 "增强订单奖励和委托的预览效果，并添加首次制造图标、未学习配方图标和追踪配方图标。"
L.QUICK_ORDER_DURATION =                 "快速订单时长"
-- L.QUICK_ORDER_DURATION_DESC =            "Set the duration for placing quick orders."
-- L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
-- L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
-- L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

L.TRACKING_WINDOW =                      "追踪窗口"
L.SHOW_HELP_TOOLTIPS =                   "显示帮助提示"
L.SHOW_HELP_TOOLTIPS_DESC =              "在跟踪窗口中悬停条目时显示存在的鼠标操作说明。"
L.WINDOW_POSITION_PER_CHAR =             "角色独立窗口位置"
L.WINDOW_POSITION_PER_CHAR_DESC =        "按角色保存窗口位置，而非账号通用。"
L.TRACK_RECIPES_PER_CHAR =               "角色独立配方追踪"
L.TRACK_RECIPES_PER_CHAR_DESC =          "按角色追踪配方，而非账号通用。"
L.SHOW_REMAINING_REAGENTS =              "显示剩余材料"
L.SHOW_REMAINING_REAGENTS_DESC =         "在追踪窗口仅显示仍需材料数量，而非拥有/需要。"
L.UNTRACK_ON_CRAFT =                     "制作后取消追踪"
L.UNTRACK_ON_CRAFT_DESC =                "成功制作后减少1个追踪数量。"
L.CLOSE_WINDOW_WHEN_DONE =               "完成后关闭窗口"
L.CLOSE_WINDOW_WHEN_DONE_DESC =          "制作完最后一个追踪配方后关闭窗口。"

-- Tracking window
L.CLOSE_WINDOW =                         "关闭窗口"
L.LOCK_WINDOW =                          "锁定窗口位置"
L.UNLOCK_WINDOW =                        "解锁窗口位置"
L.UPDATE_AUCTIONATOR_LIST1 =             "更新 Auctionator 购物清单"
L.UPDATE_AUCTIONATOR_LIST2 =             "购物清单会在打开拍卖行时自动生成"
L.DOUBLE =                               "双击" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "自动调整窗口尺寸"
L.LINK_RECIPE =                          "链接配方"
L.OPEN_RECIPE =                          "打开配方"
-- L.CRAFT_RECIPE =                         "Craft this recipe"
L.LINK_REAGENT =                         "链接材料"
-- L.TRACK_RECIPE_SUBREAGENT =              "Track the recipe to craft this reagent, if one exists"
L.REMOVE_COOLDOWN_REMINDER =             "移除该冷却提醒"

L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.ITEMS =                                ITEMS -- "Items"
L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.COSTS =                                "成本"
L.COOLDOWNS =                            "冷却时间"
L.CLEAR_CONFIRMATION =                   "这将清除所有配方。"
L.CONFIRMATION =                         "确定要继续吗？"
L.SUBREAGENTS1 =                         "存在多个可制作 %s" -- %s becomes an item link
L.SUBREAGENTS2 =                         "请选择以下配方之一："
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
-- L.MERCHANT_BUY =                         "Buy all tracked reagents, if available."

L.READY =                                "准备就绪"
L.DAYS =                                 "天"
L.HOURS =                                "小时"
L.MINUTES =                              "分钟"
L.READY_TO_CRAFT =                       "%s 的冷却时间已重置，可在角色 %s" -- %s becomes a recipe name, and character name

L.MORE_NEEDED =                          "%d个仍需" -- %d becomes a number
L.MADE_WITH =                            "制造专业：%s" -- %s becomes a profession
L.RECIPE_LEARNED =                       "配方已学会"
L.RECIPE_UNLEARNED =                     "配方未学会"
L.CRAFTING_COST =                        "制造成本"

-- Profession window
L.TRACK =                                "追踪"
L.UNTRACK =                              "取消追踪"
L.RANK =                                 RANK -- "Rank"
L.MILLING_INFORMATION =                  "研磨信息"
L.THAUMATURGY_INFORMATION =              "炼金转化信息"
L.FROM =                                 "来自" -- Preceded by a percentage, followed by an item link
L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
L.SWITCH_AVAILABLE_PETS =                "在可用宠物间切换"
-- L.TRACK_NEW =                            "Track New"
L.CURRENT_SETTING =                      "当前设置："
L.NEW_APPEARANCES =                      "新外观"
L.NEW_APPEARANCES_AND_SOURCES =          "新外观及来源"
L.ADDED_RECIPES =                        "已检查 %s 的 %d 个可见配方，追踪了 %d 个配方。" -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

L.RECHARGED =                            "已完全恢复"
L.PROFTOOL_AUTOEQUIP =                   "自动装备此工具" -- Followed by L.PROFTOOL_FOR
L.PROFTOOL_FOR =                         "用于 %s。" -- %s becomes one of the two following phrases
L.PROFTOOL_DEFAULT =                     "常规制造"
L.PROFTOOL_ORDERS =                      "处理订单"
L.PROFTOOL_DRAG =                        "将工具拖拽至此处。"
L.PROFTOOL_EQUIP =                       "装备此工具。"
L.PROFTOOL_REMOVE =                      "移除此工具。"

L.PERKS_UNLOCKED =                       "特长已解锁"
L.PROFESSION_KNOWLEDGE =                 "知识点数"
L.VENDORS =                              "供应商"
L.RENOWN =                               "名望"
L.WORLD =                                "世界"
L.HIDDEN_PROFESSION_MASTER =             "隐藏专业大师"
L.WEEKLY =                               WEEKLY -- "每周"
L.TREASURE =                             "宝藏"
L.DROP =                                 BATTLE_PET_SOURCE_1 -- "掉落"
L.CATCHUP_KNOWLEDGE =                    "可用追赶知识："
L.LOADING =                              SEARCH_LOADING_TEXT -- "加载中..."

L.AUCTION_ADDONS =                       "Auctionator、Oribos Exchange 或 TradeSkillMaster"
L.ORDERS_PRICING_MISSING =               "缺失"
L.ORDERS_PRICING_UPDATE =                "请使用 %s 更新或扫描价格。" -- %s becomes a list of addon names
L.ORDERS_SET_CRITERIA =                  "设置追踪订单的标准。"
L.ORDERS_COST_NEED =                     "成本设置仅在使用以下插件时生效：%s。" -- %s becomes a list of addon names
L.ORDERS_MAX_COST_KNOWLEDGE =            "每个知识点的最大成本："
L.ORDERS_MAX_COST_ARTISAN =              "每份工匠货币的最大成本：" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "每个奖励袋的最大成本：" -- This refers to Artisan's Payout bag
L.ORDERS_TRACK_AFTER_RESET =             "追踪每周重置后可用的订单"
L.ORDERS_TRACK_CONCENTRATION =           "追踪消耗专注度的订单："
L.ORDERS_TRACK_ON =                      "在 %s 上追踪："  -- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "队列"
L.ORDERSQUEUE_QUEUE =                    "队列中的订单："
L.ORDERSQUEUE_NEXT =                     "下一个订单"
L.ORDERSQUEUE_CLAIM =                    "开始接单"
L.ORDERSQUEUE_CRAFT =                    "制作订单"
L.ORDERSQUEUE_CRAFTING =                 "制作中..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "完成订单"
L.ORDERSQUEUE_WARNING_QUEST =            "你尚未接取任务：%s。" -- %s becomes a quest name
L.ORDERSQUEUE_WARNING_REAGENTS =         "你的材料不足以完成所有已追踪的配方。"

-- Crafting Orders window
L.RECRAFT_TOOLTIP =                      "选择带有缓存配方的物品进行追踪。"
L.QUICK_ORDER =                          "快速订单"
L.QUICKORDER_TOOLTIP1 =                  "立即为指定接收者创建制造订单。"
L.QUICKORDER_TOOLTIP2 =                  "使用%s（全大写）创建" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "。" -- "Guild Order", %s becomes "GUILD"
L.QUICKORDER_TOOLTIP3 =                  "使用角色名创建" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "。" -- "Personal Order"
L.QUICKORDER_TOOLTIP4 =                  "接收者按配方保存。"
L.USE_LOCAL_REAGENTS =                   "使用本地材料"
L.USE_LOCAL_REAGENTS_DESC =              "使用（最低品质的）本地材料。无法自定义使用的材料。"
L.REPEAT_LAST_QUICK_ORDER =              "重复该角色上次的快速订单"
L.RECIPIENT =                            "接收者"

L.FALSE =                                "否"
L.TRUE =                                 "是"
L.NO_LAST_QUICK_ORDER_FOUND =            "未找到最近的快速订单"
L.ERROR =                                "错误："
L.ERROR_CRAFTSIM =                       "CraftSim数据读取失败"
L.ERROR_REAGENTS =                       "无法为需要指定材料的物品创建快速订单"
L.ERROR_WARBANK =                        "无法使用战争银行材料创建快速订单"
L.ERROR_GUILD =                          "未加入公会时无法创建" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD -- "Guild Order"
L.ERROR_RECIPIENT =                      "目标接收者无法制作该物品。请输入有效角色名"
L.ERROR_MULTISIM =                       "未使用模拟材料。请启用以下支持插件之一："
