extends RefCounted
class_name SaveManager

var purchased: Dictionary = {}
var best_moves: Dictionary = {}
var best_times: Dictionary = {}
var total_stars := 0

func load_data() -> void:
	if not FileAccess.file_exists(AppConfig.SAVE_PATH):
		return
	var file := FileAccess.open(AppConfig.SAVE_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	purchased = parsed.get("purchased", {})
	best_moves = parsed.get("best_moves", {})
	best_times = parsed.get("best_times", {})
	total_stars = int(parsed.get("total_stars", 0))

func save_data() -> void:
	var file := FileAccess.open(AppConfig.SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify({
		"version": AppConfig.VERSION,
		"purchased": purchased,
		"best_moves": best_moves,
		"best_times": best_times,
		"total_stars": total_stars,
	}))

func is_unlocked(level: int) -> bool:
	return level <= AppConfig.FREE_LEVELS or bool(purchased.get(str(level), false))

func unlock(level: int) -> void:
	if level > AppConfig.FREE_LEVELS:
		purchased[str(level)] = true
		save_data()

func record_result(level: int, moves: int, seconds: float, stars: int) -> void:
	var key := str(level)
	if not best_moves.has(key) or moves < int(best_moves[key]):
		best_moves[key] = moves
	if not best_times.has(key) or seconds < float(best_times[key]):
		best_times[key] = seconds
	# El total es acumulativo por mejores estrellas: recalculamos para evitar farm infinito.
	var star_key := "stars_" + key
	var old := int(purchased.get(star_key, 0))
	if stars > old:
		purchased[star_key] = stars
		total_stars += stars - old
	save_data()

func get_best_text(level: int) -> String:
	var key := str(level)
	if not best_moves.has(key):
		return "Sin marca"
	return "%d mov · %.1fs" % [int(best_moves[key]), float(best_times.get(key, 0.0))]
