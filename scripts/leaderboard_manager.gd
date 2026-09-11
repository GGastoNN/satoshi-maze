extends Node
class_name LeaderboardManager

signal leaderboard_ready(challenge_key: String, entries: Array)
signal submit_finished(ok: bool)
signal leaderboard_error(message: String)

var _http: HTTPRequest
var _stage := ""
var _key := ""

func _ready() -> void:
	_http = HTTPRequest.new()
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)

func configured() -> bool:
	return not AppConfig.LEADERBOARD_API_BASE.is_empty()

func fetch_leaderboard(challenge_key: String) -> void:
	if not configured():
		leaderboard_error.emit("Ranking online no configurado")
		return
	_stage = "fetch"
	_key = challenge_key
	var url := "%s/v1/leaderboards/%s" % [AppConfig.LEADERBOARD_API_BASE, challenge_key.uri_encode()]
	var err := _http.request(url, PackedStringArray(["Accept: application/json"]), HTTPClient.METHOD_GET)
	if err != OK:
		_stage = ""
		leaderboard_error.emit("No se pudo cargar el ranking")

func submit_score(challenge_key: String, alias_name: String, install_id: String, moves: int, seconds: float, efficiency: float, path: Array) -> void:
	if not configured():
		return
	_stage = "submit"
	_key = challenge_key
	var serialized_path: Array = []
	for p in path:
		if p is Vector2i:
			serialized_path.append([p.x, p.y])
	var body := JSON.stringify({
		"challenge_key": challenge_key,
		"alias": alias_name,
		"install_id": install_id,
		"moves": moves,
		"seconds": seconds,
		"efficiency": efficiency,
		"path": serialized_path,
		"app_version": AppConfig.VERSION,
	})
	var headers := PackedStringArray(["Content-Type: application/json", "Accept: application/json"])
	var err := _http.request(AppConfig.LEADERBOARD_API_BASE + "/v1/scores", headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		_stage = ""
		submit_finished.emit(false)

func _on_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if response_code < 200 or response_code >= 300 or typeof(parsed) != TYPE_DICTIONARY:
		var was_submit := _stage == "submit"
		_stage = ""
		if was_submit:
			submit_finished.emit(false)
		else:
			leaderboard_error.emit("Ranking no disponible")
		return
	var data: Dictionary = parsed
	if _stage == "fetch":
		var entries: Array = data.get("entries", [])
		_stage = ""
		leaderboard_ready.emit(_key, entries)
	elif _stage == "submit":
		_stage = ""
		submit_finished.emit(true)
