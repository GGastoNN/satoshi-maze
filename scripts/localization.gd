extends RefCounted
class_name Localization

const SUPPORTED_LANGUAGES: Array[String] = ["es", "en", "pt", "fr", "de", "it"]
const LANGUAGE_NAMES := {
	"es": "Español",
	"en": "English",
	"pt": "Português",
	"fr": "Français",
	"de": "Deutsch",
	"it": "Italiano",
}


const BRAND_STRINGS := {
	"en": {
		"FEEDBACK HÁPTICO": "HAPTIC FEEDBACK",
		"Vibración breve al chocar contra una pared.": "Brief vibration when you hit a wall.",
		"ACTIVADO": "ON",
		"DESACTIVADO": "OFF",
		"PRESENTA": "PRESENTS",
		"TOCÁ PARA CONTINUAR": "TAP TO CONTINUE",
		"JUEGOS · LIGHTNING · ARCADE": "GAMES · LIGHTNING · ARCADE",
		"ENTRÁ AL LABERINTO": "ENTER THE MAZE",
		"Satoshi Maze es un juego de ILLU ENTERTAINMENT.": "Satoshi Maze is a game by ILLU ENTERTAINMENT.",
		"POLÍTICA DE PRIVACIDAD": "PRIVACY POLICY",
		"TÉRMINOS Y CONDICIONES": "TERMS AND CONDITIONS",
	},
	"pt": {
		"FEEDBACK HÁPTICO": "FEEDBACK HÁPTICO",
		"Vibración breve al chocar contra una pared.": "Vibração breve ao bater em uma parede.",
		"ACTIVADO": "ATIVADO",
		"DESACTIVADO": "DESATIVADO",
		"PRESENTA": "APRESENTA",
		"TOCÁ PARA CONTINUAR": "TOQUE PARA CONTINUAR",
		"JUEGOS · LIGHTNING · ARCADE": "JOGOS · LIGHTNING · ARCADE",
		"ENTRÁ AL LABERINTO": "ENTRE NO LABIRINTO",
		"Satoshi Maze es un juego de ILLU ENTERTAINMENT.": "Satoshi Maze é um jogo da ILLU ENTERTAINMENT.",
		"POLÍTICA DE PRIVACIDAD": "POLÍTICA DE PRIVACIDADE",
		"TÉRMINOS Y CONDICIONES": "TERMOS E CONDIÇÕES",
	},
	"fr": {
		"FEEDBACK HÁPTICO": "RETOUR HAPTIQUE",
		"Vibración breve al chocar contra una pared.": "Brève vibration lors d’un choc contre un mur.",
		"ACTIVADO": "ACTIVÉ",
		"DESACTIVADO": "DÉSACTIVÉ",
		"PRESENTA": "PRÉSENTE",
		"TOCÁ PARA CONTINUAR": "TOUCHEZ POUR CONTINUER",
		"JUEGOS · LIGHTNING · ARCADE": "JEUX · LIGHTNING · ARCADE",
		"ENTRÁ AL LABERINTO": "ENTREZ DANS LE LABYRINTHE",
		"Satoshi Maze es un juego de ILLU ENTERTAINMENT.": "Satoshi Maze est un jeu d’ILLU ENTERTAINMENT.",
		"POLÍTICA DE PRIVACIDAD": "POLITIQUE DE CONFIDENTIALITÉ",
		"TÉRMINOS Y CONDICIONES": "CONDITIONS D’UTILISATION",
	},
	"de": {
		"FEEDBACK HÁPTICO": "HAPTISCHES FEEDBACK",
		"Vibración breve al chocar contra una pared.": "Kurze Vibration beim Aufprall auf eine Wand.",
		"ACTIVADO": "EIN",
		"DESACTIVADO": "AUS",
		"PRESENTA": "PRÄSENTIERT",
		"TOCÁ PARA CONTINUAR": "TIPPEN ZUM FORTFAHREN",
		"JUEGOS · LIGHTNING · ARCADE": "SPIELE · LIGHTNING · ARCADE",
		"ENTRÁ AL LABERINTO": "BETRITT DAS LABYRINTH",
		"Satoshi Maze es un juego de ILLU ENTERTAINMENT.": "Satoshi Maze ist ein Spiel von ILLU ENTERTAINMENT.",
		"POLÍTICA DE PRIVACIDAD": "DATENSCHUTZERKLÄRUNG",
		"TÉRMINOS Y CONDICIONES": "NUTZUNGSBEDINGUNGEN",
	},
	"it": {
		"FEEDBACK HÁPTICO": "FEEDBACK APTICO",
		"Vibración breve al chocar contra una pared.": "Breve vibrazione quando colpisci una parete.",
		"ACTIVADO": "ATTIVO",
		"DESACTIVADO": "DISATTIVO",
		"PRESENTA": "PRESENTA",
		"TOCÁ PARA CONTINUAR": "TOCCA PER CONTINUARE",
		"JUEGOS · LIGHTNING · ARCADE": "GIOCHI · LIGHTNING · ARCADE",
		"ENTRÁ AL LABERINTO": "ENTRA NEL LABIRINTO",
		"Satoshi Maze es un juego de ILLU ENTERTAINMENT.": "Satoshi Maze è un gioco di ILLU ENTERTAINMENT.",
		"POLÍTICA DE PRIVACIDAD": "INFORMATIVA SULLA PRIVACY",
		"TÉRMINOS Y CONDICIONES": "TERMINI E CONDIZIONI",
	},
}

static var _current_language: String = "en"
static var _override: String = "auto"

const STRINGS := {
	"en": {
		"CAMPAÑA": "CAMPAIGN",
		"CAMPAÑA · 100 LABERINTOS": "CAMPAIGN · 100 MAZES",
		"COLECCIÓN": "COLLECTION",
		"ESTADÍSTICAS": "STATS",
		"CÓMO JUGAR": "HOW TO PLAY",
		"AJUSTES": "SETTINGS",
		"IDIOMA": "LANGUAGE",
		"AUTOMÁTICO": "AUTO",
		"IDIOMA DEL DISPOSITIVO": "DEVICE LANGUAGE",
		"100 laberintos · retos globales · Ghost Run · colección premium": "100 mazes · global challenges · Ghost Run · premium collection",
		"Cada 10 niveles aparece un Boss Maze. Encontrarás niebla, llaves, portales y hielo.": "Every 10 levels brings a Boss Maze. Expect fog, keys, portals and ice.",
		"∞ MAZE PASS · DESBLOQUEAR LOS 100 · 149 SATS": "∞ MAZE PASS · UNLOCK ALL 100 · 149 SATS",
		"SIN MARCA": "NO SCORE",
		"GLOBAL CHALLENGES": "GLOBAL CHALLENGES",
		"Mismo laberinto para todos hoy.": "The same maze for everyone today.",
		"Tu marca:": "Your best:",
		"JUGAR DAILY": "PLAY DAILY",
		"Reto técnico semanal. Ghost Run y ranking global.": "Weekly technical challenge. Ghost Run and global ranking.",
		"JUGAR WEEKLY": "PLAY WEEKLY",
		"TOP DAILY": "DAILY TOP",
		"RACHA TERMINADA": "RUN ENDED",
		"NUEVA RACHA": "NEW RUN",
		"MENÚ": "MENU",
		"Compras permanentes. Sin loot boxes, sin pay-to-win. Personalizá tu identidad dentro del laberinto.": "Permanent purchases. No loot boxes, no pay-to-win. Customize your identity inside the maze.",
		"ÚLTIMAS COMPRAS": "RECENT PURCHASES",
		"EQUIPAR": "EQUIP",
		"ADQUIRIDO": "OWNED",
		"MI COLECCIÓN": "MY COLLECTION",
		"RESET SKIN": "RESET SKIN",
		"RESET TRAIL": "RESET TRAIL",
		"TU COLECCIÓN EMPIEZA ACÁ": "YOUR COLLECTION STARTS HERE",
		"Las skins y efectos premium aparecerán en esta vitrina.": "Your premium skins and effects will appear here.",
		"EXPLORAR TIENDA": "EXPLORE STORE",
		"PERFIL & ESTADÍSTICAS": "PROFILE & STATS",
		"Tu identidad anónima para rankings globales.": "Your anonymous identity for global leaderboards.",
		"Desbloquea eficiencia global, récords, actividad y métricas avanzadas.": "Unlock global efficiency, records, activity and advanced metrics.",
		"DESBLOQUEAR PRO STATS · 29 SATS": "UNLOCK PRO STATS · 29 SATS",
		"DOMINÁ EL LABERINTO": "MASTER THE MAZE",
		"Deslizá o usá el pad. Menos movimientos aumenta tu eficiencia y mejora el Ghost Run.": "Swipe or use the pad. Fewer moves improve efficiency and your Ghost Run.",
		"3 ESTRELLAS": "3 STARS",
		"Completá, resolvé cerca de la ruta óptima y recogé los tres orbes.": "Finish, stay close to the optimal path and collect all three orbs.",
		"MODIFICADORES": "MODIFIERS",
		"Niebla limita la visión. Las llaves abren la meta. Los portales cambian tu posición y el hielo te desliza.": "Fog limits vision. Keys open the goal. Portals move you and ice makes you slide.",
		"GHOST RUN": "GHOST RUN",
		"Tu mejor recorrido queda como un fantasma visual para competir contra vos mismo.": "Your best route becomes a visual ghost so you can race yourself.",
		"DAILY & WEEKLY": "DAILY & WEEKLY",
		"Desafíos de semilla global para comparar tiempos y movimientos en rankings.": "Global-seed challenges for comparing times and moves.",
		"INFINITE": "INFINITE",
		"Encadená laberintos cada vez más exigentes y buscá tu mejor racha.": "Chain increasingly difficult mazes and chase your best streak.",
		"LIGHTNING STORE": "LIGHTNING STORE",
		"Los pagos compran desbloqueos y cosméticos permanentes. No venden soluciones ni ventajas competitivas.": "Payments buy permanent unlocks and cosmetics, never solutions or competitive advantages.",
		"COMPRA LIGHTNING": "LIGHTNING PURCHASE",
		"Pago Lightning directo. Solo se habilita contenido después de una verificación criptográfica del invoice.": "Direct Lightning payment. Content unlocks only after cryptographic invoice verification.",
		"GENERAR INVOICE": "GENERATE INVOICE",
		"No pagues si el proveedor no ofrece verificación automática. El juego bloqueará el cobro antes de abrir tu wallet.": "Do not pay if the provider cannot verify automatically. The game will block payment before opening your wallet.",
		"ABRIR WALLET": "OPEN WALLET",
		"COPIAR INVOICE": "COPY INVOICE",
		"COMPROBAR AHORA": "CHECK NOW",
		"COMPRA CONFIRMADA": "PURCHASE CONFIRMED",
		"JUGAR AHORA": "PLAY NOW",
		"VER COLECCIÓN": "VIEW COLLECTION",
		"VOLVER A LA TIENDA": "BACK TO STORE",
		"¡ESCAPASTE!": "YOU ESCAPED!",
		"MEDALLA": "MEDAL",
		"ORO": "GOLD",
		"PLATA": "SILVER",
		"BRONCE": "BRONZE",
		"RUN COMPLETADO": "RUN COMPLETE",
		"SIGUIENTE NIVEL": "NEXT LEVEL",
		"VER DESAFÍOS & RANKING": "VIEW CHALLENGES & RANKING",
		"REPETIR · GHOST RUN": "REPLAY · GHOST RUN",
		"Todavía no hay tiempos publicados.": "No published times yet.",
		"Ghost Run activo: competís contra tu mejor recorrido.": "Ghost Run active: race against your best route.",
		"Tu mejor recorrido quedará guardado como Ghost Run.": "Your best route will be saved as a Ghost Run.",
		"NIEBLA": "FOG", "LLAVE": "KEY", "PORTALES": "PORTALS", "HIELO": "ICE", "CLÁSICO": "CLASSIC",
		"Creando invoice Lightning…": "Creating Lightning invoice…",
		"Consultando tu Lightning Address de forma segura…": "Securely checking the Lightning Address…",
		"Invoice listo. Esperando pago Lightning…": "Invoice ready. Waiting for Lightning payment…",
		"Esperando confirmación Lightning…": "Waiting for Lightning confirmation…",
		"¡Pago confirmado!": "Payment confirmed!",
		"Invoice copiado al portapapeles": "Invoice copied to clipboard",
		"Producto inválido": "Invalid product",
		"No se pudo conectar al servicio Lightning": "Could not connect to the Lightning service",
		"Respuesta Lightning inválida": "Invalid Lightning response",
		"El importe no está permitido por el receptor": "The amount is not accepted by the receiver",
		"El callback Lightning no es HTTPS": "The Lightning callback is not HTTPS",
		"No se pudo generar el invoice Lightning": "Could not generate the Lightning invoice",
		"Este receptor no ofrece verificación segura del pago. Compra cancelada: no envíes sats.": "This receiver does not provide secure payment verification. Purchase cancelled: do not send sats.",
		"La URL de verificación no es HTTPS": "The verification URL is not HTTPS",
		"La verificación no corresponde al invoice generado": "The verification does not match the generated invoice",
		"El invoice venció. Generá uno nuevo.": "The invoice expired. Generate a new one.",
		"Pago todavía no confirmado.": "Payment not confirmed yet.",
		"Las compras se guardan en este dispositivo. Sin servidor no hay restauración segura tras borrar la app o cambiar de teléfono.": "Purchases are stored on this device. Without a server, secure restoration after deleting the app or changing phones is not available.",
		"Ranking online no configurado": "Online ranking not configured",
		"No se pudo cargar el ranking": "Could not load the leaderboard",
		"Ranking no disponible": "Leaderboard unavailable",
		"BITCOIN GOLD": "BITCOIN GOLD",
		"Núcleo dorado con pulso cálido y destello premium.": "Golden core with a warm pulse and premium glow.",
		"PLASMA CORE": "PLASMA CORE",
		"Esfera magenta-cyan de alta energía.": "High-energy magenta-cyan sphere.",
		"EMERALD": "EMERALD",
		"Cristal verde con brillo limpio y minimalista.": "Green crystal with a clean minimalist glow.",
		"VOID": "VOID",
		"Núcleo oscuro con anillo violeta y halo profundo.": "Dark core with a violet ring and deep halo.",
		"COMET TRAIL": "COMET TRAIL",
		"Cola de cometa que se desvanece tras cada movimiento.": "Comet tail that fades after every move.",
		"LIGHTNING TRAIL": "LIGHTNING TRAIL",
		"Conecta tu recorrido con descargas eléctricas.": "Connects your route with electric arcs.",
		"PIXEL DUST": "PIXEL DUST",
		"Partículas retro de baja persistencia.": "Short-lived retro particles.",
		"SUNSET GRID": "SUNSET GRID",
		"Naranjas, violetas y luces de arcade nocturno.": "Orange, violet and late-night arcade lights.",
		"MONOCHROME": "MONOCHROME",
		"Blanco, negro y cyan para un look técnico y limpio.": "Black, white and cyan for a clean technical look.",
		"MATRIX": "MATRIX",
		"Negro profundo y verde terminal.": "Deep black and terminal green.",
		"SUPERNOVA FINISH": "SUPERNOVA FINISH",
		"Explosión de partículas premium al completar un laberinto.": "Premium particle burst when completing a maze.",
		"MAZE PASS · 100": "MAZE PASS · 100",
		"Desbloquea permanentemente todos los laberintos premium del 4 al 100.": "Permanently unlocks every premium maze from 4 to 100.",
		"PRO STATS": "PRO STATS",
		"Panel avanzado: eficiencia global, récords, actividad y comparativas.": "Advanced panel: global efficiency, records, activity and comparisons.",
		"Desbloqueo permanente de este laberinto en tu colección.": "Permanent unlock for this maze.",
		"NOVA": "NOVA", "STAR TRACE": "STAR TRACE", "DEEP SPACE": "DEEP SPACE",
		"Recompensa por alcanzar 20 estrellas.": "Reward for reaching 20 stars.",
		"Recompensa por alcanzar 60 estrellas.": "Reward for reaching 60 stars.",
		"Recompensa por alcanzar 120 estrellas.": "Reward for reaching 120 stars.",
	},
	"pt": {
		"CAMPAÑA": "CAMPANHA", "CAMPAÑA · 100 LABERINTOS": "CAMPANHA · 100 LABIRINTOS", "COLECCIÓN": "COLEÇÃO", "ESTADÍSTICAS": "ESTATÍSTICAS", "CÓMO JUGAR": "COMO JOGAR", "AJUSTES": "CONFIGURAÇÕES", "IDIOMA": "IDIOMA", "AUTOMÁTICO": "AUTOMÁTICO", "IDIOMA DEL DISPOSITIVO": "IDIOMA DO DISPOSITIVO",
		"100 laberintos · retos globales · Ghost Run · colección premium": "100 labirintos · desafios globais · Ghost Run · coleção premium",
		"Cada 10 niveles aparece un Boss Maze. Encontrarás niebla, llaves, portales y hielo.": "A cada 10 níveis aparece um Boss Maze. Há neblina, chaves, portais e gelo.",
		"SIN MARCA": "SEM MARCA", "JUGAR DAILY": "JOGAR DAILY", "JUGAR WEEKLY": "JOGAR WEEKLY", "RACHA TERMINADA": "SEQUÊNCIA ENCERRADA", "NUEVA RACHA": "NOVA SEQUÊNCIA", "MENÚ": "MENU",
		"Compras permanentes. Sin loot boxes, sin pay-to-win. Personalizá tu identidad dentro del laberinto.": "Compras permanentes. Sem loot boxes e sem pay-to-win. Personalize sua identidade no labirinto.",
		"ÚLTIMAS COMPRAS": "ÚLTIMAS COMPRAS", "EQUIPAR": "EQUIPAR", "ADQUIRIDO": "ADQUIRIDO", "MI COLECCIÓN": "MINHA COLEÇÃO", "TU COLECCIÓN EMPIEZA ACÁ": "SUA COLEÇÃO COMEÇA AQUI", "EXPLORAR TIENDA": "EXPLORAR LOJA",
		"PERFIL & ESTADÍSTICAS": "PERFIL & ESTATÍSTICAS", "Tu identidad anónima para rankings globales.": "Sua identidade anônima nos rankings globais.",
		"DOMINÁ EL LABERINTO": "DOMINE O LABIRINTO", "Deslizá o usá el pad. Menos movimientos aumenta tu eficiencia y mejora el Ghost Run.": "Deslize ou use o controle. Menos movimentos aumentam a eficiência e melhoram o Ghost Run.",
		"3 ESTRELLAS": "3 ESTRELAS", "Completá, resolvé cerca de la ruta óptima y recogé los tres orbes.": "Complete, fique perto da rota ideal e colete os três orbes.",
		"MODIFICADORES": "MODIFICADORES", "Niebla limita la visión. Las llaves abren la meta. Los portales cambian tu posición y el hielo te desliza.": "A neblina limita a visão. Chaves abrem a meta. Portais mudam sua posição e o gelo faz você deslizar.",
		"Tu mejor recorrido queda como un fantasma visual para competir contra vos mismo.": "Seu melhor percurso vira um fantasma visual para competir contra você mesmo.",
		"Desafíos de semilla global para comparar tiempos y movimientos en rankings.": "Desafios com seed global para comparar tempos e movimentos.",
		"Encadená laberintos cada vez más exigentes y buscá tu mejor racha.": "Complete labirintos cada vez mais difíceis e busque sua melhor sequência.",
		"Los pagos compran desbloqueos y cosméticos permanentes. No venden soluciones ni ventajas competitivas.": "Pagamentos compram desbloqueios e cosméticos permanentes, nunca soluções ou vantagens competitivas.",
		"COMPRA LIGHTNING": "COMPRA LIGHTNING", "Pago Lightning directo. Solo se habilita contenido después de una verificación criptográfica del invoice.": "Pagamento Lightning direto. O conteúdo só é liberado após verificação criptográfica do invoice.",
		"GENERAR INVOICE": "GERAR INVOICE", "No pagues si el proveedor no ofrece verificación automática. El juego bloqueará el cobro antes de abrir tu wallet.": "Não pague se o provedor não oferecer verificação automática. O jogo bloqueará a cobrança antes de abrir sua wallet.",
		"COPIAR INVOICE": "COPIAR INVOICE", "COMPROBAR AHORA": "VERIFICAR AGORA", "COMPRA CONFIRMADA": "COMPRA CONFIRMADA", "JUGAR AHORA": "JOGAR AGORA", "VER COLECCIÓN": "VER COLEÇÃO", "VOLVER A LA TIENDA": "VOLTAR À LOJA",
		"¡ESCAPASTE!": "VOCÊ ESCAPOU!", "MEDALLA": "MEDALHA", "ORO": "OURO", "PLATA": "PRATA", "BRONCE": "BRONZE", "RUN COMPLETADO": "RUN CONCLUÍDO", "SIGUIENTE NIVEL": "PRÓXIMO NÍVEL", "REPETIR · GHOST RUN": "REPETIR · GHOST RUN",
		"Ghost Run activo: competís contra tu mejor recorrido.": "Ghost Run ativo: compita contra seu melhor percurso.", "Tu mejor recorrido quedará guardado como Ghost Run.": "Seu melhor percurso será salvo como Ghost Run.",
		"NIEBLA": "NEBLINA", "LLAVE": "CHAVE", "PORTALES": "PORTAIS", "HIELO": "GELO", "CLÁSICO": "CLÁSSICO",
		"Creando invoice Lightning…": "Criando invoice Lightning…", "Consultando tu Lightning Address de forma segura…": "Consultando a Lightning Address com segurança…", "Invoice listo. Esperando pago Lightning…": "Invoice pronto. Aguardando pagamento Lightning…", "Esperando confirmación Lightning…": "Aguardando confirmação Lightning…", "¡Pago confirmado!": "Pagamento confirmado!", "Invoice copiado al portapapeles": "Invoice copiado para a área de transferência",
		"Producto inválido": "Produto inválido", "No se pudo conectar al servicio Lightning": "Não foi possível conectar ao serviço Lightning", "Respuesta Lightning inválida": "Resposta Lightning inválida", "El importe no está permitido por el receptor": "O valor não é aceito pelo recebedor", "El callback Lightning no es HTTPS": "O callback Lightning não usa HTTPS", "No se pudo generar el invoice Lightning": "Não foi possível gerar o invoice Lightning", "Este receptor no ofrece verificación segura del pago. Compra cancelada: no envíes sats.": "Este recebedor não oferece verificação segura. Compra cancelada: não envie sats.", "La URL de verificación no es HTTPS": "A URL de verificação não usa HTTPS", "La verificación no corresponde al invoice generado": "A verificação não corresponde ao invoice gerado", "El invoice venció. Generá uno nuevo.": "O invoice expirou. Gere um novo.", "Pago todavía no confirmado.": "Pagamento ainda não confirmado.",
		"Las compras se guardan en este dispositivo. Sin servidor no hay restauración segura tras borrar la app o cambiar de teléfono.": "As compras ficam salvas neste dispositivo. Sem servidor não há restauração segura após apagar o app ou trocar de telefone.",
		"BITCOIN GOLD": "BITCOIN GOLD", "Núcleo dorado con pulso cálido y destello premium.": "Núcleo dourado com pulso quente e brilho premium.", "PLASMA CORE": "PLASMA CORE", "Esfera magenta-cyan de alta energía.": "Esfera magenta-ciano de alta energia.", "EMERALD": "EMERALD", "Cristal verde con brillo limpio y minimalista.": "Cristal verde com brilho limpo e minimalista.", "VOID": "VOID", "Núcleo oscuro con anillo violeta y halo profundo.": "Núcleo escuro com anel violeta e halo profundo.", "COMET TRAIL": "COMET TRAIL", "Cola de cometa que se desvanece tras cada movimiento.": "Cauda de cometa que desaparece após cada movimento.", "LIGHTNING TRAIL": "LIGHTNING TRAIL", "Conecta tu recorrido con descargas eléctricas.": "Conecta seu percurso com descargas elétricas.", "PIXEL DUST": "PIXEL DUST", "Partículas retro de baja persistencia.": "Partículas retrô de curta duração.", "SUNSET GRID": "SUNSET GRID", "Naranjas, violetas y luces de arcade nocturno.": "Laranjas, violetas e luzes de arcade noturno.", "MONOCHROME": "MONOCHROME", "Blanco, negro y cyan para un look técnico y limpio.": "Branco, preto e ciano para um visual técnico e limpo.", "MATRIX": "MATRIX", "Negro profundo y verde terminal.": "Preto profundo e verde terminal.", "SUPERNOVA FINISH": "SUPERNOVA FINISH", "Explosión de partículas premium al completar un laberinto.": "Explosão premium de partículas ao completar um labirinto.", "Desbloquea permanentemente todos los laberintos premium del 4 al 100.": "Desbloqueia permanentemente todos os labirintos premium do 4 ao 100.", "Panel avanzado: eficiencia global, récords, actividad y comparativas.": "Painel avançado: eficiência global, recordes, atividade e comparações.", "Desbloqueo permanente de este laberinto en tu colección.": "Desbloqueio permanente deste labirinto.",
		"Recompensa por alcanzar 20 estrellas.": "Recompensa por alcançar 20 estrelas.", "Recompensa por alcanzar 60 estrellas.": "Recompensa por alcançar 60 estrelas.", "Recompensa por alcanzar 120 estrellas.": "Recompensa por alcançar 120 estrelas.",
	},
	"fr": {
		"CAMPAÑA": "CAMPAGNE", "CAMPAÑA · 100 LABERINTOS": "CAMPAGNE · 100 LABYRINTHES", "COLECCIÓN": "COLLECTION", "ESTADÍSTICAS": "STATISTIQUES", "CÓMO JUGAR": "COMMENT JOUER", "AJUSTES": "PARAMÈTRES", "IDIOMA": "LANGUE", "AUTOMÁTICO": "AUTO", "IDIOMA DEL DISPOSITIVO": "LANGUE DE L’APPAREIL",
		"100 laberintos · retos globales · Ghost Run · colección premium": "100 labyrinthes · défis mondiaux · Ghost Run · collection premium", "SIN MARCA": "AUCUN SCORE", "JUGAR DAILY": "JOUER DAILY", "JUGAR WEEKLY": "JOUER WEEKLY", "RACHA TERMINADA": "SÉRIE TERMINÉE", "NUEVA RACHA": "NOUVELLE SÉRIE", "MENÚ": "MENU",
		"Compras permanentes. Sin loot boxes, sin pay-to-win. Personalizá tu identidad dentro del laberinto.": "Achats permanents. Pas de loot boxes ni de pay-to-win. Personnalisez votre identité dans le labyrinthe.", "ÚLTIMAS COMPRAS": "ACHATS RÉCENTS", "EQUIPAR": "ÉQUIPER", "ADQUIRIDO": "ACQUIS", "MI COLECCIÓN": "MA COLLECTION", "EXPLORAR TIENDA": "VOIR LA BOUTIQUE",
		"PERFIL & ESTADÍSTICAS": "PROFIL & STATISTIQUES", "DOMINÁ EL LABERINTO": "MAÎTRISEZ LE LABYRINTHE", "3 ESTRELLAS": "3 ÉTOILES", "MODIFICADORES": "MODIFICATEURS", "INFINITE": "INFINITE",
		"COMPRA LIGHTNING": "ACHAT LIGHTNING", "GENERAR INVOICE": "GÉNÉRER LA FACTURE", "COPIAR INVOICE": "COPIER LA FACTURE", "COMPROBAR AHORA": "VÉRIFIER", "COMPRA CONFIRMADA": "ACHAT CONFIRMÉ", "JUGAR AHORA": "JOUER", "VER COLECCIÓN": "VOIR LA COLLECTION", "VOLVER A LA TIENDA": "RETOUR À LA BOUTIQUE",
		"¡ESCAPASTE!": "VOUS ÊTES SORTI !", "MEDALLA": "MÉDAILLE", "ORO": "OR", "PLATA": "ARGENT", "BRONCE": "BRONZE", "RUN COMPLETADO": "RUN TERMINÉ", "SIGUIENTE NIVEL": "NIVEAU SUIVANT", "REPETIR · GHOST RUN": "REJOUER · GHOST RUN",
		"NIEBLA": "BROUILLARD", "LLAVE": "CLÉ", "PORTALES": "PORTAILS", "HIELO": "GLACE", "CLÁSICO": "CLASSIQUE",
		"Creando invoice Lightning…": "Création de la facture Lightning…", "Consultando tu Lightning Address de forma segura…": "Vérification sécurisée de l’adresse Lightning…", "Invoice listo. Esperando pago Lightning…": "Facture prête. En attente du paiement Lightning…", "Esperando confirmación Lightning…": "En attente de confirmation Lightning…", "¡Pago confirmado!": "Paiement confirmé !", "Invoice copiado al portapapeles": "Facture copiée",
		"Producto inválido": "Produit invalide", "No se pudo conectar al servicio Lightning": "Impossible de joindre le service Lightning", "Respuesta Lightning inválida": "Réponse Lightning invalide", "El importe no está permitido por el receptor": "Montant refusé par le destinataire", "El callback Lightning no es HTTPS": "Le callback Lightning n’est pas HTTPS", "No se pudo generar el invoice Lightning": "Impossible de générer la facture Lightning", "Este receptor no ofrece verificación segura del pago. Compra cancelada: no envíes sats.": "Ce destinataire ne fournit pas de vérification sûre. Achat annulé : n’envoyez pas de sats.", "La URL de verificación no es HTTPS": "L’URL de vérification n’est pas HTTPS", "La verificación no corresponde al invoice generado": "La vérification ne correspond pas à la facture", "El invoice venció. Generá uno nuevo.": "La facture a expiré. Générez-en une nouvelle.", "Pago todavía no confirmado.": "Paiement pas encore confirmé.",
		"BITCOIN GOLD": "BITCOIN GOLD", "Núcleo dorado con pulso cálido y destello premium.": "Noyau doré, pulsation chaude et éclat premium.", "PLASMA CORE": "PLASMA CORE", "Esfera magenta-cyan de alta energía.": "Sphère magenta-cyan à haute énergie.", "EMERALD": "EMERALD", "Cristal verde con brillo limpio y minimalista.": "Cristal vert au rendu minimaliste.", "VOID": "VOID", "Núcleo oscuro con anillo violeta y halo profundo.": "Noyau sombre avec anneau violet et halo profond.", "COMET TRAIL": "COMET TRAIL", "Cola de cometa que se desvanece tras cada movimiento.": "Traînée de comète qui s’estompe après chaque mouvement.", "LIGHTNING TRAIL": "LIGHTNING TRAIL", "Conecta tu recorrido con descargas eléctricas.": "Relie votre trajet par des arcs électriques.", "PIXEL DUST": "PIXEL DUST", "Partículas retro de baja persistencia.": "Particules rétro à courte persistance.", "SUNSET GRID": "SUNSET GRID", "Naranjas, violetas y luces de arcade nocturno.": "Orange, violet et lumières d’arcade nocturnes.", "MONOCHROME": "MONOCHROME", "Blanco, negro y cyan para un look técnico y limpio.": "Noir, blanc et cyan pour un style technique épuré.", "MATRIX": "MATRIX", "Negro profundo y verde terminal.": "Noir profond et vert terminal.", "SUPERNOVA FINISH": "SUPERNOVA FINISH", "Explosión de partículas premium al completar un laberinto.": "Explosion premium de particules à la fin d’un labyrinthe.",
	},
	"de": {
		"CAMPAÑA": "KAMPAGNE", "CAMPAÑA · 100 LABERINTOS": "KAMPAGNE · 100 LABYRINTHE", "COLECCIÓN": "SAMMLUNG", "ESTADÍSTICAS": "STATISTIK", "CÓMO JUGAR": "SO SPIELST DU", "AJUSTES": "EINSTELLUNGEN", "IDIOMA": "SPRACHE", "AUTOMÁTICO": "AUTO", "IDIOMA DEL DISPOSITIVO": "GERÄTESPRACHE",
		"100 laberintos · retos globales · Ghost Run · colección premium": "100 Labyrinthe · globale Challenges · Ghost Run · Premium-Sammlung", "SIN MARCA": "KEIN REKORD", "JUGAR DAILY": "DAILY SPIELEN", "JUGAR WEEKLY": "WEEKLY SPIELEN", "RACHA TERMINADA": "SERIE BEENDET", "NUEVA RACHA": "NEUE SERIE", "MENÚ": "MENÜ",
		"Compras permanentes. Sin loot boxes, sin pay-to-win. Personalizá tu identidad dentro del laberinto.": "Dauerhafte Käufe. Keine Lootboxen, kein Pay-to-win. Personalisiere deinen Look im Labyrinth.", "ÚLTIMAS COMPRAS": "LETZTE KÄUFE", "EQUIPAR": "AUSRÜSTEN", "ADQUIRIDO": "GEKAUFT", "MI COLECCIÓN": "MEINE SAMMLUNG", "EXPLORAR TIENDA": "SHOP ÖFFNEN",
		"PERFIL & ESTADÍSTICAS": "PROFIL & STATISTIK", "DOMINÁ EL LABERINTO": "MEISTERE DAS LABYRINTH", "3 ESTRELLAS": "3 STERNE", "MODIFICADORES": "MODIFIKATOREN",
		"COMPRA LIGHTNING": "LIGHTNING-KAUF", "GENERAR INVOICE": "INVOICE ERSTELLEN", "COPIAR INVOICE": "INVOICE KOPIEREN", "COMPROBAR AHORA": "JETZT PRÜFEN", "COMPRA CONFIRMADA": "KAUF BESTÄTIGT", "JUGAR AHORA": "JETZT SPIELEN", "VER COLECCIÓN": "SAMMLUNG ANSEHEN", "VOLVER A LA TIENDA": "ZURÜCK ZUM SHOP",
		"¡ESCAPASTE!": "ENTKOMMEN!", "MEDALLA": "MEDAILLE", "ORO": "GOLD", "PLATA": "SILBER", "BRONCE": "BRONZE", "RUN COMPLETADO": "RUN ABGESCHLOSSEN", "SIGUIENTE NIVEL": "NÄCHSTES LEVEL", "REPETIR · GHOST RUN": "WIEDERHOLEN · GHOST RUN",
		"NIEBLA": "NEBEL", "LLAVE": "SCHLÜSSEL", "PORTALES": "PORTALE", "HIELO": "EIS", "CLÁSICO": "KLASSISCH",
		"Creando invoice Lightning…": "Lightning-Invoice wird erstellt…", "Consultando tu Lightning Address de forma segura…": "Lightning-Adresse wird sicher abgefragt…", "Invoice listo. Esperando pago Lightning…": "Invoice bereit. Warte auf Lightning-Zahlung…", "Esperando confirmación Lightning…": "Warte auf Lightning-Bestätigung…", "¡Pago confirmado!": "Zahlung bestätigt!", "Invoice copiado al portapapeles": "Invoice kopiert",
		"Producto inválido": "Ungültiges Produkt", "No se pudo conectar al servicio Lightning": "Lightning-Dienst nicht erreichbar", "Respuesta Lightning inválida": "Ungültige Lightning-Antwort", "El importe no está permitido por el receptor": "Betrag wird vom Empfänger nicht akzeptiert", "El callback Lightning no es HTTPS": "Lightning-Callback ist nicht HTTPS", "No se pudo generar el invoice Lightning": "Lightning-Invoice konnte nicht erstellt werden", "Este receptor no ofrece verificación segura del pago. Compra cancelada: no envíes sats.": "Dieser Empfänger bietet keine sichere Zahlungsprüfung. Kauf abgebrochen: keine Sats senden.", "La URL de verificación no es HTTPS": "Prüf-URL ist nicht HTTPS", "La verificación no corresponde al invoice generado": "Prüfung passt nicht zum erstellten Invoice", "El invoice venció. Generá uno nuevo.": "Invoice abgelaufen. Erstelle einen neuen.", "Pago todavía no confirmado.": "Zahlung noch nicht bestätigt.",
	},
	"it": {
		"CAMPAÑA": "CAMPAGNA", "CAMPAÑA · 100 LABERINTOS": "CAMPAGNA · 100 LABIRINTI", "COLECCIÓN": "COLLEZIONE", "ESTADÍSTICAS": "STATISTICHE", "CÓMO JUGAR": "COME GIOCARE", "AJUSTES": "IMPOSTAZIONI", "IDIOMA": "LINGUA", "AUTOMÁTICO": "AUTO", "IDIOMA DEL DISPOSITIVO": "LINGUA DEL DISPOSITIVO",
		"100 laberintos · retos globales · Ghost Run · colección premium": "100 labirinti · sfide globali · Ghost Run · collezione premium", "SIN MARCA": "NESSUN RECORD", "JUGAR DAILY": "GIOCA DAILY", "JUGAR WEEKLY": "GIOCA WEEKLY", "RACHA TERMINADA": "SERIE TERMINATA", "NUEVA RACHA": "NUOVA SERIE", "MENÚ": "MENU",
		"Compras permanentes. Sin loot boxes, sin pay-to-win. Personalizá tu identidad dentro del laberinto.": "Acquisti permanenti. Niente loot box, niente pay-to-win. Personalizza la tua identità nel labirinto.", "ÚLTIMAS COMPRAS": "ACQUISTI RECENTI", "EQUIPAR": "EQUIPAGGIA", "ADQUIRIDO": "ACQUISTATO", "MI COLECCIÓN": "LA MIA COLLEZIONE", "EXPLORAR TIENDA": "ESPLORA NEGOZIO",
		"PERFIL & ESTADÍSTICAS": "PROFILO & STATISTICHE", "DOMINÁ EL LABERINTO": "DOMINA IL LABIRINTO", "3 ESTRELLAS": "3 STELLE", "MODIFICADORES": "MODIFICATORI",
		"COMPRA LIGHTNING": "ACQUISTO LIGHTNING", "GENERAR INVOICE": "GENERA INVOICE", "COPIAR INVOICE": "COPIA INVOICE", "COMPROBAR AHORA": "VERIFICA ORA", "COMPRA CONFIRMADA": "ACQUISTO CONFERMATO", "JUGAR AHORA": "GIOCA ORA", "VER COLECCIÓN": "VEDI COLLEZIONE", "VOLVER A LA TIENDA": "TORNA AL NEGOZIO",
		"¡ESCAPASTE!": "SEI USCITO!", "MEDALLA": "MEDAGLIA", "ORO": "ORO", "PLATA": "ARGENTO", "BRONCE": "BRONZO", "RUN COMPLETADO": "RUN COMPLETATA", "SIGUIENTE NIVEL": "LIVELLO SUCCESSIVO", "REPETIR · GHOST RUN": "RIPETI · GHOST RUN",
		"NIEBLA": "NEBBIA", "LLAVE": "CHIAVE", "PORTALES": "PORTALI", "HIELO": "GHIACCIO", "CLÁSICO": "CLASSICO",
		"Creando invoice Lightning…": "Creazione invoice Lightning…", "Consultando tu Lightning Address de forma segura…": "Controllo sicuro dell’indirizzo Lightning…", "Invoice listo. Esperando pago Lightning…": "Invoice pronta. In attesa del pagamento Lightning…", "Esperando confirmación Lightning…": "In attesa della conferma Lightning…", "¡Pago confirmado!": "Pagamento confermato!", "Invoice copiado al portapapeles": "Invoice copiata",
		"Producto inválido": "Prodotto non valido", "No se pudo conectar al servicio Lightning": "Impossibile connettersi al servizio Lightning", "Respuesta Lightning inválida": "Risposta Lightning non valida", "El importe no está permitido por el receptor": "Importo non accettato dal destinatario", "El callback Lightning no es HTTPS": "Il callback Lightning non usa HTTPS", "No se pudo generar el invoice Lightning": "Impossibile generare l’invoice Lightning", "Este receptor no ofrece verificación segura del pago. Compra cancelada: no envíes sats.": "Il destinatario non offre una verifica sicura. Acquisto annullato: non inviare sats.", "La URL de verificación no es HTTPS": "L’URL di verifica non usa HTTPS", "La verificación no corresponde al invoice generado": "La verifica non corrisponde all’invoice generata", "El invoice venció. Generá uno nuevo.": "Invoice scaduta. Generane una nuova.", "Pago todavía no confirmado.": "Pagamento non ancora confermato.",
	},
}

const EXTRA_STRINGS := {
	"pt": {
		"Cada 10 niveles aparece un Boss Maze. Encontrarás niebla, llaves, portales y hielo.": "A cada 10 níveis surge um Boss Maze. Você encontrará neblina, chaves, portais e gelo.",
		"∞ MAZE PASS · DESBLOQUEAR LOS 100 · 149 SATS": "∞ MAZE PASS · DESBLOQUEAR OS 100 · 149 SATS",
		"GLOBAL CHALLENGES": "DESAFIOS GLOBAIS", "Mismo laberinto para todos hoy.": "O mesmo labirinto para todos hoje.", "Reto técnico semanal. Ghost Run y ranking global.": "Desafio técnico semanal. Ghost Run e ranking global.", "TOP DAILY": "TOP DAILY",
		"Las skins y efectos premium aparecerán en esta vitrina.": "Skins e efeitos premium aparecerão nesta vitrine.", "RESET SKIN": "RESETAR SKIN", "RESET TRAIL": "RESETAR TRAIL",
		"Desbloquea eficiencia global, récords, actividad y métricas avanzadas.": "Desbloqueia eficiência global, recordes, atividade e métricas avançadas.", "DESBLOQUEAR PRO STATS · 29 SATS": "DESBLOQUEAR PRO STATS · 29 SATS",
		"Tu identidad anónima para rankings globales.": "Sua identidade anônima para rankings globais.",
		"DAILY & WEEKLY": "DAILY & WEEKLY", "Desafíos de semilla global para comparar tiempos y movimientos en rankings.": "Desafios com seed global para comparar tempos e movimentos nos rankings.",
		"LIGHTNING STORE": "LIGHTNING STORE", "Pago Lightning directo. Solo se habilita contenido después de una verificación criptográfica del invoice.": "Pagamento Lightning direto. O conteúdo só é liberado após a verificação criptográfica do invoice.",
		"No pagues si el proveedor no ofrece verificación automática. El juego bloqueará el cobro antes de abrir tu wallet.": "Não pague se o provedor não oferecer verificação automática. O jogo bloqueará a cobrança antes de abrir sua wallet.",
		"Las compras se guardan en este dispositivo. Sin servidor no hay restauración segura tras borrar la app o cambiar de teléfono.": "As compras ficam salvas neste dispositivo. Sem servidor não há restauração segura depois de apagar o app ou trocar de telefone.",
		"VER DESAFÍOS & RANKING": "VER DESAFIOS & RANKING", "Todavía no hay tiempos publicados.": "Ainda não há tempos publicados.",
		"Ghost Run activo: competís contra tu mejor recorrido.": "Ghost Run ativo: você compete contra seu melhor percurso.", "Tu mejor recorrido quedará guardado como Ghost Run.": "Seu melhor percurso será salvo como Ghost Run.",
		"Pago todavía no confirmado.": "Pagamento ainda não confirmado.", "Ranking online no configurado": "Ranking online não configurado", "No se pudo cargar el ranking": "Não foi possível carregar o ranking", "Ranking no disponible": "Ranking indisponível",
	},
	"fr": {
		"Cada 10 niveles aparece un Boss Maze. Encontrarás niebla, llaves, portales y hielo.": "Tous les 10 niveaux, un Boss Maze apparaît avec brouillard, clés, portails et glace.",
		"∞ MAZE PASS · DESBLOQUEAR LOS 100 · 149 SATS": "∞ MAZE PASS · DÉBLOQUER LES 100 · 149 SATS", "GLOBAL CHALLENGES": "DÉFIS MONDIAUX", "Mismo laberinto para todos hoy.": "Le même labyrinthe pour tout le monde aujourd’hui.", "Reto técnico semanal. Ghost Run y ranking global.": "Défi technique hebdomadaire. Ghost Run et classement mondial.", "TOP DAILY": "TOP DAILY",
		"Las skins y efectos premium aparecerán en esta vitrina.": "Les skins et effets premium apparaîtront ici.", "RESET SKIN": "RÉINITIALISER SKIN", "RESET TRAIL": "RÉINITIALISER TRAIL", "TU COLECCIÓN EMPIEZA ACÁ": "VOTRE COLLECTION COMMENCE ICI",
		"Desbloquea eficiencia global, récords, actividad y métricas avanzadas.": "Débloque l’efficacité globale, les records, l’activité et les métriques avancées.", "DESBLOQUEAR PRO STATS · 29 SATS": "DÉBLOQUER PRO STATS · 29 SATS", "Tu identidad anónima para rankings globales.": "Votre identité anonyme pour les classements mondiaux.",
		"Deslizá o usá el pad. Menos movimientos aumenta tu eficiencia y mejora el Ghost Run.": "Faites glisser ou utilisez le pad. Moins de mouvements améliore l’efficacité et le Ghost Run.", "Completá, resolvé cerca de la ruta óptima y recogé los tres orbes.": "Terminez près du chemin optimal et récupérez les trois orbes.", "Niebla limita la visión. Las llaves abren la meta. Los portales cambian tu posición y el hielo te desliza.": "Le brouillard limite la vision. Les clés ouvrent l’arrivée. Les portails vous déplacent et la glace vous fait glisser.",
		"Tu mejor recorrido queda como un fantasma visual para competir contra vos mismo.": "Votre meilleur trajet devient un fantôme visuel pour vous affronter vous-même.", "DAILY & WEEKLY": "DAILY & WEEKLY", "Desafíos de semilla global para comparar tiempos y movimientos en rankings.": "Défis à seed mondiale pour comparer temps et mouvements.", "Encadená laberintos cada vez más exigentes y buscá tu mejor racha.": "Enchaînez des labyrinthes de plus en plus difficiles et visez votre meilleure série.",
		"Los pagos compran desbloqueos y cosméticos permanentes. No venden soluciones ni ventajas competitivas.": "Les paiements achètent des déblocages et cosmétiques permanents, jamais d’avantage compétitif.",
		"Pago Lightning directo. Solo se habilita contenido después de una verificación criptográfica del invoice.": "Paiement Lightning direct. Le contenu n’est débloqué qu’après vérification cryptographique de la facture.", "No pagues si el proveedor no ofrece verificación automática. El juego bloqueará el cobro antes de abrir tu wallet.": "Ne payez pas si le fournisseur ne permet pas la vérification automatique. Le jeu bloquera le paiement avant d’ouvrir votre wallet.",
		"Las compras se guardan en este dispositivo. Sin servidor no hay restauración segura tras borrar la app o cambiar de teléfono.": "Les achats restent sur cet appareil. Sans serveur, aucune restauration sûre après suppression de l’app ou changement de téléphone.", "VER DESAFÍOS & RANKING": "VOIR DÉFIS & CLASSEMENT", "Todavía no hay tiempos publicados.": "Aucun temps publié pour le moment.",
		"Ghost Run activo: competís contra tu mejor recorrido.": "Ghost Run actif : affrontez votre meilleur trajet.", "Tu mejor recorrido quedará guardado como Ghost Run.": "Votre meilleur trajet sera sauvegardé comme Ghost Run.", "Ranking online no configurado": "Classement en ligne non configuré", "No se pudo cargar el ranking": "Impossible de charger le classement", "Ranking no disponible": "Classement indisponible",
	},
	"de": {
		"Cada 10 niveles aparece un Boss Maze. Encontrarás niebla, llaves, portales y hielo.": "Alle 10 Level wartet ein Boss Maze mit Nebel, Schlüsseln, Portalen und Eis.", "∞ MAZE PASS · DESBLOQUEAR LOS 100 · 149 SATS": "∞ MAZE PASS · ALLE 100 FREISCHALTEN · 149 SATS", "GLOBAL CHALLENGES": "GLOBALE CHALLENGES", "Mismo laberinto para todos hoy.": "Heute spielt jeder dasselbe Labyrinth.", "Reto técnico semanal. Ghost Run y ranking global.": "Wöchentliche Technik-Challenge mit Ghost Run und globalem Ranking.", "TOP DAILY": "DAILY TOP",
		"Las skins y efectos premium aparecerán en esta vitrina.": "Premium-Skins und Effekte erscheinen hier.", "RESET SKIN": "SKIN ZURÜCKSETZEN", "RESET TRAIL": "TRAIL ZURÜCKSETZEN", "TU COLECCIÓN EMPIEZA ACÁ": "DEINE SAMMLUNG STARTET HIER", "EXPLORAR TIENDA": "SHOP ANSEHEN",
		"Desbloquea eficiencia global, récords, actividad y métricas avanzadas.": "Schaltet globale Effizienz, Rekorde, Aktivität und erweiterte Werte frei.", "DESBLOQUEAR PRO STATS · 29 SATS": "PRO STATS FREISCHALTEN · 29 SATS", "Tu identidad anónima para rankings globales.": "Deine anonyme Identität für globale Rankings.",
		"Deslizá o usá el pad. Menos movimientos aumenta tu eficiencia y mejora el Ghost Run.": "Wische oder nutze das Steuerkreuz. Weniger Züge verbessern Effizienz und Ghost Run.", "Completá, resolvé cerca de la ruta óptima y recogé los tres orbes.": "Schließe das Labyrinth nahe am optimalen Weg ab und sammle alle drei Orbs.", "Niebla limita la visión. Las llaves abren la meta. Los portales cambian tu posición y el hielo te desliza.": "Nebel begrenzt die Sicht. Schlüssel öffnen das Ziel. Portale versetzen dich und Eis lässt dich rutschen.",
		"Tu mejor recorrido queda como un fantasma visual para competir contra vos mismo.": "Dein bester Weg wird als visueller Ghost gespeichert.", "DAILY & WEEKLY": "DAILY & WEEKLY", "Desafíos de semilla global para comparar tiempos y movimientos en rankings.": "Challenges mit globalem Seed zum Vergleichen von Zeiten und Zügen.", "Encadená laberintos cada vez más exigentes y buscá tu mejor racha.": "Spiele immer schwierigere Labyrinthe und jage deine beste Serie.",
		"Los pagos compran desbloqueos y cosméticos permanentes. No venden soluciones ni ventajas competitivas.": "Zahlungen kaufen dauerhafte Freischaltungen und Kosmetik, niemals Lösungen oder Wettbewerbsvorteile.", "Pago Lightning directo. Solo se habilita contenido después de una verificación criptográfica del invoice.": "Direkte Lightning-Zahlung. Inhalte werden erst nach kryptografischer Invoice-Prüfung freigeschaltet.", "No pagues si el proveedor no ofrece verificación automática. El juego bloqueará el cobro antes de abrir tu wallet.": "Nicht zahlen, wenn der Anbieter keine automatische Prüfung bietet. Das Spiel blockiert vorher.",
		"Las compras se guardan en este dispositivo. Sin servidor no hay restauración segura tras borrar la app o cambiar de teléfono.": "Käufe bleiben auf diesem Gerät. Ohne Server gibt es nach Löschen der App oder Gerätewechsel keine sichere Wiederherstellung.", "VER DESAFÍOS & RANKING": "CHALLENGES & RANKING", "Todavía no hay tiempos publicados.": "Noch keine Zeiten veröffentlicht.", "Ghost Run activo: competís contra tu mejor recorrido.": "Ghost Run aktiv: tritt gegen deinen besten Weg an.", "Tu mejor recorrido quedará guardado como Ghost Run.": "Dein bester Weg wird als Ghost Run gespeichert.", "Ranking online no configurado": "Online-Ranking nicht konfiguriert", "No se pudo cargar el ranking": "Ranking konnte nicht geladen werden", "Ranking no disponible": "Ranking nicht verfügbar",
	},
	"it": {
		"Cada 10 niveles aparece un Boss Maze. Encontrarás niebla, llaves, portales y hielo.": "Ogni 10 livelli arriva un Boss Maze con nebbia, chiavi, portali e ghiaccio.", "∞ MAZE PASS · DESBLOQUEAR LOS 100 · 149 SATS": "∞ MAZE PASS · SBLOCCA TUTTI I 100 · 149 SATS", "GLOBAL CHALLENGES": "SFIDE GLOBALI", "Mismo laberinto para todos hoy.": "Oggi lo stesso labirinto per tutti.", "Reto técnico semanal. Ghost Run y ranking global.": "Sfida tecnica settimanale con Ghost Run e classifica globale.", "TOP DAILY": "TOP DAILY",
		"Las skins y efectos premium aparecerán en esta vitrina.": "Skin ed effetti premium appariranno qui.", "RESET SKIN": "RESET SKIN", "RESET TRAIL": "RESET TRAIL", "TU COLECCIÓN EMPIEZA ACÁ": "LA TUA COLLEZIONE INIZIA QUI", "EXPLORAR TIENDA": "ESPLORA NEGOZIO",
		"Desbloquea eficiencia global, récords, actividad y métricas avanzadas.": "Sblocca efficienza globale, record, attività e metriche avanzate.", "DESBLOQUEAR PRO STATS · 29 SATS": "SBLOCCA PRO STATS · 29 SATS", "Tu identidad anónima para rankings globales.": "La tua identità anonima nelle classifiche globali.",
		"Deslizá o usá el pad. Menos movimientos aumenta tu eficiencia y mejora el Ghost Run.": "Scorri o usa il pad. Meno mosse migliorano efficienza e Ghost Run.", "Completá, resolvé cerca de la ruta óptima y recogé los tres orbes.": "Completa vicino al percorso ottimale e raccogli tutti e tre gli orb.", "Niebla limita la visión. Las llaves abren la meta. Los portales cambian tu posición y el hielo te desliza.": "La nebbia limita la visuale. Le chiavi aprono il traguardo. I portali ti spostano e il ghiaccio ti fa scivolare.",
		"Tu mejor recorrido queda como un fantasma visual para competir contra vos mismo.": "Il tuo percorso migliore diventa un fantasma visivo contro cui gareggiare.", "DAILY & WEEKLY": "DAILY & WEEKLY", "Desafíos de semilla global para comparar tiempos y movimientos en rankings.": "Sfide con seed globale per confrontare tempi e mosse.", "Encadená laberintos cada vez más exigentes y buscá tu mejor racha.": "Affronta labirinti sempre più difficili e punta alla tua serie migliore.",
		"Los pagos compran desbloqueos y cosméticos permanentes. No venden soluciones ni ventajas competitivas.": "I pagamenti acquistano sblocchi e cosmetici permanenti, mai soluzioni o vantaggi competitivi.", "Pago Lightning directo. Solo se habilita contenido después de una verificación criptográfica del invoice.": "Pagamento Lightning diretto. I contenuti si sbloccano solo dopo la verifica crittografica dell’invoice.", "No pagues si el proveedor no ofrece verificación automática. El juego bloqueará el cobro antes de abrir tu wallet.": "Non pagare se il provider non offre verifica automatica. Il gioco bloccherà il pagamento prima di aprire la wallet.",
		"Las compras se guardan en este dispositivo. Sin servidor no hay restauración segura tras borrar la app o cambiar de teléfono.": "Gli acquisti restano su questo dispositivo. Senza server non c’è ripristino sicuro dopo la cancellazione dell’app o il cambio telefono.", "VER DESAFÍOS & RANKING": "VEDI SFIDE & CLASSIFICA", "Todavía no hay tiempos publicados.": "Non ci sono ancora tempi pubblicati.", "Ghost Run activo: competís contra tu mejor recorrido.": "Ghost Run attivo: gareggia contro il tuo percorso migliore.", "Tu mejor recorrido quedará guardado como Ghost Run.": "Il tuo percorso migliore sarà salvato come Ghost Run.", "Ranking online no configurado": "Classifica online non configurata", "No se pudo cargar el ranking": "Impossibile caricare la classifica", "Ranking no disponible": "Classifica non disponibile",
	},
}

const FORMATS := {
	"en": {
		"menu_summary": "★ %d    🔥 Daily %d    ∞ Record %d",
		"hud": "MOV %d   ·   %.1fs   ·   ORB %d/3%s",
		"hud_infinite": "MOV %d/%d   ·   %.1fs   ·   ORB %d/3%s",
		"maze_number": "MAZE %02d",
		"infinite_run": "INFINITE · RUN %02d",
		"infinite_failed": "You cleared %d rounds. All-time record: %d.",
		"daily_best": "Your best: %s   ·   Streak: %d",
		"weekly_best": "Your best: %s",
		"purchase_row": "✓ %s · %d sats",
		"purchase_success": "%s is now part of your local collection.",
		"result_stats": "%d moves   ·   %.1f s\nOptimal path: %d   ·   Efficiency: %.1f%%   ·   Orbs %d/3",
		"next_sats": "NEXT · %d SATS",
		"open_wallet": "OPEN WALLET · %d SATS",
		"best_text": "%d mov · %.1fs",
		"score_row": "#%d  %s   ·   %.2fs   ·   %d mov",
		"full_stats": "ESCAPES  %d\nSTARS  %d / 300\nDAILY STREAK  %d\nINFINITE RECORD  %d",
		"pro_stats": "AVG. EFFICIENCY  %.1f%%\nTOTAL MOVES  %d\nMAZE TIME  %.1f min\nORBS  %d\nACHIEVEMENTS  %d",
		"equipped": "SKIN %s   ·   TRAIL %s\nTHEME %s   ·   FINISH %s",
	},
	"pt": {
		"menu_summary": "★ %d    🔥 Daily %d    ∞ Recorde %d", "hud": "MOV %d   ·   %.1fs   ·   ORB %d/3%s", "hud_infinite": "MOV %d/%d   ·   %.1fs   ·   ORB %d/3%s", "maze_number": "LABIRINTO %02d", "infinite_run": "INFINITE · RUN %02d", "infinite_failed": "Você superou %d rodadas. Recorde histórico: %d.", "daily_best": "Sua marca: %s   ·   Sequência: %d", "weekly_best": "Sua marca: %s", "purchase_row": "✓ %s · %d sats", "purchase_success": "%s agora faz parte da sua coleção local.", "result_stats": "%d movimentos   ·   %.1f s\nRota ideal: %d   ·   Eficiência: %.1f%%   ·   Orbes %d/3", "next_sats": "PRÓXIMO · %d SATS", "open_wallet": "ABRIR WALLET · %d SATS", "best_text": "%d mov · %.1fs", "full_stats": "ESCAPES  %d\nESTRELAS  %d / 300\nDAILY STREAK  %d\nINFINITE RECORD  %d", "pro_stats": "EFICIÊNCIA MÉDIA  %.1f%%\nMOVIMENTOS TOTAIS  %d\nTEMPO EM LABIRINTOS  %.1f min\nORBES  %d\nCONQUISTAS  %d", "equipped": "SKIN %s   ·   TRAIL %s\nTEMA %s   ·   FINAL %s",
	},
	"fr": {
		"menu_summary": "★ %d    🔥 Daily %d    ∞ Record %d", "hud": "MVT %d   ·   %.1fs   ·   ORB %d/3%s", "hud_infinite": "MVT %d/%d   ·   %.1fs   ·   ORB %d/3%s", "maze_number": "LABYRINTHE %02d", "infinite_run": "INFINITE · RUN %02d", "infinite_failed": "Vous avez réussi %d manches. Record : %d.", "daily_best": "Votre record : %s   ·   Série : %d", "weekly_best": "Votre record : %s", "purchase_row": "✓ %s · %d sats", "purchase_success": "%s fait maintenant partie de votre collection locale.", "result_stats": "%d mouvements   ·   %.1f s\nChemin optimal : %d   ·   Efficacité : %.1f%%   ·   Orbes %d/3", "next_sats": "SUIVANT · %d SATS", "open_wallet": "OUVRIR WALLET · %d SATS", "best_text": "%d mvt · %.1fs", "full_stats": "SORTIES  %d\nÉTOILES  %d / 300\nSÉRIE DAILY  %d\nRECORD INFINITE  %d", "pro_stats": "EFFICACITÉ MOY.  %.1f%%\nMOUVEMENTS  %d\nTEMPS DE JEU  %.1f min\nORBES  %d\nSUCCÈS  %d", "equipped": "SKIN %s   ·   TRAIL %s\nTHÈME %s   ·   FIN %s",
	},
	"de": {
		"menu_summary": "★ %d    🔥 Daily %d    ∞ Rekord %d", "hud": "ZÜGE %d   ·   %.1fs   ·   ORB %d/3%s", "hud_infinite": "ZÜGE %d/%d   ·   %.1fs   ·   ORB %d/3%s", "maze_number": "LABYRINTH %02d", "infinite_run": "INFINITE · RUN %02d", "infinite_failed": "%d Runden geschafft. Rekord: %d.", "daily_best": "Bestwert: %s   ·   Serie: %d", "weekly_best": "Bestwert: %s", "purchase_row": "✓ %s · %d sats", "purchase_success": "%s gehört jetzt zu deiner lokalen Sammlung.", "result_stats": "%d Züge   ·   %.1f s\nOptimaler Weg: %d   ·   Effizienz: %.1f%%   ·   Orbs %d/3", "next_sats": "WEITER · %d SATS", "open_wallet": "WALLET ÖFFNEN · %d SATS", "best_text": "%d Züge · %.1fs", "full_stats": "ESCAPES  %d\nSTERNE  %d / 300\nDAILY-SERIE  %d\nINFINITE-REKORD  %d", "pro_stats": "Ø EFFIZIENZ  %.1f%%\nZÜGE GESAMT  %d\nLABYRINTH-ZEIT  %.1f min\nORBS  %d\nERFOLGE  %d", "equipped": "SKIN %s   ·   TRAIL %s\nTHEME %s   ·   FINISH %s",
	},
	"it": {
		"menu_summary": "★ %d    🔥 Daily %d    ∞ Record %d", "hud": "MOSSE %d   ·   %.1fs   ·   ORB %d/3%s", "hud_infinite": "MOSSE %d/%d   ·   %.1fs   ·   ORB %d/3%s", "maze_number": "LABIRINTO %02d", "infinite_run": "INFINITE · RUN %02d", "infinite_failed": "Hai superato %d round. Record storico: %d.", "daily_best": "Il tuo record: %s   ·   Serie: %d", "weekly_best": "Il tuo record: %s", "purchase_row": "✓ %s · %d sats", "purchase_success": "%s ora fa parte della tua collezione locale.", "result_stats": "%d mosse   ·   %.1f s\nPercorso ottimale: %d   ·   Efficienza: %.1f%%   ·   Orb %d/3", "next_sats": "SUCCESSIVO · %d SATS", "open_wallet": "APRI WALLET · %d SATS", "best_text": "%d mosse · %.1fs", "full_stats": "USCITE  %d\nSTELLE  %d / 300\nDAILY STREAK  %d\nINFINITE RECORD  %d", "pro_stats": "EFFICIENZA MEDIA  %.1f%%\nMOSSE TOTALI  %d\nTEMPO NEI LABIRINTI  %.1f min\nORB  %d\nOBIETTIVI  %d", "equipped": "SKIN %s   ·   TRAIL %s\nTEMA %s   ·   FINALE %s",
	},
}

static func configure(language_override: String = "auto") -> void:
	_override = language_override if language_override in SUPPORTED_LANGUAGES else "auto"
	_current_language = detect_device_language() if _override == "auto" else _override

static func detect_device_language() -> String:
	var locale: String = OS.get_locale().replace("-", "_").to_lower()
	for language in SUPPORTED_LANGUAGES:
		if locale == language or locale.begins_with(language + "_"):
			return language
	return "en"

static func current_language() -> String:
	return _current_language

static func current_language_name() -> String:
	return str(LANGUAGE_NAMES.get(_current_language, "English"))

static func override_value() -> String:
	return _override

static func text(source: String) -> String:
	if _current_language == "es":
		return source
	var brand_dictionary: Dictionary = BRAND_STRINGS.get(_current_language, {})
	if brand_dictionary.has(source):
		return str(brand_dictionary[source])
	var extra_dictionary: Dictionary = EXTRA_STRINGS.get(_current_language, {})
	if extra_dictionary.has(source):
		return str(extra_dictionary[source])
	var dictionary: Dictionary = STRINGS.get(_current_language, {})
	if dictionary.has(source):
		return str(dictionary[source])
	var english: Dictionary = STRINGS.get("en", {})
	return str(english.get(source, source))

static func f(key: String, values: Array) -> String:
	var language_formats: Dictionary = FORMATS.get(_current_language, {})
	var spanish_formats: Dictionary = {
		"menu_summary": "★ %d    🔥 Daily %d    ∞ Récord %d",
		"hud": "MOV %d   ·   %.1fs   ·   ORB %d/3%s",
		"hud_infinite": "MOV %d/%d   ·   %.1fs   ·   ORB %d/3%s",
		"maze_number": "LABERINTO %02d",
		"infinite_run": "INFINITE · RUN %02d",
		"infinite_failed": "Superaste %d rondas. Récord histórico: %d.",
		"daily_best": "Tu marca: %s   ·   Racha: %d",
		"weekly_best": "Tu marca: %s",
		"purchase_row": "✓ %s · %d sats",
		"purchase_success": "%s ya forma parte de tu cuenta local.",
		"result_stats": "%d movimientos   ·   %.1f s\nRuta óptima: %d   ·   Eficiencia: %.1f%%   ·   Orbes %d/3",
		"next_sats": "SIGUIENTE · %d SATS",
		"open_wallet": "ABRIR WALLET · %d SATS",
		"best_text": "%d mov · %.1fs",
		"score_row": "#%d  %s   ·   %.2fs   ·   %d mov",
		"full_stats": "ESCAPES  %d\nESTRELLAS  %d / 300\nDAILY STREAK  %d\nINFINITE RECORD  %d",
		"pro_stats": "EFICIENCIA MEDIA  %.1f%%\nMOVIMIENTOS TOTALES  %d\nTIEMPO EN LABERINTOS  %.1f min\nORBES  %d\nLOGROS  %d",
		"equipped": "SKIN %s   ·   TRAIL %s\nTEMA %s   ·   FINAL %s",
	}
	var english_formats: Dictionary = FORMATS.get("en", {})
	var template: String = str(language_formats.get(key, english_formats.get(key, spanish_formats.get(key, key)))) if _current_language != "es" else str(spanish_formats.get(key, key))
	return template % values
