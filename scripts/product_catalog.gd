extends RefCounted
class_name ProductCatalog

const PRODUCTS := {
	"pro_stats": {
		"name": "PRO STATS", "kind": "feature", "price_sats": 29, "icon": "⌁",
		"description": "Panel avanzado: eficiencia global, récords, actividad y comparativas.", "accent": "58e7ff",
	},

	# Packs: una sola compra, varios cosméticos permanentes.
	"bundle_neon": {
		"name": "NEON STARTER PACK", "kind": "bundle", "price_sats": 39, "icon": "✧",
		"description": "Plasma Core + Comet Trail + Sunset Grid. Un set completo con precio especial.", "accent": "ff5fce",
		"items": ["skin_plasma", "trail_comet", "theme_sunset"],
	},
	"bundle_bitcoin": {
		"name": "BITCOIN SIGNATURE", "kind": "bundle", "price_sats": 49, "icon": "₿",
		"description": "Bitcoin Gold + Lightning Trail + Sats Burst. Identidad Lightning completa.", "accent": "ffbd2e",
		"items": ["skin_btc_gold", "trail_lightning", "victory_fx_sats"],
	},
	"bundle_void": {
		"name": "VOID PROTOCOL", "kind": "bundle", "price_sats": 55, "icon": "◉",
		"description": "Void + Glitch Trail + Synthwave + Portal Collapse. El set visual más intenso.", "accent": "a78bfa",
		"items": ["skin_void", "trail_glitch", "theme_synthwave", "victory_fx_portal"],
	},

	# Skins
	"skin_btc_gold": {
		"name": "BITCOIN GOLD", "kind": "skin", "price_sats": 15, "icon": "₿",
		"description": "Núcleo dorado con pulso cálido y destello premium.", "accent": "ffbd2e",
	},
	"skin_plasma": {
		"name": "PLASMA CORE", "kind": "skin", "price_sats": 12, "icon": "●",
		"description": "Esfera magenta-cyan de alta energía.", "accent": "ff5fce",
	},
	"skin_emerald": {
		"name": "EMERALD", "kind": "skin", "price_sats": 10, "icon": "◆",
		"description": "Cristal verde con brillo limpio y minimalista.", "accent": "4dff9d",
	},
	"skin_void": {
		"name": "VOID", "kind": "skin", "price_sats": 18, "icon": "◉",
		"description": "Núcleo oscuro con anillo violeta y halo profundo.", "accent": "a78bfa",
	},
	"skin_ruby": {
		"name": "CYBER RUBY", "kind": "skin", "price_sats": 13, "icon": "⬢",
		"description": "Hexágono rubí con centro brillante y estética cyberpunk.", "accent": "ff466f",
	},
	"skin_ice": {
		"name": "ICE SHARD", "kind": "skin", "price_sats": 14, "icon": "◇",
		"description": "Fragmento de hielo azul con reflejo blanco pulsante.", "accent": "9ee7ff",
	},
	"skin_solar": {
		"name": "SOLAR CORE", "kind": "skin", "price_sats": 16, "icon": "☀",
		"description": "Mini estrella naranja con corona solar animada.", "accent": "ffad33",
	},
	"skin_quantum": {
		"name": "QUANTUM", "kind": "skin", "price_sats": 20, "icon": "◎",
		"description": "Núcleo cuántico con órbitas dobles y resplandor eléctrico.", "accent": "6de7ff",
	},

	# Trails
	"trail_comet": {
		"name": "COMET TRAIL", "kind": "trail", "price_sats": 12, "icon": "☄",
		"description": "Cola de cometa que se desvanece tras cada movimiento.", "accent": "84f7ff",
	},
	"trail_lightning": {
		"name": "LIGHTNING TRAIL", "kind": "trail", "price_sats": 15, "icon": "ϟ",
		"description": "Conecta tu recorrido con descargas eléctricas.", "accent": "ffe66d",
	},
	"trail_pixels": {
		"name": "PIXEL DUST", "kind": "trail", "price_sats": 9, "icon": "⁙",
		"description": "Partículas retro de baja persistencia.", "accent": "72efdd",
	},
	"trail_neon": {
		"name": "NEON RIBBON", "kind": "trail", "price_sats": 13, "icon": "〰",
		"description": "Cinta luminosa continua que dibuja tu ruta reciente.", "accent": "ff70d9",
	},
	"trail_firefly": {
		"name": "FIREFLY", "kind": "trail", "price_sats": 11, "icon": "✣",
		"description": "Puntos de luz que titilan detrás de cada movimiento.", "accent": "d8ff73",
	},
	"trail_orbit": {
		"name": "ORBIT TRAIL", "kind": "trail", "price_sats": 17, "icon": "⊙",
		"description": "Microórbitas que giran alrededor de las huellas recientes.", "accent": "9f8cff",
	},
	"trail_glitch": {
		"name": "GLITCH TRAIL", "kind": "trail", "price_sats": 14, "icon": "▥",
		"description": "Fragmentos digitales desplazados con apariencia de señal rota.", "accent": "ff5fd7",
	},

	# Themes
	"theme_sunset": {
		"name": "SUNSET GRID", "kind": "theme", "price_sats": 22, "icon": "◫",
		"description": "Naranjas, violetas y luces de arcade nocturno.", "accent": "ff8a5b",
	},
	"theme_mono": {
		"name": "MONOCHROME", "kind": "theme", "price_sats": 18, "icon": "◩",
		"description": "Blanco, negro y cyan para un look técnico y limpio.", "accent": "f5f5f5",
	},
	"theme_matrix": {
		"name": "MATRIX", "kind": "theme", "price_sats": 20, "icon": "▦",
		"description": "Negro profundo y verde terminal.", "accent": "52ff9a",
	},
	"theme_arctic": {
		"name": "ARCTIC", "kind": "theme", "price_sats": 19, "icon": "❄",
		"description": "Azules helados, paredes blancas y reflejos de aurora.", "accent": "8de8ff",
	},
	"theme_lava": {
		"name": "LAVA CORE", "kind": "theme", "price_sats": 21, "icon": "♨",
		"description": "Negro volcánico, magma naranja y objetivos incandescentes.", "accent": "ff6b35",
	},
	"theme_ocean": {
		"name": "ABYSS OCEAN", "kind": "theme", "price_sats": 20, "icon": "≋",
		"description": "Azul abisal, turquesa y brillo bioluminiscente.", "accent": "4deeea",
	},
	"theme_synthwave": {
		"name": "SYNTHWAVE", "kind": "theme", "price_sats": 23, "icon": "▱",
		"description": "Fucsia eléctrico, violeta oscuro y cyan retrofuturista.", "accent": "ff4fd8",
	},

	# Victory effects
	"victory_fx_supernova": {
		"name": "SUPERNOVA FINISH", "kind": "victory_fx", "price_sats": 16, "icon": "✦",
		"description": "Explosión de partículas premium al completar un laberinto.", "accent": "ffd166",
	},
	"victory_fx_thunder": {
		"name": "THUNDER FINISH", "kind": "victory_fx", "price_sats": 15, "icon": "ϟ",
		"description": "Descarga eléctrica de victoria con corona Lightning.", "accent": "ffe66d",
	},
	"victory_fx_portal": {
		"name": "PORTAL COLLAPSE", "kind": "victory_fx", "price_sats": 18, "icon": "◉",
		"description": "El final se presenta como un colapso dimensional violeta.", "accent": "a78bfa",
	},
	"victory_fx_sats": {
		"name": "SATS BURST", "kind": "victory_fx", "price_sats": 21, "icon": "₿",
		"description": "Celebración dorada inspirada en sats al escapar del laberinto.", "accent": "ffbd2e",
	},
}

const REWARD_PRODUCTS := {
	"skin_nova": {
		"name": "NOVA", "kind": "skin", "price_sats": 0, "icon": "✺",
		"description": "Recompensa por alcanzar 20 estrellas.", "accent": "84f7ff", "reward": "20 estrellas"
	},
	"trail_stars": {
		"name": "STAR TRACE", "kind": "trail", "price_sats": 0, "icon": "✧",
		"description": "Recompensa por alcanzar 60 estrellas.", "accent": "ffd166", "reward": "60 estrellas"
	},
	"theme_deep": {
		"name": "DEEP SPACE", "kind": "theme", "price_sats": 0, "icon": "◌",
		"description": "Recompensa por alcanzar 120 estrellas.", "accent": "8b5cf6", "reward": "120 estrellas"
	},
}

# Traducciones de los nuevos productos. Si falta una traducción puntual, cae a inglés.
const NEW_PRODUCT_TEXT := {
	"en": {
		"NEON STARTER PACK": "NEON STARTER PACK", "Plasma Core + Comet Trail + Sunset Grid. Un set completo con precio especial.": "Plasma Core + Comet Trail + Sunset Grid. A complete set at a special price.",
		"BITCOIN SIGNATURE": "BITCOIN SIGNATURE", "Bitcoin Gold + Lightning Trail + Sats Burst. Identidad Lightning completa.": "Bitcoin Gold + Lightning Trail + Sats Burst. A complete Lightning identity.",
		"VOID PROTOCOL": "VOID PROTOCOL", "Void + Glitch Trail + Synthwave + Portal Collapse. El set visual más intenso.": "Void + Glitch Trail + Synthwave + Portal Collapse. The most intense visual set.",
		"CYBER RUBY": "CYBER RUBY", "Hexágono rubí con centro brillante y estética cyberpunk.": "Ruby hexagon with a bright core and cyberpunk styling.",
		"ICE SHARD": "ICE SHARD", "Fragmento de hielo azul con reflejo blanco pulsante.": "Blue ice shard with a pulsing white reflection.",
		"SOLAR CORE": "SOLAR CORE", "Mini estrella naranja con corona solar animada.": "Mini orange star with an animated solar corona.",
		"QUANTUM": "QUANTUM", "Núcleo cuántico con órbitas dobles y resplandor eléctrico.": "Quantum core with twin orbits and an electric glow.",
		"NEON RIBBON": "NEON RIBBON", "Cinta luminosa continua que dibuja tu ruta reciente.": "A continuous luminous ribbon tracing your recent route.",
		"FIREFLY": "FIREFLY", "Puntos de luz que titilan detrás de cada movimiento.": "Tiny lights flickering behind every move.",
		"ORBIT TRAIL": "ORBIT TRAIL", "Microórbitas que giran alrededor de las huellas recientes.": "Micro-orbits rotating around your recent footsteps.",
		"GLITCH TRAIL": "GLITCH TRAIL", "Fragmentos digitales desplazados con apariencia de señal rota.": "Offset digital fragments with a broken-signal look.",
		"ARCTIC": "ARCTIC", "Azules helados, paredes blancas y reflejos de aurora.": "Icy blues, white walls and aurora reflections.",
		"LAVA CORE": "LAVA CORE", "Negro volcánico, magma naranja y objetivos incandescentes.": "Volcanic black, orange magma and glowing goals.",
		"ABYSS OCEAN": "ABYSS OCEAN", "Azul abisal, turquesa y brillo bioluminiscente.": "Abyssal blue, turquoise and bioluminescent glow.",
		"SYNTHWAVE": "SYNTHWAVE", "Fucsia eléctrico, violeta oscuro y cyan retrofuturista.": "Electric fuchsia, dark violet and retro-futuristic cyan.",
		"THUNDER FINISH": "THUNDER FINISH", "Descarga eléctrica de victoria con corona Lightning.": "Electric victory burst with a Lightning crown.",
		"PORTAL COLLAPSE": "PORTAL COLLAPSE", "El final se presenta como un colapso dimensional violeta.": "The finish appears as a violet dimensional collapse.",
		"SATS BURST": "SATS BURST", "Celebración dorada inspirada en sats al escapar del laberinto.": "Golden sats-inspired celebration when escaping the maze.",
	},
	"pt": {
		"Plasma Core + Comet Trail + Sunset Grid. Un set completo con precio especial.": "Plasma Core + Comet Trail + Sunset Grid. Um conjunto completo com preço especial.",
		"Bitcoin Gold + Lightning Trail + Sats Burst. Identidad Lightning completa.": "Bitcoin Gold + Lightning Trail + Sats Burst. Uma identidade Lightning completa.",
		"Void + Glitch Trail + Synthwave + Portal Collapse. El set visual más intenso.": "Void + Glitch Trail + Synthwave + Portal Collapse. O conjunto visual mais intenso.",
		"Hexágono rubí con centro brillante y estética cyberpunk.": "Hexágono rubi com núcleo brilhante e visual cyberpunk.", "Fragmento de hielo azul con reflejo blanco pulsante.": "Fragmento de gelo azul com reflexo branco pulsante.", "Mini estrella naranja con corona solar animada.": "Miniestrela laranja com coroa solar animada.", "Núcleo cuántico con órbitas dobles y resplandor eléctrico.": "Núcleo quântico com órbitas duplas e brilho elétrico.",
		"Cinta luminosa continua que dibuja tu ruta reciente.": "Fita luminosa contínua que desenha sua rota recente.", "Puntos de luz que titilan detrás de cada movimiento.": "Pontos de luz que piscam atrás de cada movimento.", "Microórbitas que giran alrededor de las huellas recientes.": "Micro-órbitas que giram ao redor dos rastros recentes.", "Fragmentos digitales desplazados con apariencia de señal rota.": "Fragmentos digitais deslocados com aparência de sinal quebrado.",
		"Azules helados, paredes blancas y reflejos de aurora.": "Azuis gelados, paredes brancas e reflexos de aurora.", "Negro volcánico, magma naranja y objetivos incandescentes.": "Preto vulcânico, magma laranja e objetivos incandescentes.", "Azul abisal, turquesa y brillo bioluminiscente.": "Azul abissal, turquesa e brilho bioluminescente.", "Fucsia eléctrico, violeta oscuro y cyan retrofuturista.": "Fúcsia elétrico, violeta escuro e ciano retrofuturista.",
		"Descarga eléctrica de victoria con corona Lightning.": "Descarga elétrica de vitória com coroa Lightning.", "El final se presenta como un colapso dimensional violeta.": "O final aparece como um colapso dimensional violeta.", "Celebración dorada inspirada en sats al escapar del laberinto.": "Celebração dourada inspirada em sats ao escapar do labirinto.",
	},
	"fr": {
		"Plasma Core + Comet Trail + Sunset Grid. Un set completo con precio especial.": "Plasma Core + Comet Trail + Sunset Grid. Un ensemble complet à prix spécial.",
		"Bitcoin Gold + Lightning Trail + Sats Burst. Identidad Lightning completa.": "Bitcoin Gold + Lightning Trail + Sats Burst. Une identité Lightning complète.",
		"Void + Glitch Trail + Synthwave + Portal Collapse. El set visual más intenso.": "Void + Glitch Trail + Synthwave + Portal Collapse. L'ensemble visuel le plus intense.",
		"Hexágono rubí con centro brillante y estética cyberpunk.": "Hexagone rubis au cœur lumineux, style cyberpunk.", "Fragmento de hielo azul con reflejo blanco pulsante.": "Éclat de glace bleue avec reflet blanc pulsant.", "Mini estrella naranja con corona solar animada.": "Mini étoile orange avec couronne solaire animée.", "Núcleo cuántico con órbitas dobles y resplandor eléctrico.": "Noyau quantique à double orbite et lueur électrique.",
		"Cinta luminosa continua que dibuja tu ruta reciente.": "Ruban lumineux continu retraçant votre parcours récent.", "Puntos de luz que titilan detrás de cada movimiento.": "Petites lumières scintillant derrière chaque mouvement.", "Microórbitas que giran alrededor de las huellas recientes.": "Micro-orbites tournant autour de vos traces récentes.", "Fragmentos digitales desplazados con apariencia de señal rota.": "Fragments numériques décalés à l'aspect de signal perturbé.",
		"Azules helados, paredes blancas y reflejos de aurora.": "Bleus glacés, murs blancs et reflets d'aurore.", "Negro volcánico, magma naranja y objetivos incandescentes.": "Noir volcanique, magma orange et objectifs incandescents.", "Azul abisal, turquesa y brillo bioluminiscente.": "Bleu abyssal, turquoise et lueur bioluminescente.", "Fucsia eléctrico, violeta oscuro y cyan retrofuturista.": "Fuchsia électrique, violet sombre et cyan rétrofuturiste.",
		"Descarga eléctrica de victoria con corona Lightning.": "Décharge électrique de victoire avec couronne Lightning.", "El final se presenta como un colapso dimensional violeta.": "La fin prend la forme d'un effondrement dimensionnel violet.", "Celebración dorada inspirada en sats al escapar del laberinto.": "Célébration dorée inspirée des sats à la sortie du labyrinthe.",
	},
	"de": {
		"Plasma Core + Comet Trail + Sunset Grid. Un set completo con precio especial.": "Plasma Core + Comet Trail + Sunset Grid. Ein komplettes Set zum Sonderpreis.",
		"Bitcoin Gold + Lightning Trail + Sats Burst. Identidad Lightning completa.": "Bitcoin Gold + Lightning Trail + Sats Burst. Der komplette Lightning-Look.",
		"Void + Glitch Trail + Synthwave + Portal Collapse. El set visual más intenso.": "Void + Glitch Trail + Synthwave + Portal Collapse. Das intensivste visuelle Set.",
		"Hexágono rubí con centro brillante y estética cyberpunk.": "Rubinrotes Hexagon mit hellem Kern im Cyberpunk-Look.", "Fragmento de hielo azul con reflejo blanco pulsante.": "Blauer Eissplitter mit pulsierendem weißem Reflex.", "Mini estrella naranja con corona solar animada.": "Kleiner orangefarbener Stern mit animierter Sonnenkorona.", "Núcleo cuántico con órbitas dobles y resplandor eléctrico.": "Quantenkern mit Doppelorbit und elektrischem Leuchten.",
		"Cinta luminosa continua que dibuja tu ruta reciente.": "Durchgehendes Neonband entlang deiner letzten Route.", "Puntos de luz que titilan detrás de cada movimiento.": "Flackernde Lichtpunkte hinter jedem Zug.", "Microórbitas que giran alrededor de las huellas recientes.": "Mikro-Orbits kreisen um deine jüngsten Spuren.", "Fragmentos digitales desplazados con apariencia de señal rota.": "Versetzte digitale Fragmente im Störsignal-Look.",
		"Azules helados, paredes blancas y reflejos de aurora.": "Eisblau, weiße Wände und Aurora-Reflexe.", "Negro volcánico, magma naranja y objetivos incandescentes.": "Vulkanschwarz, oranges Magma und glühende Ziele.", "Azul abisal, turquesa y brillo bioluminiscente.": "Tiefseeblau, Türkis und biolumineszentes Leuchten.", "Fucsia eléctrico, violeta oscuro y cyan retrofuturista.": "Elektrisches Fuchsia, dunkles Violett und retrofuturistisches Cyan.",
		"Descarga eléctrica de victoria con corona Lightning.": "Elektrischer Siegeseffekt mit Lightning-Krone.", "El final se presenta como un colapso dimensional violeta.": "Das Ziel erscheint als violetter Dimensionskollaps.", "Celebración dorada inspirada en sats al escapar del laberinto.": "Goldene Sats-inspirierte Feier beim Entkommen.",
	},
	"it": {
		"Plasma Core + Comet Trail + Sunset Grid. Un set completo con precio especial.": "Plasma Core + Comet Trail + Sunset Grid. Un set completo a prezzo speciale.",
		"Bitcoin Gold + Lightning Trail + Sats Burst. Identidad Lightning completa.": "Bitcoin Gold + Lightning Trail + Sats Burst. Un'identità Lightning completa.",
		"Void + Glitch Trail + Synthwave + Portal Collapse. El set visual más intenso.": "Void + Glitch Trail + Synthwave + Portal Collapse. Il set visivo più intenso.",
		"Hexágono rubí con centro brillante y estética cyberpunk.": "Esagono rubino con nucleo luminoso e stile cyberpunk.", "Fragmento de hielo azul con reflejo blanco pulsante.": "Scheggia di ghiaccio blu con riflesso bianco pulsante.", "Mini estrella naranja con corona solar animada.": "Mini stella arancione con corona solare animata.", "Núcleo cuántico con órbitas dobles y resplandor eléctrico.": "Nucleo quantico con doppie orbite e bagliore elettrico.",
		"Cinta luminosa continua que dibuja tu ruta reciente.": "Nastro luminoso continuo che traccia il percorso recente.", "Puntos de luz que titilan detrás de cada movimiento.": "Punti luminosi che lampeggiano dietro ogni mossa.", "Microórbitas que giran alrededor de las huellas recientes.": "Micro-orbite che ruotano intorno alle tracce recenti.", "Fragmentos digitales desplazados con apariencia de señal rota.": "Frammenti digitali sfalsati con effetto segnale disturbato.",
		"Azules helados, paredes blancas y reflejos de aurora.": "Blu ghiaccio, pareti bianche e riflessi d'aurora.", "Negro volcánico, magma naranja y objetivos incandescentes.": "Nero vulcanico, magma arancione e obiettivi incandescenti.", "Azul abisal, turquesa y brillo bioluminiscente.": "Blu abissale, turchese e bagliore bioluminescente.", "Fucsia eléctrico, violeta oscuro y cyan retrofuturista.": "Fucsia elettrico, viola scuro e ciano retrofuturista.",
		"Descarga eléctrica de victoria con corona Lightning.": "Scarica elettrica di vittoria con corona Lightning.", "El final se presenta como un colapso dimensional violeta.": "Il finale appare come un collasso dimensionale viola.", "Celebración dorada inspirada en sats al escapar del laberinto.": "Celebrazione dorata ispirata ai sats quando esci dal labirinto.",
	},
}

static func get_product(product_id: String) -> Dictionary:
	if product_id.begins_with("level_"):
		var level := int(product_id.trim_prefix("level_"))
		if AppConfig.is_boss_level(level):
			return {
				"id": product_id,
				"name": "BOSS · " + Localization.f("maze_number", [level]),
				"kind": "level",
				"level": level,
				"price_sats": AppConfig.boss_price_sats(level),
				"icon": "⚡",
				"description": Localization.text("Acceso permanente a este Boss Maze. Debés llegar completando la campaña en orden."),
				"accent": "ff5fce",
			}
	if not PRODUCTS.has(product_id) and not REWARD_PRODUCTS.has(product_id):
		return {}
	var source: Dictionary = PRODUCTS[product_id] if PRODUCTS.has(product_id) else REWARD_PRODUCTS[product_id]
	var item: Dictionary = source.duplicate(true)
	item["id"] = product_id
	item["name"] = _product_text(str(item.get("name", product_id)))
	item["description"] = _product_text(str(item.get("description", "")))
	if item.has("reward"):
		item["reward"] = Localization.text(str(item.get("reward", "")))
	return item

static func _product_text(source: String) -> String:
	var language: String = Localization.current_language()
	if language == "es":
		return source
	var dictionary: Dictionary = NEW_PRODUCT_TEXT.get(language, {})
	if dictionary.has(source):
		return str(dictionary[source])
	var english: Dictionary = NEW_PRODUCT_TEXT.get("en", {})
	if english.has(source):
		return str(english[source])
	return Localization.text(source)

static func list_store_products() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var featured: Array[String] = [
		"pro_stats", "bundle_neon", "bundle_bitcoin", "bundle_void",
		"skin_btc_gold", "skin_plasma", "skin_emerald", "skin_void", "skin_ruby", "skin_ice", "skin_solar", "skin_quantum",
		"trail_comet", "trail_lightning", "trail_pixels", "trail_neon", "trail_firefly", "trail_orbit", "trail_glitch",
		"theme_sunset", "theme_mono", "theme_matrix", "theme_arctic", "theme_lava", "theme_ocean", "theme_synthwave",
		"victory_fx_supernova", "victory_fx_thunder", "victory_fx_portal", "victory_fx_sats",
	]
	for product_id in featured:
		out.append(get_product(product_id))
	return out

static func list_collection_products() -> Array[Dictionary]:
	var out := list_store_products()
	for product_id in REWARD_PRODUCTS.keys():
		out.append(get_product(str(product_id)))
	return out

static func default_cosmetics() -> Dictionary:
	return {"skin": "default", "trail": "default", "theme": "auto", "victory_fx": "default"}

static func is_cosmetic_kind(kind: String) -> bool:
	return kind in ["skin", "trail", "theme", "victory_fx"]

static func bundle_items(product_id: String) -> Array:
	var product: Dictionary = PRODUCTS.get(product_id, {})
	if str(product.get("kind", "")) != "bundle":
		return []
	var items: Array = product.get("items", [])
	return items
