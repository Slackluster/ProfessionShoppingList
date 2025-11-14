----------------------------------------
-- Profession Shopping List: ruRU.lua --
----------------------------------------
-- Russian (Russia) localisation
-- Translator(s): ZamestoTV

-- Initialisation
if GetLocale() ~= "ruRU" then return end
local appName, app = ...
local L = app.locales

-- Main window
L.WINDOW_BUTTON_CLOSE =					"Закрыть окно"
L.WINDOW_BUTTON_LOCK =					"Заблокировать окно"
L.WINDOW_BUTTON_UNLOCK =				"Разблокировать окно"
L.WINDOW_BUTTON_SETTINGS =				"Откройте настройки"
L.WINDOW_BUTTON_CLEAR =					"Очистить все отслеживаемые рецепты"
L.WINDOW_BUTTON_AUCTIONATOR =			"Обновите список покупок на аукционе\n" ..
										"Список покупок формируется автоматически при открытии Аукционного дома"
L.WINDOW_BUTTON_CORNER =				"Двойной " .. app.IconLMB .. "|cffFFFFFF: Автоматическое изменение размера окна"

L.WINDOW_HEADER_RECIPES =				PROFESSIONS_RECIPES_TAB	-- "Recipes"
L.WINDOW_HEADER_ITEMS =					ITEMS	-- "Items"
L.WINDOW_HEADER_REAGENTS =				PROFESSIONS_COLUMN_HEADER_REAGENTS	-- "Reagents"
L.WINDOW_HEADER_COSTS =					"Расходы"
L.WINDOW_HEADER_COOLDOWNS =				"Перезарядки"

L.WINDOW_TOOLTIP_RECIPES =				"Shift " .. app.IconLMB .. "|cffFFFFFF: Ссылка на рецепт\n|r" ..
										"Ctrl " .. app.IconLMB .. "|cffFFFFFF: Открыть рецепт (если известен)\n|r" ..
										"Alt " .. app.IconLMB .. "|cffFFFFFF: Попробуйте изготовить этот рецепт (столько раз, сколько раз вы его отслеживали)\n\n|r" ..
										app.IconRMB .. "|cffFFFFFF: Отменить отслеживание 1 из выбранных рецептов\n|r" ..
										"Ctrl " .. app.IconRMB .. "|cffFFFFFF: Отменить отслеживание всех выбранных рецептов"
L.WINDOW_TOOLTIP_REAGENTS =				"Shift " .. app.IconLMB .. "|cffFFFFFF: Ссылка на реагент\n|r" ..
										"Ctrl " .. app.IconLMB .. "|cffFFFFFF: Добавить рецепт для выбранного субреагента, если он существует и кэширован"
L.WINDOW_TOOLTIP_COOLDOWNS =			"Shift " .. app.IconRMB .. "|cffFFFFFF: Удалить это конкретное напоминание о перезарядке\n|r" ..
										"Ctrl " .. app.IconLMB .. "|cffFFFFFF: Открыть рецепт (если известен)\n|r" ..
										"Alt " .. app.IconLMB .. "|cffFFFFFF: Попытайтесь изготовить этот рецепт"

L.CLEAR_CONFIRMATION =					"Это очистит все рецепты."
L.CONFIRMATION =						"Хотите продолжить?"
L.SUBREAGENTS1 =						"Существует множество рецептов, которые можно изготовить"	-- Followed by an item link
L.SUBREAGENTS2 =						"Пожалуйста, выберите один из следующих вариантов"
L.GOLD =								BONUS_ROLL_REWARD_MONEY	-- "Gold"

-- Cooldowns
L.RECHARGED =							"Полностью заряжен"
L.READY =								"Готов"
L.DAYS =								"д"
L.HOURS =								"ч"
L.MINUTES =								"м"
L.READY_TO_CRAFT =						"готов снова к работе"	-- Preceded by a recipe name, followed by a character name

-- Recipe tracking
L.TRACK =								"Отслеживать"
L.UNTRACK =								"Не отслеживать"
L.RANK =								RANK	-- "Rank"
L.RECRAFT_TOOLTIP =						"Выберите предмет с сохраненным рецептом, чтобы отслеживать его.\n" ..
										"Чтобы кэшировать рецепт, откройте профессию, к которой относится рецепт, на любом персонаже\nили просмотреть предмет как обычный заказ на изготовление."
L.QUICKORDER =							"Быстрый заказ"
L.QUICKORDER_TOOLTIP =					"|cffFF0000Немедленно|r создать заказ на изготовление для указанного получателя.\n\n" ..
										"Используйте |cffFFFFFFGUILD|r (все заглавные буквы), чтобы разместить " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. ".\n" ..	-- "Guild Order". Don't translate "|cffFFFFFFGUILD|r" as this is hardcoded
										"Используйте имя персонажа, чтобы разместить " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. ".\n" ..	-- "Personal Order"
										"Получатели сохраняются по рецепту."
L.LOCALREAGENTS_LABEL =					"Используйте местные реагенты"
L.LOCALREAGENTS_TOOLTIP =				"Используйте (самого низкого качества) доступные местные реагенты. Какие реагенты использовать |cffFF0000нельзя|r настроить."
L.QUICKORDER_REPEAT_TOOLTIP =			"Повторите последнее " .. L.QUICKORDER .. " изготовленное на этом персонаже"
L.RECIPIENT =							"Получатель"

-- Profession window
L.MILLING_INFO =						"Информация о Измельчении"
L.THAUMATURGY_INFO =					"Информация о Тауматургии"
L.FROM =								"из"	-- I will convert this whole section to item links, then this is the only localisation needed. I recommend skipping the rest of this section. :)

L.MILLING_CLASSIC =						"Сапфировый краситель: 25% из Золотой сансам, Снолист, Горный серебряный шалфей, Печаль-трава, Ледяной зев\n" ..
										"Серебряный краситель: 75% из Золотой сансам, Снолист, Горный серебряный шалфей, Печаль-трава, Ледяной зев\n\n" ..
										"Рубиновый краситель: 25% из Огнецвет, Лиловый лотос, Слезы Артаса, Солнечник, Пастушья сумка,\n      Призрачная поганка, Кровь Грома\n" ..
										"Фиалковый краситель: 75% из Огнецвет, Лиловый лотос, Слезы Артаса, Солнечник, Пастушья сумка,\n      Призрачная поганка, Кровь Грома\n\n" ..
										"Краситель индиго: 25% из Бледнолист, Златошип, Кадгаров ус, Драконьи зубы\n" ..
										"Изумрудный краситель: 75% из Бледнолист, Златошип, Кадгаров ус, Драконьи зубы\n\n" ..
										"Жженый краситель: 25% из Дикий сталецвет, Могильный мох, Королевская кровь, Корень жизни\n" ..
										"Золотой краситель: 75% из Дикий сталецвет, Могильный мох, Королевская кровь, Корень жизни\n\n" ..
										"Зеленый краситель: 25% из Магороза, Остротерн, Скорополох, Синячник, Удавник\n" ..
										"Мглистый краситель: 75% из Магороза, Остротерн, Скорополох, Синячник, Удавник\n\n" ..
										"Алебастровый краситель: 100% из Мироцвет, Сребролист, Земляной корень"
L.MILLING_TBC =							"Эбеновый краситель: 25%\n" ..
										"Краситель пустоты: 100%"
L.MILLING_WOTLK =						"Ледяной краситель: 25%\n" ..
										"Лазурный краситель: 100%"
L.MILLING_CATA =						"Раскаленные угли: 25%, 50% из Сумеречный жасмин, Хлыстохвост\n" ..
										"Пепельный краситель: 100%"
L.MILLING_MOP =							"Туманный краситель: 25%, 50% из Дурногриб\n" ..
										"Теневой краситель: 100%"
L.MILLING_WOD =							"Голубой краситель: 100%"
L.MILLING_LEGION =						"Землистый краситель: 10%, 80% из Зверобой Скверны\n" ..
										"Розовый краситель: 90%"
L.MILLING_BFA =							"Изумрудно-зеленый краситель: 10%, 30% из Якорь-трава\n" ..
										"Алый краситель: 25%\n" ..
										"Ультрамариновый краситель: 75%"
L.MILLING_SL =							"Пигмент безмятежности: Беладонна\n" ..
										"Светящийся пигмент: Смертоцвет, Славолист, Факел дозорного\n" ..
										"Теневой пигмент: Смертоцвет, Костяной корень, Вдовоцвет"
L.MILLING_DF =							"Пылающий пигмент: Камнеломка\n" ..
										"Цветущий пигмент: Витая кора\n" ..
										"Спокойный пигмент: Пузырчатый мак\n" ..
										"Мерцающий пигмент: Хоэнвейс"
L.MILLING_TWW =							"Цветочный краситель: Благоцвет\n" ..
										"Краситель из блесницы: Блесница\n" ..
										"Краситель из кольчатки: Кольчатка\n" ..
										"Перламутровый краситель: Микоцвет"
L.THAUMATURGY_TWW =						"Ртутный трансмутаген: Акирит, Сумрачный хитин, Блесница, Кольчатка\n" ..
										"Зловещий трансмутаген: Висмут, Микоцвет, Штормовая пыль, Паутинная ткань\n" ..
										"Нестабильный трансмутаген: Копье Аратора, Благоцвет, Когтесталь, Заряженная бурей кожа"

L.BUTTON_COOKINGFIRE =					app.IconLMB .. ": " .. BINDING_NAME_TARGETSELF .. "\n" ..
										app.IconRMB .. ": " .. STATUS_TEXT_TARGET
L.BUTTON_COOKINGPET =					app.IconLMB .. ": Призвать этого питомца\n" ..
										app.IconRMB .. ": Переключение между доступными питомцами"
L.BUTTON_CHEFSHAT =						app.IconLMB .. ": Используйте"
L.BUTTON_THERMALANVIL =					app.IconLMB .. ": Используйте"
L.BUTTON_ALVIN =						app.IconLMB .. ": Призвать этого питомца"
L.BUTTON_LIGHTFORGE =					app.IconLMB .. ": Каст"

-- Track new mogs
L.BUTTON_TRACKNEW =						"Отслеживать новые образы"
L.CURRENT_SETTING =						"Текущая настройка:"
L.MODE_APPEARANCES =					"новые внешние виды"
L.MODE_SOURCES =						"новые внешние виды и источники"
L.TRACK_NEW1 =							"Это позволит проверить"	-- Followed by a number
L.TRACK_NEW2 =							"видимые рецепты для"	-- Preceded by a number, followed by L.MODE_APPEARANCES or L.MODE_SOURCES
L.TRACK_NEW3 =							"Ваша игра может зависнуть на несколько секунд."
L.ADDED_RECIPES1 =						"Добавлен"	-- Followed by a number
L.ADDED_RECIPES2 =						"подходящие рецепты"	-- Preceded by a number

-- Tooltip info
L.MORE_NEEDED =							"нужно больше" -- Preceded by a number
L.MADE_WITH =							"Сделано"	-- Followed by a profession name such as "Blacksmithing" or "Leatherworking"
L.RECIPE_LEARNED =						"рецепт изучен"
L.RECIPE_UNLEARNED =					"рецепт не изучен"

-- Profession knowledge
L.PERKS_UNLOCKED =						"перки разблокированы"
L.PROFESSION_KNOWLEDGE =				"знание"
L.VENDORS =								"Торговцы"
L.RENOWN =								COVENANT_SANCTUM_TAB_RENOWN	-- "Renown "
L.WORLD =								"Мир"
L.HIDDEN_PROFESSION_MASTER =			"Скрыть мастера профессии"
L.CATCHUP_KNOWLEDGE =					"Доступные дополнительные знания:"
L.LOADING =								SEARCH_LOADING_TEXT

-- Chat feedback
L.INVALID_PARAMETERS =					"Неверные параметры."
L.INVALID_RECIPEQUANTITY =				L.INVALID_PARAMETERS .. " Пожалуйста, введите допустимое количество по рецепту."
L.INVALID_RECIPEID =				    L.INVALID_PARAMETERS .. " Пожалуйста, введите кэшированный recipeID."
L.INVALID_RECIPE_TRACKED =				L.INVALID_PARAMETERS .. " Пожалуйста, введите recipeID отслеживаемого рецепта."
L.INVALID_ACHIEVEMENT =					L.INVALID_PARAMETERS .. " Это не достижение изготовления. Рецепты не были добавлены."
L.INVALID_RESET_ARG =					L.INVALID_PARAMETERS .. " Вы можете использовать следующие аргументы:"
L.INVALID_COMMAND =						"Неверная команда. Используйте " .. app.Colour("/psl settings") .. " для получения дополнительной информации."
L.DEBUG_ENABLED =						"Режим отладки включен."
L.DEBUG_DISABLED =						"Режим отладки отключен."
L.RESET_DONE =							"Сброс данных выполнен успешно."
L.REQUIRES_RELOAD =						"|cffFF0000" .. REQUIRES_RELOAD .. ".|r Используйте |cffFFFFFF/reload|r или перезайдите в игру."	-- "Requires Reload"

L.FALSE =								"ложь"
L.TRUE =								"правда"
L.NOLASTORDER =							"Последние " .. L.QUICKORDER .. " не найдены"
L.ERROR =								"Ошибка"
L.ERROR_CRAFTSIM =						L.ERROR .. ": Не удалось прочитать информацию из CraftSim."
L.ERROR_QUICKORDER =					L.ERROR .. ": " .. L.QUICKORDER .. " не удалось. Извините. :("
L.ERROR_REAGENTS =						L.ERROR .. ": Невозможно создать " .. L.QUICKORDER .. " для предметов с обязательными реагентами. Извините. :("
L.ERROR_WARBANK =						L.ERROR .. ": Невозможно создать " .. L.QUICKORDER .. " с предметами в Банке Отряда."
L.ERROR_GUILD =							L.ERROR .. ": Невозможно создать " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " не будучи в гильдии."	-- "Guild Order"
L.ERROR_RECIPIENT =						L.ERROR .. ": Выбранный получатель не может создать этот предмет. Введите допустимое имя получателя."
L.ERROR_MULTISIM =						L.ERROR .. ": Никакие смоделированные реагенты не использовались. Пожалуйста, включите только один из следующих поддерживаемых аддонов:"

L.VERSION_CHECK =						"Доступна более новая версия " .. app.NameLong .. " аддона:"

-- Settings
L.SETTINGS_SUPPORT_TEXTLONG = "Разработка этого аддона требует значительного времени и усилий.\nПожалуйста, рассмотрите возможность финансовой поддержки разработчика."
L.SETTINGS_SUPPORT_TEXT = "Поддержать"
L.SETTINGS_SUPPORT_BUTTON = "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_SUPPORT_DESC = "Спасибо!"
L.SETTINGS_HELP_TEXT = "Обратная связь и помощь"
L.SETTINGS_HELP_BUTTON = "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_HELP_DESC = "Присоединиться к серверу Discord."
L.SETTINGS_ISSUES_TEXT = "Отслеживание ошибок"
L.SETTINGS_ISSUES_BUTTON = "GitHub" -- Brand name, if there isn't a localised version, keep it the way it is
L.SETTINGS_ISSUES_DESC = "Просмотреть трекер ошибок на GitHub."
L.SETTINGS_URL_COPY = "Ctrl+C — скопировать:"
L.SETTINGS_URL_COPIED = "Ссылка скопирована в буфер обмена"

L.SETTINGS_TOOLTIP =					app.IconLMB .. "|cffFFFFFF: Переключить окно\n" ..
										app.IconRMB .. ": " .. L.WINDOW_BUTTON_SETTINGS

L.SETTINGS_MINIMAP_TITLE =				"Показать значок на миникарте"
L.SETTINGS_MINIMAP_TOOLTIP =			"Показать значок на миникарте. Если вы отключите это, " .. app.NameShort .. " все еще будет доступен из настроек."
L.SETTINGS_COOLDOWNS_TITLE =			"Отслеживание перезарядки рецептов"
L.SETTINGS_COOLDOWNS_TOOLTIP =			"Включить отслеживание перезарядки рецептов. Они будут отображаться в окне отслеживания и в чате при входе в игру, если готовы."
L.SETTINGS_COOLDOWNSWINDOW_TITLE =		"Показать окно, когда будет готово"
L.SETTINGS_COOLDOWNSWINDOW_TOOLTIP =	"Открывать окно отслеживания при входе в игру, когда время восстановления готово, в дополнение к напоминанию в сообщении чата."
L.SETTINGS_TOOLTIP_TITLE =				"Показывать информацию в всплывающей подсказке"
L.SETTINGS_TOOLTIP_TOOLTIP =			"Показывать, сколько реагентов у вас есть/нужно, на подсказке к предмету."
L.SETTINGS_CRAFTTOOLTIP_TITLE =			"Показать информацию о изготовлении"
L.SETTINGS_CRAFTTOOLTIP_TOOLTIP =		"Показывать, с помощью какой профессии сделана экипировка, и известен ли рецепт на вашем аккаунте."
L.SETTINGS_REAGENTQUALITY_TITLE =		"Минимальное качество реагента"
L.SETTINGS_REAGENTQUALITY_TOOLTIP =		"Установите минимальное качество, которое должны иметь реагенты, чтобы " .. app.NameShort .. " включал их в подсчёт предметов. Результаты CraftSim всё равно будут иметь приоритет."
L.SETTINGS_INCLUDEHIGHER_TITLE =		"Включить более высокое качество"
L.SETTINGS_INCLUDEHIGHER_TOOLTIP =		"Установите, какие более высокие качества учитывать при отслеживании реагентов более низкого качества. (Например, учитывать ли реагенты 3-го уровня при подсчёте реагентов 1-го уровня.)"
L.SETTINGS_COLLECTMODE_TITLE =			"Режим сбора"
L.SETTINGS_COLLECTMODE_TOOLTIP =		"Установите, какие предметы будут включены при использовании " .. app.Colour(L.BUTTON_TRACKNEW) .. " кнопки."
L.SETTINGS_ENHANCEDORDERS_TITLE =		"Улучшенные заказы"
L.SETTINGS_ENHANCEDORDERS_TOOLTIP =		"Улучшите предварительный просмотр наград за заказы и комиссионных, а также добавьте значки для первых созданных, неизученных рецептов и отслеживаемых рецептов.\n\n" .. L.REQUIRES_RELOAD
L.SETTINGS_QUICKORDER_TITLE =			"Продолжительность быстрого заказа"
L.SETTINGS_QUICKORDER_TOOLTIP =			"Установите продолжительность размещения быстрых заказов с помощью " .. app.NameShort .. "."

L.SETTINGS_REAGENTTIER =				"Тир"	-- Followed by a number
L.SETTINGS_INCLUDE =					"Включать"	-- Followed by "Tier X"
L.SETTINGS_ONLY_INCLUDE =				"Включать только"	-- Followed by "Tier X"
L.SETTINGS_DONT_INCLUDE =				"Не включайте более высокие качества"
L.SETTINGS_APPEARANCES_TITLE =			WARDROBE	-- "Appearances"
L.SETTINGS_APPEARANCES_TEXT =			"Включайте предметы только в том случае, если они имеют новый внешний вид."
L.SETTINGS_SOURCES_TITLE =				"Источники"
L.SETTINGS_SOURCES_TEXT =				"Включите предметы, если они являются новым источником, в том числе для известных моделей."
L.SETTINGS_DURATION_SHORT =				"Короткий (12 часов)"
L.SETTINGS_DURATION_MEDIUM =			"Средний (24 часа)"
L.SETTINGS_DURATION_LONG =				"Длительный (48 часов)"

L.SETTINGS_HEADER_TRACK =				"Окно отслеживания"
L.SETTINGS_HELP_TITLE =					"Показать подсказки справки"
L.SETTINGS_HELP_TOOLTIP =				"Отображение действий мыши при наведении курсора на записи в окне отслеживания."
L.SETTINGS_PERSONALWINDOWS_TITLE =		"Положение окна на персонаже"
L.SETTINGS_PERSONALWINDOWS_TOOLTIP =	"Сохранение положения окна для каждого персонажа, а не для всей учетной записи."
L.SETTINGS_PERSONALRECIPES_TITLE =		"Отслеживание рецептов для каждого персонажа"
L.SETTINGS_PERSONALRECIPES_TOOLTIP =	"Отслеживайте рецепты для каждого персонажа, а не для всей учетной записи."
L.SETTINGS_SHOWREMAINING_TITLE =		"Показать оставшиеся реагенты"
L.SETTINGS_SHOWREMAINING_TOOLTIP =		"В окне отслеживания отображается только количество реагентов, которые вам еще нужны, а не количество есть/нужно."
L.SETTINGS_REMOVECRAFT_TITLE =			"Отключить отслеживание на изготовления"
L.SETTINGS_REMOVECRAFT_TOOLTIP =		"Удалите один из отслеживаемых рецептов, если вы успешно его изготовили."
L.SETTINGS_CLOSEWHENDONE_TITLE =		"Закрыть окно, когда закончите"
L.SETTINGS_CLOSEWHENDONE_TOOLTIP =		"Закройте окно отслеживания после создания последнего отслеживаемого рецепта."

L.SETTINGS_HEADER_INFO =				"Информация"
L.SETTINGS_SLASHCOMMANDS_TITLE =		"Слэш-команды"
L.SETTINGS_SLASHCOMMANDS_TOOLTIP =		"Чтобы использовать их, введите их в чат!"
L.SETTINGS_SLASH_TOGGLE =				"Переключить окно отслеживания."
L.SETTINGS_SLASH_RESETPOS =				"Сбросить положение окна отслеживания."
L.SETTINGS_SLASH_RESET =				"Сбросить сохраненные данные."
L.SETTINGS_SLASH_TRACK =				"Отслеживать рецепт."
L.SETTINGS_SLASH_UNTRACK =				"Отменить отслеживание рецепта."
L.SETTINGS_SLASH_UNTRACKALL =			"Отменить отслеживание всех рецептов."
L.SETTINGS_SLASH_TRACKACHIE =			"Отслеживайте рецепты, необходимые для связанного достижения."
L.SETTINGS_SLASH_CRAFTINGACHIE =		"достижение профессий"
L.SETTINGS_SLASH_RECIPEID =				"recipeID"
L.SETTINGS_SLASH_QUANTITY =				"число"
