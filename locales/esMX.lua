----------------------------------------
-- Profession Shopping List: esMX.lua --
----------------------------------------
-- Spanish (Mexico) localisation
-- Translator(s): Ferran Carril

if GetLocale() ~= "esMX" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Hay una versión más nueva de %s disponible:" -- %s becomes the addon name

L.RESET_DONE =                           "Los datos se han restablecido correctamente."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.DEBUG_ENABLED =                        "Modo de depuración activado"
L.DEBUG_DISABLED =                       "Modo de depuración desactivado"
L.INVALID_PARAMETERS =                   "Parámetros no válidos"
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
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. ": Activar/Desactivar ventana"
L.ORDERS_QUEUE =                         "Cola de pedidos"
L.TOGGLE_TRACKING_WINDOW =               "Activar/Desactivar la ventana de seguimiento"
L.RESET_WINDOW_POSITION =                "Restablecer la posición de la ventana de seguimiento"
L.RESET_SAVED_DATA =                     "Restablecer datos guardados"
L.OPEN_SETTINGS =                        "Abrir opciones"
L.CLEAR_TRACKED_RECIPES =                "Borrar todas las recetas rastreadas"
L.RECIPEID =                             "recipeID"
L.QUANTITY =                             "cantidad"
L.TRACK_RECIPE =                         "Rastrear una receta"
L.UNTRACK_RECIPE =                       "Dejar de rastrear una receta"
L.UNTRACK_RECIPE_ALL =                   "Dejar de rastrear todas las unidades de una receta"
L.CRAFTING_ACHIEVEMENT =                 "logro de fabricación"
L.TRACK_ACHIEVEMENT_RECIPES =            "Rastrear las recetas necesarias para el logro enlazado"
L.ITEMLINK_OR_ITEMID =                   "itemLink o itemID"
L.TRACK_REAGENT_RECIPES =                "Rastrear todas las recetas que usan este componente"

L.GENERAL =                              GENERAL -- "General"
L.SHOW_MINIMAP_ICON =                    "Mostrar icono de minimapa"
L.SHOW_MINIMAP_ICON_DESC =               "Muestra el icono del minimapa. Si desactivas esto, %s sigue disponible en el apartado de Addons." -- %s becomes the addon name
L.SHOW_TAB =                             "Mostrar pestaña"
L.SHOW_TAB_DESC =                        "Muestra la pestaña de %s en las ventanas de profesiones y de la casa de subastas." -- %s becomes the addon name
L.TRACK_RECIPE_COOLDOWNS =               "Rastrear tiempos de reutilización de recetas"
L.TRACK_RECIPE_COOLDOWNS_DESC =          "Activa el seguimiento de los tiempos de reutilización de las recetas. Se mostrarán en la ventana de seguimiento y, si están listas, en el chat al iniciar sesión."
L.SHOW_WINDOW_WHEN_READY =               "Mostrar ventana cuando esté listo"
L.SHOW_WINDOW_WHEN_READY_DESC =          "Abrir la ventana de seguimiento al iniciar sesión cuando termine un tiempo de reutilización, además del aviso en el chat."
L.SHOW_TOOLTIP_INFORMATION =             "Mostrar información en la descripción emergente"
L.SHOW_TOOLTIP_INFORMATION_DESC =        "Muestra cuántos componentes tienes/necesitas en la descripción emergente del objeto."
L.SHOW_CRAFTING_INFORMATION =            "Mostrar información de fabricación"
L.SHOW_CRAFTING_INFORMATION_DESC =       "Muestra con qué profesión se fabrica una pieza de equipo y si la receta se conoce en tu cuenta."
L.SHOW_CRAFTING_COST =                   "Mostrar coste de fabricación"
L.SHOW_CRAFTING_COST_DESC =              "Muestra cuánto cuesta fabricar un objeto, si la información está disponible."
L.MINIMUM_REAGENT_QUALITY =              "Calidad mínima de componentes"
L.MINIMUM_REAGENT_QUALITY_DESC =         "Establece la calidad mínima que deben tener los componentes para contarlos. Los resultados simulados seguirán teniendo prioridad."
L.LOW =                                  LOW -- "Low"
L.HIGH =                                 HIGH -- "High"
L.INCLUDE_HIGHER_QUALITY =               "Incluir calidad superior"
L.INCLUDE_HIGHER_QUALITY_DESC =          "Determina si contar componentes de calidad superior. (Por ejemplo, incluir los de nivel 2 que posees al contar los de nivel 1)."
L.INCLUDE_HIGHER_QUALITY_DESC2 =         "Las calidades superiores se tendrán en cuenta automáticamente si son más baratas."
L.INCLUDE_HIGHER_QUALITIES_YES =         "Incluir calidades superiores"
L.INCLUDE_HIGHER_QUALITIES_NO =          "No incluir calidades superiores"
L.COLLECTION_MODE =                      "Modo colección"
L.COLLECTION_MODE_DESC =                 "Establece qué objetos se incluyen al usar el botón %s." -- %s becomes "Track New"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_SETTING_DESC =             "Incluir solo objetos con una apariencia nueva."
L.APPEARANCES_SOURCES =                  "Fuentes"
L.APPEARANCES_SOURCES_SETTING_DESC =     "Incluir objetos que sean una nueva fuente, incluso si la apariencia ya es conocida."

L.PROFESSION_WINDOW =                    "Ventana de profesiones"
L.FILTER_OPTIONAL_REAGENTS =             "Filtrar componentes opcionales"
L.FILTER_OPTIONAL_REAGENTS_DESC =        "Cuando %s esté marcado para componentes opcionales, ocultar objetos combinables." -- %s becomes "Hide Unavailable"
L.SPEND_TO_NEXT_PERK =                   "Gastar hasta el siguiente beneficio"
L.SPEND_TO_NEXT_PERK_DESC =              "Mayús+clic en un nodo de conocimiento de profesión gasta puntos hasta el siguiente beneficio."
L.ENHANCED_ORDERS =                      "Pedidos mejorados"
L.ENHANCED_ORDERS_DESC =                 "Mejora la vista previa de recompensas y comisiones de pedidos, y añade iconos para primeras fabricaciones, recetas sin aprender y recetas rastreadas."
L.QUICK_ORDER_DURATION =                 "Duración del Pedido rápido"
L.QUICK_ORDER_DURATION_DESC =            "Establece la duración de los pedidos rápidos."
L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

L.TRACKING_WINDOW =                      "Ventana de seguimiento"
L.SHOW_HELP_TOOLTIPS =                   "Mostrar descripciones de ayuda"
L.SHOW_HELP_TOOLTIPS_DESC =              "Muestra las acciones del ratón disponibles al pasar el cursor sobre las entradas de la ventana de seguimiento."
L.WINDOW_POSITION_PER_CHAR =             "Posición de ventana por personaje"
L.WINDOW_POSITION_PER_CHAR_DESC =        "Guardar la posición de la ventana por personaje en lugar de por cuenta."
L.TRACK_RECIPES_PER_CHAR =               "Rastrear recetas por personaje"
L.TRACK_RECIPES_PER_CHAR_DESC =          "Rastrear recetas por personaje en lugar de por cuenta."
L.SHOW_REMAINING_REAGENTS =              "Mostrar componentes restantes"
L.SHOW_REMAINING_REAGENTS_DESC =         "Mostrar únicamente cuántos componentes faltan en la ventana de seguimiento, en lugar de los que tienes/necesitas."
L.UNTRACK_ON_CRAFT =                     "Dejar de rastrear al fabricar"
L.UNTRACK_ON_CRAFT_DESC =                "Elimina una unidad de una receta rastreada cuando la fabricas correctamente."
L.CLOSE_WINDOW_WHEN_DONE =               "Cerrar la ventana al terminar"
L.CLOSE_WINDOW_WHEN_DONE_DESC =          "Cierra la ventana de seguimiento después de fabricar la última receta rastreada."

-- Tracking window
L.CLOSE_WINDOW =                         "Cerrar ventana"
L.LOCK_WINDOW =                          "Bloquear ventana"
L.UNLOCK_WINDOW =                        "Desbloquear ventana"
L.UPDATE_AUCTIONATOR_LIST1 =             "Actualizar la lista de compras de Auctionator"
L.UPDATE_AUCTIONATOR_LIST2 =             "La lista de compras se genera automáticamente al abrir la Casa de Subastas"
L.DOUBLE =                               "Doble" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Mayús" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "Ajustar tamaño automáticamente a la ventana"
L.LINK_RECIPE =                          "Enlazar la receta"
L.OPEN_RECIPE =                          "Abrir la receta"
L.CRAFT_RECIPE =                         "Fabricar esta receta"
L.LINK_REAGENT =                         "Enlazar el componente"
L.TRACK_RECIPE_SUBREAGENT =              "Rastrear la receta para fabricar este componente, si existe"
L.REMOVE_COOLDOWN_REMINDER =             "Eliminar este recordatorio específico de tiempo de reutilización"

L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.ITEMS =                                ITEMS -- "Items"
L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.COSTS =                                "Costes"
L.COOLDOWNS =                            "Tiempos de reutilización"
L.CLEAR_CONFIRMATION =                   "Esto borrará todas las recetas."
L.CONFIRMATION =                         "¿Quieres continuar?"
L.SUBREAGENTS1 =                         "Hay varias recetas que pueden fabricar %s" -- %s becomes an item link
L.SUBREAGENTS2 =                         "Selecciona una de las siguientes opciones:"
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
L.MERCHANT_BUY =                         "Comprar todos los componentes rastreados, si están disponibles."

L.READY =                                READY -- "Ready"
L.DAYS =                                 "d"
L.HOURS =                                "h"
L.MINUTES =                              "m"
L.READY_TO_CRAFT =                       "%s está listo para fabricar de nuevo en %s" -- %s becomes a recipe name, and character name

L.MORE_NEEDED =                          "Faltan %d más" -- %d becomes a number
L.MADE_WITH =                            "Fabricado con %s" -- %s becomes a profession
L.RECIPE_LEARNED =                       "receta aprendida"
L.RECIPE_UNLEARNED =                     "receta sin aprender"
L.CRAFTING_COST =                        "Coste de fabricación"

-- Profession window
L.TRACK =                                TRACK_QUEST_ABBREV -- "Track"
L.UNTRACK =                              PROFESSIONS_UNTRACK_RECIPE -- "Untrack"
L.RANK =                                 RANK -- "Rank"
L.MILLING_INFORMATION =                  "Información de molienda"
L.THAUMATURGY_INFORMATION =              "Información de taumaturgia"
L.FROM =                                 "de" -- Preceded by a percentage, followed by an item link
L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
L.SWITCH_AVAILABLE_PETS =                "Cambiar entre mascotas disponibles"
L.TRACK_NEW =                            "Rastrear nuevos"
L.CURRENT_SETTING =                      "Ajuste actual:"
L.NEW_APPEARANCES =                      "nuevas apariencias"
L.NEW_APPEARANCES_AND_SOURCES =          "nuevas apariencias y fuentes"
L.ADDED_RECIPES =                        "Se han comprobado %d recetas visibles de %s. Se han rastreado %d recetas." -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

L.RECHARGED =                            "Recargado por completo"
L.PROFTOOL_AUTOEQUIP =                   "Equipar esta herramienta automáticamente" -- Followed by L.PROFTOOL_FOR
L.PROFTOOL_FOR =                         "para %s." -- %s becomes one of the two following phrases
L.PROFTOOL_DEFAULT =                     "fabricación normal"
L.PROFTOOL_ORDERS =                      "realizando pedidos"
L.PROFTOOL_DRAG =                        "Arrastra una herramienta aquí."
L.PROFTOOL_EQUIP =                       "Equipa esta herramienta."
L.PROFTOOL_REMOVE =                      "Quita esta herramienta."

L.PERKS_UNLOCKED =                       "beneficios desbloqueados"
L.PROFESSION_KNOWLEDGE =                 "conocimiento"
L.VENDORS =                              "Comerciantes"
L.RENOWN =                               COVENANT_SANCTUM_TAB_RENOWN -- "Renown "
L.WORLD =                                WORLD -- "World"
L.HIDDEN_PROFESSION_MASTER =             "Maestro de profesión oculto"
L.WEEKLY =                               WEEKLY -- "Weekly"
L.TREASURE =                             "Tesoro"
L.DROP =                                 BATTLE_PET_SOURCE_1 -- "Drop"
L.CATCHUP_KNOWLEDGE =                    "Conocimiento de recuperación disponible:"
L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

L.AUCTION_ADDONS =                       "Auctionator, Oribos Exchange o TradeSkillMaster"
L.ORDERS_PRICING_MISSING =               "Falta"
L.ORDERS_PRICING_UPDATE =                "Actualiza o escanea con %s." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_SET_CRITERIA =                  "Establece los criterios para rastrear pedidos."
L.ORDERS_COST_NEED =                     "Los ajustes de coste solo funcionan con: %s." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_MAX_COST_KNOWLEDGE =            "Coste máximo por punto de conocimiento:"
L.ORDERS_MAX_COST_ARTISAN =              "Coste máximo por moneda de artesano:" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "Coste máximo por bolsa de recompensa:" -- This refers to Artisan's Payout bag
L.ORDERS_TRACK_AFTER_RESET =             "Rastrear los pedidos disponibles tras el reinicio semanal"
L.ORDERS_TRACK_CONCENTRATION =           "Rastrear pedidos que gastan concentración:"
L.ORDERS_TRACK_ON =                      "Rastrear en %s:"-- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "Cola"
L.ORDERSQUEUE_QUEUED =                   "Pedidos en cola:"
L.ORDERSQUEUE_NEXT =                     "Pedido siguiente"
L.ORDERSQUEUE_CLAIM =                    "Reclamar pedido"
L.ORDERSQUEUE_CRAFT =                    "Pedido de fabricación"
L.ORDERSQUEUE_CRAFTING =                 "Fabricando..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"
L.CANCEL_FORM =                          "Cancelar formulario" -- Cancel Shapeshift Form
L.ORDERSQUEUE_WARNING_QUEST =            "Todavía no has recogido %s." -- %s becomes a quest name
L.ORDERSQUEUE_WARNING_REAGENTS =         "No tienes componentes suficientes para todas las recetas rastreadas."
L.ORDERSQUEUE_WARNING_KEYBIND_DK =       "Para usar el atajo propio de %s, desactiva el ajuste \"Pedidos de fabricación\" de DialogKey." -- %s becomes PSL

-- Crafting Orders window
L.RECRAFT_TOOLTIP =                      "Selecciona un objeto con una receta en caché para rastrearlo."
L.QUICK_ORDER =                          "Pedido rápido"
L.QUICKORDER_TOOLTIP1 =                  "Crea al instante un pedido de fabricación para el destinatario indicado."
L.QUICKORDER_TOOLTIP2 =                  "Usa %s (todo en mayúsculas) para realizar un " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "." -- "Guild Order", %s becomes "GUILD"
L.QUICKORDER_TOOLTIP3 =                  "Usa el nombre de un personaje para realizar un " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "." -- "Personal Order"
L.QUICKORDER_TOOLTIP4 =                  "Los destinatarios se guardan por receta."
L.USE_LOCAL_REAGENTS =                   "Usar componentes locales"
L.USE_LOCAL_REAGENTS_DESC =              "Usar los componentes locales disponibles (de la menor calidad). No se puede personalizar qué componentes se utilizan."
L.REPEAT_LAST_QUICK_ORDER =              "Repetir el último Pedido rápido realizado con este personaje"
L.RECIPIENT =                            "Destinatario"

L.FALSE =                                "falso"
L.TRUE =                                 "verdadero"
L.NO_LAST_QUICK_ORDER_FOUND =            "No se ha encontrado ningún Pedido rápido anterior"
L.ERROR =                                "Error:"
L.ERROR_CRAFTSIM =                       "No se ha podido leer la información de CraftSim"
L.ERROR_REAGENTS =                       "No se puede crear un Pedido rápido para objetos con componentes obligatorios"
L.ERROR_WARBANK =                        "No se puede crear un Pedido rápido con objetos del banco de la banda guerrera"
L.ERROR_GUILD =                          "No se puede crear un " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " sin pertenecer a una hermandad" -- "Guild Order"
L.ERROR_RECIPIENT =                      "El destinatario indicado no puede fabricar ese objeto. Introduce un nombre de destinatario válido"
L.ERROR_MULTISIM =                       "No se han utilizado componentes simulados. Activa solo uno de los siguientes addons compatibles:"
