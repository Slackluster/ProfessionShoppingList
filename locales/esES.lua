----------------------------------------
-- Profession Shopping List: esES.lua --
----------------------------------------
-- Spanish (Spain) localisation
-- Translator(s): Ferran Carril

if GetLocale() ~= "esES" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Hay una versión más nueva de %s disponible:" -- %s becomes the addon name

-- L.RESET_DONE =                           "Data reset performed successfully."
-- L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
-- L.DEBUG_ENABLED =                        "Debug mode enabled"
-- L.DEBUG_DISABLED =                       "Debug mode disabled"
-- L.INVALID_PARAMETERS =                   "Invalid parameters"
L.INVALID_COMMAND =                      "Comando no válido"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Desarrollar este addon requiere una cantidad significativa de tiempo y esfuerzo."
L.SUPPORT_TEXTLONG2 =                    "Por favor, considera apoyar financieramente al desarrollador."
L.SUPPORT =                              "Apoyar"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "¡Gracias!"
L.FEEDBACK_AND_HELP =                    "Comentarios y Ayuda"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Únete al servidor de Discord."
L.CTRL_C_COPY =                          "Ctrl+C para copiar:"
L.LINK_COPIED =                          "Enlace copiado al portapapeles"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " y Comandos" -- "Keybindings"
-- _G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. ": Toggle Window"
-- L.TOGGLE_TRACKING_WINDOW =               "Toggle the tracking window"
-- L.RESET_WINDOW_POSITION =                "Reset the tracking window position"
-- L.RESET_SAVED_DATA =                     "Reset saved data"
L.OPEN_SETTINGS =                        "Abrir opciones"
-- L.CLEAR_TRACKED_RECIPES =                "Clear all tracked recipes"
-- L.RECIPEID =                             "recipeID"
-- L.QUANTITY =                             "quantity"
-- L.TRACK_RECIPE =                         "Track a recipe"
-- L.UNTRACK_RECIPE =                       "Untrack a recipe"
-- L.UNTRACK_RECIPE_ALL =                   "Untrack all of a recipe"
-- L.CRAFTING_ACHIEVEMENT =                 "crafting achievement"
-- L.TRACK_ACHIEVEMENT_RECIPES =            "Track the recipes needed for the linked achievement"
-- L.ITEMLINK_OR_ITEMID =                   "itemLink or itemID"
-- L.TRACK_REAGENT_RECIPES =                "Track all recipes using this reagent"

L.GENERAL =                              GENERAL -- "General"
L.SHOW_MINIMAP_ICON =                    "Mostrar icono de minimapa"
L.SHOW_MINIMAP_ICON_DESC =               "Muestra el icono del minimapa. Si desactivas esto, %s sigue disponible en el apartado de Addons." -- %s becomes the addon name
-- L.TRACK_RECIPE_COOLDOWNS =               "Track Recipe Cooldowns"
-- L.TRACK_RECIPE_COOLDOWNS_DESC =          "Enable the tracking of recipe cooldowns. These will show in the tracking window, and in chat upon login if ready."
-- L.SHOW_WINDOW_WHEN_READY =               "Show Window When Ready"
-- L.SHOW_WINDOW_WHEN_READY_DESC =          "Open the tracking window on login when a cooldown is ready, in addition to the reminder via chat message."
-- L.SHOW_TOOLTIP_INFORMATION =             "Show Tooltip Information"
-- L.SHOW_TOOLTIP_INFORMATION_DESC =        "Show how many of a reagent you have/need on the item's tooltip."
-- L.SHOW_CRAFTING_INFORMATION =            "Show Crafting Information"
-- L.SHOW_CRAFTING_INFORMATION_DESC =       "Show with which profession a piece of gear is made, and if the recipe is known on your account."
-- L.SHOW_CRAFTING_COST =                   "Show Crafting Cost"
-- L.SHOW_CRAFTING_COST_DESC =              "Show how much an item costs to craft, if that information is available."
-- L.MINIMUM_REAGENT_QUALITY =              "Minimum Reagent Quality"
-- L.MINIMUM_REAGENT_QUALITY_DESC =         "Set the minimum quality reagents need to be before they are counted. Simulated results will still override this."
-- L.LOW =                                  LOW -- "Low"
-- L.HIGH =                                 HIGH -- "High"
-- L.INCLUDE_HIGHER_QUALITY =               "Include Higher Quality"
-- L.INCLUDE_HIGHER_QUALITY_DESC =          "Whether or not to count higher quality reagents. (I.e. include owned tier 2 reagents when counting tier 1 reagents.)"
-- L.INCLUDE_HIGHER_QUALITIES_YES =         "Include higher qualities"
-- L.INCLUDE_HIGHER_QUALITIES_NO =          "Don't include higher qualities"
-- L.COLLECTION_MODE =                      "Collection Mode"
-- L.COLLECTION_MODE_DESC =                 "Set which items are included when using the %s button." -- %s becomes "Track New"
-- L.APPEARANCES =                          WARDROBE -- "Appearances"
-- L.APPEARANCES_SETTING_DESC =             "Include items only if they have a new appearance."
-- L.APPEARANCES_SOURCES =                  "Sources"
-- L.APPEARANCES_SOURCES_SETTING_DESC =     "Include items if they are a new source, including for known appearances."

-- L.PROFESSION_WINDOW =                    "Profession Window"
-- L.FILTER_OPTIONAL_REAGENTS =             "Filter Optional Reagents"
-- L.FILTER_OPTIONAL_REAGENTS_DESC =        "When %s is checked for optional reagents, hide combinable items." -- %s becomes "Hide Unavailable"
-- L.SPEND_TO_NEXT_PERK =                   "Spend to Next Perk"
-- L.SPEND_TO_NEXT_PERK_DESC =              "Shift+clicking a profession knowledge node spends points until the next perk."
-- L.ENHANCED_ORDERS =                      "Enhanced Orders"
-- L.ENHANCED_ORDERS_DESC =                 "Enhance the preview of order rewards and commission, and add icons for first crafts, unlearned recipes, and tracked recipes."
-- L.QUICK_ORDER_DURATION =                 "Quick Order Duration"
-- L.QUICK_ORDER_DURATION_DESC =            "Set the duration for placing quick orders."
-- L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
-- L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
-- L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

-- L.TRACKING_WINDOW =                      "Tracking Window"
-- L.SHOW_HELP_TOOLTIPS =                   "Show Help Tooltips"
-- L.SHOW_HELP_TOOLTIPS_DESC =              "Display what mouse actions exist when hovering over entries in the tracking window."
-- L.WINDOW_POSITION_PER_CHAR =             "Window Position per Character"
-- L.WINDOW_POSITION_PER_CHAR_DESC =        "Save the window position per character, instead of account wide."
-- L.TRACK_RECIPES_PER_CHAR =               "Track Recipes per Character"
-- L.TRACK_RECIPES_PER_CHAR_DESC =          "Track recipes per character, instead of account wide."
-- L.SHOW_REMAINING_REAGENTS =              "Show Remaining Reagents"
-- L.SHOW_REMAINING_REAGENTS_DESC =         "Only show how many reagents you still need in the tracking window, instead of have/need."
-- L.UNTRACK_ON_CRAFT =                     "Untrack on Craft"
-- L.UNTRACK_ON_CRAFT_DESC =                "Remove one of a tracked recipe when you successfully craft it."
-- L.CLOSE_WINDOW_WHEN_DONE =               "Close Window When Done"
-- L.CLOSE_WINDOW_WHEN_DONE_DESC =          "Close the tracking window after crafting the last tracked recipe."

-- Tracking window
-- L.CLOSE_WINDOW =                         "Close the window"
-- L.LOCK_WINDOW =                          "Lock the window"
-- L.UNLOCK_WINDOW =                        "Unlock the window"
-- L.UPDATE_AUCTIONATOR_LIST1 =             "Update the Auctionator shopping list"
-- L.UPDATE_AUCTIONATOR_LIST2 =             "The shopping list is automatically generated when opening the Auction House"
L.DOUBLE =                               "Doble" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Mayús" -- Followed by LMB or RMB
-- L.AUTOSIZE_WINDOW =                      "Autosize to fit the window"
-- L.LINK_RECIPE =                          "Link the recipe"
-- L.OPEN_RECIPE =                          "Open the recipe"
-- L.CRAFT_RECIPE =                         "Craft this recipe"
-- L.LINK_REAGENT =                         "Link the reagent"
-- L.TRACK_RECIPE_SUBREAGENT =              "Track the recipe to craft this reagent, if one exists"
-- L.REMOVE_COOLDOWN_REMINDER =             "Remove this specific cooldown reminder"

-- L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
-- L.ITEMS =                                ITEMS -- "Items"
-- L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
-- L.COSTS =                                "Costs"
-- L.COOLDOWNS =                            "Cooldowns"
-- L.CLEAR_CONFIRMATION =                   "This will clear all recipes."
-- L.CONFIRMATION =                         "Do you wish to proceed?"
-- L.SUBREAGENTS1 =                         "There are multiple recipes that can create %s" -- %s becomes an item link
-- L.SUBREAGENTS2 =                         "Please select one of the following:"
-- L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
-- L.MERCHANT_BUY =                         "Buy all tracked reagents, if available."

-- L.READY =                                "Ready"
-- L.DAYS =                                 "d"
-- L.HOURS =                                "h"
-- L.MINUTES =                              "m"
-- L.READY_TO_CRAFT =                       "%s is ready to craft again on %s" -- %s becomes a recipe name, and character name

-- L.MORE_NEEDED =                          "%d more needed" -- %d becomes a number
-- L.MADE_WITH =                            "Made with %s" -- %s becomes a profession
-- L.RECIPE_LEARNED =                       "recipe learned"
-- L.RECIPE_UNLEARNED =                     "recipe not learned"
-- L.CRAFTING_COST =                        "Crafting Cost"

-- Profession window
-- L.TRACK =                                "Track"
-- L.UNTRACK =                              "Untrack"
-- L.RANK =                                 RANK -- "Rank"
-- L.MILLING_INFORMATION =                  "Milling Information"
-- L.THAUMATURGY_INFORMATION =              "Thaumaturgy Information"
-- L.FROM =                                 "from" -- Preceded by a percentage, followed by an item link
-- L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
-- L.SWITCH_AVAILABLE_PETS =                "Switch between available pets"
-- L.TRACK_NEW =                            "Track New"
-- L.CURRENT_SETTING =                      "Current setting:"
-- L.NEW_APPEARANCES =                      "new appearances"
-- L.NEW_APPEARANCES_AND_SOURCES =          "new appearances and sources"
-- L.ADDED_RECIPES =                        "Checked %d visible recipes for %s. Tracked %d recipes." -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

-- L.RECHARGED =                            "Fully recharged"
-- L.PROFTOOL_AUTOEQUIP =                   "Automatically equip this tool" -- Followed by L.PROFTOOL_FOR
-- L.PROFTOOL_FOR =                         "for %s." -- %s becomes one of the two following phrases
-- L.PROFTOOL_DEFAULT =                     "regular crafting"
-- L.PROFTOOL_ORDERS =                      "doing orders"
-- L.PROFTOOL_DRAG =                        "Drag a tool here."
-- L.PROFTOOL_EQUIP =                       "Equip this tool."
-- L.PROFTOOL_REMOVE =                      "Remove this tool."

-- L.PERKS_UNLOCKED =                       "perks unlocked"
-- L.PROFESSION_KNOWLEDGE =                 "knowledge"
-- L.VENDORS =                              "Vendors"
-- L.RENOWN =                               COVENANT_SANCTUM_TAB_RENOWN -- "Renown "
-- L.WORLD =                                "World"
-- L.HIDDEN_PROFESSION_MASTER =             "Hidden Profession Master"
-- L.WEEKLY =                               WEEKLY -- "Weekly"
-- L.TREASURE =                             "Treasure"
-- L.DROP =                                 BATTLE_PET_SOURCE_1 -- "Drop"
-- L.CATCHUP_KNOWLEDGE =                    "Available catch-up knowledge:"
-- L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

-- L.AUCTION_ADDONS =                       "Auctionator, Oribos Exchange, or TradeSkillMaster"
-- L.ORDERS_PRICING_MISSING =               "Missing"
-- L.ORDERS_PRICING_UPDATE =                "Update or scan with %s." -- %s becomes L.AUCTION_ADDONS
-- L.ORDERS_SET_CRITERIA =                  "Set the criteria to track orders."
-- L.ORDERS_COST_NEED =                     "Cost settings only work with: %s." -- %s becomes L.AUCTION_ADDONS
-- L.ORDERS_MAX_COST_KNOWLEDGE =            "Maximum cost per knowledge point:"
-- L.ORDERS_MAX_COST_ARTISAN =              "Maximum cost per artisan currency:" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
-- L.ORDERS_MAX_COST_PAYOUT =               "Maximum cost per reward bag:" -- This refers to Artisan's Payout bag
-- L.ORDERS_TRACK_AFTER_RESET =             "Track orders available after weekly reset"
-- L.ORDERS_TRACK_CONCENTRATION =           "Track orders costing concentration:"
-- L.ORDERS_TRACK_ON =                      "Track on %s:"-- %s becomes a character name

-- L.ORDERSQUEUE_QUEUE =                    "Queue"
-- L.ORDERSQUEUE_QUEUED =                   "Orders in queue:"
-- L.ORDERSQUEUE_NEXT =                     "Next Order"
-- L.ORDERSQUEUE_CLAIM =                    "Claim Order"
-- L.ORDERSQUEUE_CRAFT =                    "Craft Order"
-- L.ORDERSQUEUE_CRAFTING =                 "Crafting..."
-- L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"
-- L.ORDERSQUEUE_WARNING_QUEST =            "You have not picked up %s." -- %s becomes a quest name
-- L.ORDERSQUEUE_WARNING_REAGENTS =         "You do not have enough reagents for all tracked recipes."

-- Crafting Orders window
-- L.RECRAFT_TOOLTIP =                      "Select an item with a cached recipe to track it."
-- L.QUICK_ORDER =                          "Quick Order"
-- L.QUICKORDER_TOOLTIP1 =                  "Instantly create a crafting order for the specified recipient."
-- L.QUICKORDER_TOOLTIP2 =                  "Use %s (all uppercase) to place a " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "." -- "Guild Order", %s becomes "GUILD"
-- L.QUICKORDER_TOOLTIP3 =                  "Use a character name to place a " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "." -- "Personal Order"
-- L.QUICKORDER_TOOLTIP4 =                  "Recipients are saved per recipe."
-- L.USE_LOCAL_REAGENTS =                   "Use local reagents"
-- L.USE_LOCAL_REAGENTS_DESC =              "Use (the lowest quality) available local reagents. Which reagents are used cannot be customised."
-- L.REPEAT_LAST_QUICK_ORDER =              "Repeat the last Quick Order done on this character"
-- L.RECIPIENT =                            "Recipient"

-- L.FALSE =                                "false"
-- L.TRUE =                                 "true"
-- L.NO_LAST_QUICK_ORDER_FOUND =            "No last Quick Order found"
-- L.ERROR =                                "Error:"
-- L.ERROR_CRAFTSIM =                       "Could not read the information from CraftSim"
-- L.ERROR_REAGENTS =                       "Can't create a Quick Order for items with mandatory reagents"
-- L.ERROR_WARBANK =                        "Can't create a Quick Order with items in the Warbank"
-- L.ERROR_GUILD =                          "Can't create a " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " while not in a guild" -- "Guild Order"
-- L.ERROR_RECIPIENT =                      "Target recipient cannot craft that item. Please enter a valid recipient name"
-- L.ERROR_MULTISIM =                       "No simulated reagents have been used. Please only enable one of the following supported addons:"
