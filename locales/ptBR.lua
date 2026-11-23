----------------------------------------
-- Profession Shopping List: ptBR.lua --
----------------------------------------
-- Portuguese (Brazil) localisation
-- Translator(s):

if GetLocale() ~= "ptBR" then return end
local appName, app = ...
local L = app.locales

-- Core
L.NEW_VERSION_AVAILABLE =                "Há uma versão mais recente de %s disponível:" -- %s becomes the addon name

L.RESET_DONE =                           "Dados redefinidos com sucesso."
L.REQUIRES_RELOAD =                      REQUIRES_RELOAD -- "Requires Reload"
L.DEBUG_ENABLED =                        "Modo de depuração ativado"
L.DEBUG_DISABLED =                       "Modo de depuração desativado"
L.INVALID_PARAMETERS =                   "Parâmetros inválidos"
L.INVALID_COMMAND =                      "Comando inválido"

-- Settings
L.VERSION =                              GAME_VERSION_LABEL .. ":" -- "Version"
L.SUPPORT_TEXTLONG1 =                    "Desenvolver este addon exige muito tempo e dedicação."
L.SUPPORT_TEXTLONG2 =                    "Considere apoiar financeiramente o desenvolvedor."
L.SUPPORT =                              "Apoiar"
L.BUY_ME_A_COFFEE =                      "Buy Me a Coffee" -- Brand name, if there isn't a localised version, keep it the way it is
L.THANK_YOU =                            "Obrigado!"
L.FEEDBACK_AND_HELP =                    "Comentários e Ajuda"
L.DISCORD =                              "Discord" -- Brand name, if there isn't a localised version, keep it the way it is
L.JOIN_DISCORD_SERVER =                  "Entre no servidor do Discord."
L.CTRL_C_COPY =                          "Ctrl+C para copiar:"
L.LINK_COPIED =                          "Link copiado para a área de transferência"

L.KEYBINDINGS_AND_SLASH_COMMANDS =       SETTINGS_KEYBINDINGS_LABEL .. " e comandos de barra" -- "Keybindings"
_G["BINDING_NAME_PSL_TOGGLEWINDOW"] =    app.NameShort .. ": Alternar janela"
L.ORDERS_QUEUE =                         "Fila de pedidos"
L.TOGGLE_TRACKING_WINDOW =               "Alternar janela de rastreamento"
L.RESET_WINDOW_POSITION =                "Redefinir posição da janela de rastreamento"
L.RESET_SAVED_DATA =                     "Redefinir dados salvos"
L.OPEN_SETTINGS =                        "Abrir as configurações"
L.CLEAR_TRACKED_RECIPES =                "Limpar todas as receitas rastreadas"
L.RECIPEID =                             "recipeID"
L.QUANTITY =                             "quantidade"
L.TRACK_RECIPE =                         "Rastrear uma receita"
L.UNTRACK_RECIPE =                       "Parar de rastrear uma receita"
L.UNTRACK_RECIPE_ALL =                   "Parar de rastrear todas as cópias de uma receita"
L.CRAFTING_ACHIEVEMENT =                 "conquista de criação"
L.TRACK_ACHIEVEMENT_RECIPES =            "Rastrear as receitas necessárias para a conquista vinculada"
L.ITEMLINK_OR_ITEMID =                   "itemLink ou itemID"
L.TRACK_REAGENT_RECIPES =                "Rastrear todas as receitas que usam este reagente"

L.GENERAL =                              GENERAL -- "General"
L.SHOW_MINIMAP_ICON =                    "Mostrar ícone no minimapa"
L.SHOW_MINIMAP_ICON_DESC =               "Mostra o ícone no minimapa. Se desativado, %s continuará disponível no Compartimento de Addons." -- %s becomes the addon name
L.TRACK_RECIPE_COOLDOWNS =               "Rastrear Recargas de Receitas"
L.TRACK_RECIPE_COOLDOWNS_DESC =          "Ativa o rastreamento das recargas das receitas. Elas aparecem na janela de rastreamento e, quando prontas, no chat ao entrar."
L.SHOW_WINDOW_WHEN_READY =               "Mostrar janela quando estiver pronto"
L.SHOW_WINDOW_WHEN_READY_DESC =          "Abre a janela de rastreamento ao entrar quando uma recarga estiver pronta, além do lembrete no chat."
L.SHOW_TOOLTIP_INFORMATION =             "Mostrar informações na dica de interface"
L.SHOW_TOOLTIP_INFORMATION_DESC =        "Mostra na dica de interface do item quantos reagentes você possui/precisa."
L.SHOW_CRAFTING_INFORMATION =            "Mostrar informações de criação"
L.SHOW_CRAFTING_INFORMATION_DESC =       "Mostra com qual profissão uma peça de equipamento é criada e se a receita é conhecida na sua conta."
L.SHOW_CRAFTING_COST =                   "Mostrar custo de criação"
L.SHOW_CRAFTING_COST_DESC =              "Mostra quanto custa criar um item, se essa informação estiver disponível."
L.MINIMUM_REAGENT_QUALITY =              "Qualidade mínima dos reagentes"
L.MINIMUM_REAGENT_QUALITY_DESC =         "Defina a qualidade mínima para contabilizar reagentes. Os resultados simulados continuarão tendo prioridade."
L.LOW =                                  LOW -- "Low"
L.HIGH =                                 HIGH -- "High"
L.INCLUDE_HIGHER_QUALITY =               "Incluir qualidade superior"
L.INCLUDE_HIGHER_QUALITY_DESC =          "Se devem ser contados reagentes de qualidade superior. (Por exemplo, incluir reagentes de nível 2 ao contar os de nível 1.)"
L.INCLUDE_HIGHER_QUALITY_DESC2 =         "Qualidades superiores serão consideradas automaticamente se forem mais baratas."
L.INCLUDE_HIGHER_QUALITIES_YES =         "Incluir qualidades superiores"
L.INCLUDE_HIGHER_QUALITIES_NO =          "Não incluir qualidades superiores"
L.COLLECTION_MODE =                      "Modo de coleção"
L.COLLECTION_MODE_DESC =                 "Defina quais itens serão incluídos ao usar o botão %s." -- %s becomes "Track New"
L.APPEARANCES =                          WARDROBE -- "Appearances"
L.APPEARANCES_SETTING_DESC =             "Incluir apenas itens com uma nova aparência."
L.APPEARANCES_SOURCES =                  "Fontes"
L.APPEARANCES_SOURCES_SETTING_DESC =     "Incluir itens se forem uma nova fonte, mesmo para aparências conhecidas."

L.PROFESSION_WINDOW =                    "Janela de Profissão"
L.FILTER_OPTIONAL_REAGENTS =             "Filtrar reagentes opcionais"
L.FILTER_OPTIONAL_REAGENTS_DESC =        "Quando %s estiver marcado para reagentes opcionais, ocultar itens combináveis." -- %s becomes "Hide Unavailable"
L.SPEND_TO_NEXT_PERK =                   "Gastar até o Próximo Benefício"
L.SPEND_TO_NEXT_PERK_DESC =              "Shift+clique em um nó de conhecimento de profissão gasta pontos até o próximo benefício."
L.ENHANCED_ORDERS =                      "Pedidos aprimorados"
L.ENHANCED_ORDERS_DESC =                 "Melhora a prévia das recompensas e comissões dos pedidos e adiciona ícones de primeira criação, receitas não aprendidas e receitas rastreadas."
L.QUICK_ORDER_DURATION =                 "Duração do Pedido Rápido"
L.QUICK_ORDER_DURATION_DESC =            "Defina a duração dos Pedidos Rápidos."
L.QUICK_ORDER_DURATION_SHORT =           PROFESSIONS_LISTING_DURATION_ONE -- "12 Hours"
L.QUICK_ORDER_DURATION_MEDIUM =          PROFESSIONS_LISTING_DURATION_TWO -- "24 Hours"
L.QUICK_ORDER_DURATION_LONG =            PROFESSIONS_LISTING_DURATION_THREE -- "48 Hours"

L.TRACKING_WINDOW =                      "Janela de Rastreamento"
L.SHOW_HELP_TOOLTIPS =                   "Mostrar dicas de ajuda"
L.SHOW_HELP_TOOLTIPS_DESC =              "Mostra as ações do mouse disponíveis ao passar o cursor sobre entradas na janela de rastreamento."
L.WINDOW_POSITION_PER_CHAR =             "Posição da janela por personagem"
L.WINDOW_POSITION_PER_CHAR_DESC =        "Salvar a posição da janela por personagem, em vez de por conta."
L.TRACK_RECIPES_PER_CHAR =               "Rastrear Receitas por Personagem"
L.TRACK_RECIPES_PER_CHAR_DESC =          "Rastrear receitas por personagem, em vez de por conta."
L.SHOW_REMAINING_REAGENTS =              "Mostrar reagentes restantes"
L.SHOW_REMAINING_REAGENTS_DESC =         "Mostrar apenas a quantidade de reagentes que ainda falta na janela de rastreamento, em vez de possuídos/necessários."
L.UNTRACK_ON_CRAFT =                     "Parar de Rastrear ao Criar"
L.UNTRACK_ON_CRAFT_DESC =                "Remove uma unidade da receita rastreada quando você a cria com sucesso."
L.CLOSE_WINDOW_WHEN_DONE =               "Fechar janela ao terminar"
L.CLOSE_WINDOW_WHEN_DONE_DESC =          "Fecha a janela de rastreamento após criar a última receita rastreada."

-- Tracking window
L.CLOSE_WINDOW =                         "Fechar janela"
L.LOCK_WINDOW =                          "Bloquear janela"
L.UNLOCK_WINDOW =                        "Desbloquear janela"
L.UPDATE_AUCTIONATOR_LIST1 =             "Atualizar lista de compras do Auctionator"
L.UPDATE_AUCTIONATOR_LIST2 =             "A lista de compras é gerada automaticamente ao abrir a Casa de Leilões"
L.DOUBLE =                               "Duplo" -- Followed by LMB or RMB
L.CTRL =                                 "Ctrl" -- Followed by LMB or RMB
L.ALT =                                  "Alt" -- Followed by LMB or RMB
L.SHIFT =                                "Shift" -- Followed by LMB or RMB
L.AUTOSIZE_WINDOW =                      "Ajustar automaticamente ao tamanho da janela"
L.LINK_RECIPE =                          "Vincular a receita"
L.OPEN_RECIPE =                          "Abrir a receita"
L.CRAFT_RECIPE =                         "Criar esta receita"
L.LINK_REAGENT =                         "Vincular o reagente"
L.TRACK_RECIPE_SUBREAGENT =              "Rastrear a receita para criar este reagente, se existir"
L.REMOVE_COOLDOWN_REMINDER =             "Remover este lembrete de recarga específico"

L.RECIPES =                              PROFESSIONS_RECIPES_TAB -- "Recipes"
L.ITEMS =                                ITEMS -- "Items"
L.REAGENTS =                             PROFESSIONS_COLUMN_HEADER_REAGENTS -- "Reagents"
L.COSTS =                                "Custos"
L.COOLDOWNS =                            "Recargas"
L.CLEAR_CONFIRMATION =                   "Isso limpará todas as receitas."
L.CONFIRMATION =                         "Deseja continuar?"
L.SUBREAGENTS1 =                         "Existem várias receitas que podem criar %s" -- %s becomes an item link
L.SUBREAGENTS2 =                         "Selecione uma das opções a seguir:"
L.GOLD =                                 BONUS_ROLL_REWARD_MONEY -- "Gold"
L.MERCHANT_BUY =                         "Comprar todos os reagentes rastreados, se disponíveis."

L.READY =                                READY -- "Ready"
L.DAYS =                                 "d"
L.HOURS =                                "h"
L.MINUTES =                              "m"
L.READY_TO_CRAFT =                       "%s está pronto para ser criado novamente em %s" -- %s becomes a recipe name, and character name

L.MORE_NEEDED =                          "Faltam mais %d" -- %d becomes a number
L.MADE_WITH =                            "Criado com %s" -- %s becomes a profession
L.RECIPE_LEARNED =                       "receita aprendida"
L.RECIPE_UNLEARNED =                     "receita não aprendida"
L.CRAFTING_COST =                        "Custo de Criação"

-- Profession window
L.TRACK =                                TRACK_QUEST_ABBREV -- "Track"
L.UNTRACK =                              PROFESSIONS_UNTRACK_RECIPE -- "Untrack"
L.RANK =                                 RANK -- "Rank"
L.MILLING_INFORMATION =                  "Informações de Trituração"
L.THAUMATURGY_INFORMATION =              "Informações de Taumaturgia"
L.FROM =                                 "de" -- Preceded by a percentage, followed by an item link
L.TARGET =                               STATUS_TEXT_TARGET -- "Target"
L.SWITCH_AVAILABLE_PETS =                "Alternar entre mascotes disponíveis"
L.TRACK_NEW =                            "Rastrear Novos"
L.CURRENT_SETTING =                      "Configuração atual:"
L.NEW_APPEARANCES =                      "novas aparências"
L.NEW_APPEARANCES_AND_SOURCES =          "novas aparências e fontes"
L.ADDED_RECIPES =                        "Verificadas %d receitas visíveis de %s. %d receitas rastreadas." -- %d becomes a number, %s becomes L.NEW_APPEARANCES or L.NEW_APPEARANCES_AND_SOURCES

L.RECHARGED =                            "Totalmente recarregado"
L.PROFTOOL_AUTOEQUIP =                   "Equipar esta ferramenta automaticamente" -- Followed by L.PROFTOOL_FOR
L.PROFTOOL_FOR =                         "para %s." -- %s becomes one of the two following phrases
L.PROFTOOL_DEFAULT =                     "criação normal"
L.PROFTOOL_ORDERS =                      "realizando pedidos"
L.PROFTOOL_DRAG =                        "Arraste uma ferramenta para cá."
L.PROFTOOL_EQUIP =                       "Equipar esta ferramenta."
L.PROFTOOL_REMOVE =                      "Remover esta ferramenta."

L.PERKS_UNLOCKED =                       "benefícios desbloqueados"
L.PROFESSION_KNOWLEDGE =                 "conhecimento"
L.VENDORS =                              "Vendedores"
L.RENOWN =                               COVENANT_SANCTUM_TAB_RENOWN -- "Renown "
L.WORLD =                                WORLD -- "World"
L.HIDDEN_PROFESSION_MASTER =             "Mestre de profissão oculto"
L.WEEKLY =                               WEEKLY -- "Weekly"
L.TREASURE =                             "Tesouro"
L.DROP =                                 BATTLE_PET_SOURCE_1 -- "Drop"
L.CATCHUP_KNOWLEDGE =                    "Conhecimento de recuperação disponível:"
L.LOADING =                              SEARCH_LOADING_TEXT -- "Loading..."

L.AUCTION_ADDONS =                       "Auctionator, Oribos Exchange ou TradeSkillMaster"
L.ORDERS_PRICING_MISSING =               "Ausente"
L.ORDERS_PRICING_UPDATE =                "Atualize ou examine com %s." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_SET_CRITERIA =                  "Defina os critérios para rastrear pedidos."
L.ORDERS_COST_NEED =                     "As configurações de custo só funcionam com: %s." -- %s becomes L.AUCTION_ADDONS
L.ORDERS_MAX_COST_KNOWLEDGE =            "Custo máximo por ponto de conhecimento:"
L.ORDERS_MAX_COST_ARTISAN =              "Custo máximo por moeda de artesão:" -- This refers to Artisan's Mettle, Artisan's Acuity, and Artisan's Moxie
L.ORDERS_MAX_COST_PAYOUT =               "Custo máximo por bolsa de recompensa:" -- This refers to Artisan's Payout bag
L.ORDERS_TRACK_AFTER_RESET =             "Rastrear pedidos disponíveis após a reinicialização semanal"
L.ORDERS_TRACK_CONCENTRATION =           "Rastrear pedidos que custam concentração:"
L.ORDERS_TRACK_ON =                      "Rastrear em %s:"-- %s becomes a character name

L.ORDERSQUEUE_QUEUE =                    "Fila"
L.ORDERSQUEUE_QUEUED =                   "Pedidos na fila:"
L.ORDERSQUEUE_NEXT =                     "Próximo pedido"
L.ORDERSQUEUE_CLAIM =                    "Resgatar pedido"
L.ORDERSQUEUE_CRAFT =                    "Pedido de Criação"
L.ORDERSQUEUE_CRAFTING =                 "Criando..."
L.ORDERSQUEUE_COMPLETE =                 PROFESSIONS_COMPLETE_ORDER -- "Complete Order"
L.CANCEL_FORM =                          "Cancelar formulário" -- Cancel Shapeshift Form
L.ORDERSQUEUE_WARNING_QUEST =            "Você ainda não retirou %s." -- %s becomes a quest name
L.ORDERSQUEUE_WARNING_REAGENTS =         "Você não tem reagentes suficientes para todas as receitas rastreadas."
L.ORDERSQUEUE_WARNING_KEYBIND_DK =       "Para usar o atalho próprio de %s, desative a configuração \"Pedidos de Criação\" do DialogKey." -- %s becomes PSL

-- Crafting Orders window
L.RECRAFT_TOOLTIP =                      "Selecione um item com uma receita em cache para rastreá-la."
L.QUICK_ORDER =                          "Pedido Rápido"
L.QUICKORDER_TOOLTIP1 =                  "Cria instantaneamente um pedido de criação para o destinatário especificado."
L.QUICKORDER_TOOLTIP2 =                  "Use %s (tudo em maiúsculas) para fazer um " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. "." -- "Guild Order", %s becomes "GUILD"
L.QUICKORDER_TOOLTIP3 =                  "Use o nome de um personagem para fazer um " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_PRIVATE .. "." -- "Personal Order"
L.QUICKORDER_TOOLTIP4 =                  "Os destinatários são salvos por receita."
L.USE_LOCAL_REAGENTS =                   "Usar reagentes locais"
L.USE_LOCAL_REAGENTS_DESC =              "Usa os reagentes locais disponíveis (da menor qualidade). Não é possível personalizar quais reagentes serão usados."
L.REPEAT_LAST_QUICK_ORDER =              "Repetir o último Pedido Rápido feito neste personagem"
L.RECIPIENT =                            "Destinatário"

L.FALSE =                                "falso"
L.TRUE =                                 "verdadeiro"
L.NO_LAST_QUICK_ORDER_FOUND =            "Nenhum Pedido Rápido anterior encontrado"
L.ERROR =                                "Erro:"
L.ERROR_CRAFTSIM =                       "Não foi possível ler as informações do CraftSim"
L.ERROR_REAGENTS =                       "Não é possível criar um Pedido Rápido para itens com reagentes obrigatórios"
L.ERROR_WARBANK =                        "Não é possível criar um Pedido Rápido com itens no Banco do Bando de Guerra"
L.ERROR_GUILD =                          "Não é possível criar um " .. PROFESSIONS_CRAFTING_FORM_ORDER_RECIPIENT_GUILD .. " sem estar em uma guilda" -- "Guild Order"
L.ERROR_RECIPIENT =                      "O destinatário escolhido não pode criar esse item. Informe um nome de destinatário válido"
L.ERROR_MULTISIM =                       "Nenhum reagente simulado foi usado. Ative apenas um dos seguintes addons compatíveis:"
