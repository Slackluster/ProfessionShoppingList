----------------------------------------
-- Profession Shopping List: frFR.lua --
----------------------------------------
-- French (France) localisation

-- Initialisation
local appName, app =  ...	-- Returns the AddOn name and a unique table
local L = app.locales

-- Only load this file when the appropriate locale is found
if GetLocale() ~= "frFR" then return end

-- Main window
L.WINDOW_BUTTON_CLOSE =						"Fermer la fenêtre"
L.WINDOW_BUTTON_LOCK =						"Verrouiller la fenêtre"
L.WINDOW_BUTTON_UNLOCK =					"Déverrouiller la fenêtre"
L.WINDOW_BUTTON_SETTINGS =					"Ouvrir les paramètres"
L.WINDOW_BUTTON_CLEAR =						"Effacer toutes les recettes suivies"
L.WINDOW_BUTTON_AUCTIONATOR =				"Créer une liste d'achat Auctionator.\n" ..
											"Lance également une recherche si l'onglet « Achats » est ouvert à l'Hôtel des ventes."

L.WINDOW_BUTTON_CORNER =					"Double " .. app.IconLMB .. "|cffFFFFFF : Dimensionner automatiquement pour s'adapter à la fenêtre"

L.WINDOW_HEADER_RECIPES =					PROFESSIONS_RECIPES_TAB	-- "Recettes"
L.WINDOW_HEADER_ITEMS =						ITEMS	-- "Objets"
L.WINDOW_HEADER_REAGENTS =					PROFESSIONS_COLUMN_HEADER_REAGENTS	-- "Composants"
L.WINDOW_HEADER_COSTS =						"Coûts"

L.WINDOW_TOOLTIP_RECIPES =					"Maj " .. app.IconLMB .. "|cffFFFFFF : Poste la recette\n|r" ..
											"Ctrl " .. app.IconLMB .. "|cffFFFFFF : Ouvre la recette (si connue)\n|r" ..
											"Alt " .. app.IconLMB .. "|cffFFFFFF : Essaie de créer cette recette (autant de fois que vous l'avez suivie)\n\n|r" ..
											app.IconRMB .. "|cffFFFFFF : Retire 1 de la recette suivie\n|r" ..
											"Ctrl " .. app.IconRMB .. "|cffFFFFFF : Retirer toutes les recettes sélectionnées"
L.WINDOW_TOOLTIP_REAGENTS =					"Maj " .. app.IconLMB .. "|cffFFFFFF : Poste le composant\n|r" ..
											"Ctrl " .. app.IconLMB .. "|cffFFFFFF : Ajoute une recette pour le sous-composant sélectionné, s'il existe et est mis en cache"
L.WINDOW_TOOLTIP_COOLDOWNS =				"Maj " .. app.IconRMB .. "|cffFFFFFF : Supprime le rappel de temps de recharge\n|r" ..
											"Ctrl " .. app.IconLMB .. "|cffFFFFFF : Ouvre la recette (si connue)\n|r" ..
											"Alt " .. app.IconLMB .. "|cffFFFFFF : Essaie de réaliser cette recette"

L.CLEAR_CONFIRMATION =						"Cela effacera toutes les recettes."
L.CONFIRMATION =							"Souhaitez-vous poursuivre ?"
L.SUBREAGENTS1 =							"Il existe de nombreuses recettes qui permettent de créer" -- Followed by an item link
L.SUBREAGENTS2 =							"Veuillez sélectionner l'un des éléments suivants"

L.GOLD =									BONUS_ROLL_REWARD_MONEY	-- "Or"
L.WARBANK_CHECKBOX =						"Inclure la Banque de bataillon"
L.WARBANK_TOOLTIP =							"Comme les commandes d'artisanat ne peuvent pas utiliser les objets stockés dans la Banque de bataillon pour le moment, vous pouvez désactiver leur suivi."

-- Cooldowns
L.RECHARGED =								"Entièrement rechargée"
L.READY =									"Prêt"
L.DAYS =									"j"
L.HOURS =									"h"
L.MINUTES =									"m"
L.READY_TO_CRAFT =							"sera prêt le"	-- Preceded by a recipe name, followed by a character name

-- Recipe tracking
L.TRACK =									"Suivre"
L.UNTRACK =									"Annuler"
-- L.RANK =									RANK	-- "Rank"
L.RECRAFT_TOOLTIP =							"Sélectionnez un objet dont la recette a été mise en cache pour en assurer le suivi.\n" ..
											"Pour mettre une recette en cache, ouvrez la profession à laquelle la recette appartient (sur n'importe quel personnage)\nou visualisez l'objet comme une commande d'artisanat normale."
L.QUICKORDER =								"Commande rapide"
L.QUICKORDER_TOOLTIP =						"|cffFF0000Créer instantanément|r une commande d'artisanat pour le destinataire spécifié.\n\n" ..
											"Utilisez |cffFFFFFFGUILD|r (tout en majuscules) pour placer une " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. ".\n" ..	-- "Guild Order". Don't translate "|cffFFFFFFGUILD|r" as this is hardcoded
											"Utilisez un nom de personnage pour placer une " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. ".\n" ..	-- "Personal Order"
											"Les destinataires sont enregistrés par recette."
L.LOCALREAGENTS_LABEL =						"Utiliser des composants dans les sacs"
L.LOCALREAGENTS_TOOLTIP =					"Utiliser les composants disponibles dans les sacs (de la plus basse qualité). Les composants utilisés |cffFF0000ne peuvent pas|r être personnalisés."
L.QUICKORDER_REPEAT_TOOLTIP =				"Répéter la dernière " .. L.QUICKORDER .. " effectuée sur ce personnage."
L.RECIPIENT =								"Destinataire"

-- Profession window
L.FROM =									"de"	-- I will convert this whole section to item links, then this is the only localisation needed. I recommend skipping this section, other than the two headers. :)
L.MILLING_INFO =							"Informations sur le broyage"
L.MILLING_CLASSIC =							"Pigment saphir : 25% depuis Sansam doré, Feuillerêve, Sauge-argent des montagnes, Chagrinelle, Chapeglace\n" ..
											"Pigment argenté : 75% depuis Sansam doré, Feuillerêve, Sauge-argent des montagnes, Chagrinelle, Chapeglace\n\n" ..
											"Pigment rubis : 25% depuis Fleur de feu, Lotus pourpre, Larmes d'Arthas, Soleillette, Aveuglette,\n      Champignon fantôme, Gromsang\n" ..	-- The spacing here is an indentation because of the line overflow in the profession window
											"Pigment violet : 75% depuis Fleur de feu, Lotus pourpre, Larmes d'Arthas, Soleillette, Aveuglette,\n      Champignon fantôme, Gromsang\n\n" ..	-- The spacing here is an indentation because of the line overflow in the profession window
											"Pigment indigo : 25% depuis Pâlerette, Dorépine, Moustache de Khadgar, Dents de dragon\n" ..
											"Pigment émeraude : 75% depuis Pâlerette, Dorépine, Moustache de Khadgar, Dents de dragon\n\n" ..
											"Pigment brûlé : 25% depuis Aciérite sauvage, Tombeline, Sang-royal, Vietérule\n" ..
											"Pigment doré : 75% depuis Aciérite sauvage, Tombeline, Sang-royal, Vietérule\n\n" ..
											"Pigment verdoyant : 25% depuis Mage royal, Eglantine, Chardonnier, Doulourante, Etouffante\n" ..
											"Pigment crépusculaire : 75% depuis Mage royal, Eglantine, Chardonnier, Doulourante, Etouffante\n\n" ..
											"Pigment albâtre : 100% depuis Pacifique, Feuillargent, Terrestrine"
L.MILLING_TBC =								"Pigment ébène : 25%\n" ..
											"Pigment néantin : 100%"
L.MILLING_WOTLK =							"Pigment glacé : 25%\n" ..
											"Pigment azur : 100%"
L.MILLING_CATA =							"Braises ardentes : 25%, 50% depuis Jasmin crépusculaire, Fouettine\n" ..
											"Pigment cendreux: 100%"
L.MILLING_MOP =								"Pigment brumeux : 25%, 50% depuis Berluette\n" ..
											"Pigment ombreux : 100%"
L.MILLING_WOD =								"Pigment céruléen : 100%"
L.MILLING_LEGION =							"Pigment jaunâtre : 10%, 80% depuis Gangrèche\n" ..
											"Pigment rosé : 90%"
L.MILLING_BFA =								"Pigment smaragdin : 10%, 30% depuis Ancoracée\n" ..
											"Pigment bleu outremer : 25%\n" ..
											"Pigment cramoisi : 75%"
L.MILLING_SL =								"Pigment paisible : Belladone\n" ..
											"Pigment lumineux : Fatalée, Belle-de-l’aube, Plante-torche du veilleur\n" ..
											"Pigment ombreux : Fatalée, Courgineuse, Endeuillée"
L.MILLING_DF =								"Pigment flamboyant : Saxifrage\n" ..
											"Pigment florissant : Écorce tordue\n" ..
											"Pigment serein : Pavot à bulle\n" ..
											"Pigment chatoyant : Hochenblume"
L.MILLING_TWW =								"Pigment de la floraison : Floraison bénie\n" ..
											"Pigment de pose-appât : Pose-appât\n" ..
											"Pigment d'orbinide : Orbinide\n" ..
											"Pigment nacré : Champifleur"
L.THAUMATURGY_INFO =						"Information de Thaumaturgie"
L.THAUMATURGY_TWW =							"Transmutagène mercurien : Aqirite, Chitine sinistre, Pose-appât, Orbinide\n" ..
											"Transmutagène sinistre : Bismuth, Champifleur, Poussière de tempête, Tissétoffe\n" ..
											"Transmutagène instable : Lance d’Arathor, Floraison bénie, Minerai de griffefer, Cuir chargé par la tempête"

L.BUTTON_COOKINGFIRE =						app.IconLMB .. ": " .. BINDING_NAME_TARGETSELF .. ".\n" ..
											app.IconRMB .. ": " .. STATUS_TEXT_TARGET .. ""
L.BUTTON_COOKINGPET =						app.IconLMB .. " : Invoquer cette mascotte\n" ..
											app.IconRMB .. " : Passer d'une mascotte à l'autre"
-- Track new mogs
L.BUTTON_TRACKNEW =							"Suivre les apparences inconnues"
L.CURRENT_SETTING =							"Paramètre actuel"
L.MODE_APPEARANCES =						"nouvelles apparences"
L.MODE_SOURCES =							"nouvelles apparences et sources "
L.TRACK_NEW1 =								"Cela va vérifier"	-- Followed by a number
L.TRACK_NEW1 =								"Cela va vérifier"	-- Followed by a number
L.TRACK_NEW2 =								"recettes visibles pour les"	-- Preceded by a number, followed by L.MODE_APPEARANCES or L.MODE_SOURCES
L.TRACK_NEW3 =								"Le jeu peut se bloquer pendant quelques secondes."
L.ADDED_RECIPES1 =							"Ajout de"	-- Followed by a number
L.ADDED_RECIPES2 =							"recettes éligibles"	-- Preceded by a number

-- Tooltip info
L.MORE_NEEDED =								"de plus sont nécessaires" -- Preceded by a number
L.MADE_WITH =								"Fabriqué via"	-- Followed by a profession name such as "Blacksmithing" or "Leatherworking"
L.RECIPE_LEARNED =							"recette apprise"
L.RECIPE_UNLEARNED =						"recette non apprise"
L.REGION =									"Region"	-- Preceded by an abbreviated region name such as "EU" or "US"

-- Profession knowledge
L.PERKS_UNLOCKED =							"avantages débloqués"
L.PROFESSION_KNOWLEDGE =					"connaissances"
L.VENDORS =									"Vendeurs"
--L.RENOWN =									RENOWN_LEVEL_LABEL	-- "Renown "
L.WORLD =									"Monde"
L.HIDDEN_PROFESSION_MASTER =				"Hidden Profession Master"

-- Tweaks
L.CATALYSTBUTTON_LABEL =					"Catalyseur instantané" -- maybe need review in fr_FR

-- Chat feedback
L.INVALID_RECIPEQUANTITY =					"Paramètres non valides. Veuillez saisir une quantité de recette valide."
L.INVALID_RECIPE_CACHE =					"Paramètres non valides. Veuillez saisir un numéro d'identification de recette (recipeID) mis en cache."
L.INVALID_RECIPE_TRACKED =					"Paramètres non valides. Veuillez saisir un numéro de recette suivi (recipeID)."
L.INVALID_ACHIEVEMENT =						"Paramètres non valides. Il ne s'agit pas d'un haut fait de métier. Aucune recette n'a été ajoutée."
L.INVALID_COMMAND =							"Commande non valide. Voir " .. app.Colour("/psl settings") .. " pour plus d'informations."
L.DEBUG_ENABLED =							"Mode ddébogage activé."
L.DEBUG_DISABLED =							"Mode débogage désactivé."

L.FALSE =									"vrai"
L.TRUE =									"faux"
L.NOLASTORDER =								"Aucune dernière " .. L.QUICKORDER .. " trouvée."
L.ERROR =									"Erreur"
L.ERROR_CRAFTSIM =							L.ERROR .. " : Impossible de lire les informations provenant de CraftSim."
L.ERROR_QUICKORDER =						L.ERROR .. " : La " .. L.QUICKORDER .. " a échouée ! désolé. :("
L.ERROR_REAGENTS =							L.ERROR .. " : Impossible de créer une " .. L.QUICKORDER .. " pour les objets comportant des composants obligatoires. désolé. :("
L.ERROR_WARBANK =							L.ERROR .. " : Impossible de créer une " .. L.QUICKORDER .. " avec des objets provenants de la Banque de bataillon."
L.ERROR_GUILD =								L.ERROR .. " : Impossible de créer une " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " en dehors d'une guilde."	-- "Guild Order"
L.ERROR_RECIPIENT =							L.ERROR .. " : Le destinataire cible ne peut pas fabriquer cet objet. Veuillez saisir un nom de destinataire valide."
L.ERROR_MULTISIM =							L.ERROR .. " : Aucun composant simulé n'a été utilisé. Veuillez n'activer que l'un des AddOns suivants :"

L.VERSION_CHECK =							"Une nouvelle version de " .. app.NameLong .. " est disponible"

-- Settings
L.SETTINGS_TOOLTIP =						app.IconLMB .. "|cffFFFFFF : Afficher / masquer la fenêtre\n" ..
											app.IconRMB .. " : Afficher les paramètres"

L.SETTINGS_MINIMAP_TITLE =					"Afficher le bouton de la mini-carte"
L.SETTINGS_MINIMAP_TOOLTIP =				"Afficher le bouton de la mini-carte. Si vous désactivez cette fonction, " .. app.NameShort .. " sera toujours disponible dans la partie AddOn."
L.SETTINGS_COOLDOWNS_TITLE =				"Suivre le temps de recharge des recettes"
L.SETTINGS_COOLDOWNS_TOOLTIP =				"Activer le suivi des temps de recharge des recettes. Ceux-ci s'afficheront dans la fenêtre de suivi, et dans le chat lors de la connexion s'ils sont prêts."
L.SETTINGS_TOOLTIP_TITLE =					"Afficher les informations de l'info-bulle"
L.SETTINGS_TOOLTIP_TOOLTIP =				"Afficher la quantité de composant que vous avez ou dont vous avez besoin dans l'info-bulle de l'objet."
L.SETTINGS_CRAFTTOOLTIP_TITLE =				"Afficher les informations de profession"
L.SETTINGS_CRAFTTOOLTIP_TOOLTIP =			"Afficher avec quelle profession une pièce d'équipement est fabriquée et si la recette est connue sur votre compte."
L.SETTINGS_REAGENTQUALITY_TITLE =			"Qualité minimum de composant"
L.SETTINGS_REAGENTQUALITY_TOOLTIP =			"Définit la qualité minimale requise pour que les composants soient inclus dans le décompte des objets par " .. app.NameShort .. ". Les résultats de CraftSim seront toujours prioritaires."
L.SETTINGS_INCLUDEHIGHER_TITLE =			"Inclure une qualité supérieure"
L.SETTINGS_INCLUDEHIGHER_TOOLTIP =			"Définir les qualités supérieures à inclure dans le suivi des composants de qualité inférieure. (Par exemple, déterminer si les composants de niveau 3 doivent être pris en compte dans le décompte des composants de niveau 1)."
L.SETTINGS_COLLECTMODE_TITLE =				"Mode de collection"
L.SETTINGS_COLLECTMODE_TOOLTIP =			"Définir les objets à inclure lors de l'utilisation du bouton " .. app.Colour("Suivre les apparences inconnues") .. "."
L.SETTINGS_QUICKORDER_TITLE =				"Durée de la commande rapide"
L.SETTINGS_QUICKORDER_TOOLTIP =				"Définir la durée pour passer des commandes rapides avec " .. app.NameShort .. "."

L.SETTINGS_REAGENTTIER =					"Tier"	-- Followed by a number
L.SETTINGS_INCLUDE =						"Inclure"	-- Followed by "Tier X"
L.SETTINGS_ONLY_INCLUDE =					"Inclure seulement"	-- Followed by "Tier X"
L.SETTINGS_DONT_INCLUDE =					"Ne pas inclure les qualités supérieures"
L.SETTINGS_APPEARANCES_TITLE =				WARDROBE	-- "Appearances"
L.SETTINGS_APPEARANCES_TEXT =				"Inclure uniquement les objets que s'ils ont une nouvelle apparence."
L.SETTINGS_SOURCES_TITLE =					"Sources"
L.SETTINGS_SOURCES_TEXT =					"Inclure les objets s'il s'agit d'une nouvelle source, y compris pour les apparences connues."
L.SETTINGS_DURATION_SHORT =					"Court (12 heures)"
L.SETTINGS_DURATION_MEDIUM =				"Moyen (24 heures)"
L.SETTINGS_DURATION_LONG =					"Long (48 heures)"

L.SETTINGS_HEADER_TRACK =					"Fenêtre de suivi"

L.SETTINGS_PERSONALWINDOWS_TITLE =			"Position de la fenêtre par personnage"
L.SETTINGS_PERSONALWINDOWS_TOOLTIP =		"Enregistrer la position de la fenêtre par personnage, au lieu de l'enregistrer sur l'ensemble du compte."
L.SETTINGS_PERSONALRECIPES_TITLE =			"Suivre les recettes par personnage"
L.SETTINGS_PERSONALRECIPES_TOOLTIP =		"Suivre les recettes par personnage, au lieu de les suivre sur l'ensemble du compte."
L.SETTINGS_SHOWREMAINING_TITLE =			"Afficher les composants restants"
L.SETTINGS_SHOWREMAINING_TOOLTIP =			"Afficher uniquement le nombre de composants dont vous avez encore besoin dans la fenêtre de suivi."
L.SETTINGS_REMOVECRAFT_TITLE =				"Arrêter le suivi lors de la fabrication"
L.SETTINGS_REMOVECRAFT_TOOLTIP =			"Retirer une unité d'une recette suivie lorsqu'elle est fabriquée avec succès."
L.SETTINGS_CLOSEWHENDONE_TITLE =			"Fermez la fenêtre lorsque vous avez terminé"
L.SETTINGS_CLOSEWHENDONE_TOOLTIP =			"Fermer la fenêtre de suivi après avoir fabriqué la dernière recette suivie."

L.SETTINGS_HEADER_INFO =					"Information"
L.SETTINGS_SLASHCOMMANDS_TITLE =			"Commandes « Slash »"
L.SETTINGS_SLASHCOMMANDS_TOOLTIP =			"Tapez-les dans le chat pour les utiliser !"
L.SETTINGS_SLASH_TOGGLE =					"afficher / masquer la fenêtre de suivi"
L.SETTINGS_SLASH_RESETPOS =					"réinitialise la position de la fenêtre de suivi"
L.SETTINGS_SLASH_SETTINGS =					"accédez aux paramètres"
L.SETTINGS_SLASH_TRACK =					"suivre une recette"
L.SETTINGS_SLASH_UNTRACK =					"ne pas suivre une recette"
L.SETTINGS_SLASH_UNTRACKALL =				"ne plus suivre l'ensemble des recettes"

L.SETTINGS_SLASH_TRACKACHIE =				"Suivre les recettes nécessaires à l'obtention d'un haut fait."
L.SETTINGS_SLASH_CRAFTINGACHIE =			"haut fait de métier"
L.SETTINGS_SLASH_RECIPEID =					"recipeID"
L.SETTINGS_SLASH_QUANTITY =					"quantité"
L.SETTINGS_DEFAULT =						CHAT_DEFAULT	-- "Default"
L.SETTINGS_LTOR =							"Gauche-vers-Droite"
L.SETTINGS_RTOL =							"Droite-vers-Gauche"

L.SETTINGS_HEADER_TWEAKS =					"Ajustements"
L.SETTINGS_SPLITBAG_TITLE =					"Nombre de composants dans les sacs"
L.SETTINGS_SPLITBAG_TOOLTIP =				"Affiche les emplacements libres de vos sacs ainsi que votre sac de composants séparément au-dessus de l'icône du sac à dos."
L.SETTINGS_BAG_EXPLAIN =					"- " .. CHAT_DEFAULT .. ", " .. app.NameShort .. " ne modifiera pas le comportement par défaut du jeu.\n" ..
											"- Les autres options permettent à " .. app.NameShort .. " d'appliquer ce paramètre spécifique."
L.SETTINGS_CLEANBAG_TITLE =					BAG_CLEANUP_BAGS
L.SETTINGS_CLEANBAG_TOOLTIP =				"Permettre à " .. app.NameShort .. " d'appliquer la direction du tri lors du nettoyage.\n" .. L.SETTINGS_BAG_EXPLAIN
L.SETTINGS_LOOTBAG_TITLE =					"Order du butin"
L.SETTINGS_LOOTBAG_TOOLTIP =				"Permettre à " .. app.NameShort .. " d'appliquer la direction du tri lors du ramassage.\n" .. L.SETTINGS_BAG_EXPLAIN

L.SETTINGS_HEADER_OTHERTWEAKS =				"Autres ajustements"
L.SETTINGS_VENDORFILTER_TITLE =				"Désactiver le filtre des vendeurs"
L.SETTINGS_VENDORFILTER_TOOLTIP =			"Définissez automatiquement tous les filtres des vendeurs sur |cffFFFFFFTous|R pour afficher les objets qui ne sont normalement pas montrés à votre classe."
L.SETTINGS_CATALYSTBUTTON_TITLE =			"Afficher le bouton du Catalyseur" -- maybe need review in fr_FR

L.SETTINGS_CATALYSTBUTTON_TOOLTIP =			"Affiche un bouton sur le Catalyseur de renouveau qui vous permet de catalyser instantanément un objet, en sautant le minuteur de confirmation de 5 secondes."
L.SETTINGS_QUEUESOUND_TITLE =				"Jouer un son pour la file d'attente"
L.SETTINGS_QUEUESOUND_TOOLTIP =				"Joue le son de la file d'attente comme celui de « Deadly Boss Mods » lorsque n'importe quelle file d'attente s'ouvre, y compris les champs de bataille et les combats de mascottes."
L.SETTINGS_HANDYNOTESFIX_TITLE =			"Désactiver HandyNotes Alt " .. app.IconRMB
L.SETTINGS_HANDYNOTESFIX_TOOLTIP =			"Permettre à " .. app.NameShort .. " de désactiver le raccourci clavier d'HandyNotes sur la carte, en le réactivant pour les points de passages TomTom à la place.\n\n" ..
											"|cffFF0000" .. REQUIRES_RELOAD	-- "Nécessite le rechargement du jeu"
L.SETTINGS_ORIBOSEXCHANGEFIX_TITLE =		"Corriger l'info-bulle de l'échange d'Oribos"
L.SETTINGS_ORIBOSEXCHANGEFIX_TOOLTIP =		app.NameShort .. " simplifie et corrige l'info-bulle fournie par l'AddOn Oribos Exchange :\n" ..
											"- Arrondir à l'or le plus proche\n" ..
											"- Fixe les prix des recettes\n" ..
											"- Fixe les prix des fenêtres de profession\n" ..
											"- Afficher les prix des mascottes de combat dans l'info-bulle existante"
