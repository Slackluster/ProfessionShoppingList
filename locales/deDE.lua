----------------------------------------
-- Profession Shopping List: deDE.lua --
----------------------------------------
-- German (Germany) localisation
-- Translator(s):

if GetLocale() ~= "deDE" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Eine neuere Version von %s ist verfügbar:" -- %s becomes the addon name

L.RESET_DONE =                           "Daten erfolgreich zurückgesetzt."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.DEBUG_ENABLED =                        "Debugmodus aktiviert"
L.DEBUG_DISABLED =                       "Debugmodus deaktiviert"
L.INVALID_PARAMETERS =                   "Ungültige Parameter"
L.INVALID_COMMAND =                      "Ungültiger Befehl"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Die Entwicklung dieses Addons erfordert viel Zeit und Mühe."
L.SUPPORT_TEXTLONG2 =                    "Bitte erwäge, die Entwicklung finanziell zu unterstützen."
L.SUPPORT =                              "Unterstützen"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Vielen Dank!"
L.FEEDBACK_AND_HELP =                    "Feedback und Hilfe"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Discord-Server beitreten."
L.CTRL_C_COPY =                          "Strg+C zum Kopieren:"
L.LINK_COPIED =                          "Link in die Zwischenablage kopiert"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & Slash-Befehle" -- "Keybindings"
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. ": Fenster ein-/ausblenden"
L.ORDERS_QUEUE =                         "Auftragswarteschlange"
L.TOGGLE_TRACKING_WINDOW =               "Verfolgungsfenster ein-/ausblenden"
L.RESET_WINDOW_POSITION =                "Position des Verfolgungsfensters zurücksetzen"
L.RESET_SAVED_DATA =                     "Gespeicherte Daten zurücksetzen"
L.OPEN_SETTINGS =                        "Einstellungen öffnen"
L.CLEAR_TRACKED_RECIPES =                "Alle verfolgten Rezepte entfernen"
L.RECIPEID =                             "recipeID"
L.QUANTITY =                             "Menge"
L.TRACK_RECIPE =                         "Ein Rezept verfolgen"
L.UNTRACK_RECIPE =                       "Rezept nicht mehr verfolgen"
L.UNTRACK_RECIPE_ALL =                   "Alle Einträge dieses Rezepts nicht mehr verfolgen"
L.CRAFTING_ACHIEVEMENT =                 "Handwerkserfolg"
L.TRACK_ACHIEVEMENT_RECIPES =            "Die für den verlinkten Erfolg benötigten Rezepte verfolgen"
L.ITEMLINK_OR_ITEMID =                   "itemLink oder itemID"
L.TRACK_REAGENT_RECIPES =                "Alle Rezepte verfolgen, die dieses Reagenz verwenden"

L.GENERAL =                              GENERAL -- "General"
L.SHOW_MINIMAP_ICON =                    "Minikartensymbol anzeigen"
L.SHOW_MINIMAP_ICON_DESC =               "Zeigt das Minikartensymbol an. Wenn du dies deaktivierst, bleibt %s über das Addon-Fach erreichbar." -- %s becomes the addon name
L.TRACK_RECIPE_COOLDOWNS =               "Rezeptabklingzeiten verfolgen"
L.TRACK_RECIPE_COOLDOWNS_DESC =          "Aktiviert die Verfolgung von Rezeptabklingzeiten. Diese werden im Verfolgungsfenster und, falls bereit, beim Einloggen im Chat angezeigt."
L.SHOW_WINDOW_WHEN_READY =               "Fenster anzeigen, wenn bereit"
L.SHOW_WINDOW_WHEN_READY_DESC =          "Öffnet beim Einloggen das Verfolgungsfenster, wenn eine Abklingzeit bereit ist, zusätzlich zur Chatnachricht."
L.SHOW_TOOLTIP_INFORMATION =             "Tooltip-Informationen anzeigen"
L.SHOW_TOOLTIP_INFORMATION_DESC =        "Zeigt im Tooltip des Gegenstands an, wie viele Reagenzien du besitzt bzw. benötigst."
L.SHOW_CRAFTING_INFORMATION =            "Herstellungsinformationen anzeigen"
L.SHOW_CRAFTING_INFORMATION_DESC =       "Zeigt an, mit welchem Beruf ein Ausrüstungsstück hergestellt wird und ob das Rezept auf deinem Account bekannt ist."
L.SHOW_CRAFTING_COST =                   "Herstellungskosten anzeigen"
L.SHOW_CRAFTING_COST_DESC =              "Zeigt an, wie viel die Herstellung eines Gegenstands kostet, falls diese Informationen verfügbar sind."
L.MINIMUM_REAGENT_QUALITY =              "Minimale Reagenzienqualität"
L.MINIMUM_REAGENT_QUALITY_DESC =         "Lege die Mindestqualität fest, ab der Reagenzien gezählt werden. Simulierte Ergebnisse haben weiterhin Vorrang."
L.LOW =                                  LOW -- "Low"
L.HIGH =                                 HIGH -- "High"
L.INCLUDE_HIGHER_QUALITY =               "Höhere Qualität berücksichtigen"
L.INCLUDE_HIGHER_QUALITY_DESC =          "Ob höherwertige Reagenzien berücksichtigt werden sollen. (Z. B. Stufe-2-Reagenzien im Besitz beim Zählen von Stufe-1-Reagenzien berücksichtigen.)"
L.INCLUDE_HIGHER_QUALITY_DESC2 =         "Höhere Qualitätsstufen werden automatisch berücksichtigt, wenn sie günstiger sind."
L.INCLUDE_HIGHER_QUALITIES_YES =         "Höhere Qualitätsstufen berücksichtigen"
L.INCLUDE_HIGHER_QUALITIES_NO =          "Höhere Qualitätsstufen nicht berücksichtigen"
L.COLLECTION_MODE =                      "Sammlungsmodus"
L.COLLECTION_MODE_DESC =                 "Lege fest, welche Gegenstände beim Klicken auf %s berücksichtigt werden." -- %s becomes "Track New"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_SETTING_DESC =             "Nur Gegenstände mit einem neuen Aussehen berücksichtigen."
L.APPEARANCES_SOURCES =                  "Quellen"
L.APPEARANCES_SOURCES_SETTING_DESC =     "Gegenstände mit einer neuen Quelle berücksichtigen, auch wenn das Aussehen bereits bekannt ist."

L.PROFESSION_WINDOW =                    "Berufsfenster"
L.FILTER_OPTIONAL_REAGENTS =             "Optionale Reagenzien filtern"
L.FILTER_OPTIONAL_REAGENTS_DESC =        "Wenn %s für optionale Reagenzien aktiviert ist, kombinierbare Gegenstände ausblenden." -- %s becomes "Hide Unavailable"
L.SPEND_TO_NEXT_PERK =                   "Bis zum nächsten Vorteil investieren"
L.SPEND_TO_NEXT_PERK_DESC =              "Mit Umschalt+Klick auf einen Berufswissensknoten werden Punkte bis zum nächsten Vorteil ausgegeben."
L.ENHANCED_ORDERS =                      "Verbesserte Aufträge"
L.ENHANCED_ORDERS_DESC =                 "Verbessert die Vorschau von Auftragsbelohnungen und Provisionen und fügt Symbole für Erstherstellungen, unbekannte Rezepte und verfolgte Rezepte hinzu."
L.QUICK_ORDER_DURATION =                 "Dauer des Schnellauftrags"
L.QUICK_ORDER_DURATION_DESC =            "Dauer für Schnellaufträge festlegen."
L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

L.TRACKING_WINDOW =                      "Verfolgungsfenster"
L.SHOW_HELP_TOOLTIPS =                   "Hilfe-Tooltips anzeigen"
L.SHOW_HELP_TOOLTIPS_DESC =              "Zeigt die verfügbaren Mausaktionen beim Zeigen auf Einträge im Verfolgungsfenster an."
L.WINDOW_POSITION_PER_CHAR =             "Fensterposition pro Charakter"
L.WINDOW_POSITION_PER_CHAR_DESC =        "Fensterposition für jeden Charakter separat speichern statt accountweit."
L.TRACK_RECIPES_PER_CHAR =               "Rezepte pro Charakter verfolgen"
L.TRACK_RECIPES_PER_CHAR_DESC =          "Rezepte pro Charakter statt accountweit verfolgen."
L.SHOW_REMAINING_REAGENTS =              "Verbleibende Reagenzien anzeigen"
L.SHOW_REMAINING_REAGENTS_DESC =         "Im Verfolgungsfenster nur die noch benötigte Menge eines Reagenzes anzeigen, statt vorhanden/benötigt."
L.UNTRACK_ON_CRAFT =                     "Nach Herstellung nicht mehr verfolgen"
L.UNTRACK_ON_CRAFT_DESC =                "Entfernt nach erfolgreicher Herstellung eines verfolgten Rezepts eine Einheit aus der Liste."
L.CLOSE_WINDOW_WHEN_DONE =               "Fenster nach Abschluss schließen"
L.CLOSE_WINDOW_WHEN_DONE_DESC =          "Schließt das Verfolgungsfenster nach der Herstellung des letzten verfolgten Rezepts."

-- Tracking window
L.CLOSE_WINDOW =                         "Fenster schließen"
L.LOCK_WINDOW =                          "Fenster sperren"
L.UNLOCK_WINDOW =                        "Fenster entsperren"
L.UPDATE_AUCTIONATOR_LIST1 =             "Auctionator-Einkaufsliste aktualisieren"
L.UPDATE_AUCTIONATOR_LIST2 =             "Die Einkaufsliste wird automatisch beim Öffnen des Auktionshauses erstellt"
L.DOUBLE =                               "Doppelt" -- Followed by LMB or RMB
L.CTRL =                                 "Strg" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Umschalt" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "Größe automatisch an das Fenster anpassen"
L.LINK_RECIPE =                          "Rezept verlinken"
L.OPEN_RECIPE =                          "Rezept öffnen"
L.CRAFT_RECIPE =                         "Dieses Rezept herstellen"
L.LINK_REAGENT =                         "Reagenz verlinken"
L.TRACK_RECIPE_SUBREAGENT =              "Rezept zur Herstellung dieses Reagenzes verfolgen, falls vorhanden"
L.REMOVE_COOLDOWN_REMINDER =             "Diese Abklingzeiterinnerung entfernen"

L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.ITEMS =                                ITEMS -- "Items"
L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.COSTS =                                "Kosten"
L.COOLDOWNS =                            "Abklingzeiten"
L.CLEAR_CONFIRMATION =                   "Dadurch werden alle Rezepte entfernt."
L.CONFIRMATION =                         "Möchtest du fortfahren?"
L.SUBREAGENTS1 =                         "Mehrere Rezepte können %s herstellen" -- %s becomes an item link
L.SUBREAGENTS2 =                         "Bitte wähle eine der folgenden Optionen:"
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
L.MERCHANT_BUY =                         "Alle verfolgten Reagenzien kaufen, falls verfügbar."

L.READY =                                READY -- "Ready"
L.DAYS =                                 "T"
L.HOURS =                                "Std."
L.MINUTES =                              "Min."
L.READY_TO_CRAFT =                       "%s kann auf %s wieder hergestellt werden" -- %s becomes a recipe name, and character name

L.MORE_NEEDED =                          "%d weitere benötigt" -- %d becomes a number
L.MADE_WITH =                            "Hergestellt mit %s" -- %s becomes a profession
L.RECIPE_LEARNED =                       "Rezept erlernt"
L.RECIPE_UNLEARNED =                     "Rezept nicht erlernt"
L.CRAFTING_COST =                        "Herstellungskosten"

-- Profession window
L.TRACK =                                TRACK_QUEST_ABBREV -- "Track"
L.UNTRACK =                              PROFESSIONS_UNTRACK_RECIPE -- "Untrack"
L.RANK =                                 RANK -- "Rank"
L.MILLING_INFORMATION =                  "Mahl-Informationen"
L.THAUMATURGY_INFORMATION =              "Thaumaturgie-Informationen"
L.FROM =                                 "von" -- Preceded by a percentage, followed by an item link
L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
L.SWITCH_AVAILABLE_PETS =                "Zwischen verfügbaren Haustieren wechseln"
L.TRACK_NEW =                            "Neues verfolgen"
L.CURRENT_SETTING =                      "Aktuelle Einstellung:"
L.NEW_APPEARANCES =                      "neue Aussehen"
L.NEW_APPEARANCES_AND_SOURCES =          "neue Aussehen und Quellen"
L.ADDED_RECIPES =                        "%d sichtbare Rezepte für %s geprüft. %d Rezepte verfolgt." -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

L.RECHARGED =                            "Vollständig aufgeladen"
L.PROFTOOL_AUTOEQUIP =                   "Dieses Werkzeug automatisch anlegen" -- Followed by L.PROFTOOL_FOR
L.PROFTOOL_FOR =                         "für %s." -- %s becomes one of the two following phrases
L.PROFTOOL_DEFAULT =                     "normale Herstellung"
L.PROFTOOL_ORDERS =                      "Aufträge erledigen"
L.PROFTOOL_DRAG =                        "Ziehe ein Werkzeug hierher."
L.PROFTOOL_EQUIP =                       "Dieses Werkzeug anlegen."
L.PROFTOOL_REMOVE =                      "Dieses Werkzeug entfernen."

L.PERKS_UNLOCKED =                       "freigeschaltete Vorteile"
L.PROFESSION_KNOWLEDGE =                 "Wissen"
L.VENDORS =                              "Händler"
L.RENOWN =                               COVENANT_SANCTUM_TAB_RENOWN -- "Renown "
L.WORLD =                                WORLD -- "World"
L.HIDDEN_PROFESSION_MASTER =             "Versteckter Berufslehrer"
L.WEEKLY =                               WEEKLY -- "Weekly"
L.TREASURE =                             "Schatz"
L.DROP =                                 BATTLE_PET_SOURCE_1 -- "Drop"
L.CATCHUP_KNOWLEDGE =                    "Verfügbares Aufholwissen:"
L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

L.AUCTION_ADDONS =                       "Auctionator, Oribos Exchange oder TradeSkillMaster"
L.ORDERS_PRICING_MISSING =               "Fehlt"
L.ORDERS_PRICING_UPDATE =                "Mit %s aktualisieren oder scannen." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_SET_CRITERIA =                  "Kriterien für die Auftragsverfolgung festlegen."
L.ORDERS_COST_NEED =                     "Kosteneinstellungen funktionieren nur mit: %s." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_MAX_COST_KNOWLEDGE =            "Maximale Kosten pro Wissenspunkt:"
L.ORDERS_MAX_COST_ARTISAN =              "Maximale Kosten pro Handwerkswährung:" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "Maximale Kosten pro Belohnungsbeutel:" -- This refers to Artisan's Payout bag
L.ORDERS_TRACK_AFTER_RESET =             "Nach dem wöchentlichen Reset verfügbare Aufträge verfolgen"
L.ORDERS_TRACK_CONCENTRATION =           "Aufträge mit Konzentrationskosten verfolgen:"
L.ORDERS_TRACK_ON =                      "Verfolgen auf %s:"-- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "Warteschlange"
L.ORDERSQUEUE_QUEUED =                   "Aufträge in der Warteschlange:"
L.ORDERSQUEUE_NEXT =                     "Nächster Auftrag"
L.ORDERSQUEUE_CLAIM =                    "Auftrag einlösen"
L.ORDERSQUEUE_CRAFT =                    "Handwerksauftrag"
L.ORDERSQUEUE_CRAFTING =                 "Wird hergestellt ..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"
L.CANCEL_FORM =                          "Formular abbrechen" -- Cancel Shapeshift Form
L.ORDERSQUEUE_WARNING_QUEST =            "Du hast %s noch nicht abgeholt." -- %s becomes a quest name
L.ORDERSQUEUE_WARNING_REAGENTS =         "Du hast nicht genügend Reagenzien für alle verfolgten Rezepte."
L.ORDERSQUEUE_WARNING_KEYBIND_DK =       "Um die eigene Tastenbelegung von %s zu verwenden, deaktiviere die Einstellung \"Handwerksaufträge\" von DialogKey." -- %s becomes PSL

-- Crafting Orders window
L.RECRAFT_TOOLTIP =                      "Wähle einen Gegenstand mit einem zwischengespeicherten Rezept aus, um ihn zu verfolgen."
L.QUICK_ORDER =                          "Schnellauftrag"
L.QUICKORDER_TOOLTIP1 =                  "Erstellt sofort einen Handwerksauftrag für den angegebenen Empfänger."
L.QUICKORDER_TOOLTIP2 =                  "Verwende %s (nur Großbuchstaben), um einen " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " zu erstellen." -- "Guild Order", %s becomes "GUILD"
L.QUICKORDER_TOOLTIP3 =                  "Verwende einen Charakternamen, um einen " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. " zu erstellen." -- "Personal Order"
L.QUICKORDER_TOOLTIP4 =                  "Empfänger werden pro Rezept gespeichert."
L.USE_LOCAL_REAGENTS =                   "Lokale Reagenzien verwenden"
L.USE_LOCAL_REAGENTS_DESC =              "Verwendet verfügbare lokale Reagenzien (mit der niedrigsten Qualität). Welche Reagenzien verwendet werden, kann nicht angepasst werden."
L.REPEAT_LAST_QUICK_ORDER =              "Wiederholt den letzten Schnellauftrag dieses Charakters"
L.RECIPIENT =                            "Empfänger"

L.FALSE =                                "falsch"
L.TRUE =                                 "wahr"
L.NO_LAST_QUICK_ORDER_FOUND =            "Kein letzter Schnellauftrag gefunden"
L.ERROR =                                "Fehler:"
L.ERROR_CRAFTSIM =                       "Informationen von CraftSim konnten nicht gelesen werden"
L.ERROR_REAGENTS =                       "Schnellauftrag für Gegenstände mit obligatorischen Reagenzien kann nicht erstellt werden"
L.ERROR_WARBANK =                        "Schnellauftrag für Gegenstände in der Kriegsmeutenbank kann nicht erstellt werden"
L.ERROR_GUILD =                          "Du kannst keinen " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " erstellen, wenn du keiner Gilde angehörst." -- "Guild Order"
L.ERROR_RECIPIENT =                      "Zielempfänger kann diesen Gegenstand nicht herstellen. Bitte gib einen gültigen Empfängernamen ein"
L.ERROR_MULTISIM =                       "Es wurden keine simulierten Reagenzien verwendet. Bitte aktiviere nur eines der folgenden unterstützten Addons:"
