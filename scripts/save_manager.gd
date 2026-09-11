extends RefCounted
class_name SaveManager

var purchased_levels: Dictionary = {}
var owned_products: Dictionary = {}
var equipped: Dictionary = ProductCatalog.default_cosmetics()
var best_moves: Dictionary = {}
var best_times: Dictionary = {}
var best_stars: Dictionary = {}
var best_efficiency: Dictionary = {}
var ghost_runs: Dictionary = {}
var purchase_history: Array = []
var challenge_records: Dictionary = {}
var achievements: Dictionary = {}
var total_stars := 0
var total_moves := 0
var total_seconds := 0.0
var total_orbs := 0
var total_completions := 0
var daily_streak := 0
var last_daily_day := -1
var infinite_best_round := 0
var install_id := ""
var language_override := "auto"
var reduced_motion := false
var show_minimap := true

func load_data() -> void:
	var source_path: String = AppConfig.SAVE_PATH
	if not FileAccess.file_exists(source_path):
		if FileAccess.file_exists(AppConfig.PREVIOUS_SAVE_PATH):
			source_path = AppConfig.PREVIOUS_SAVE_PATH
		else:
			_migrate_legacy()
			_ensure_install_id()
			return
	var file := FileAccess.open(source_path, FileAccess.READ)
	if file == null:
		_ensure_install_id()
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		_ensure_install_id()
		return
	var data: Dictionary = parsed
	_apply_data(data)
	_ensure_install_id()
	_unlock_achievements()
	# Persist newly introduced achievement cosmetics for existing V3/V4 saves.
	save_data()

func _apply_data(data: Dictionary) -> void:
	purchased_levels = data.get("purchased_levels", data.get("purchased", {}))
	owned_products = data.get("owned_products", {})
	equipped = data.get("equipped", ProductCatalog.default_cosmetics())
	best_moves = data.get("best_moves", {})
	best_times = data.get("best_times", {})
	best_stars = data.get("best_stars", {})
	best_efficiency = data.get("best_efficiency", {})
	ghost_runs = data.get("ghost_runs", {})
	purchase_history = data.get("purchase_history", [])
	challenge_records = data.get("challenge_records", {})
	achievements = data.get("achievements", {})
	total_stars = int(data.get("total_stars", 0))
	total_moves = int(data.get("total_moves", 0))
	total_seconds = float(data.get("total_seconds", 0.0))
	total_orbs = int(data.get("total_orbs", 0))
	total_completions = int(data.get("total_completions", 0))
	daily_streak = int(data.get("daily_streak", 0))
	last_daily_day = int(data.get("last_daily_day", -1))
	infinite_best_round = int(data.get("infinite_best_round", 0))
	install_id = str(data.get("install_id", ""))
	language_override = str(data.get("language_override", "auto"))
	reduced_motion = bool(data.get("reduced_motion", false))
	show_minimap = bool(data.get("show_minimap", true))

func _migrate_legacy() -> void:
	if not FileAccess.file_exists(AppConfig.LEGACY_SAVE_PATH):
		return
	var file := FileAccess.open(AppConfig.LEGACY_SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var old: Dictionary = parsed
	var old_purchased: Dictionary = old.get("purchased", {})
	for key in old_purchased.keys():
		var skey := str(key)
		if skey.begins_with("stars_"):
			best_stars[skey.trim_prefix("stars_")] = int(old_purchased[key])
		elif skey.is_valid_int() and bool(old_purchased[key]):
			purchased_levels[skey] = true
	best_moves = old.get("best_moves", {})
	best_times = old.get("best_times", {})
	total_stars = int(old.get("total_stars", 0))
	_unlock_achievements()
	save_data()

func _ensure_install_id() -> void:
	if not install_id.is_empty():
		return
	var entropy := "%s-%s-%s" % [str(Time.get_unix_time_from_system()), str(Time.get_ticks_usec()), str(randi())]
	install_id = entropy.sha256_text().substr(0, 32)
	save_data()

func save_data() -> void:
	var file := FileAccess.open(AppConfig.SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify({
		"version": AppConfig.VERSION,
		"purchased_levels": purchased_levels,
		"owned_products": owned_products,
		"equipped": equipped,
		"best_moves": best_moves,
		"best_times": best_times,
		"best_stars": best_stars,
		"best_efficiency": best_efficiency,
		"ghost_runs": ghost_runs,
		"purchase_history": purchase_history,
		"challenge_records": challenge_records,
		"achievements": achievements,
		"total_stars": total_stars,
		"total_moves": total_moves,
		"total_seconds": total_seconds,
		"total_orbs": total_orbs,
		"total_completions": total_completions,
		"daily_streak": daily_streak,
		"last_daily_day": last_daily_day,
		"infinite_best_round": infinite_best_round,
		"install_id": install_id,
		"language_override": language_override,
		"reduced_motion": reduced_motion,
		"show_minimap": show_minimap,
	}))

func is_unlocked(level: int) -> bool:
	return level <= AppConfig.FREE_LEVELS or has_product("full_pass") or bool(purchased_levels.get(str(level), false))

func unlock_level(level: int) -> void:
	if level > AppConfig.FREE_LEVELS:
		purchased_levels[str(level)] = true
		save_data()

func unlock_all_levels() -> void:
	for level in range(AppConfig.FREE_LEVELS + 1, AppConfig.TOTAL_LEVELS + 1):
		purchased_levels[str(level)] = true
	save_data()

func has_product(product_id: String) -> bool:
	return bool(owned_products.get(product_id, false))

func owns_product_id(product_id: String) -> bool:
	var product := ProductCatalog.get_product(product_id)
	if product.is_empty():
		return false
	if str(product.get("kind", "")) == "level":
		return is_unlocked(int(product.get("level", 0)))
	return has_product(product_id)

func grant_product(product_id: String, payment_id := "", amount_sats := 0) -> void:
	var product := ProductCatalog.get_product(product_id)
	if product.is_empty():
		return
	var kind := str(product.get("kind", ""))
	if kind == "level":
		unlock_level(int(product.get("level", 0)))
	elif product_id == "full_pass":
		owned_products[product_id] = true
		unlock_all_levels()
	elif kind == "bundle":
		owned_products[product_id] = true
		for bundled_product in ProductCatalog.bundle_items(product_id):
			owned_products[str(bundled_product)] = true
	else:
		owned_products[product_id] = true
	purchase_history.push_front({
		"product_id": product_id,
		"name": str(product.get("name", product_id)),
		"amount_sats": amount_sats,
		"payment_id": payment_id,
		"timestamp": int(Time.get_unix_time_from_system()),
	})
	if purchase_history.size() > 100:
		purchase_history.resize(100)
	save_data()

func can_equip(product_id: String) -> bool:
	if product_id in ["default", "auto"]:
		return true
	return has_product(product_id)

func equip_product(product_id: String) -> bool:
	var product := ProductCatalog.get_product(product_id)
	if product.is_empty() or not can_equip(product_id):
		return false
	var kind := str(product.get("kind", ""))
	if not ProductCatalog.is_cosmetic_kind(kind):
		return false
	equipped[kind] = product_id
	save_data()
	return true

func reset_equipped(kind: String) -> void:
	if kind == "theme":
		equipped[kind] = "auto"
	else:
		equipped[kind] = "default"
	save_data()

func record_result(level_key: String, moves: int, seconds: float, stars: int, shortest: int, orbs: int, path: Array, is_daily := false, count_stars := true) -> Dictionary:
	var efficiency := clampf(float(shortest) / maxf(float(moves), 1.0), 0.0, 1.0) * 100.0
	var improved := false
	if not best_moves.has(level_key) or moves < int(best_moves[level_key]):
		best_moves[level_key] = moves
		improved = true
	if not best_times.has(level_key) or seconds < float(best_times[level_key]):
		best_times[level_key] = seconds
	if not best_efficiency.has(level_key) or efficiency > float(best_efficiency[level_key]):
		best_efficiency[level_key] = efficiency
	var old_stars := int(best_stars.get(level_key, 0))
	if stars > old_stars:
		best_stars[level_key] = stars
		if count_stars:
			total_stars += stars - old_stars
	if improved or not ghost_runs.has(level_key):
		ghost_runs[level_key] = {"path": _serialize_path(path), "total_time": seconds, "moves": moves}
	total_moves += moves
	total_seconds += seconds
	total_orbs += orbs
	total_completions += 1
	if is_daily:
		_record_daily_streak()
	_unlock_achievements()
	save_data()
	return {"efficiency": efficiency, "improved": improved}

func _serialize_path(path: Array) -> Array:
	var result: Array = []
	for pos in path:
		if pos is Vector2i:
			result.append([pos.x, pos.y])
	return result

func get_ghost(level_key: String) -> Dictionary:
	var raw: Dictionary = ghost_runs.get(level_key, {})
	if raw.is_empty():
		return {}
	var positions: Array[Vector2i] = []
	for point in raw.get("path", []):
		if point is Array and point.size() >= 2:
			positions.append(Vector2i(int(point[0]), int(point[1])))
	return {
		"path": positions,
		"total_time": float(raw.get("total_time", 0.0)),
		"moves": int(raw.get("moves", positions.size())),
	}

func get_best_text(level_key: String) -> String:
	if not best_moves.has(level_key):
		return Localization.text("Sin marca")
	return Localization.f("best_text", [int(best_moves[level_key]), float(best_times.get(level_key, 0.0))])

func set_language_override(value: String) -> void:
	language_override = value if value == "auto" or value in Localization.SUPPORTED_LANGUAGES else "auto"
	save_data()


func set_reduced_motion(value: bool) -> void:
	reduced_motion = value
	save_data()

func set_show_minimap(value: bool) -> void:
	show_minimap = value
	save_data()

func get_level_stars(level: int) -> int:
	return int(best_stars.get(str(level), 0))

func record_challenge(key: String, moves: int, seconds: float, efficiency: float) -> void:
	var current: Dictionary = challenge_records.get(key, {})
	if current.is_empty() or seconds < float(current.get("seconds", 1e20)):
		challenge_records[key] = {"moves": moves, "seconds": seconds, "efficiency": efficiency}
	save_data()

func _record_daily_streak() -> void:
	var today := ChallengeManager.day_index()
	if last_daily_day == today:
		return
	if last_daily_day == today - 1:
		daily_streak += 1
	else:
		daily_streak = 1
	last_daily_day = today

func record_infinite_round(round_number: int) -> void:
	infinite_best_round = maxi(infinite_best_round, round_number)
	save_data()

func _unlock_achievements() -> void:
	if total_completions >= 1: achievements["first_escape"] = true
	if total_completions >= 25: achievements["maze_runner"] = true
	if total_completions >= 100: achievements["centurion"] = true
	if total_orbs >= 100: achievements["orb_hunter"] = true
	if total_stars >= 20: owned_products["skin_nova"] = true
	if total_stars >= 60: owned_products["trail_stars"] = true
	if total_stars >= 120: owned_products["theme_deep"] = true
	if total_stars >= 200: owned_products["aura_master"] = true
	if total_stars >= 150: achievements["star_master"] = true
	if daily_streak >= 7: achievements["daily_7"] = true
	if infinite_best_round >= 10: achievements["infinite_10"] = true

func average_efficiency() -> float:
	if best_efficiency.is_empty():
		return 0.0
	var total := 0.0
	for value in best_efficiency.values():
		total += float(value)
	return total / float(best_efficiency.size())
