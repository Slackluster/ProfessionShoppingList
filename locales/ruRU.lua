----------------------------------------
-- Profession Shopping List: ruRU.lua --
----------------------------------------
-- Russian (Russia) localisation
-- Translator(s): ZamestoTV

if GetLocale() ~= "ruRU" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Доступна более новая версия %s аддона:" -- %s becomes the addon name

L.RESET_DONE =                           "Сброс данных выполнен успешно."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.DEBUG_ENABLED =                        "Режим отладки включен"
L.DEBUG_DISABLED =                       "Режим отладки отключен"
L.INVALID_PARAMETERS =                   "Неверные параметры"
L.INVALID_COMMAND =                      "Неверная команда"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Разработка этого аддона требует значительного времени и усилий."
L.SUPPORT_TEXTLONG2 =                    "Пожалуйста, рассмотрите возможность финансовой поддержки разработчика."
L.SUPPORT =                              "Поддержать"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Спасибо!"
L.FEEDBACK_AND_HELP =                    "Обратная связь и помощь"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Присоединиться к серверу Discord."
L.CTRL_C_COPY =                          "Ctrl+C — скопировать:"
L.LINK_COPIED =                          "Ссылка скопирована в буфер обмена"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & Слэш-команды" -- "Keybindings"
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. ": Включить окно"
L.TOGGLE_TRACKING_WINDOW =               "Переключить окно отслеживания"
L.RESET_WINDOW_POSITION =                "Сбросить положение окна отслеживания"
L.RESET_SAVED_DATA =                     "Сбросить сохраненные данные"
L.OPEN_SETTINGS =                        "Откройте настройки"
L.CLEAR_TRACKED_RECIPES =                "Очистить все отслеживаемые рецепты"
L.RECIPEID =                             "recipeID"
L.QUANTITY =                             "число"
L.TRACK_RECIPE =                         "Отслеживать рецепт"
L.UNTRACK_RECIPE =                       "Отменить отслеживание рецепта"
L.UNTRACK_RECIPE_ALL =                   "Отменить отслеживание всех рецептов"
L.CRAFTING_ACHIEVEMENT =                 "достижение профессий"
L.TRACK_ACHIEVEMENT_RECIPES =            "Отслеживайте рецепты, необходимые для связанного достижения"
L.ITEMLINK_OR_ITEMID =                   "itemLink или itemID"
L.TRACK_REAGENT_RECIPES =                "Отслеживать все рецепты, использующие этот реагент"

L.GENERAL =                              GENERAL -- "General"
L.SHOW_MINIMAP_ICON =                    "Показать значок на миникарте"
L.SHOW_MINIMAP_ICON_DESC =               "Показать значок на миникарте. Если вы отключите это, %s все еще будет доступен из настроек." -- %s becomes the addon name
L.TRACK_RECIPE_COOLDOWNS =               "Отслеживание перезарядки рецептов"
L.TRACK_RECIPE_COOLDOWNS_DESC =          "Включить отслеживание перезарядки рецептов. Они будут отображаться в окне отслеживания и в чате при входе в игру, если готовы."
L.SHOW_WINDOW_WHEN_READY =               "Показать окно, когда будет готово"
L.SHOW_WINDOW_WHEN_READY_DESC =          "Открывать окно отслеживания при входе в игру, когда время восстановления готово, в дополнение к напоминанию в сообщении чата."
L.SHOW_TOOLTIP_INFORMATION =             "Показывать информацию в всплывающей подсказке"
L.SHOW_TOOLTIP_INFORMATION_DESC =        "Показывать, сколько реагентов у вас есть/нужно, на подсказке к предмету."
L.SHOW_CRAFTING_INFORMATION =            "Показать информацию о изготовлении"
L.SHOW_CRAFTING_INFORMATION_DESC =       "Показывать, с помощью какой профессии сделана экипировка, и известен ли рецепт на вашем аккаунте."
L.SHOW_CRAFTING_COST =                   "Показывать стоимость создания"
L.SHOW_CRAFTING_COST_DESC =              "Показывать, сколько стоит изготовление предмета, если эта информация доступна."
L.MINIMUM_REAGENT_QUALITY =              "Минимальное качество реагента"
-- L.MINIMUM_REAGENT_QUALITY_DESC =         "Set the minimum quality reagents need to be before they are counted. Simulated results will still override this."
L.LOW =                                  LOW -- "Low"
L.HIGH =                                 HIGH -- "High"
L.INCLUDE_HIGHER_QUALITY =               "Включить более высокое качество"
L.INCLUDE_HIGHER_QUALITY_DESC =          "Учитывать ли реагенты более высокого качества. (Например, включать имеющиеся реагенты 2-го уровня при подсчете реагентов 1-го уровня.)"
L.INCLUDE_HIGHER_QUALITIES_YES =         "Включать более высокое качество"
L.INCLUDE_HIGHER_QUALITIES_NO =          "Не включайте более высокие качества"
L.COLLECTION_MODE =                      "Режим сбора"
L.COLLECTION_MODE_DESC =                 "Установите, какие предметы будут включены при использовании %s кнопки." -- %s becomes "Track New"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_SETTING_DESC =             "Включайте предметы только в том случае, если они имеют новый внешний вид."
L.APPEARANCES_SOURCES =                  "Источники"
L.APPEARANCES_SOURCES_SETTING_DESC =     "Включите предметы, если они являются новым источником, в том числе для известных моделей."

L.PROFESSION_WINDOW =                    "Окно профессий"
L.FILTER_OPTIONAL_REAGENTS =             "Фильтр необязательных реагентов"
L.FILTER_OPTIONAL_REAGENTS_DESC =        "Если для необязательных реагентов включена опция %s, объединяемые предметы будут скрыты." -- %s becomes "Hide Unavailable"
L.SPEND_TO_NEXT_PERK =                   "Тратить до ближайшего таланта"
L.SPEND_TO_NEXT_PERK_DESC =              "Shift+клик по узлу специализации профессии тратит очки до достижения следующего бонуса."
L.ENHANCED_ORDERS =                      "Улучшенные заказы"
L.ENHANCED_ORDERS_DESC =                 "Улучшите предварительный просмотр наград за заказы и комиссионных, а также добавьте значки для первых созданных, неизученных рецептов и отслеживаемых рецептов."
L.QUICK_ORDER_DURATION =                 "Продолжительность быстрого заказа"
-- L.QUICK_ORDER_DURATION_DESC =            "Set the duration for placing quick orders."
-- L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
-- L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
-- L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

L.TRACKING_WINDOW =                      "Окно отслеживания"
L.SHOW_HELP_TOOLTIPS =                   "Показать подсказки справки"
L.SHOW_HELP_TOOLTIPS_DESC =              "Отображение действий мыши при наведении курсора на записи в окне отслеживания."
L.WINDOW_POSITION_PER_CHAR =             "Положение окна на персонаже"
L.WINDOW_POSITION_PER_CHAR_DESC =        "Сохранение положения окна для каждого персонажа, а не для всей учетной записи."
L.TRACK_RECIPES_PER_CHAR =               "Отслеживание рецептов для каждого персонажа"
L.TRACK_RECIPES_PER_CHAR_DESC =          "Отслеживайте рецепты для каждого персонажа, а не для всей учетной записи."
L.SHOW_REMAINING_REAGENTS =              "Показать оставшиеся реагенты"
L.SHOW_REMAINING_REAGENTS_DESC =         "В окне отслеживания отображается только количество реагентов, которые вам еще нужны, а не количество есть/нужно."
L.UNTRACK_ON_CRAFT =                     "Отключить отслеживание на изготовления"
L.UNTRACK_ON_CRAFT_DESC =                "Удалите один из отслеживаемых рецептов, если вы успешно его изготовили."
L.CLOSE_WINDOW_WHEN_DONE =               "Закрыть окно, когда закончите"
L.CLOSE_WINDOW_WHEN_DONE_DESC =          "Закройте окно отслеживания после создания последнего отслеживаемого рецепта."

-- Tracking window
L.CLOSE_WINDOW =                         "Закрыть окно"
L.LOCK_WINDOW =                          "Заблокировать окно"
L.UNLOCK_WINDOW =                        "Разблокировать окно"
L.UPDATE_AUCTIONATOR_LIST1 =             "Обновите список покупок на аукционе"
L.UPDATE_AUCTIONATOR_LIST2 =             "Список покупок формируется автоматически при открытии Аукционного дома"
L.DOUBLE =                               "Двойное" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "Автоматическое изменение размера окна"
L.LINK_RECIPE =                          "Ссылка на рецепт"
L.OPEN_RECIPE =                          "Открыть рецепт"
-- L.CRAFT_RECIPE =                         "Craft this recipe"
L.LINK_REAGENT =                         "Ссылка на реагент"
-- L.TRACK_RECIPE_SUBREAGENT =              "Track the recipe to craft this reagent, if one exists"
L.REMOVE_COOLDOWN_REMINDER =             "Удалить это конкретное напоминание о перезарядке"

L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.ITEMS =                                ITEMS -- "Items"
L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.COSTS =                                "Расходы"
L.COOLDOWNS =                            "Перезарядки"
L.CLEAR_CONFIRMATION =                   "Это очистит все рецепты."
L.CONFIRMATION =                         "Хотите продолжить?"
L.SUBREAGENTS1 =                         "Существует множество рецептов, которые можно изготовить %s"  -- %s becomes an item link
L.SUBREAGENTS2 =                         "Пожалуйста, выберите один из следующих вариантов:"
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
-- L.MERCHANT_BUY =                         "Buy all tracked reagents, if available."

L.READY =                                "Готов"
L.DAYS =                                 "д"
L.HOURS =                                "ч"
L.MINUTES =                              "м"
L.READY_TO_CRAFT =                       "%s готов снова к работе %s"-- %s becomes a recipe name, and character name

L.MORE_NEEDED =                          "%d нужно больше" -- %d becomes a number
L.MADE_WITH =                            "Сделано %s" -- %s becomes a profession
L.RECIPE_LEARNED =                       "рецепт изучен"
L.RECIPE_UNLEARNED =                     "рецепт не изучен"
L.CRAFTING_COST =                        "Стоимость создания"

-- Profession window
L.TRACK =                                "Отслеживать"
L.UNTRACK =                              "Не отслеживать"
L.RANK =                                 RANK -- "Rank"
L.MILLING_INFORMATION =                  "Информация о Измельчении"
L.THAUMATURGY_INFORMATION =              "Информация о Тауматургии"
L.FROM =                                 "из"
L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
L.SWITCH_AVAILABLE_PETS =                "Переключение между доступными питомцами"
-- L.TRACK_NEW =                            "Track New"
L.CURRENT_SETTING =                      "Текущая настройка:"
L.NEW_APPEARANCES =                      "новые внешние виды"
L.NEW_APPEARANCES_AND_SOURCES =          "новые внешние виды и источники"
L.ADDED_RECIPES =                        "Проверено рецептов для %2$s: %1$d. Отслеживается рецептов: %3$d." -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

L.RECHARGED =                            "Полностью заряжен"
L.PROFTOOL_AUTOEQUIP =                   "Автоматически экипировать этот инструмент" -- Followed by L.PROFTOOL_FOR
L.PROFTOOL_FOR =                         "для %s." -- %s becomes one of the two following phrases
L.PROFTOOL_DEFAULT =                     "обычного ремесла"
L.PROFTOOL_ORDERS =                      "выполнении заказов"
L.PROFTOOL_DRAG =                        "Перетащите инструмент сюда."
L.PROFTOOL_EQUIP =                       "экипировать этот инструмент."
L.PROFTOOL_REMOVE =                      "убрать этот инструмент."

L.PERKS_UNLOCKED =                       "перки разблокированы"
L.PROFESSION_KNOWLEDGE =                 "знание"
L.VENDORS =                              "Торговцы"
L.RENOWN =                               COVENANT_SANCTUM_TAB_RENOWN -- "Renown "
L.WORLD =                                "Мир"
L.HIDDEN_PROFESSION_MASTER =             "Скрыть мастера профессии"
L.WEEKLY =                               WEEKLY -- "Weekly"
L.TREASURE =                             "Сокровище"
L.DROP =                                 BATTLE_PET_SOURCE_1 -- "Drop"
L.CATCHUP_KNOWLEDGE =                    "Доступные дополнительные знания:"
L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

L.AUCTION_ADDONS =                       "Auctionator, Oribos Exchange или TradeSkillMaster"
L.ORDERS_PRICING_MISSING =               "Отсутствует"
L.ORDERS_PRICING_UPDATE =                "Обновите или просканируйте с помощью %s." -- %s becomes a list of addon names
L.ORDERS_SET_CRITERIA =                  "Задайте критерии для отслеживания заказов."
L.ORDERS_COST_NEED =                     "Настройки стоимости работают только с: %s." -- %s becomes a list of addon names
L.ORDERS_MAX_COST_KNOWLEDGE =            "Макс. стоимость за одно очко знаний:"
L.ORDERS_MAX_COST_ARTISAN =              "Макс. стоимость за ремесленную валюту:" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "Макс. стоимость за сумку с наградой:" -- This refers to Artisan's Payout bag
L.ORDERS_TRACK_AFTER_RESET =             "Отслеживать заказы, доступные после еженедельного сброса"
L.ORDERS_TRACK_CONCENTRATION =           "Отслеживать заказы, требующие концентрации:"
L.ORDERS_TRACK_ON =                      "Отслеживать на %s:"  -- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "Очередь"
L.ORDERSQUEUE_QUEUE =                    "Заказов в очереди:"
L.ORDERSQUEUE_NEXT =                     "След. заказ"
L.ORDERSQUEUE_CLAIM =                    "Принять заказ"
L.ORDERSQUEUE_CRAFT =                    "Изготовить"
L.ORDERSQUEUE_CRAFTING =                 "Изготовление..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"
L.ORDERSQUEUE_WARNING_QUEST =            "Вы не взяли %s." -- %s becomes a quest name
L.ORDERSQUEUE_WARNING_REAGENTS =         "У вас недостаточно реагентов для всех отслеживаемых рецептов."

-- Crafting Orders window
L.RECRAFT_TOOLTIP =                      "Выберите предмет с сохраненным рецептом, чтобы отслеживать его."
L.QUICK_ORDER =                          "Быстрый заказ"
L.QUICKORDER_TOOLTIP1 =                  "Немедленно создать заказ на изготовление для указанного получателя."
L.QUICKORDER_TOOLTIP2 =                  "Используйте %s (все заглавные буквы), чтобы разместить " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "." -- "Guild Order", %s becomes "GUILD"
L.QUICKORDER_TOOLTIP3 =                  "Используйте имя персонажа, чтобы разместить " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "." -- "Personal Order"
L.QUICKORDER_TOOLTIP4 =                  "Получатели сохраняются по рецепту."
L.USE_LOCAL_REAGENTS =                   "Используйте местные реагенты"
L.USE_LOCAL_REAGENTS_DESC =              "Используйте (самого низкого качества) доступные местные реагенты. Какие реагенты использовать нельзя настроить."
L.REPEAT_LAST_QUICK_ORDER =              "Повторите последнее Быстрый заказ изготовленное на этом персонаже"
L.RECIPIENT =                            "Получатель"

L.FALSE =                                "ложь"
L.TRUE =                                 "правда"
L.NO_LAST_QUICK_ORDER_FOUND =            "Последние Быстрый заказ не найдены"
L.ERROR =                                "Ошибка:"
L.ERROR_CRAFTSIM =                       "Не удалось прочитать информацию из CraftSim"
L.ERROR_REAGENTS =                       "Невозможно создать Быстрый заказ для предметов с обязательными реагентами"
L.ERROR_WARBANK =                        "Невозможно создать Быстрый заказ с предметами в Банке Отряда"
L.ERROR_GUILD =                          "Невозможно создать " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " не будучи в гильдии" -- "Guild Order"
L.ERROR_RECIPIENT =                      "Выбранный получатель не может создать этот предмет. Введите допустимое имя получателя"
L.ERROR_MULTISIM =                       "Никакие смоделированные реагенты не использовались. Пожалуйста, включите только один из следующих поддерживаемых аддонов:"
