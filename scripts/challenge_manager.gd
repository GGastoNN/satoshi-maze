extends RefCounted
class_name ChallengeManager

static func day_index() -> int:
	return int(floor(Time.get_unix_time_from_system() / 86400.0))

static func week_index() -> int:
	return int(floor(float(day_index()) / 7.0))

static func daily_key() -> String:
	return "daily_%d" % day_index()

static func weekly_key() -> String:
	return "weekly_%d" % week_index()

static func daily_maze() -> Dictionary:
	var d := day_index()
	var pseudo_level := AppConfig.DAILY_BASE_LEVEL + posmod(d, 24)
	var seed := 0x5A7051 + d * 7919
	var modifiers := {
		"fog": posmod(d, 3) == 0,
		"requires_key": posmod(d, 2) == 0,
		"portals": posmod(d, 4) == 1,
		"ice": posmod(d, 5) == 2,
		"boss": false,
		"challenge": "daily",
	}
	return MazeGenerator.generate_custom(pseudo_level, seed, modifiers)

static func weekly_maze() -> Dictionary:
	var w := week_index()
	var pseudo_level := AppConfig.WEEKLY_BASE_LEVEL + posmod(w, 20)
	var seed := 0x71EE51 + w * 15485863
	var modifiers := {
		"fog": true,
		"requires_key": true,
		"portals": true,
		"ice": posmod(w, 2) == 0,
		"boss": true,
		"challenge": "weekly",
	}
	return MazeGenerator.generate_custom(pseudo_level, seed, modifiers)

static func infinite_maze(round_number: int) -> Dictionary:
	var pseudo_level := clampi(AppConfig.INFINITE_START_LEVEL + round_number * 3, 1, 100)
	var seed := 0x1F1F51 + day_index() * 104729 + round_number * 13007
	var modifiers := {
		"fog": round_number >= 3 and round_number % 4 == 0,
		"requires_key": round_number >= 2 and round_number % 3 == 0,
		"portals": round_number >= 4 and round_number % 5 == 0,
		"ice": round_number >= 5 and round_number % 6 == 0,
		"boss": round_number > 0 and round_number % 5 == 0,
		"challenge": "infinite",
	}
	return MazeGenerator.generate_custom(pseudo_level, seed, modifiers)

static func modifier_text(maze: Dictionary) -> String:
	var labels: Array[String] = []
	if bool(maze.get("fog", false)): labels.append(Localization.text("NIEBLA"))
	if bool(maze.get("requires_key", false)): labels.append(Localization.text("LLAVE"))
	if bool(maze.get("portals", false)): labels.append(Localization.text("PORTALES"))
	if bool(maze.get("ice", false)): labels.append(Localization.text("HIELO"))
	if bool(maze.get("boss", false)): labels.append("BOSS")
	return " · ".join(labels) if not labels.is_empty() else Localization.text("CLÁSICO")
