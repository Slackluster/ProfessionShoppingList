----------------------------------------
-- Profession Shopping List: zhCN.lua --
----------------------------------------
-- Chinese (Simplified, PRC) localisation
-- Translator(s): cikichen

if GetLocale() ~= "zhCN" then return end
local appName, app = ...
local L = app.locales

-- Main window
L.WINDOW_BUTTON_CLOSE =                  "关闭窗口"
L.WINDOW_BUTTON_LOCK =                   "锁定窗口位置"
L.WINDOW_BUTTON_UNLOCK =                 "解锁窗口位置"
L.WINDOW_BUTTON_SETTINGS =               "打开设置"
L.WINDOW_BUTTON_CLEAR =                  "清除所有追踪的配方"
L.WINDOW_BUTTON_AUCTIONATOR =            "更新 Auctionator 购物清单\n" ..
                                         "购物清单会在打开拍卖行时自动生成"
L.WINDOW_BUTTON_CORNER =                 "双击" .. app.IconLMB .. "|cffFFFFFF：自动调整窗口尺寸|r"

L.WINDOW_HEADER_RECIPES =                PROFESSIONS_RECIPES_TAB -- "Recipes"
L.WINDOW_HEADER_ITEMS =                  ITEMS -- "Items"
L.WINDOW_HEADER_REAGENTS =               PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.WINDOW_HEADER_COSTS =                  "成本"
L.WINDOW_HEADER_COOLDOWNS =              "冷却时间"

L.WINDOW_TOOLTIP_RECIPES =               "Shift + " .. app.IconLMB .. "|cffFFFFFF：链接配方。|r\n" ..
                                         "Ctrl + " .. app.IconLMB .. "|cffFFFFFF：打开配方（如果已学会）。|r\n" ..
                                         "Alt + " .. app.IconLMB .. "|cffFFFFFF：尝试制作该配方。|r\n\n" ..
                                         app.IconRMB .. "|cffFFFFFF：取消追踪1个该配方。|r\n" ..
                                         "Ctrl + " .. app.IconRMB .. "|cffFFFFFF：取消追踪全部该配方。|r"
L.WINDOW_TOOLTIP_REAGENTS =              "Shift + " .. app.IconLMB .. "|cffFFFFFF：链接材料。|r\n" ..
                                         "Ctrl + " .. app.IconLMB .. "|cffFFFFFF：添加该次级材料的配方（如果存在缓存）。|r"
L.WINDOW_TOOLTIP_COOLDOWNS =             "Shift + " .. app.IconRMB .. "|cffFFFFFF：移除该冷却提醒。|r\n" ..
                                         "Ctrl + " .. app.IconLMB .. "|cffFFFFFF：打开配方（如果已学会）。|r\n" ..
                                         "Alt + " .. app.IconLMB .. "|cffFFFFFF：尝试制作该配方。|r"

L.CLEAR_CONFIRMATION =                   "这将清除所有配方。"
L.CONFIRMATION =                         "确定要继续吗？"
L.SUBREAGENTS1 =                         "存在多个可制作" -- Followed by an item link
L.SUBREAGENTS2 =                         "请选择以下配方之一"
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
L.MERCHANT_BUY =                         "让 " .. app.NameShort .. " 从该商人处购买你需要的已追踪 " .. L.WINDOW_HEADER_REAGENTS .. " 和 " .. L.WINDOW_HEADER_COSTS .. "（如果可用）。"

-- Cooldowns
L.RECHARGED =                            "已完全恢复"
L.READY =                                "准备就绪"
L.DAYS =                                 "天"
L.HOURS =                                "小时"
L.MINUTES =                              "分钟"
L.READY_TO_CRAFT =                       "的冷却时间已重置，可在角色" -- Preceded by a recipe name, followed by a character name

-- Recipe tracking
L.TRACK =                                "追踪"
L.UNTRACK =                              "取消追踪"
L.RANK =                                 RANK -- "Rank"
L.RECRAFT_TOOLTIP =                      "选择带有缓存配方的物品进行追踪。\n" ..
                                         "要缓存配方，请在任何角色上打开对应专业窗口\n或查看普通制造订单中的物品。"
L.QUICKORDER =                           "快速订单"
L.QUICKORDER_TOOLTIP =                   "|cffFF0000立即|r为指定接收者创建制造订单。\n\n" ..
                                         "使用|cffFFFFFFGUILD|r（全大写）创建" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "。\n" .. -- "Guild Order". Don't translate "|cffFFFFFFGUILD|r" as this is hardcoded
                                         "使用角色名创建" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "。\n" .. -- "Personal Order"
                                         "接收者按配方保存。"
L.LOCALREAGENTS_LABEL =                  "使用本地材料"
L.LOCALREAGENTS_TOOLTIP =                "使用（最低品质的）本地材料。|cffFF0000无法|r自定义使用的材料。"
L.QUICKORDER_REPEAT_TOOLTIP =            "重复该角色上次的" .. L.QUICKORDER
L.RECIPIENT =                            "接收者"

-- Profession window
L.MILLING_INFO =                         "研磨信息"
L.THAUMATURGY_INFO =                     "炼金转化信息"
L.FROM =                                 "来自" -- I will convert this whole section to item links, then this is the only localisation needed. I recommend skipping the rest of this section. :)

L.MILLING_CLASSIC =                      "天蓝颜料：25%（黄金参、梦叶草、山鼠草、哀伤苔、冰盖草）\n" ..
                                         "银色颜料：75%（黄金参、梦叶草、山鼠草、哀伤苔、冰盖草）\n\n" ..
                                         "深红颜料：25%（火焰花、紫莲花、太阳草、盲目草、幽灵菇、阿尔萨斯之泪、格罗姆之血）\n" ..
                                         "紫色颜料：75%（火焰花、紫莲花、太阳草、盲目草、幽灵菇、阿尔萨斯之泪、格罗姆之血）\n\n" ..
                                         "深紫颜料：25%（枯叶草、金棘草、龙齿草、卡德加的胡须）\n" ..
                                         "翡翠颜料：75%（枯叶草、金棘草、龙齿草、卡德加的胡须）\n\n" ..
                                         "褐色颜料：25%（野钢花、墓地苔、皇血草、活根草）\n" ..
                                         "金色颜料：75%（野钢花、墓地苔、皇血草、活根草）\n\n" ..
                                         "翠绿颜料：25%（魔皇草、石南草、雨燕草、跌打草、荆棘藻）\n" ..
                                         "暗色颜料：75%（魔皇草、石南草、雨燕草、跌打草、荆棘藻）\n\n" ..
                                         "雪白颜料：100%（宁神花、银叶草、地根草）"
L.MILLING_TBC =                          "乌青颜料：25%\n" ..
                                         "虚空颜料：100%"
L.MILLING_WOTLK =                        "淡白颜料：25%\n" ..
                                         "碧蓝颜料：100%"
L.MILLING_CATA =                         "燃烧的余烬：25%，50%（暮光茉莉、鞭尾草）\n" ..
                                         "烬色颜料：100%"
L.MILLING_MOP =                          "雾色颜料：25%，50%（愚人菇）\n" ..
                                         "影色颜料：100%"
L.MILLING_WOD =                          "蔚蓝颜料：100%"
L.MILLING_LEGION =                       "蜡黄颜料：10%，80%（邪能球茎）\n" ..
                                         "玫红颜料：90%"
L.MILLING_BFA =                          "淡绿颜料：10%，30%（锚草）\n" ..
                                         "赤红颜料：25%\n" ..
                                         "群青颜料：75%"
L.MILLING_SL =                           "静谧颜料：夜影花\n" ..
                                         "辉光颜料：绽亡花, 晋荣花, 慰魂之光\n" ..
                                         "幽影颜料：绽亡花, 髓根草, 孀花"
L.MILLING_DF =                           "灼火颜料：虎耳草\n" ..
                                         "繁盛颜料：歪扭树皮\n" ..
                                         "安详颜料：泡粟花\n" ..
                                         "闪光颜料：霍亨布墨花"
L.MILLING_TWW =                          "棠花颜料：圣祝棠\n" ..
                                         "惑露颜料：惑露堇\n" ..
                                         "球首颜料：球首兰\n" ..
                                         "珍珠颜料：菌丝花"
L.THAUMATURGY_TWW =                      "顺滑转化剂: 亚基矿、惑露堇、球首兰、掠幽几丁质\n" ..
                                         "不祥转化剂: 铋矿、菌丝花、风暴之尘、梭绸布\n" ..
                                         "动燃转化剂: 镔爪矿、阿拉索之矛、圣祝棠、注雷之革"

L.BUTTON_COOKINGFIRE =                   app.IconLMB .. ": " .. BINDING_NAME_TARGETSELF .. "\n" .. -- "Target Self"
                                         app.IconRMB .. ": " .. STATUS_TEXT_TARGET -- "Target"
L.BUTTON_COOKINGPET =                    app.IconLMB .. ": 召唤此宠物\n" ..
                                         app.IconRMB .. ": 在可用宠物间切换"
L.BUTTON_CHEFSHAT =                      app.IconLMB .. ": 使用"
L.BUTTON_THERMALANVIL =                  app.IconLMB .. ": 使用一个"
L.BUTTON_ALVIN =                         app.IconLMB .. ": 召唤此宠物"
L.BUTTON_LIGHTFORGE =                    app.IconLMB .. ": 施放"

-- Track new mogs
L.BUTTON_TRACKNEW =                      "追踪新外观"
L.CURRENT_SETTING =                      "当前设置："
L.MODE_APPEARANCES =                     "新外观"
L.MODE_SOURCES =                         "新外观及来源"
L.TRACK_NEW1 =                           "即将扫描" -- Followed by a number
L.TRACK_NEW2 =                           "个可见配方中的" -- Preceded by a number, followed by L.MODE_APPEARANCES or L.MODE_SOURCES
L.TRACK_NEW3 =                           "游戏可能会卡顿数秒。"
L.ADDED_RECIPES1 =                       "已添加" -- Followed by a number
L.ADDED_RECIPES2 =                       "个符合条件的配方" -- Preceded by a number

-- Tooltip info
L.MORE_NEEDED =                          "个仍需" -- Preceded by a number
L.MADE_WITH =                            "制造专业：" -- Followed by a profession name such as "Blacksmithing" or "Leatherworking"
L.RECIPE_LEARNED =                       "配方已学会"
L.RECIPE_UNLEARNED =                     "配方未学会"

-- Profession knowledge
L.PERKS_UNLOCKED =                       "特长已解锁"
L.PROFESSION_KNOWLEDGE =                 "知识点数"
L.VENDORS =                              "供应商"
L.RENOWN =                               "名望"
L.WORLD =                                "世界"
L.HIDDEN_PROFESSION_MASTER =             "隐藏专业大师"
L.CATCHUP_KNOWLEDGE =                    "可用追赶知识："
L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

-- Order adjustments
L.ORDERS_SCAN_NEEDED =                   "需要扫描"
L.ORDERS_DO_SCAN =                       "使用 Auctionator 进行完整扫描以计算利润。"
L.ORDERS_SET_CRITERIA =                  "设置追踪订单的标准。"
L.ORDERS_COST_NEED =                     "成本设置仅在启用 Auctionator 时有效。"
L.ORDERS_MAX_COST_KNOWLEDGE =            "每个知识点的最大成本："
L.ORDERS_MAX_COST_ARTISAN =              "每份工匠货币的最大成本：" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "每个奖励袋的最大成本：" -- This refers to Artisan's Payout bag
-- L.ORDERS_TRACK_AFTER_RESET =             "Track orders available after weekly reset"
L.ORDERS_TRACK_CONCENTRATION =           "追踪消耗专注度的订单："
-- L.ORDERS_TRACK_ON =                      "Track on %s:"  -- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "队列"
L.ORDERSQUEUE_QUEUE =                    "队列中的订单："
L.ORDERSQUEUE_NEXT =                     "下一个订单"
L.ORDERSQUEUE_CLAIM =                    "开始接单"
L.ORDERSQUEUE_CRAFT =                    "制作订单"
L.ORDERSQUEUE_CRAFTING =                 "制作中..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"

-- Chat feedback
L.INVALID_PARAMETERS =                   "参数无效。"
L.INVALID_RECIPEQUANTITY =               L.INVALID_PARAMETERS .. " 请输入有效的配方数量。"
L.INVALID_RECIPEID =                     L.INVALID_PARAMETERS .. " 请输入已缓存的配方ID。"
L.INVALID_RECIPE_TRACKED =               L.INVALID_PARAMETERS .. " 请输入已追踪的配方ID。"
L.INVALID_ACHIEVEMENT =                  L.INVALID_PARAMETERS .. " 这不是制造类成就。未添加任何配方。"
L.INVALID_RESET_ARG =                    L.INVALID_PARAMETERS .. " 可用参数："
L.INVALID_COMMAND =                      "无效指令。输入" .. app:Colour("/psl settings") .. "查看帮助。"
L.DEBUG_ENABLED =                        "调试模式已启用。"
L.DEBUG_DISABLED =                       "调试模式已禁用。"
L.RESET_DONE =                           "数据重置成功。"
L.REQUIRES_RELOAD =                      "|cffFF0000需要重新加载界面。|r使用|cffFFFFFF/reload|r或重新登录。" -- "Requires Reload"

L.FALSE =                                "否"
L.TRUE =                                 "是"
L.NOLASTORDER =                          "未找到最近的" .. L.QUICKORDER
L.ERROR =                                "错误"
L.ERROR_CRAFTSIM =                       "CraftSim数据读取失败。"
L.ERROR_QUICKORDER =                     "快速订单失败。"
L.ERROR_REAGENTS =                       L.ERROR .. "：无法为需要指定材料的物品创建" .. L.QUICKORDER .. "。"
L.ERROR_WARBANK =                        L.ERROR .. "：无法使用战争银行材料创建" .. L.QUICKORDER .. "。"
L.ERROR_GUILD =                          L.ERROR .. "：未加入公会时无法创建" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "。" -- "Guild Order"
L.ERROR_RECIPIENT =                      L.ERROR .. "：目标接收者无法制作该物品。请输入有效角色名。"
L.ERROR_MULTISIM =                       L.ERROR .. "：未使用模拟材料。请启用以下支持插件之一："

L.NEW_VERSION_AVAILABLE =                app.NameLong .. "有新版本可用："

-- Settings
L.SETTINGS_TOOLTIP =                     app.NameLong .. "\n|cffFFFFFF" ..
                                         app.IconLMB .. ": 切换窗口\n" ..
                                         app.IconRMB .. ": " .. L.WINDOW_BUTTON_SETTINGS

L.SETTINGS_VERSION =                     GAME_VERSION_LABEL .. ":" -- "Version"
L.SETTINGS_SUPPORT_TEXTLONG =            "开发这个插件需要大量的时间和精力。\n请考虑在经济上支持开发者。"
L.SETTINGS_SUPPORT_TEXT =                "支持"
L.SETTINGS_SUPPORT_BUTTON =              "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC =                "谢谢！"
L.SETTINGS_HELP_TEXT =                   "反馈与帮助"
L.SETTINGS_HELP_BUTTON =                 "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC =                   "加入 Discord 服务器。"
L.SETTINGS_URL_COPY =                    "按 Ctrl+C 复制："
L.SETTINGS_URL_COPIED =                  "链接已复制到剪贴板"

L.SETTINGS_KEYSLASH_TITLE =              SETTINGS_KEYBINDINGS_LABEL .. " & 斜杠命令" -- "Keybindings"
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. ": 切换窗口"
L.SETTINGS_SLASH_TOGGLE =                "切换追踪窗口"
L.SETTINGS_SLASH_RESETPOS =              "重置窗口位置"
L.SETTINGS_SLASH_RESET =                 "重置保存的数据"
L.SETTINGS_SLASH_TRACK =                 "追踪配方"
L.SETTINGS_SLASH_UNTRACK =               "取消追踪配方"
L.SETTINGS_SLASH_UNTRACKALL =            "取消追踪全部该配方"
L.SETTINGS_SLASH_TRACKACHIE =            "追踪链接成就所需配方"
L.SETTINGS_SLASH_CRAFTINGACHIE =         "制造成就"
L.SETTINGS_SLASH_RECIPEID =              "配方ID"
L.SETTINGS_SLASH_QUANTITY =              "数量"

L.GENERAL =                              GENERAL -- "General"
L.SETTINGS_MINIMAP_TITLE =               "显示小地图图标"
L.SETTINGS_MINIMAP_DESC =                "显示小地图图标。禁用后仍可通过插件菜单访问。"
L.SETTINGS_COOLDOWNS_TITLE =             "追踪配方冷却"
L.SETTINGS_COOLDOWNS_DESC =              "启用配方冷却时间追踪。显示在追踪窗口，并在登录时通过聊天提醒就绪冷却。"
L.SETTINGS_COOLDOWNSWINDOW_TITLE =       "冷却就绪时显示窗口"
L.SETTINGS_COOLDOWNSWINDOW_DESC =        "登录时若有冷却就绪，除聊天提醒外同时打开追踪窗口。"
L.SETTINGS_TOOLTIP_TITLE =               "显示提示信息"
L.SETTINGS_TOOLTIP_DESC =                "在物品提示中显示拥有/需要的材料数量。"
L.SETTINGS_CRAFTTOOLTIP_TITLE =          "显示制造信息"
L.SETTINGS_CRAFTTOOLTIP_DESC =           "在装备提示中显示制造专业及配方是否学会。"
L.SETTINGS_REAGENTQUALITY_TITLE =        "最低材料品质"
L.SETTINGS_REAGENTQUALITY_DESC =         "设置材料所需的最低品质，" .. app.NameShort .. "才会将其计入物品数量统计。模拟结果仍会覆盖此设置。"
L.SETTINGS_INCLUDEHIGHER_TITLE =         "包含更高品质"
L.SETTINGS_INCLUDEHIGHER_DESC =          "是否统计高品质材料。（例如：在统计1级材料时包含拥有的2级材料。）"
L.SETTINGS_COLLECTMODE_TITLE =           "收集模式"
L.SETTINGS_COLLECTMODE_DESC =            "设置使用" .. app:Colour(L.BUTTON_TRACKNEW) .. "按钮时包含的物品类型。"
L.SETTINGS_SPENDTOPERK_TITLE =           "花费至下一专精"
L.SETTINGS_SPENDTOPERK_DESC =            "Shift+点击专业技能知识节点时，自动花费技能点直至获得下一个专精效果。"
L.SETTINGS_ENHANCEDORDERS_TITLE =        "增强订单"
L.SETTINGS_ENHANCEDORDERS_DESC =         "增强订单奖励和委托的预览效果，并添加首次制造图标、未学习配方图标和追踪配方图标。\n\n" .. L.REQUIRES_RELOAD
L.SETTINGS_QUICKORDER_TITLE =            "快速订单时长"
L.SETTINGS_QUICKORDER_DESC =             "设置" .. app.NameShort .. "快速订单的持续时间。"

L.LOW =                                  LOW -- "Low"
L.HIGH =                                 HIGH -- "High"
L.SETTINGS_INCLUDE =                     "包含更高品质"
L.SETTINGS_DONT_INCLUDE =                "不包含更高品质"
L.SETTINGS_APPEARANCES_TITLE =           WARDROBE -- "Appearances"
L.SETTINGS_APPEARANCES_TEXT =            "仅包含新外观物品。"
L.SETTINGS_SOURCES_TITLE =               "来源"
L.SETTINGS_SOURCES_TEXT =                "包含新来源物品（包括已知外观的新来源）。"
L.SETTINGS_DURATION_SHORT =              "短（12小时）"
L.SETTINGS_DURATION_MEDIUM =             "中（24小时）"
L.SETTINGS_DURATION_LONG =               "长（48小时）"

L.SETTINGS_HEADER_TRACK =                "追踪窗口"
L.SETTINGS_HELPTOOLTIP_TITLE =           "显示帮助提示"
L.SETTINGS_HELPTOOLTIP_DESC =            "在跟踪窗口中悬停条目时显示存在的鼠标操作说明。"
L.SETTINGS_PERSONALWINDOWS_TITLE =       "角色独立窗口位置"
L.SETTINGS_PERSONALWINDOWS_DESC =        "按角色保存窗口位置，而非账号通用。"
L.SETTINGS_PERSONALRECIPES_TITLE =       "角色独立配方追踪"
L.SETTINGS_PERSONALRECIPES_DESC =        "按角色追踪配方，而非账号通用。"
L.SETTINGS_SHOWREMAINING_TITLE =         "显示剩余材料"
L.SETTINGS_SHOWREMAINING_DESC =          "在追踪窗口仅显示仍需材料数量，而非拥有/需要。"
L.SETTINGS_REMOVECRAFT_TITLE =           "制作后取消追踪"
L.SETTINGS_REMOVECRAFT_DESC =            "成功制作后减少1个追踪数量。"
L.SETTINGS_CLOSEWHENDONE_TITLE =         "完成后关闭窗口"
L.SETTINGS_CLOSEWHENDONE_DESC =          "制作完最后一个追踪配方后关闭窗口。"
