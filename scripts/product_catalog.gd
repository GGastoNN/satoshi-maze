extends RefCounted
class_name ProductCatalog

const PRODUCTS := {
	"full_pass": {
		"name": "MAZE PASS · 100",
		"kind": "pass",
		"price_sats": 149,
		"icon": "∞",
		"description": "Desbloquea permanentemente todos los laberintos premium del 4 al 100.",
		"accent": "ffd166",
	},
	"pro_stats": {
		"name": "PRO STATS",
		"kind": "feature",
		"price_sats": 29,
		"icon": "⌁",
		"description": "Panel avanzado: eficiencia global, récords, actividad y comparativas.",
		"accent": "58e7ff",
	},
	"skin_btc_gold": {
		"name": "BITCOIN GOLD",
		"kind": "skin",
		"price_sats": 15,
		"icon": "₿",
		"description": "Núcleo dorado con pulso cálido y destello premium.",
		"accent": "ffbd2e",
	},
	"skin_plasma": {
		"name": "PLASMA CORE",
		"kind": "skin",
		"price_sats": 12,
		"icon": "●",
		"description": "Esfera magenta-cyan de alta energía.",
		"accent": "ff5fce",
	},
	"skin_emerald": {
		"name": "EMERALD",
		"kind": "skin",
		"price_sats": 10,
		"icon": "◆",
		"description": "Cristal verde con brillo limpio y minimalista.",
		"accent": "4dff9d",
	},
	"skin_void": {
		"name": "VOID",
		"kind": "skin",
		"price_sats": 18,
		"icon": "◉",
		"description": "Núcleo oscuro con anillo violeta y halo profundo.",
		"accent": "a78bfa",
	},
	"trail_comet": {
		"name": "COMET TRAIL",
		"kind": "trail",
		"price_sats": 12,
		"icon": "☄",
		"description": "Cola de cometa que se desvanece tras cada movimiento.",
		"accent": "84f7ff",
	},
	"trail_lightning": {
		"name": "LIGHTNING TRAIL",
		"kind": "trail",
		"price_sats": 15,
		"icon": "ϟ",
		"description": "Conecta tu recorrido con descargas eléctricas.",
		"accent": "ffe66d",
	},
	"trail_pixels": {
		"name": "PIXEL DUST",
		"kind": "trail",
		"price_sats": 9,
		"icon": "⁙",
		"description": "Partículas retro de baja persistencia.",
		"accent": "72efdd",
	},
	"theme_sunset": {
		"name": "SUNSET GRID",
		"kind": "theme",
		"price_sats": 22,
		"icon": "◫",
		"description": "Naranjas, violetas y luces de arcade nocturno.",
		"accent": "ff8a5b",
	},
	"theme_mono": {
		"name": "MONOCHROME",
		"kind": "theme",
		"price_sats": 18,
		"icon": "◩",
		"description": "Blanco, negro y cyan para un look técnico y limpio.",
		"accent": "f5f5f5",
	},
	"theme_matrix": {
		"name": "MATRIX",
		"kind": "theme",
		"price_sats": 20,
		"icon": "▦",
		"description": "Negro profundo y verde terminal.",
		"accent": "52ff9a",
	},
	"victory_fx_supernova": {
		"name": "SUPERNOVA FINISH",
		"kind": "victory_fx",
		"price_sats": 16,
		"icon": "✦",
		"description": "Explosión de partículas premium al completar un laberinto.",
		"accent": "ffd166",
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

static func get_product(product_id: String) -> Dictionary:
	if product_id.begins_with("level_"):
		var level := int(product_id.trim_prefix("level_"))
		if level >= 4 and level <= AppConfig.TOTAL_LEVELS:
			return {
				"id": product_id,
				"name": Localization.f("maze_number", [level]),
				"kind": "level",
				"level": level,
				"price_sats": AppConfig.LEVEL_PRICE_SATS,
				"icon": "◇",
				"description": Localization.text("Desbloqueo permanente de este laberinto en tu colección."),
				"accent": "ffd166",
			}
	if not PRODUCTS.has(product_id) and not REWARD_PRODUCTS.has(product_id):
		return {}
	var source: Dictionary = PRODUCTS[product_id] if PRODUCTS.has(product_id) else REWARD_PRODUCTS[product_id]
	var item: Dictionary = source.duplicate(true)
	item["id"] = product_id
	item["name"] = Localization.text(str(item.get("name", product_id)))
	item["description"] = Localization.text(str(item.get("description", "")))
	if item.has("reward"):
		item["reward"] = Localization.text(str(item.get("reward", "")))
	return item

static func list_store_products() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var featured := [
		"full_pass", "pro_stats", "skin_btc_gold", "skin_plasma", "skin_emerald", "skin_void",
		"trail_comet", "trail_lightning", "trail_pixels", "theme_sunset", "theme_mono", "theme_matrix",
		"victory_fx_supernova"
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
