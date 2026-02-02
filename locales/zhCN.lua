----------------------------------------
-- Profession Shopping List: zhCN.lua --
----------------------------------------
-- Chinese (Simplified, PRC) localisation
-- Translator(s): cikichen

-- Initialisation
if GetLocale() ~= "zhCN" then return end
local appName, app = ...
local L = app.locales

-- Main window
L.WINDOW_BUTTON_CLOSE =					"关闭窗口"
L.WINDOW_BUTTON_LOCK =					"锁定窗口位置"
L.WINDOW_BUTTON_UNLOCK =				"解锁窗口位置"
L.WINDOW_BUTTON_SETTINGS =				"打开设置"
L.WINDOW_BUTTON_CLEAR =					"清除所有追踪的配方"
-- L.WINDOW_BUTTON_AUCTIONATOR =			"Update the Auctionator shopping list\n" ..
-- 										"The shopping list is automatically generated when opening the Auction House"
L.WINDOW_BUTTON_CORNER =				"双击" .. app.IconLMB .. "|cffFFFFFF：自动调整窗口尺寸|r"

L.WINDOW_HEADER_RECIPES =				PROFESSIONS_RECIPES_TAB	-- "配方"
L.WINDOW_HEADER_ITEMS =					ITEMS	-- "物品"
L.WINDOW_HEADER_REAGENTS =				PROFESSIONS_COLUMN_HEADER_REAGENTS	-- "材料"
L.WINDOW_HEADER_COSTS =					"成本"
L.WINDOW_HEADER_COOLDOWNS =				"冷却时间"

L.WINDOW_TOOLTIP_RECIPES =				"Shift + " .. app.IconLMB .. "|cffFFFFFF：链接配方。|r\n" ..
										"Ctrl + " .. app.IconLMB .. "|cffFFFFFF：打开配方（如果已学会）。|r\n" ..
										"Alt + " .. app.IconLMB .. "|cffFFFFFF：尝试制作该配方。|r\n\n" ..
										app.IconRMB .. "|cffFFFFFF：取消追踪1个该配方。|r\n" ..
										"Ctrl + " .. app.IconRMB .. "|cffFFFFFF：取消追踪全部该配方。|r"
L.WINDOW_TOOLTIP_REAGENTS =				"Shift + " .. app.IconLMB .. "|cffFFFFFF：链接材料。|r\n" ..
										"Ctrl + " .. app.IconLMB .. "|cffFFFFFF：添加该次级材料的配方（如果存在缓存）。|r"
L.WINDOW_TOOLTIP_COOLDOWNS =			"Shift + " .. app.IconRMB .. "|cffFFFFFF：移除该冷却提醒。|r\n" ..
										"Ctrl + " .. app.IconLMB .. "|cffFFFFFF：打开配方（如果已学会）。|r\n" ..
										"Alt + " .. app.IconLMB .. "|cffFFFFFF：尝试制作该配方。|r"

L.CLEAR_CONFIRMATION =					"这将清除所有配方。"
L.CONFIRMATION =						"确定要继续吗？"
L.SUBREAGENTS1 =						"存在多个可制作"	-- 后接物品链接
L.SUBREAGENTS2 =						"请选择以下配方之一"
L.GOLD =								BONUS_ROLL_REWARD_MONEY	-- "金币"
-- L.MERCHANT_BUY = 						"Let " .. app.NameShort .. " buy the tracked " .. L.WINDOW_HEADER_REAGENTS .. " and " .. L.WINDOW_HEADER_COSTS .. "\nyou need from this merchant, if available."

-- Cooldowns
L.RECHARGED =							"已完全恢复"
L.READY =								"准备就绪"
L.DAYS =								"天"
L.HOURS =								"小时"
L.MINUTES =								"分钟"
L.READY_TO_CRAFT =						"的冷却时间已重置，可在角色"	-- 前接配方名称，后接角色名

-- Recipe tracking
L.TRACK =								"追踪"
L.UNTRACK =								"取消追踪"
L.RANK =								RANK	-- "等级"
L.RECRAFT_TOOLTIP =						"选择带有缓存配方的物品进行追踪。\n" ..
										"要缓存配方，请在任何角色上打开对应专业窗口\n或查看普通制造订单中的物品。"
L.QUICKORDER =							"快速订单"
L.QUICKORDER_TOOLTIP =					"|cffFF0000立即|r为指定接收者创建制造订单。\n\n" ..
										"使用|cffFFFFFFGUILD|r（全大写）创建" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "。\n" ..	-- "公会订单"
										"使用角色名创建" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "。\n" ..	-- "个人订单"
										"接收者按配方保存。"
L.LOCALREAGENTS_LABEL =					"使用本地材料"
L.LOCALREAGENTS_TOOLTIP =				"使用（最低品质的）本地材料。|cffFF0000无法|r自定义使用的材料。"
L.QUICKORDER_REPEAT_TOOLTIP =			"重复该角色上次的" .. L.QUICKORDER
L.RECIPIENT =							"接收者"

-- Profession window
L.MILLING_INFO =						"研磨信息"
L.THAUMATURGY_INFO =					"炼金转化信息"
L.FROM =								"来自"	-- 用于材料来源说明

-- L.MILLING_CLASSIC =						"Sapphire Pigment: 25% from Golden Sansam, Dreamfoil, Mountain Silversage, Sorrowmoss, Icecap\n" ..
-- 										"Silvery Pigment: 75% from Golden Sansam, Dreamfoil, Mountain Silversage, Sorrowmoss, Icecap\n\n" ..
-- 										"Ruby Pigment: 25% from Firebloom, Purple Lotus, Arthas' Tears, Sungrass, Blindweed,\n      Ghost Mushroom, Gromsblood\n" ..
-- 										"Violet Pigment: 75% from Firebloom, Purple Lotus, Arthas' Tears, Sungrass, Blindweed,\n      Ghost Mushroom, Gromsblood\n\n" ..
-- 										"Indigo Pigment: 25% from Fadeleaf, Goldthorn, Khadgar's Whisker, Dragon's Teeth\n" ..
-- 										"Emerald Pigment: 75% from Fadeleaf, Goldthorn, Khadgar's Whisker, Dragon's Teeth\n\n" ..
-- 										"Burnt Pigment: 25% from Wild Steelbloom, Grave Moss, Kingsblood, Liferoot\n" ..
-- 										"Golden Pigment: 75% from Wild Steelbloom, Grave Moss, Kingsblood, Liferoot\n\n" ..
-- 										"Verdant Pigment: 25% from Mageroyal, Briarthorn, Swiftthistle, Bruiseweed, Stranglekelp\n" ..
-- 										"Dusky Pigment: 75% from Mageroyal, Briarthorn, Swiftthistle, Bruiseweed, Stranglekelp\n\n" ..
-- 										"Alabaster Pigment: 100% from Peacebloom, Silverleaf, Earthroot"
-- L.MILLING_TBC =							"Ebon Pigment: 25%\n" ..
-- 										"Nether Pigment: 100%"
-- L.MILLING_WOTLK =						"Icy Pigment: 25%\n" ..
-- 										"Azure Pigment: 100%"
-- L.MILLING_CATA =						"Burning Embers: 25%, 50% from Twilight Jasmine, Whiptail\n" ..
-- 										"Ashen Pigment: 100%"
-- L.MILLING_MOP =							"Misty Pigment: 25%, 50% from Fool's Cap\n" ..
-- 										"Shadow Pigment: 100%"
-- L.MILLING_WOD =							"Cerulean Pigment: 100%"
-- L.MILLING_LEGION =						"Sallow Pigment: 10%, 80% from Felwort\n" ..
-- 										"Roseate Pigment: 90%"
-- L.MILLING_BFA =							"Viridescent Pigment: 10%, 30% from Anchor Weed\n" ..
-- 										"Crimson Pigment: 25%\n" ..
-- 										"Ultramarine Pigment: 75%"
-- L.MILLING_SL =							"Tranquil Pigment: Nightshade\n" ..
-- 										"Luminous Pigment: Death Blossom, Rising Glory, Vigil's Torch\n" ..
-- 										"Umbral Pigment: Death's Blossom, Marrowroot, Widowbloom"
-- L.MILLING_DF =							"Blazing Pigment: Saxifrage\n" ..
-- 										"Flourishing Pigment: Writhebark\n" ..
-- 										"Serene Pigment: Bubble Poppy\n" ..
-- 										"Shimmering Pigment: Hochenblume"
-- L.MILLING_TWW =							"Blossom Pigment: Blessing Blossom\n" ..
-- 										"Luredrop Pigment: Luredrop\n" ..
-- 										"Orbinid Pigment: Orbinid\n" ..
-- 										"Nacreous Pigment: Mycobloom"
-- L.THAUMATURGY_TWW =						"Mercurial Transmutagen: Aqirite, Gloom Chitin, Luredrop, Orbinid\n" ..
-- 										"Ominous Transmutagen: Bismuth, Mycobloom, Storm Dust, Weavercloth\n" ..
-- 										"Volatile Transmutagen: Arathor's Spear, Blessing Blossom, Ironclaw Ore, Stormcharged Leather"

-- L.BUTTON_COOKINGFIRE =					app.IconLMB .. ": " .. BINDING_NAME_TARGETSELF .. "\n" ..
-- 										app.IconRMB .. ": " .. STATUS_TEXT_TARGET
-- L.BUTTON_COOKINGPET =					app.IconLMB .. ": Summon this pet\n" ..
-- 										app.IconRMB .. ": Switch between available pets"
-- L.BUTTON_CHEFSHAT =						app.IconLMB .. ": Use the"
-- L.BUTTON_THERMALANVIL =					app.IconLMB .. ": Use a"
-- L.BUTTON_ALVIN =						app.IconLMB .. ": Summon this pet"
-- L.BUTTON_LIGHTFORGE =					app.IconLMB .. ": Cast"

-- Track new mogs
L.BUTTON_TRACKNEW =						"追踪新外观"
L.CURRENT_SETTING =						"当前设置："
L.MODE_APPEARANCES =					"新外观"
L.MODE_SOURCES =						"新外观及来源"
L.TRACK_NEW1 =							"即将扫描"	-- 后接数字
L.TRACK_NEW2 =							"个可见配方中的"	-- 前接数字，后接L.MODE_APPEARANCES或L.MODE_SOURCES
L.TRACK_NEW3 =							"游戏可能会卡顿数秒。"
L.ADDED_RECIPES1 =						"已添加"	-- 后接数字
L.ADDED_RECIPES2 =						"个符合条件的配方"	-- 前接数字

-- Tooltip info
L.MORE_NEEDED =							"个仍需"	-- 前接数字
L.MADE_WITH =							"制造专业："	-- 后接专业名称如"锻造"、"制皮"
L.RECIPE_LEARNED =						"配方已学会"
L.RECIPE_UNLEARNED =					"配方未学会"

-- Profession knowledge
L.PERKS_UNLOCKED =						"特长已解锁"
L.PROFESSION_KNOWLEDGE =				"知识点数"
L.VENDORS =								"供应商"
L.RENOWN =								"名望"
L.WORLD =								"世界"
L.HIDDEN_PROFESSION_MASTER =			"隐藏专业大师"
L.CATCHUP_KNOWLEDGE =					"可用追赶知识："
L.LOADING =								SEARCH_LOADING_TEXT

-- Chat feedback
L.INVALID_PARAMETERS =					"参数无效。"
L.INVALID_RECIPEQUANTITY =				L.INVALID_PARAMETERS .. " 请输入有效的配方数量。"
L.INVALID_RECIPEID =				L.INVALID_PARAMETERS .. " 请输入已缓存的配方ID。"
L.INVALID_RECIPE_TRACKED =				L.INVALID_PARAMETERS .. " 请输入已追踪的配方ID。"
L.INVALID_ACHIEVEMENT =					L.INVALID_PARAMETERS .. " 这不是制造类成就。未添加任何配方。"
L.INVALID_RESET_ARG =					L.INVALID_PARAMETERS .. " 可用参数："
L.INVALID_COMMAND =						"无效指令。输入" .. app:Colour("/psl settings") .. "查看帮助。"
L.DEBUG_ENABLED =						"调试模式已启用。"
L.DEBUG_DISABLED =						"调试模式已禁用。"
L.RESET_DONE =							"数据重置成功。"
L.REQUIRES_RELOAD =						"|cffFF0000需要重新加载界面。|r使用|cffFFFFFF/reload|r或重新登录。"	-- "需要重载界面"

L.FALSE =								"否"
L.TRUE =								"是"
L.NOLASTORDER =							"未找到最近的" .. L.QUICKORDER
L.ERROR =								"错误"
L.ERROR_CRAFTSIM =						"CraftSim数据读取失败。"
L.ERROR_QUICKORDER =					"快速订单失败。"
L.ERROR_REAGENTS =						L.ERROR .. "：无法为需要指定材料的物品创建" .. L.QUICKORDER .. "。"
L.ERROR_WARBANK =						L.ERROR .. "：无法使用战争银行材料创建" .. L.QUICKORDER .. "。"
L.ERROR_GUILD =							L.ERROR .. "：未加入公会时无法创建" .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "。"	-- "公会订单"
L.ERROR_RECIPIENT =						L.ERROR .. "：目标接收者无法制作该物品。请输入有效角色名。"
L.ERROR_MULTISIM =						L.ERROR .. "：未使用模拟材料。请启用以下支持插件之一："

L.VERSION_CHECK =						app.NameLong .. "有新版本可用："

-- Settings
L.SETTINGS_TOOLTIP =					app.NameLong .. "\n|cffFFFFFF" .. app.IconLMB .. ": 切换窗口\n" .. app.IconRMB .. ": " .. L.WINDOW_BUTTON_SETTINGS

-- L.SETTINGS_VERSION =					GAME_VERSION_LABEL .. ":"	-- "Version"
-- L.SETTINGS_SUPPORT_TEXTLONG =			"Developing this addon takes a significant amount of time and effort.\nPlease consider financially supporting the developer."
-- L.SETTINGS_SUPPORT_TEXT =				"Support"
-- L.SETTINGS_SUPPORT_BUTTON =				"Buy Me a Coffee"	-- Brand name, if there isn't a localised version, keep it the way it is
-- L.SETTINGS_SUPPORT_DESC =				"Thank you!"
-- L.SETTINGS_HELP_TEXT =					"Feedback & Help"
-- L.SETTINGS_HELP_BUTTON =				"Discord"	-- Brand name, if there isn't a localised version, keep it the way it is
-- L.SETTINGS_HELP_DESC =					"Join the Discord server."
-- L.SETTINGS_URL_COPY =					"Ctrl+C to copy:"
-- L.SETTINGS_URL_COPIED =					"Link copied to clipboard"

L.SETTINGS_KEYSLASH_TITLE =				SETTINGS_KEYBINDINGS_LABEL .. " & 斜杠命令"	-- "Keybindings"
-- _G["BINDING_NAME_PSL_TOGGLEWINDOW"] =	app.NameShort .. ": Toggle Window"
L.SETTINGS_SLASH_TOGGLE =				"切换追踪窗口"
L.SETTINGS_SLASH_RESETPOS =				"重置窗口位置"
L.SETTINGS_SLASH_RESET =				"重置保存的数据"
L.SETTINGS_SLASH_TRACK =				"追踪配方"
L.SETTINGS_SLASH_UNTRACK =				"取消追踪配方"
L.SETTINGS_SLASH_UNTRACKALL =			"取消追踪全部该配方"
L.SETTINGS_SLASH_TRACKACHIE =			"追踪链接成就所需配方"
L.SETTINGS_SLASH_CRAFTINGACHIE =		"制造成就"
L.SETTINGS_SLASH_RECIPEID =				"配方ID"
L.SETTINGS_SLASH_QUANTITY =				"数量"

-- L.GENERAL =								GENERAL	-- "General"
L.SETTINGS_MINIMAP_TITLE =				"显示小地图图标"
L.SETTINGS_MINIMAP_TOOLTIP =			"显示小地图图标。禁用后仍可通过插件菜单访问。"
L.SETTINGS_COOLDOWNS_TITLE =			"追踪配方冷却"
L.SETTINGS_COOLDOWNS_TOOLTIP =			"启用配方冷却时间追踪。显示在追踪窗口，并在登录时通过聊天提醒就绪冷却。"
L.SETTINGS_COOLDOWNSWINDOW_TITLE =		"冷却就绪时显示窗口"
L.SETTINGS_COOLDOWNSWINDOW_TOOLTIP =	"登录时若有冷却就绪，除聊天提醒外同时打开追踪窗口。"
L.SETTINGS_TOOLTIP_TITLE =				"显示提示信息"
L.SETTINGS_TOOLTIP_TOOLTIP =			"在物品提示中显示拥有/需要的材料数量。"
L.SETTINGS_CRAFTTOOLTIP_TITLE =			"显示制造信息"
L.SETTINGS_CRAFTTOOLTIP_TOOLTIP =		"在装备提示中显示制造专业及配方是否学会。"
L.SETTINGS_REAGENTQUALITY_TITLE =		"最低材料品质"
L.SETTINGS_REAGENTQUALITY_TOOLTIP =		"设置计入物品数量的最低材料品质。CraftSim结果将覆盖此设置。"
L.SETTINGS_INCLUDEHIGHER_TITLE =		"包含更高品质"
L.SETTINGS_INCLUDEHIGHER_TOOLTIP =		"设置追踪低品质材料时包含哪些更高品质材料。（例如是否在统计1级材料时包含3级材料）"
L.SETTINGS_COLLECTMODE_TITLE =			"收集模式"
L.SETTINGS_COLLECTMODE_TOOLTIP =		"设置使用" .. app:Colour(L.BUTTON_TRACKNEW) .. "按钮时包含的物品类型。"
-- L.SETTINGS_ENHANCEDORDERS_TITLE =		"Enhanced Orders"
-- L.SETTINGS_ENHANCEDORDERS_TOOLTIP =	"Enhance the preview of order rewards and commission, and add icons for first crafts, unlearned recipes, and tracked recipes.\n\n" .. L.REQUIRES_RELOAD
L.SETTINGS_QUICKORDER_TITLE =			"快速订单时长"
L.SETTINGS_QUICKORDER_TOOLTIP =			"设置" .. app.NameShort .. "快速订单的持续时间。"

L.SETTINGS_REAGENTTIER =				"等级"	-- 后接数字
L.SETTINGS_INCLUDE =					"包含"	-- 后接"第X级"
L.SETTINGS_ONLY_INCLUDE =				"仅包含"	-- 后接"第X级"
L.SETTINGS_DONT_INCLUDE =				"不包含更高品质"
L.SETTINGS_APPEARANCES_TITLE =			WARDROBE	-- "外观"
L.SETTINGS_APPEARANCES_TEXT =			"仅包含新外观物品。"
L.SETTINGS_SOURCES_TITLE =				"来源"
L.SETTINGS_SOURCES_TEXT =				"包含新来源物品（包括已知外观的新来源）。"
L.SETTINGS_DURATION_SHORT =				"短（12小时）"
L.SETTINGS_DURATION_MEDIUM =			"中（24小时）"
L.SETTINGS_DURATION_LONG =				"长（48小时）"

L.SETTINGS_HEADER_TRACK =				"追踪窗口"
-- L.SETTINGS_HELP_TITLE =					"Show Help Tooltips"
-- L.SETTINGS_HELP_TOOLTIP =				"Display what mouse actions exist when hovering over entries in the tracking window."
L.SETTINGS_PERSONALWINDOWS_TITLE =		"角色独立窗口位置"
L.SETTINGS_PERSONALWINDOWS_TOOLTIP =	"按角色保存窗口位置，而非账号通用。"
L.SETTINGS_PERSONALRECIPES_TITLE =		"角色独立配方追踪"
L.SETTINGS_PERSONALRECIPES_TOOLTIP =	"按角色追踪配方，而非账号通用。"
L.SETTINGS_SHOWREMAINING_TITLE =		"显示剩余材料"
L.SETTINGS_SHOWREMAINING_TOOLTIP =		"在追踪窗口仅显示仍需材料数量，而非拥有/需要。"
L.SETTINGS_REMOVECRAFT_TITLE =			"制作后取消追踪"
L.SETTINGS_REMOVECRAFT_TOOLTIP =		"成功制作后减少1个追踪数量。"
L.SETTINGS_CLOSEWHENDONE_TITLE =		"完成后关闭窗口"
L.SETTINGS_CLOSEWHENDONE_TOOLTIP =		"制作完最后一个追踪配方后关闭窗口。"
