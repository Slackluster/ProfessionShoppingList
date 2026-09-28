----------------------------------------
-- Profession Shopping List: frFR.lua --
----------------------------------------
-- French (France) localisation
-- Translator(s): Klep-Ysondre

if GetLocale() ~= "frFR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Une nouvelle version de %s est disponible :" -- %s becomes the addon name

L.RESET_DONE =                           "La réinitialisation des données a été effectuée avec succès."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.DEBUG_ENABLED =                        "Mode débogage activé"
L.DEBUG_DISABLED =                       "Mode débogage désactivé"
L.INVALID_PARAMETERS =                   "Paramètres non valides"
L.INVALID_COMMAND =                      "Commande non valide"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Le développement de cette extension demande beaucoup de temps et d’efforts."
L.SUPPORT_TEXTLONG2 =                    "Veuillez envisager de soutenir financièrement le développeur."
L.SUPPORT =                              "Soutien"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Merci !"
L.FEEDBACK_AND_HELP =                    "Commentaires et aide"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Rejoignez le serveur Discord."
L.CTRL_C_COPY =                          "Ctrl + C pour copier :"
L.LINK_COPIED =                          "lien a été copié dans le presse-papiers"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " & Commandes « Slash »" -- "Keybindings"
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. " : afficher / masquer la fenêtre"
L.TOGGLE_TRACKING_WINDOW =               "Afficher / masquer la fenêtre de suivi"
L.RESET_WINDOW_POSITION =                "Réinitialiser la position de la fenêtre de suivi"
L.RESET_SAVED_DATA =                     "Réinitialiser les données enregistrées"
L.OPEN_SETTINGS =                        "Ouvrir les paramètres"
L.CLEAR_TRACKED_RECIPES =                "Effacer toutes les recettes suivies"
L.RECIPEID =                             "recipeID"
L.QUANTITY =                             "quantité"
L.TRACK_RECIPE =                         "Suivre une recette"
L.UNTRACK_RECIPE =                       "Annuler le suivi d’une recette"
L.UNTRACK_RECIPE_ALL =                   "Annuler le suivi de toutes les unités d’une recette"
L.CRAFTING_ACHIEVEMENT =                 "haut fait de métier"
L.TRACK_ACHIEVEMENT_RECIPES =            "Suivre les recettes nécessaires pour le haut fait sélectionné"
-- L.ITEMLINK_OR_ITEMID =                   "itemLink or itemID"
-- L.TRACK_REAGENT_RECIPES =                "Track all recipes using this reagent"

L.GENERAL =                              GENERAL    -- "General"
L.SHOW_MINIMAP_ICON =                    "Afficher le bouton de la mini-carte"
L.SHOW_MINIMAP_ICON_DESC =               "Afficher le bouton de la mini-carte. Si vous désactivez cette fonction, %s sera toujours disponible dans le panneau des addons." -- %s becomes the addon name
L.TRACK_RECIPE_COOLDOWNS =               "Suivre le temps de recharge des recettes"
L.TRACK_RECIPE_COOLDOWNS_DESC =          "Activer le suivi des temps de recharge des recettes. Ceux-ci s’afficheront dans la fenêtre de suivi, et dans le chat à la connexion s’ils sont prêts."
L.SHOW_WINDOW_WHEN_READY =               "Afficher la fenêtre lorsque « Prêt »"
L.SHOW_WINDOW_WHEN_READY_DESC =          "Ouvrir la fenêtre de suivi lors de la connexion lorsqu’un temps de recharge est prêt, en plus du rappel par message de chat."
L.SHOW_TOOLTIP_INFORMATION =             "Afficher les informations de l’infobulle"
L.SHOW_TOOLTIP_INFORMATION_DESC =        "Afficher la quantité de composants que vous possédez / avez besoin dans l’infobulle de l’objet."
L.SHOW_CRAFTING_INFORMATION =            "Afficher les informations d’artisanat"
L.SHOW_CRAFTING_INFORMATION_DESC =       "Afficher avec quel métier une pièce d’équipement est fabriquée et si la recette est connue sur votre compte."
-- L.SHOW_CRAFTING_COST =                   "Show Crafting Cost"
-- L.SHOW_CRAFTING_COST_DESC =              "Show how much an item costs to craft, if that information is available."
L.MINIMUM_REAGENT_QUALITY =              "Qualité minimale de composant"
-- L.MINIMUM_REAGENT_QUALITY_DESC =         "Set the minimum quality reagents need to be before they are counted. Simulated results will still override this."
L.LOW =                                  LOW -- "Low"
L.HIGH =                                 HIGH -- "High"
L.INCLUDE_HIGHER_QUALITY =               "Inclure une qualité supérieure"
L.INCLUDE_HIGHER_QUALITY_DESC =          "Faut-il inclure ou non les réactifs de qualité supérieure ? (Par exemple, faut-il inclure les réactifs de niveau 2 détenus lors du décompte des réactifs de niveau 1 ?)"
L.INCLUDE_HIGHER_QUALITIES_YES =         "Inclure les qualités supérieures"
L.INCLUDE_HIGHER_QUALITIES_NO =          "Ne pas inclure les qualités supérieures"
L.COLLECTION_MODE =                      "Mode de collection"
L.COLLECTION_MODE_DESC =                 "Définir les objets à inclure lors de l’utilisation du bouton %s." -- %s becomes "Track New"
L.APPEARANCES =                           WARDROBE -- "Appearances"
L.APPEARANCES_SETTING_DESC =             "Inclure les objets uniquement s’ils ont une nouvelle apparence."
L.APPEARANCES_SOURCES =                  "Sources"
L.APPEARANCES_SOURCES_SETTING_DESC =     "Inclure les objets s’ils proviennent d’une nouvelle source, y compris pour les apparences connues."

-- L.PROFESSION_WINDOW =                    "Profession Window"
-- L.FILTER_OPTIONAL_REAGENTS =             "Filter Optional Reagents"
-- L.FILTER_OPTIONAL_REAGENTS_DESC =        "When %s is checked for optional reagents, hide combinable items." -- %s becomes "Hide Unavailable"
L.SPEND_TO_NEXT_PERK =                   "Dépenser jusqu’au prochain palier"
L.SPEND_TO_NEXT_PERK_DESC =              "Maj + Clic sur une spécialisation de métier dépense tous les points de connaissance jusqu’au prochain palier."
L.ENHANCED_ORDERS =                      "Commandes améliorées"
L.ENHANCED_ORDERS_DESC =                 "Améliore l’aperçu des récompenses et commissions de commande et ajoute des icônes pour les premières fabrications, les recettes non apprises et les recettes suivies."
L.QUICK_ORDER_DURATION =                 "Durée de la commande rapide"
-- L.QUICK_ORDER_DURATION_DESC =            "Set the duration for placing quick orders."
-- L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
-- L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
-- L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

L.TRACKING_WINDOW =                      "Fenêtre de suivi"
L.SHOW_HELP_TOOLTIPS =                   "Afficher les infobulles d’aide"
L.SHOW_HELP_TOOLTIPS_DESC =              "Afficher les actions disponibles à la souris lorsque vous survolez des éléments dans la fenêtre de suivi."
L.WINDOW_POSITION_PER_CHAR =             "Position de la fenêtre par personnage"
L.WINDOW_POSITION_PER_CHAR_DESC =        "Enregistrer la position de la fenêtre pour chaque personnage, au lieu de l’appliquer à tout le compte."
L.TRACK_RECIPES_PER_CHAR =               "Suivre les recettes par personnage"
L.TRACK_RECIPES_PER_CHAR_DESC =          "Suivre les recettes pour chaque personnage, au lieu de les partager à tout le compte."
L.SHOW_REMAINING_REAGENTS =              "Afficher les composants restants"
L.SHOW_REMAINING_REAGENTS_DESC =         "Afficher uniquement le nombre de composants qu’il reste à obtenir dans la fenêtre de suivi, au lieu d’afficher ceux possédés / requis."
L.UNTRACK_ON_CRAFT =                     "Arrêt du suivi après fabrication"
L.UNTRACK_ON_CRAFT_DESC =                "Arrêter de suivre une recette lorsque vous la fabriquez avec succès."
L.CLOSE_WINDOW_WHEN_DONE =               "Fermer la fenêtre une fois terminé"
L.CLOSE_WINDOW_WHEN_DONE_DESC =          "Fermer la fenêtre de suivi après avoir fabriqué la dernière recette suivie."

-- Tracking window
L.CLOSE_WINDOW =                         "Fermer la fenêtre"
L.LOCK_WINDOW =                          "Verrouiller la fenêtre"
L.UNLOCK_WINDOW =                        "Déverrouiller la fenêtre"
L.UPDATE_AUCTIONATOR_LIST1 =             "Mettre à jour la liste d’achats dans Auctionator"
L.UPDATE_AUCTIONATOR_LIST2 =             "La liste d’achats sera générée automatiquement lors de l’ouverture de l’Hôtel des ventes"
L.DOUBLE =                               "Double" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Maj" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "dimensionner automatiquement pour s’adapter à la fenêtre"
L.LINK_RECIPE =                          "poster la recette"
L.OPEN_RECIPE =                          "ouvrir la recette"
-- L.CRAFT_RECIPE =                         "Craft this recipe"
L.LINK_REAGENT =                         "poster le composant"
-- L.TRACK_RECIPE_SUBREAGENT =              "Track the recipe to craft this reagent, if one exists"
L.REMOVE_COOLDOWN_REMINDER =             "supprimer le rappel de temps de recharge"

L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.ITEMS =                                ITEMS -- "Items"
L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.COSTS =                                "Coûts"
L.COOLDOWNS =                            "Temps de recharge"
L.CLEAR_CONFIRMATION =                   "Cela effacera toutes les recettes."
L.CONFIRMATION =                         "Souhaitez-vous poursuivre ?"
L.SUBREAGENTS1 =                         "Il existe plusieurs recettes qui permettent de créer %s" -- %s becomes an item link
L.SUBREAGENTS2 =                         "Veuillez sélectionner l’un des éléments suivants :"
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
-- L.MERCHANT_BUY =                         "Buy all tracked reagents, if available."

L.READY =                                "Prêt"
L.DAYS =                                 "j"
L.HOURS =                                "h"
L.MINUTES =                              "m"
L.READY_TO_CRAFT =                       "%s est de nouveau prête pour %s" -- %s becomes a recipe name, and character name

L.MORE_NEEDED =                          "%d de plus sont nécessaires" -- %d becomes a number
L.MADE_WITH =                            "Fabriqué par %s" -- %s becomes a profession
L.RECIPE_LEARNED =                       "recette apprise"
L.RECIPE_UNLEARNED =                     "recette non apprise"
-- L.CRAFTING_COST =                        "Crafting Cost"

-- Profession window
L.TRACK =                                "Suivre"
L.UNTRACK =                              "Annuler le suivi"
L.RANK =                                 "Rang"
L.MILLING_INFORMATION =                  "Informations sur le broyage"
L.THAUMATURGY_INFORMATION =              "Informations sur la thaumaturgie"
L.FROM =                                 "depuis" -- Preceded by a percentage, followed by an item link
L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
L.SWITCH_AVAILABLE_PETS =                "passer d’une mascotte à l’autre"
-- L.TRACK_NEW =                            "Track New"
L.CURRENT_SETTING =                      "Paramètre actuel :"
L.NEW_APPEARANCES =                      "nouvelles apparences"
L.NEW_APPEARANCES_AND_SOURCES =          "nouvelles apparences et sources"
-- L.ADDED_RECIPES =                        "Checked %d visible recipes for %s. Tracked %d recipes." -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

L.RECHARGED =                            "Entièrement rechargé"
-- L.PROFTOOL_AUTOEQUIP =                   "Automatically equip this tool" -- Followed by L.PROFTOOL_FOR
-- L.PROFTOOL_FOR =                         "for %s." -- %s becomes one of the two following phrases
-- L.PROFTOOL_DEFAULT =                     "regular crafting"
-- L.PROFTOOL_ORDERS =                      "doing orders"
-- L.PROFTOOL_DRAG =                        "Drag a tool here."
-- L.PROFTOOL_EQUIP =                       "Equip this tool."
-- L.PROFTOOL_REMOVE =                      "Remove this tool."

L.PERKS_UNLOCKED =                       "avantages débloqués"
L.PROFESSION_KNOWLEDGE =                 "connaissance"
L.VENDORS =                              "Vendeurs"
L.RENOWN =                               COVENANT_SANCTUM_TAB_RENOWN --"Renown "
L.WORLD =                                "Monde"
L.HIDDEN_PROFESSION_MASTER =             "Maître de métier caché"
-- L.WEEKLY =                               WEEKLY -- "Weekly"
-- L.TREASURE =                             "Treasure"
-- L.DROP =                                 BATTLE_PET_SOURCE_1 -- "Drop"
L.CATCHUP_KNOWLEDGE =                    "Connaissances de rattrapage disponibles :"
L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

-- L.AUCTION_ADDONS =                       "Auctionator, Oribos Exchange, or TradeSkillMaster"
-- L.ORDERS_PRICING_MISSING =               "Missing"
-- L.ORDERS_PRICING_UPDATE =                "Update or scan with %s." -- %s becomes a list of addon names
L.ORDERS_SET_CRITERIA =                  "Définir les critères de suivi des commandes."
-- L.ORDERS_COST_NEED =                     "Cost settings only work with: %s." -- %s becomes a list of addon names
L.ORDERS_MAX_COST_KNOWLEDGE =            "Coût maximal par point de connaissance :"
L.ORDERS_MAX_COST_ARTISAN =              "Coût maximal par unité de monnaie d’artisan :" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "Coût maximal par sac de récompense :" -- This refers to Artisan's Payout bag
L.ORDERS_TRACK_AFTER_RESET =             "Suivi des commandes disponible après la réinitialisation hebdomadaire"
L.ORDERS_TRACK_CONCENTRATION =           "Suivre les commandes par coûts en concentration :"
-- L.ORDERS_TRACK_ON =                      "Track on %s:"  -- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "File d’attente"
L.ORDERSQUEUE_QUEUED =                   "Commandes en attente :"
L.ORDERSQUEUE_NEXT =                     "Prochaine commande"
L.ORDERSQUEUE_CLAIM =                    "Commencer la commande"
L.ORDERSQUEUE_CRAFT =                    "Lancer la commande"
L.ORDERSQUEUE_CRAFTING =                 "En cours..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"
-- L.ORDERSQUEUE_WARNING_QUEST =            "You have not picked up %s." -- %s becomes a quest name
-- L.ORDERSQUEUE_WARNING_REAGENTS =         "You do not have enough reagents for all tracked recipes."

-- Crafting Orders window
L.RECRAFT_TOOLTIP =                      "Sélectionnez un objet dont la recette a été mise en cache pour en assurer le suivi."
L.QUICK_ORDER =                          "Commande rapide"
L.QUICKORDER_TOOLTIP1 =                  "Créer instantanément une commande d’artisanat pour le destinataire spécifié."
L.QUICKORDER_TOOLTIP2 =                  "Utiliser %s (tout en majuscules) pour placer une " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "." -- "Guild Order", %s becomes "GUILD"
L.QUICKORDER_TOOLTIP3 =                  "Utiliser un nom de personnage pour placer une " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "." -- "Personal Order"
L.QUICKORDER_TOOLTIP4 =                  "Les destinataires sont mémorisés par recette."
L.USE_LOCAL_REAGENTS =                   "Utiliser des composants dans les sacs"
L.USE_LOCAL_REAGENTS_DESC =              "Utiliser les composants disponibles dans les sacs (de la plus basse qualité). Les composants utilisés ne peuvent pas être personnalisés."
L.REPEAT_LAST_QUICK_ORDER =              "Répéter la dernière Commande rapide effectuée sur ce personnage"
L.RECIPIENT =                            "Destinataire"

L.FALSE =                                "faux"
L.TRUE =                                 "vrai"
L.NO_LAST_QUICK_ORDER_FOUND =            "Aucune dernière Commande rapide trouvée"
L.ERROR =                                "Erreur :"
L.ERROR_CRAFTSIM =                       "impossible de lire les informations provenant de CraftSim"
L.ERROR_REAGENTS =                       "impossible de créer une Commande rapide pour les objets comportant des composants obligatoires"
L.ERROR_WARBANK =                        "impossible de créer une Commande rapide avec des objets provenant de la Banque de bataillon"
L.ERROR_GUILD =                          "impossible de créer une " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " en dehors d’une guilde" -- "Guild Order"
L.ERROR_RECIPIENT =                      "le destinataire cible ne peut pas fabriquer cet objet. Veuillez saisir un nom de destinataire valide"
L.ERROR_MULTISIM =                       "aucun composant simulé n’a été utilisé. Veuillez n’activer que l’un des addons suivants :"
