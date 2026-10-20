extends Node
## AdMob bridge for the GodotAdMob Android plugin.
## On editor / no inventory, the transition resolves without blocking gameplay.
signal transition_finished

# Google's official TEST ad unit IDs. Replace ONLY when live AdMob is approved.
const TEST_BANNER := "ca-app-pub-3940256099942544/6300978111"
const TEST_INTERSTITIAL := "ca-app-pub-3940256099942544/1033173712"
var admob: Node
var pending := false
var ad_was_opened := false

func _ready() -> void:
	if OS.get_name() != "Android":
		return
	# This adapter uses the node API of the GodotAdMob Android add-on.
	if not ClassDB.class_exists("AdMob"):
		push_warning("AdMob plugin missing: ads unavailable in this build")
		return
	admob = ClassDB.instantiate("AdMob") as Node
	if admob == null:
		return
	add_child(admob)
	admob.set("is_real", false)
	admob.set("banner_on_top", false)
	admob.set("banner_size", "ADAPTIVE_BANNER")
	admob.set("banner_id", TEST_BANNER)
	admob.set("interstitial_id", TEST_INTERSTITIAL)
	if admob.has_signal("interstitial_closed"):
		admob.connect("interstitial_closed", _on_closed)
	if admob.has_signal("interstitial_failed_to_load"):
		admob.connect("interstitial_failed_to_load", _on_failed)
	if admob.has_signal("interstitial_loaded"):
		admob.connect("interstitial_loaded", _on_loaded)
	admob.call("load_banner")
	admob.call("load_interstitial")

func show_level_interstitial() -> void:
	if pending:
		return
	pending = true
	ad_was_opened = false
	if admob == null:
		_finish()
		return
	if bool(admob.call("is_interstitial_loaded")):
		admob.call("show_interstitial")
	else:
		# Ad inventory is not guaranteed; never trap the player.
		_finish()
		admob.call("load_interstitial")

func _on_loaded() -> void:
	pass

func _on_closed() -> void:
	_finish()
	if admob != null:
		admob.call("load_interstitial")

func _on_failed(_error: int) -> void:
	if pending:
		_finish()

func _finish() -> void:
	if not pending:
		return
	pending = false
	transition_finished.emit()
