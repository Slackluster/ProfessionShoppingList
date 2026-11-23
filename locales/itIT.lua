----------------------------------------
-- Profession Shopping List: itIT.lua --
----------------------------------------
-- Italian (Italy) localisation
-- Translator(s):

if GetLocale() ~= "itIT" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "È disponibile una nuova versione di %s:" -- %s becomes the addon name

L.RESET_DONE =                           "Dati ripristinati correttamente."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.DEBUG_ENABLED =                        "Modalità debug attivata"
L.DEBUG_DISABLED =                       "Modalità debug disattivata"
L.INVALID_PARAMETERS =                   "Parametri non validi"
L.INVALID_COMMAND =                      "Comando non valido"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Lo sviluppo di questo addon richiede molto tempo e impegno."
L.SUPPORT_TEXTLONG2 =                    "Ti invitiamo a sostenere economicamente lo sviluppatore."
L.SUPPORT =                              "Supporto"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Grazie!"
L.FEEDBACK_AND_HELP =                    "Feedback e aiuto"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Entra nel server Discord."
L.CTRL_C_COPY =                          "Ctrl+C per copiare:"
L.LINK_COPIED =                          "Collegamento copiato negli appunti"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " e comandi slash" -- "Keybindings"
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. ": Mostra/nascondi finestra"
L.ORDERS_QUEUE =                         "Coda degli ordini"
L.TOGGLE_TRACKING_WINDOW =               "Mostra/nascondi finestra di tracciamento"
L.RESET_WINDOW_POSITION =                "Ripristina posizione finestra di tracciamento"
L.RESET_SAVED_DATA =                     "Ripristina dati salvati"
L.OPEN_SETTINGS =                        "Apri le impostazioni"
L.CLEAR_TRACKED_RECIPES =                "Cancella tutte le ricette tracciate"
L.RECIPEID =                             "recipeID"
L.QUANTITY =                             "quantità"
L.TRACK_RECIPE =                         "Traccia una ricetta"
L.UNTRACK_RECIPE =                       "Smetti di tracciare una ricetta"
L.UNTRACK_RECIPE_ALL =                   "Smetti di tracciare tutte le copie di una ricetta"
L.CRAFTING_ACHIEVEMENT =                 "conquista di creazione"
L.TRACK_ACHIEVEMENT_RECIPES =            "Traccia le ricette necessarie per la conquista collegata"
L.ITEMLINK_OR_ITEMID =                   "itemLink o itemID"
L.TRACK_REAGENT_RECIPES =                "Traccia tutte le ricette che usano questo reagente"

L.GENERAL =                              GENERAL -- "General"
L.SHOW_MINIMAP_ICON =                    "Mostra icona minimappa"
L.SHOW_MINIMAP_ICON_DESC =               "Mostra l'icona sulla minimappa. Se disattivata, %s rimane disponibile dal Comparto addon." -- %s becomes the addon name
L.TRACK_RECIPE_COOLDOWNS =               "Traccia i tempi di recupero delle ricette"
L.TRACK_RECIPE_COOLDOWNS_DESC =          "Attiva il tracciamento dei tempi di recupero delle ricette. Verranno mostrati nella finestra di tracciamento e, se pronti, in chat all'accesso."
L.SHOW_WINDOW_WHEN_READY =               "Mostra finestra quando pronto"
L.SHOW_WINDOW_WHEN_READY_DESC =          "Apri la finestra di tracciamento all'accesso quando una ricarica è pronta, oltre al promemoria in chat."
L.SHOW_TOOLTIP_INFORMATION =             "Mostra informazioni nel tooltip"
L.SHOW_TOOLTIP_INFORMATION_DESC =        "Mostra nel tooltip dell'oggetto quanti reagenti possiedi e quanti te ne servono."
L.SHOW_CRAFTING_INFORMATION =            "Mostra informazioni di creazione"
L.SHOW_CRAFTING_INFORMATION_DESC =       "Mostra con quale professione è stato creato un pezzo di equipaggiamento e se la ricetta è conosciuta sul tuo account."
L.SHOW_CRAFTING_COST =                   "Mostra costo di creazione"
L.SHOW_CRAFTING_COST_DESC =              "Mostra il costo per creare un oggetto, se l'informazione è disponibile."
L.MINIMUM_REAGENT_QUALITY =              "Qualità minima reagenti"
L.MINIMUM_REAGENT_QUALITY_DESC =         "Imposta la qualità minima dei reagenti da conteggiare. I risultati simulati hanno comunque la precedenza."
L.LOW =                                  LOW -- "Low"
L.HIGH =                                 HIGH -- "High"
L.INCLUDE_HIGHER_QUALITY =               "Includi qualità superiore"
L.INCLUDE_HIGHER_QUALITY_DESC =          "Se conteggiare reagenti di qualità superiore. (Ad esempio, includere reagenti di livello 2 posseduti quando si contano quelli di livello 1.)"
L.INCLUDE_HIGHER_QUALITY_DESC2 =         "Le qualità superiori verranno conteggiate automaticamente se sono più economiche."
L.INCLUDE_HIGHER_QUALITIES_YES =         "Includi qualità superiori"
L.INCLUDE_HIGHER_QUALITIES_NO =          "Non includere qualità superiori"
L.COLLECTION_MODE =                      "Modalità collezione"
L.COLLECTION_MODE_DESC =                 "Imposta quali oggetti includere quando usi il pulsante %s." -- %s becomes "Track New"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_SETTING_DESC =             "Includi solo oggetti con un nuovo aspetto."
L.APPEARANCES_SOURCES =                  "Fonti"
L.APPEARANCES_SOURCES_SETTING_DESC =     "Includi gli oggetti con una nuova fonte, anche per aspetti già conosciuti."

L.PROFESSION_WINDOW =                    "Finestra delle professioni"
L.FILTER_OPTIONAL_REAGENTS =             "Filtra reagenti facoltativi"
L.FILTER_OPTIONAL_REAGENTS_DESC =        "Quando %s è selezionato per i reagenti opzionali, nascondi gli oggetti combinabili." -- %s becomes "Hide Unavailable"
L.SPEND_TO_NEXT_PERK =                   "Spendi fino al prossimo beneficio"
L.SPEND_TO_NEXT_PERK_DESC =              "Maiusc+clic su un nodo di conoscenza professionale spende punti fino al prossimo beneficio."
L.ENHANCED_ORDERS =                      "Ordini migliorati"
L.ENHANCED_ORDERS_DESC =                 "Migliora l'anteprima delle ricompense e delle commissioni degli ordini e aggiunge icone per prime creazioni, ricette non apprese e ricette tracciate."
L.QUICK_ORDER_DURATION =                 "Durata ordine rapido"
L.QUICK_ORDER_DURATION_DESC =            "Imposta la durata degli ordini rapidi."
L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

L.TRACKING_WINDOW =                      "Finestra di tracciamento"
L.SHOW_HELP_TOOLTIPS =                   "Mostra tooltip di aiuto"
L.SHOW_HELP_TOOLTIPS_DESC =              "Mostra le azioni del mouse disponibili passando sopra le voci nella finestra di tracciamento."
L.WINDOW_POSITION_PER_CHAR =             "Posizione finestra per personaggio"
L.WINDOW_POSITION_PER_CHAR_DESC =        "Salva la posizione della finestra per personaggio invece che per account."
L.TRACK_RECIPES_PER_CHAR =               "Traccia ricette per personaggio"
L.TRACK_RECIPES_PER_CHAR_DESC =          "Traccia le ricette per personaggio invece che per account."
L.SHOW_REMAINING_REAGENTS =              "Mostra reagenti mancanti"
L.SHOW_REMAINING_REAGENTS_DESC =         "Nella finestra di tracciamento mostra solo quanti reagenti mancano, invece di posseduti/necessari."
L.UNTRACK_ON_CRAFT =                     "Smetti di tracciare dopo la creazione"
L.UNTRACK_ON_CRAFT_DESC =                "Rimuove un'unità da una ricetta tracciata dopo averla creata con successo."
L.CLOSE_WINDOW_WHEN_DONE =               "Chiudi finestra al termine"
L.CLOSE_WINDOW_WHEN_DONE_DESC =          "Chiudi la finestra di tracciamento dopo aver creato l'ultima ricetta tracciata."

-- Tracking window
L.CLOSE_WINDOW =                         "Chiudi finestra"
L.LOCK_WINDOW =                          "Blocca finestra"
L.UNLOCK_WINDOW =                        "Sblocca finestra"
L.UPDATE_AUCTIONATOR_LIST1 =             "Aggiorna la lista della spesa di Auctionator"
L.UPDATE_AUCTIONATOR_LIST2 =             "La lista della spesa viene generata automaticamente quando apri la casa d'aste"
L.DOUBLE =                               "Doppio" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Maiusc" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "Ridimensiona automaticamente alla finestra"
L.LINK_RECIPE =                          "Collega la ricetta"
L.OPEN_RECIPE =                          "Apri la ricetta"
L.CRAFT_RECIPE =                         "Crea questa ricetta"
L.LINK_REAGENT =                         "Collega il reagente"
L.TRACK_RECIPE_SUBREAGENT =              "Traccia la ricetta per creare questo reagente, se esiste"
L.REMOVE_COOLDOWN_REMINDER =             "Rimuovi questo promemoria di ricarica"

L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.ITEMS =                                ITEMS -- "Items"
L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.COSTS =                                "Costi"
L.COOLDOWNS =                            "Ricariche"
L.CLEAR_CONFIRMATION =                   "Questo cancellerà tutte le ricette."
L.CONFIRMATION =                         "Vuoi continuare?"
L.SUBREAGENTS1 =                         "Esistono più ricette che possono creare %s" -- %s becomes an item link
L.SUBREAGENTS2 =                         "Seleziona una delle seguenti opzioni:"
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
L.MERCHANT_BUY =                         "Acquista tutti i reagenti tracciati, se disponibili."

L.READY =                                READY -- "Ready"
L.DAYS =                                 "e"
L.HOURS =                                "h"
L.MINUTES =                              "m"
L.READY_TO_CRAFT =                       "%s può essere creato di nuovo su %s" -- %s becomes a recipe name, and character name

L.MORE_NEEDED =                          "Ne servono ancora %d" -- %d becomes a number
L.MADE_WITH =                            "Creato con %s" -- %s becomes a profession
L.RECIPE_LEARNED =                       "ricetta appresa"
L.RECIPE_UNLEARNED =                     "ricetta non appresa"
L.CRAFTING_COST =                        "Costo di creazione"

-- Profession window
L.TRACK =                                TRACK_QUEST_ABBREV -- "Track"
L.UNTRACK =                              PROFESSIONS_UNTRACK_RECIPE -- "Untrack"
L.RANK =                                 RANK -- "Rank"
L.MILLING_INFORMATION =                  "Informazioni di macinazione"
L.THAUMATURGY_INFORMATION =              "Informazioni di taumaturgia"
L.FROM =                                 "da" -- Preceded by a percentage, followed by an item link
L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
L.SWITCH_AVAILABLE_PETS =                "Passa tra le mascotte disponibili"
L.TRACK_NEW =                            "Traccia nuovi"
L.CURRENT_SETTING =                      "Impostazione attuale:"
L.NEW_APPEARANCES =                      "nuovi aspetti"
L.NEW_APPEARANCES_AND_SOURCES =          "nuovi aspetti e fonti"
L.ADDED_RECIPES =                        "Controllate %d ricette visibili per %s. Tracciate %d ricette." -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

L.RECHARGED =                            "Completamente ricaricato"
L.PROFTOOL_AUTOEQUIP =                   "Equipaggia automaticamente questo strumento" -- Followed by L.PROFTOOL_FOR
L.PROFTOOL_FOR =                         "per %s." -- %s becomes one of the two following phrases
L.PROFTOOL_DEFAULT =                     "creazione normale"
L.PROFTOOL_ORDERS =                      "esecuzione degli ordini"
L.PROFTOOL_DRAG =                        "Trascina qui uno strumento."
L.PROFTOOL_EQUIP =                       "Equipaggia questo strumento."
L.PROFTOOL_REMOVE =                      "Rimuovi questo strumento."

L.PERKS_UNLOCKED =                       "benefici sbloccati"
L.PROFESSION_KNOWLEDGE =                 "conoscenza"
L.VENDORS =                              "Mercanti"
L.RENOWN =                               COVENANT_SANCTUM_TAB_RENOWN -- "Renown "
L.WORLD =                                WORLD -- "World"
L.HIDDEN_PROFESSION_MASTER =             "Maestro delle professioni nascosto"
L.WEEKLY =                               WEEKLY -- "Weekly"
L.TREASURE =                             "Tesoro"
L.DROP =                                 BATTLE_PET_SOURCE_1 -- "Drop"
L.CATCHUP_KNOWLEDGE =                    "Conoscenza di recupero disponibile:"
L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

L.AUCTION_ADDONS =                       "Auctionator, Oribos Exchange o TradeSkillMaster"
L.ORDERS_PRICING_MISSING =               "Mancante"
L.ORDERS_PRICING_UPDATE =                "Aggiorna o scansiona con %s." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_SET_CRITERIA =                  "Imposta i criteri per tracciare gli ordini."
L.ORDERS_COST_NEED =                     "Le impostazioni dei costi funzionano solo con: %s." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_MAX_COST_KNOWLEDGE =            "Costo massimo per punto conoscenza:"
L.ORDERS_MAX_COST_ARTISAN =              "Costo massimo per valuta artigianale:" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "Costo massimo per borsa ricompensa:" -- This refers to Artisan's Payout bag
L.ORDERS_TRACK_AFTER_RESET =             "Traccia gli ordini disponibili dopo il ripristino settimanale"
L.ORDERS_TRACK_CONCENTRATION =           "Traccia ordini che richiedono concentrazione:"
L.ORDERS_TRACK_ON =                      "Traccia su %s:"-- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "Coda"
L.ORDERSQUEUE_QUEUED =                   "Ordini in coda:"
L.ORDERSQUEUE_NEXT =                     "Ordine successivo"
L.ORDERSQUEUE_CLAIM =                    "Riscatta ordine"
L.ORDERSQUEUE_CRAFT =                    "Ordine di creazione"
L.ORDERSQUEUE_CRAFTING =                 "Creazione in corso..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"
L.CANCEL_FORM =                          "Annulla modulo" -- Cancel Shapeshift Form
L.ORDERSQUEUE_WARNING_QUEST =            "Non hai ancora ritirato %s." -- %s becomes a quest name
L.ORDERSQUEUE_WARNING_REAGENTS =         "Non hai reagenti sufficienti per tutte le ricette tracciate."
L.ORDERSQUEUE_WARNING_KEYBIND_DK =       "Per usare la scorciatoia di %s, disattiva l'impostazione \"Ordini di creazione\" di DialogKey." -- %s becomes PSL

-- Crafting Orders window
L.RECRAFT_TOOLTIP =                      "Seleziona un oggetto con una ricetta in cache per tracciarlo."
L.QUICK_ORDER =                          "Ordine rapido"
L.QUICKORDER_TOOLTIP1 =                  "Crea istantaneamente un ordine di creazione per il destinatario specificato."
L.QUICKORDER_TOOLTIP2 =                  "Usa %s (tutto maiuscolo) per creare un " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "." -- "Guild Order", %s becomes "GUILD"
L.QUICKORDER_TOOLTIP3 =                  "Usa il nome di un personaggio per creare un " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "." -- "Personal Order"
L.QUICKORDER_TOOLTIP4 =                  "I destinatari vengono salvati per ogni ricetta."
L.USE_LOCAL_REAGENTS =                   "Usa reagenti locali"
L.USE_LOCAL_REAGENTS_DESC =              "Usa i reagenti locali disponibili (della qualità più bassa). Non è possibile personalizzare quali reagenti vengono usati."
L.REPEAT_LAST_QUICK_ORDER =              "Ripeti l'ultimo ordine rapido eseguito da questo personaggio"
L.RECIPIENT =                            "Destinatario"

L.FALSE =                                "falso"
L.TRUE =                                 "vero"
L.NO_LAST_QUICK_ORDER_FOUND =            "Nessun ultimo ordine rapido trovato"
L.ERROR =                                "Errore:"
L.ERROR_CRAFTSIM =                       "Impossibile leggere le informazioni da CraftSim"
L.ERROR_REAGENTS =                       "Impossibile creare un ordine rapido per gli oggetti con reagenti obbligatori"
L.ERROR_WARBANK =                        "Impossibile creare un ordine rapido con oggetti nella banca della Brigata"
L.ERROR_GUILD =                          "Non puoi creare un " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " se non fai parte di una gilda" -- "Guild Order"
L.ERROR_RECIPIENT =                      "Il destinatario scelto non può creare questo oggetto. Inserisci un nome destinatario valido"
L.ERROR_MULTISIM =                       "Non sono stati utilizzati reagenti simulati. Attiva soltanto uno dei seguenti addon supportati:"
