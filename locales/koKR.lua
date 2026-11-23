----------------------------------------
-- Profession Shopping List: koKR.lua --
----------------------------------------
-- Korean (Korea) localisation
-- Translator(s):

if GetLocale() ~= "koKR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "%s의 새 버전이 출시되었습니다:" -- %s becomes the addon name

L.RESET_DONE =                           "데이터가 초기화되었습니다."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.DEBUG_ENABLED =                        "디버그 모드 활성화"
L.DEBUG_DISABLED =                       "디버그 모드 비활성화"
L.INVALID_PARAMETERS =                   "잘못된 매개변수"
L.INVALID_COMMAND =                      "잘못된 명령어"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "이 애드온을 개발하는 데에는 많은 시간과 노력이 필요합니다."
L.SUPPORT_TEXTLONG2 =                    "개발자를 금전적으로 후원하는 것을 고려해 주세요."
L.SUPPORT =                              "후원"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "감사합니다!"
L.FEEDBACK_AND_HELP =                    "피드백 및 도움말"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Discord 서버에 참여하세요."
L.CTRL_C_COPY =                          "Ctrl+C를 눌러 복사:"
L.LINK_COPIED =                          "링크를 클립보드에 복사했습니다"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " 및 슬래시 명령어" -- "Keybindings"
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. ": 창 열기/닫기"
L.ORDERS_QUEUE =                         "주문 대기열"
L.TOGGLE_TRACKING_WINDOW =               "추적 창 열기/닫기"
L.RESET_WINDOW_POSITION =                "추적 창 위치 초기화"
L.RESET_SAVED_DATA =                     "저장된 데이터 초기화"
L.OPEN_SETTINGS =                        "설정 열기"
L.CLEAR_TRACKED_RECIPES =                "추적 중인 제조법 모두 지우기"
L.RECIPEID =                             "recipeID"
L.QUANTITY =                             "수량"
L.TRACK_RECIPE =                         "제조법 추적"
L.UNTRACK_RECIPE =                       "제조법 추적 해제"
L.UNTRACK_RECIPE_ALL =                   "해당 제조법 전체 추적 해제"
L.CRAFTING_ACHIEVEMENT =                 "제작 업적"
L.TRACK_ACHIEVEMENT_RECIPES =            "링크된 업적에 필요한 제조법 추적"
L.ITEMLINK_OR_ITEMID =                   "itemLink 또는 itemID"
L.TRACK_REAGENT_RECIPES =                "이 재료를 사용하는 모든 제조법 추적"

L.GENERAL =                              GENERAL -- "General"
L.SHOW_MINIMAP_ICON =                    "미니맵 아이콘 표시"
L.SHOW_MINIMAP_ICON_DESC =               "미니맵 아이콘을 표시합니다. 비활성화해도 애드온 메뉴에서 %s을(를) 사용할 수 있습니다." -- %s becomes the addon name
L.SHOW_TAB =                             "탭 표시"
L.SHOW_TAB_DESC =                        "전문 기술 창과 경매장 창에 %s 탭을 표시합니다." -- %s becomes the addon name
L.TRACK_RECIPE_COOLDOWNS =               "제조법 재사용 대기시간 추적"
L.TRACK_RECIPE_COOLDOWNS_DESC =          "제조법 재사용 대기시간 추적을 활성화합니다. 추적 창에 표시되며, 준비된 경우 로그인 시 채팅으로도 알려줍니다."
L.SHOW_WINDOW_WHEN_READY =               "준비 완료 시 창 표시"
L.SHOW_WINDOW_WHEN_READY_DESC =          "재사용 대기시간이 완료된 경우 로그인 시 채팅 알림과 함께 추적 창을 엽니다."
L.SHOW_TOOLTIP_INFORMATION =             "툴팁 정보 표시"
L.SHOW_TOOLTIP_INFORMATION_DESC =        "아이템 툴팁에 해당 재료의 보유량과 필요량을 표시합니다."
L.SHOW_CRAFTING_INFORMATION =            "제작 정보 표시"
L.SHOW_CRAFTING_INFORMATION_DESC =       "장비 제작에 사용되는 전문 기술과 계정에서 제조법을 배웠는지 표시합니다."
L.SHOW_CRAFTING_COST =                   "제작 비용 표시"
L.SHOW_CRAFTING_COST_DESC =              "정보가 있다면 아이템 제작 비용을 표시합니다."
L.MINIMUM_REAGENT_QUALITY =              "최소 재료 품질"
L.MINIMUM_REAGENT_QUALITY_DESC =         "재료 수량에 포함할 최소 품질을 설정합니다. 시뮬레이션 결과가 우선 적용됩니다."
L.LOW =                                  LOW -- "Low"
L.HIGH =                                 HIGH -- "High"
L.INCLUDE_HIGHER_QUALITY =               "더 높은 품질 포함"
L.INCLUDE_HIGHER_QUALITY_DESC =          "더 높은 품질의 재료도 계산할지 설정합니다. (예: 1등급 재료를 계산할 때 보유한 2등급 재료 포함.)"
L.INCLUDE_HIGHER_QUALITY_DESC2 =         "더 높은 품질이 저렴하면 자동으로 포함됩니다."
L.INCLUDE_HIGHER_QUALITIES_YES =         "더 높은 품질 포함"
L.INCLUDE_HIGHER_QUALITIES_NO =          "더 높은 품질 제외"
L.COLLECTION_MODE =                      "수집 모드"
L.COLLECTION_MODE_DESC =                 "%s 버튼을 사용할 때 포함할 아이템을 설정합니다." -- %s becomes "Track New"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_SETTING_DESC =             "새로운 형상이 있는 아이템만 포함합니다."
L.APPEARANCES_SOURCES =                  "획득처"
L.APPEARANCES_SOURCES_SETTING_DESC =     "이미 알고 있는 형상이라도 새로운 획득처인 아이템을 포함합니다."

L.PROFESSION_WINDOW =                    "전문 기술 창"
L.FILTER_OPTIONAL_REAGENTS =             "선택 재료 필터링"
L.FILTER_OPTIONAL_REAGENTS_DESC =        "선택 재료에 대해 %s이(가) 체크되어 있으면 조합 가능한 아이템을 숨깁니다." -- %s becomes "Hide Unavailable"
L.SPEND_TO_NEXT_PERK =                   "다음 특전까지 투자"
L.SPEND_TO_NEXT_PERK_DESC =              "전문 기술 지식 노드를 Shift+클릭하면 다음 특전까지 포인트를 사용합니다."
L.ENHANCED_ORDERS =                      "주문 기능 개선"
L.ENHANCED_ORDERS_DESC =                 "주문 보상과 수수료 미리보기를 개선하고 첫 제작, 미습득 제조법, 추적 중인 제조법 아이콘을 추가합니다."
L.QUICK_ORDER_DURATION =                 "빠른 주문 기간"
L.QUICK_ORDER_DURATION_DESC =            "빠른 주문의 기간을 설정합니다."
L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

L.TRACKING_WINDOW =                      "추적 창"
L.SHOW_HELP_TOOLTIPS =                   "도움말 툴팁 표시"
L.SHOW_HELP_TOOLTIPS_DESC =              "추적 창의 항목에 마우스를 올리면 사용 가능한 마우스 동작을 표시합니다."
L.WINDOW_POSITION_PER_CHAR =             "캐릭터별 창 위치"
L.WINDOW_POSITION_PER_CHAR_DESC =        "계정 전체가 아니라 캐릭터별로 창 위치를 저장합니다."
L.TRACK_RECIPES_PER_CHAR =               "캐릭터별 제조법 추적"
L.TRACK_RECIPES_PER_CHAR_DESC =          "계정 전체가 아니라 캐릭터별로 제조법을 추적합니다."
L.SHOW_REMAINING_REAGENTS =              "남은 재료 표시"
L.SHOW_REMAINING_REAGENTS_DESC =         "추적 창에서 보유량/필요량 대신 아직 필요한 재료 수만 표시합니다."
L.UNTRACK_ON_CRAFT =                     "제작 시 추적 해제"
L.UNTRACK_ON_CRAFT_DESC =                "추적 중인 제조법의 제작에 성공하면 추적 수량을 하나 줄입니다."
L.CLOSE_WINDOW_WHEN_DONE =               "완료 시 창 닫기"
L.CLOSE_WINDOW_WHEN_DONE_DESC =          "마지막으로 추적 중인 제조법의 제작을 완료하면 추적 창을 닫습니다."

-- Tracking window
L.CLOSE_WINDOW =                         "창 닫기"
L.LOCK_WINDOW =                          "창 잠금"
L.UNLOCK_WINDOW =                        "창 잠금 해제"
L.UPDATE_AUCTIONATOR_LIST1 =             "Auctionator 쇼핑 목록 업데이트"
L.UPDATE_AUCTIONATOR_LIST2 =             "경매장을 열면 쇼핑 목록이 자동으로 생성됩니다"
L.DOUBLE =                               "두 번" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "창에 맞게 크기 자동 조절"
L.LINK_RECIPE =                          "제조법 링크"
L.OPEN_RECIPE =                          "제조법 열기"
L.CRAFT_RECIPE =                         "이 제조법 제작"
L.LINK_REAGENT =                         "재료 링크"
L.TRACK_RECIPE_SUBREAGENT =              "해당 재료를 만드는 제조법이 있으면 추적"
L.REMOVE_COOLDOWN_REMINDER =             "이 재사용 대기시간 알림 제거"

L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.ITEMS =                                ITEMS -- "Items"
L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.COSTS =                                "비용"
L.COOLDOWNS =                            "재사용 대기시간"
L.CLEAR_CONFIRMATION =                   "모든 제조법이 지워집니다."
L.CONFIRMATION =                         "계속하시겠습니까?"
L.SUBREAGENTS1 =                         "%s을(를) 제작할 수 있는 제조법이 여러 개 있습니다" -- %s becomes an item link
L.SUBREAGENTS2 =                         "다음 중 하나를 선택하세요:"
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
L.MERCHANT_BUY =                         "가능하다면 추적 중인 재료를 모두 구매합니다."

L.READY =                                READY -- "Ready"
L.DAYS =                                 "일"
L.HOURS =                                "시간"
L.MINUTES =                              "분"
L.READY_TO_CRAFT =                       "%s을(를) %s에서 다시 제작할 수 있습니다" -- %s becomes a recipe name, and character name

L.MORE_NEEDED =                          "%d개 더 필요" -- %d becomes a number
L.MADE_WITH =                            "%s(으)로 제작됨" -- %s becomes a profession
L.RECIPE_LEARNED =                       "제조법 습득"
L.RECIPE_UNLEARNED =                     "제조법 미습득"
L.CRAFTING_COST =                        "제작 비용"

-- Profession window
L.TRACK =                                TRACK_QUEST_ABBREV -- "Track"
L.UNTRACK =                              PROFESSIONS_UNTRACK_RECIPE -- "Untrack"
L.RANK =                                 RANK -- "Rank"
L.MILLING_INFORMATION =                  "제분 정보"
L.THAUMATURGY_INFORMATION =              "변환술 정보"
L.FROM =                                 "에서" -- Preceded by a percentage, followed by an item link
L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
L.SWITCH_AVAILABLE_PETS =                "사용 가능한 애완동물 전환"
L.TRACK_NEW =                            "새 아이템 추적"
L.CURRENT_SETTING =                      "현재 설정:"
L.NEW_APPEARANCES =                      "새 형상"
L.NEW_APPEARANCES_AND_SOURCES =          "새 형상 및 획득처"
L.ADDED_RECIPES =                        "표시된 제조법 %d개를 %s에서 확인했습니다. 제조법 %d개를 추적했습니다." -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

L.RECHARGED =                            "완전히 충전됨"
L.PROFTOOL_AUTOEQUIP =                   "이 도구 자동 착용" -- Followed by L.PROFTOOL_FOR
L.PROFTOOL_FOR =                         "%s용." -- %s becomes one of the two following phrases
L.PROFTOOL_DEFAULT =                     "일반 제작"
L.PROFTOOL_ORDERS =                      "주문 처리 중"
L.PROFTOOL_DRAG =                        "도구를 이곳으로 끌어오세요."
L.PROFTOOL_EQUIP =                       "이 도구를 착용합니다."
L.PROFTOOL_REMOVE =                      "이 도구를 제거합니다."

L.PERKS_UNLOCKED =                       "해제한 특전"
L.PROFESSION_KNOWLEDGE =                 "지식"
L.VENDORS =                              "상인"
L.RENOWN =                               COVENANT_SANCTUM_TAB_RENOWN -- "Renown "
L.WORLD =                                WORLD -- "World"
L.HIDDEN_PROFESSION_MASTER =             "숨겨진 전문 기술 대가"
L.WEEKLY =                               WEEKLY -- "Weekly"
L.TREASURE =                             "보물"
L.DROP =                                 BATTLE_PET_SOURCE_1 -- "Drop"
L.CATCHUP_KNOWLEDGE =                    "획득 가능한 따라잡기 지식:"
L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

L.AUCTION_ADDONS =                       "Auctionator, Oribos Exchange 또는 TradeSkillMaster"
L.ORDERS_PRICING_MISSING =               "누락"
L.ORDERS_PRICING_UPDATE =                "%s(으)로 업데이트하거나 검색하세요." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_SET_CRITERIA =                  "추적할 주문 조건을 설정합니다."
L.ORDERS_COST_NEED =                     "비용 설정은 다음 애드온에서만 작동합니다: %s." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_MAX_COST_KNOWLEDGE =            "지식 점수당 최대 비용:"
L.ORDERS_MAX_COST_ARTISAN =              "전문 기술 화폐당 최대 비용:" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "보상 가방당 최대 비용:" -- This refers to Artisan's Payout bag
L.ORDERS_TRACK_AFTER_RESET =             "주간 초기화 후 가능한 주문 추적"
L.ORDERS_TRACK_CONCENTRATION =           "집중력을 소비하는 주문 추적:"
L.ORDERS_TRACK_ON =                      "%s에서 추적:"-- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "대기열"
L.ORDERSQUEUE_QUEUED =                   "대기 중인 주문:"
L.ORDERSQUEUE_NEXT =                     "다음 주문"
L.ORDERSQUEUE_CLAIM =                    "주문 완료 보상 받기"
L.ORDERSQUEUE_CRAFT =                    "제작 주문"
L.ORDERSQUEUE_CRAFTING =                 "제작 중..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"
L.CANCEL_FORM =                          "양식 취소" -- Cancel Shapeshift Form
L.ORDERSQUEUE_WARNING_QUEST =            "아직 %s을(를) 수령하지 않았습니다." -- %s becomes a quest name
L.ORDERSQUEUE_WARNING_REAGENTS =         "추적 중인 제조법을 모두 제작할 재료가 부족합니다."
L.ORDERSQUEUE_WARNING_KEYBIND_DK =       "%s의 자체 단축키를 사용하려면 DialogKey의 \"제작 주문\" 설정을 비활성화하세요." -- %s becomes PSL

-- Crafting Orders window
L.RECRAFT_TOOLTIP =                      "캐시에 제조법 정보가 있는 아이템을 선택해 추적하세요."
L.QUICK_ORDER =                          "빠른 주문"
L.QUICKORDER_TOOLTIP1 =                  "지정한 받는 사람에게 즉시 제작 주문을 생성합니다."
L.QUICKORDER_TOOLTIP2 =                  "%s(모두 대문자)를 사용하여 " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "을(를) 생성합니다." -- "Guild Order", %s becomes "GUILD"
L.QUICKORDER_TOOLTIP3 =                  "캐릭터 이름을 사용하여 " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "을(를) 생성합니다." -- "Personal Order"
L.QUICKORDER_TOOLTIP4 =                  "받는 사람은 제조법별로 저장됩니다."
L.USE_LOCAL_REAGENTS =                   "보유 재료 사용"
L.USE_LOCAL_REAGENTS_DESC =              "사용 가능한 보유 재료(최저 품질)를 사용합니다. 어떤 재료를 사용할지는 사용자 지정할 수 없습니다."
L.REPEAT_LAST_QUICK_ORDER =              "이 캐릭터의 마지막 빠른 주문 반복"
L.RECIPIENT =                            "받는 사람"

L.FALSE =                                "거짓"
L.TRUE =                                 "참"
L.NO_LAST_QUICK_ORDER_FOUND =            "이전 빠른 주문을 찾을 수 없습니다"
L.ERROR =                                "오류:"
L.ERROR_CRAFTSIM =                       "CraftSim에서 정보를 읽을 수 없습니다"
L.ERROR_REAGENTS =                       "필수 재료가 있는 아이템에는 빠른 주문을 생성할 수 없습니다"
L.ERROR_WARBANK =                        "전투부대 은행에 있는 아이템으로는 빠른 주문을 생성할 수 없습니다"
L.ERROR_GUILD =                          "길드에 소속되지 않은 경우 " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "을(를) 생성할 수 없습니다." -- "Guild Order"
L.ERROR_RECIPIENT =                      "대상 받는 사람은 이 아이템을 제작할 수 없습니다. 유효한 받는 사람 이름을 입력하세요"
L.ERROR_MULTISIM =                       "시뮬레이션 재료가 사용되지 않았습니다. 다음 지원 애드온 중 하나만 활성화하세요:"
