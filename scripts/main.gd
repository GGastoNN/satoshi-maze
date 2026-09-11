extends Control

var save := SaveManager.new()
var payment: PaymentManager
var leaderboard: LeaderboardManager
var screen_root: VBoxContainer
var backdrop: Backdrop
var current_screen := "menu"
var current_mode := "campaign"
var current_level := 1
var current_run_key := "1"
var current_maze: Dictionary = {}
var current_product: Dictionary = {}
var infinite_round := 1
var board: MazeBoard
var hud_label: Label
var game_started_ms := 0
var game_active := false
var payment_status_label: Label
var purchase_actions: VBoxContainer
var leaderboard_box: VBoxContainer
var store_filter := "all"
var audio_move: AudioStreamPlayer
var audio_orb: AudioStreamPlayer
var audio_win: AudioStreamPlayer

const TEXT := Color("eaf5ff")
const MUTED := Color("91a8c7")
const CYAN := Color("58e7ff")
const PINK := Color("ff5fce")
const GOLD := Color("ffd166")
const GREEN := Color("52ff9a")
const DANGER := Color("ff718d")

const WORLD_NAMES := [
	"NEON DISTRICT", "VIOLET CIRCUIT", "BIO GRID", "QUANTUM VAULT", "VOLCANIC CORE",
	"ARCTIC SIGNAL", "SOLAR FORGE", "MONO PROTOCOL", "ABYSS OCEAN", "SYNTHWAVE ENDGAME",
]

const WORLD_COLORS := [
	Color("58e7ff"), Color("ff70d9"), Color("52ff9a"), Color("a78bfa"), Color("ff6b35"),
	Color("9ee7ff"), Color("ffbd2e"), Color("f5f5f5"), Color("4deeea"), Color("ff4fd8"),
]

const V5_TEXT := {
	"es": {
		"VISUAL EDITION": "EDICIÓN VISUAL", "CURRENT WORLD": "MUNDO ACTUAL", "LIVE MAZE": "LABERINTO EN VIVO",
		"COLLECTION PROGRESS": "PROGRESO DE COLECCIÓN", "AURAS": "AURAS", "RESET AURA": "REINICIAR AURA",
		"REDUCED MOTION": "MOVIMIENTO REDUCIDO", "MINIMAP": "MINIMAPA", "ON": "ACTIVADO", "OFF": "DESACTIVADO",
		"Smooth movement, reactive lighting and animated worlds.": "Movimiento suave, iluminación reactiva y mundos animados.",
		"Reduce transitions and continuous movement effects.": "Reduce transiciones y efectos de movimiento continuo.",
		"Show a compact explored-area map on large mazes.": "Muestra un mapa compacto del área explorada en laberintos grandes.",
		"PERFORMANCE": "RENDIMIENTO", "NEW PERSONAL BEST": "NUEVO RÉCORD PERSONAL", "WORLD COMPLETE": "MUNDO COMPLETADO",
		"LOCKED": "BLOQUEADO", "EQUIPPED": "EQUIPADO", "OWNED": "ADQUIRIDO", "VIEW IN STORE": "VER EN TIENDA",
	},
	"en": {
		"VISUAL EDITION": "VISUAL EDITION", "CURRENT WORLD": "CURRENT WORLD", "LIVE MAZE": "LIVE MAZE",
		"COLLECTION PROGRESS": "COLLECTION PROGRESS", "AURAS": "AURAS", "RESET AURA": "RESET AURA",
		"REDUCED MOTION": "REDUCED MOTION", "MINIMAP": "MINIMAP", "ON": "ON", "OFF": "OFF",
		"Smooth movement, reactive lighting and animated worlds.": "Smooth movement, reactive lighting and animated worlds.",
		"Reduce transitions and continuous movement effects.": "Reduce transitions and continuous movement effects.",
		"Show a compact explored-area map on large mazes.": "Show a compact explored-area map on large mazes.",
		"PERFORMANCE": "PERFORMANCE", "NEW PERSONAL BEST": "NEW PERSONAL BEST", "WORLD COMPLETE": "WORLD COMPLETE",
		"LOCKED": "LOCKED", "EQUIPPED": "EQUIPPED", "OWNED": "OWNED", "VIEW IN STORE": "VIEW IN STORE",
	},
	"pt": {
		"CURRENT WORLD": "MUNDO ATUAL", "COLLECTION PROGRESS": "PROGRESSO DA COLEÇÃO", "AURAS": "AURAS", "RESET AURA": "RESETAR AURA",
		"REDUCED MOTION": "MOVIMENTO REDUZIDO", "MINIMAP": "MINIMAPA", "ON": "ATIVADO", "OFF": "DESATIVADO",
		"Smooth movement, reactive lighting and animated worlds.": "Movimento suave, iluminação reativa e mundos animados.",
		"Reduce transitions and continuous movement effects.": "Reduz transições e efeitos de movimento contínuo.",
		"Show a compact explored-area map on large mazes.": "Mostra um mapa compacto da área explorada em labirintos grandes.",
		"PERFORMANCE": "DESEMPENHO", "NEW PERSONAL BEST": "NOVO RECORDE PESSOAL", "WORLD COMPLETE": "MUNDO COMPLETO", "LOCKED": "BLOQUEADO", "EQUIPPED": "EQUIPADO", "OWNED": "ADQUIRIDO", "VIEW IN STORE": "VER NA LOJA",
	},
	"fr": {
		"CURRENT WORLD": "MONDE ACTUEL", "COLLECTION PROGRESS": "PROGRESSION DE COLLECTION", "AURAS": "AURAS", "RESET AURA": "RÉINIT. AURA",
		"REDUCED MOTION": "MOUVEMENTS RÉDUITS", "MINIMAP": "MINICARTE", "ON": "ACTIVÉ", "OFF": "DÉSACTIVÉ",
		"Smooth movement, reactive lighting and animated worlds.": "Mouvements fluides, éclairage réactif et mondes animés.",
		"Reduce transitions and continuous movement effects.": "Réduit les transitions et les effets de mouvement continu.",
		"Show a compact explored-area map on large mazes.": "Affiche une carte compacte des zones explorées dans les grands labyrinthes.",
		"PERFORMANCE": "PERFORMANCE", "NEW PERSONAL BEST": "NOUVEAU RECORD", "WORLD COMPLETE": "MONDE TERMINÉ", "LOCKED": "VERROUILLÉ", "EQUIPPED": "ÉQUIPÉ", "OWNED": "ACQUIS", "VIEW IN STORE": "VOIR EN BOUTIQUE",
	},
	"de": {
		"CURRENT WORLD": "AKTUELLE WELT", "COLLECTION PROGRESS": "SAMMLUNGSFORTSCHRITT", "AURAS": "AUREN", "RESET AURA": "AURA RESET",
		"REDUCED MOTION": "REDUZIERTE BEWEGUNG", "MINIMAP": "MINIKARTE", "ON": "AN", "OFF": "AUS",
		"Smooth movement, reactive lighting and animated worlds.": "Flüssige Bewegung, reaktive Beleuchtung und animierte Welten.",
		"Reduce transitions and continuous movement effects.": "Reduziert Übergänge und kontinuierliche Bewegungseffekte.",
		"Show a compact explored-area map on large mazes.": "Zeigt in großen Labyrinthen eine kompakte Karte erkundeter Bereiche.",
		"PERFORMANCE": "LEISTUNG", "NEW PERSONAL BEST": "NEUE BESTLEISTUNG", "WORLD COMPLETE": "WELT ABGESCHLOSSEN", "LOCKED": "GESPERRT", "EQUIPPED": "AUSGERÜSTET", "OWNED": "BESITZT", "VIEW IN STORE": "IM SHOP ANSEHEN",
	},
	"it": {
		"CURRENT WORLD": "MONDO ATTUALE", "COLLECTION PROGRESS": "PROGRESSO COLLEZIONE", "AURAS": "AURE", "RESET AURA": "RESET AURA",
		"REDUCED MOTION": "MOVIMENTO RIDOTTO", "MINIMAP": "MINIMAPPA", "ON": "ON", "OFF": "OFF",
		"Smooth movement, reactive lighting and animated worlds.": "Movimento fluido, illuminazione reattiva e mondi animati.",
		"Reduce transitions and continuous movement effects.": "Riduce transizioni ed effetti di movimento continuo.",
		"Show a compact explored-area map on large mazes.": "Mostra una mappa compatta delle aree esplorate nei labirinti grandi.",
		"PERFORMANCE": "PRESTAZIONI", "NEW PERSONAL BEST": "NUOVO RECORD PERSONALE", "WORLD COMPLETE": "MONDO COMPLETATO", "LOCKED": "BLOCCATO", "EQUIPPED": "EQUIPAGGIATO", "OWNED": "POSSEDUTO", "VIEW IN STORE": "VEDI NEL NEGOZIO",
	},
}

func _ready() -> void:
	set_process(true)
	save.load_data()
	Localization.configure(save.language_override)
	_build_shell()
	_build_audio()
	payment = PaymentManager.new()
	add_child(payment)
	payment.status_changed.connect(_on_payment_status)
	payment.invoice_ready.connect(_on_invoice_ready)
	payment.payment_verified.connect(_on_payment_verified)
	payment.payment_error.connect(_on_payment_error)
	leaderboard = LeaderboardManager.new()
	add_child(leaderboard)
	leaderboard.leaderboard_ready.connect(_on_leaderboard_ready)
	leaderboard.leaderboard_error.connect(_on_leaderboard_error)
	show_menu()

func _process(_delta: float) -> void:
	if game_active and hud_label != null and board != null:
		var elapsed := (Time.get_ticks_msec() - game_started_ms) / 1000.0
		var key_text := " · 🔑" if bool(current_maze.get("requires_key", false)) and board.has_key else ""
		if current_mode == "infinite":
			var move_limit := int(ceil(float(current_maze.get("shortest", 1)) * 2.15))
			hud_label.text = Localization.f("hud_infinite", [board.moves, move_limit, elapsed, board.collected.size(), key_text])
			if board.moves > move_limit:
				game_active = false
				show_infinite_failed()
		else:
			hud_label.text = Localization.f("hud", [board.moves, elapsed, board.collected.size(), key_text])

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_back()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_back()

func _build_shell() -> void:
	backdrop = Backdrop.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 22)
	add_child(margin)
	screen_root = VBoxContainer.new()
	screen_root.add_theme_constant_override("separation", 14)
	margin.add_child(screen_root)

func _build_audio() -> void:
	audio_move = AudioStreamPlayer.new()
	audio_move.stream = load("res://assets/audio/move.wav")
	audio_move.volume_db = -12
	add_child(audio_move)
	audio_orb = AudioStreamPlayer.new()
	audio_orb.stream = load("res://assets/audio/orb.wav")
	audio_orb.volume_db = -7
	add_child(audio_orb)
	audio_win = AudioStreamPlayer.new()
	audio_win.stream = load("res://assets/audio/win.wav")
	audio_win.volume_db = -5
	add_child(audio_win)

func show_menu() -> void:
	current_screen = "menu"
	game_active = false
	_clear_screen()
	var focus_level := _highest_campaign_level()
	_sync_backdrop(focus_level, "menu")
	var badge := _label("⚡  LIGHTNING ARCADE  ·  V5  ·  " + _v5("VISUAL EDITION"), 14, GOLD)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(badge)
	var title := _label("SATOSHI\nMAZE", 52, TEXT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_shadow_color", Color(CYAN, 0.42))
	title.add_theme_constant_override("shadow_offset_x", 3)
	title.add_theme_constant_override("shadow_offset_y", 3)
	screen_root.add_child(title)
	var subtitle := _label(Localization.text("100 laberintos · retos globales · Ghost Run · colección premium"), 16, MUTED)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(subtitle)
	var hero := MenuHero.new()
	hero.custom_minimum_size = Vector2(0, 185)
	hero.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hero.setup(save.equipped, save.reduced_motion)
	screen_root.add_child(hero)
	var world_index := clampi(int((focus_level - 1) / 10), 0, 9)
	var world_line := _label(_v5("CURRENT WORLD") + "  ·  %02d  %s" % [world_index + 1, WORLD_NAMES[world_index]], 14, WORLD_COLORS[world_index])
	world_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(world_line)
	var summary := _label(Localization.f("menu_summary", [save.total_stars, save.daily_streak, save.infinite_best_round]), 16, TEXT)
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(summary)
	screen_root.add_child(_button(Localization.text("CAMPAÑA · 100 LABERINTOS"), func(): show_levels(), true, CYAN))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.add_child(_button("DAILY", func(): show_daily(), false, GOLD))
	row.add_child(_button("INFINITE", func(): start_infinite(1), false, PINK))
	screen_root.add_child(row)
	screen_root.add_child(_button(Localization.text("LIGHTNING STORE") + " · SKINS · TRAILS · " + _v5("AURAS"), func(): show_store(), true, GOLD))
	var row2 := HBoxContainer.new()
	row2.add_theme_constant_override("separation", 10)
	row2.add_child(_button(Localization.text("COLECCIÓN"), func(): show_collection(), false, CYAN))
	row2.add_child(_button(Localization.text("ESTADÍSTICAS"), func(): show_stats(), false, TEXT))
	screen_root.add_child(row2)
	var row3 := HBoxContainer.new()
	row3.add_theme_constant_override("separation", 10)
	row3.add_child(_button(Localization.text("CÓMO JUGAR"), func(): show_help(), false, TEXT))
	row3.add_child(_button(Localization.text("AJUSTES"), func(): show_settings(), false, MUTED))
	screen_root.add_child(row3)

func show_levels() -> void:
	current_screen = "levels"
	game_active = false
	_clear_screen()
	var focus_level := _highest_campaign_level()
	_sync_backdrop(focus_level, "campaign")
	_add_topbar(Localization.text("CAMPAÑA"), func(): show_menu())
	var info := _label(Localization.text("Cada 10 niveles aparece un Boss Maze. Encontrarás niebla, llaves, portales y hielo."), 14, MUTED)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(info)
	if not save.has_product("full_pass"):
		screen_root.add_child(_button(Localization.text("∞ MAZE PASS · DESBLOQUEAR LOS 100 · 149 SATS"), func(): show_purchase_product("full_pass"), false, GOLD))
	var scroll := TouchScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var worlds := VBoxContainer.new()
	worlds.mouse_filter = Control.MOUSE_FILTER_IGNORE
	worlds.add_theme_constant_override("separation", 18)
	worlds.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(worlds)
	for world_index in 10:
		var section := VBoxContainer.new()
		section.mouse_filter = Control.MOUSE_FILTER_IGNORE
		section.add_theme_constant_override("separation", 8)
		var accent: Color = WORLD_COLORS[world_index]
		var header_panel := PanelContainer.new()
		header_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		header_panel.add_theme_stylebox_override("panel", _panel(Color("0b1328", 0.94), Color(accent, 0.32), 16))
		var header := HBoxContainer.new()
		header.mouse_filter = Control.MOUSE_FILTER_IGNORE
		header.add_theme_constant_override("separation", 10)
		header_panel.add_child(header)
		var world_title := _label("WORLD %02d  ·  %s" % [world_index + 1, WORLD_NAMES[world_index]], 18, accent)
		world_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		header.add_child(world_title)
		var stars_label := _label("★ %02d / 30" % _world_stars(world_index), 15, GOLD)
		header.add_child(stars_label)
		section.add_child(header_panel)
		var grid := GridContainer.new()
		grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
		grid.columns = 4
		grid.add_theme_constant_override("h_separation", 8)
		grid.add_theme_constant_override("v_separation", 8)
		grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		section.add_child(grid)
		for offset in 10:
			var lvl := world_index * 10 + offset + 1
			var unlocked := save.is_unlocked(lvl)
			var stars := save.get_level_stars(lvl)
			var marker := "★".repeat(stars) + "☆".repeat(3 - stars) if stars > 0 else Localization.text("SIN MARCA")
			var bottom := marker if unlocked else "⚡ %d SATS" % AppConfig.LEVEL_PRICE_SATS
			var prefix := "BOSS " if lvl % 10 == 0 else ""
			var label := "%s%02d\n%s" % [prefix, lvl, bottom]
			var button_accent: Color = GOLD if lvl % 10 == 0 else (accent if unlocked else MUTED)
			var b := _button(label, Callable(self, "_select_level").bind(lvl), false, button_accent)
			b.custom_minimum_size = Vector2(150, 82)
			b.add_theme_font_size_override("font_size", 12)
			grid.add_child(b)
		worlds.add_child(section)

func show_daily() -> void:
	current_screen = "daily"
	game_active = false
	_clear_screen()
	_sync_backdrop(AppConfig.DAILY_BASE_LEVEL, "daily")
	_add_topbar(Localization.text("GLOBAL CHALLENGES"), func(): show_menu())
	var daily := ChallengeManager.daily_maze()
	var daily_card := _card("DAILY MAZE", Localization.text("Mismo laberinto para todos hoy.") + "\n" + ChallengeManager.modifier_text(daily), GOLD)
	screen_root.add_child(daily_card)
	var daily_best := _label(Localization.f("daily_best", [save.get_best_text(ChallengeManager.daily_key()), save.daily_streak]), 16, MUTED)
	daily_best.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(daily_best)
	screen_root.add_child(_button(Localization.text("JUGAR DAILY"), func(): start_daily(), true, GOLD))
	_spacer(12)
	var weekly := ChallengeManager.weekly_maze()
	screen_root.add_child(_card("WEEKLY SPEEDRUN", Localization.text("Reto técnico semanal. Ghost Run y ranking global.") + "\n" + ChallengeManager.modifier_text(weekly), PINK))
	var weekly_best := _label(Localization.f("weekly_best", [save.get_best_text(ChallengeManager.weekly_key())]), 16, MUTED)
	weekly_best.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(weekly_best)
	screen_root.add_child(_button(Localization.text("JUGAR WEEKLY"), func(): start_weekly(), true, PINK))
	_spacer(10)
	leaderboard_box = VBoxContainer.new()
	leaderboard_box.add_theme_constant_override("separation", 6)
	screen_root.add_child(leaderboard_box)
	leaderboard_box.add_child(_label(Localization.text("TOP DAILY"), 18, CYAN))
	leaderboard.fetch_leaderboard(ChallengeManager.daily_key())

func start_daily() -> void:
	_start_maze(ChallengeManager.daily_maze(), AppConfig.DAILY_BASE_LEVEL, ChallengeManager.daily_key(), "daily", "DAILY MAZE")

func start_weekly() -> void:
	_start_maze(ChallengeManager.weekly_maze(), AppConfig.WEEKLY_BASE_LEVEL, ChallengeManager.weekly_key(), "weekly", "WEEKLY SPEEDRUN")

func start_infinite(round_number: int) -> void:
	infinite_round = round_number
	var maze := ChallengeManager.infinite_maze(round_number)
	var run_key := "infinite_%d_%d" % [ChallengeManager.day_index(), round_number]
	_start_maze(maze, AppConfig.INFINITE_START_LEVEL + round_number, run_key, "infinite", Localization.f("infinite_run", [round_number]))

func _select_level(level: int) -> void:
	if save.is_unlocked(level):
		start_level(level)
	else:
		show_purchase_product("level_%d" % level)

func start_level(level: int) -> void:
	_start_maze(MazeGenerator.generate(level), level, str(level), "campaign", Localization.f("maze_number", [level]))

func _start_maze(maze: Dictionary, level_for_palette: int, run_key: String, mode: String, title_text: String) -> void:
	current_screen = "game"
	current_mode = mode
	current_level = level_for_palette
	current_run_key = run_key
	current_maze = maze
	_clear_screen()
	_sync_backdrop(current_level, mode)
	var top := HBoxContainer.new()
	var back := _button("‹", func(): _leave_game(), false, TEXT)
	back.custom_minimum_size = Vector2(62, 52)
	top.add_child(back)
	var name := _label(title_text, 22, CYAN)
	name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	top.add_child(name)
	var reset := _button("↻", func(): _restart_current(), false, GOLD)
	reset.custom_minimum_size = Vector2(62,52)
	top.add_child(reset)
	screen_root.add_child(top)
	var world_index := clampi(int((current_level - 1) / 10), 0, 9)
	var world_chip := _label("WORLD %02d · %s" % [world_index + 1, WORLD_NAMES[world_index]], 13, WORLD_COLORS[world_index])
	world_chip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(world_chip)
	var mods := _label(ChallengeManager.modifier_text(maze), 14, GOLD if bool(maze.get("boss", false)) else MUTED)
	mods.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(mods)
	hud_label = _label("MOV 0   ·   0.0s   ·   ORB 0/3", 16, MUTED)
	hud_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(hud_label)
	board = MazeBoard.new()
	board.custom_minimum_size = Vector2(0, 640)
	board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var visual_settings: Dictionary = save.equipped.duplicate(true)
	visual_settings["_reduced_motion"] = save.reduced_motion
	visual_settings["_show_minimap"] = save.show_minimap
	board.setup(current_maze, current_level, visual_settings, save.get_ghost(current_run_key))
	board.moved.connect(_on_board_moved)
	board.orb_collected.connect(func(): _play(audio_orb))
	board.key_collected.connect(func(): _play(audio_orb))
	board.goal_reached.connect(_on_goal_reached)
	screen_root.add_child(board)
	if not save.reduced_motion:
		board.modulate = Color(1, 1, 1, 0)
		board.scale = Vector2(0.985, 0.985)
		call_deferred("_animate_game_board")
	var pad := GridContainer.new()
	pad.columns = 3
	pad.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	pad.add_theme_constant_override("h_separation", 8)
	pad.add_theme_constant_override("v_separation", 7)
	var e1 := Control.new(); e1.custom_minimum_size = Vector2(88, 56); pad.add_child(e1)
	pad.add_child(_dir_button("▲", Vector2i.UP))
	var e2 := Control.new(); e2.custom_minimum_size = Vector2(88, 56); pad.add_child(e2)
	pad.add_child(_dir_button("◀", Vector2i.LEFT))
	pad.add_child(_dir_button("▼", Vector2i.DOWN))
	pad.add_child(_dir_button("▶", Vector2i.RIGHT))
	screen_root.add_child(pad)
	var ghost_note := Localization.text("Ghost Run activo: competís contra tu mejor recorrido.") if not save.get_ghost(current_run_key).is_empty() else Localization.text("Tu mejor recorrido quedará guardado como Ghost Run.")
	var tip := _label(ghost_note, 12, MUTED)
	tip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(tip)
	game_started_ms = Time.get_ticks_msec()
	game_active = true

func _restart_current() -> void:
	match current_mode:
		"campaign": start_level(int(current_run_key))
		"daily": start_daily()
		"weekly": start_weekly()
		"infinite": start_infinite(infinite_round)

func _leave_game() -> void:
	match current_mode:
		"campaign": show_levels()
		"daily", "weekly": show_daily()
		"infinite": show_menu()
		_: show_menu()

func show_infinite_failed() -> void:
	current_screen = "result"
	game_active = false
	_clear_screen()
	_sync_backdrop(AppConfig.INFINITE_START_LEVEL + infinite_round, "result")
	_spacer(65)
	var icon := _label("×", 86, DANGER)
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(icon)
	var title := _label(Localization.text("RACHA TERMINADA"), 34, TEXT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(title)
	var reached := maxi(infinite_round - 1, 0)
	var info := _label(Localization.f("infinite_failed", [reached, save.infinite_best_round]), 18, MUTED)
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(info)
	screen_root.add_child(_button(Localization.text("NUEVA RACHA"), func(): start_infinite(1), true, PINK))
	screen_root.add_child(_button(Localization.text("MENÚ"), func(): show_menu(), false, TEXT))

func show_store(filter: String = "") -> void:
	if not filter.is_empty():
		store_filter = filter
	current_screen = "store"
	game_active = false
	_clear_screen()
	_sync_backdrop(_highest_campaign_level(), "store")
	_add_topbar(Localization.text("LIGHTNING STORE"), func(): show_menu())
	var intro := _label(Localization.text("Compras permanentes. Sin loot boxes, sin pay-to-win. Personalizá tu identidad dentro del laberinto."), 14, MUTED)
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(intro)
	var visual_note := _label(_v5("Smooth movement, reactive lighting and animated worlds."), 13, CYAN)
	visual_note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	visual_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(visual_note)
	var local_note := _label(Localization.text("Las compras se guardan en este dispositivo. Sin servidor no hay restauración segura tras borrar la app o cambiar de teléfono."), 12, MUTED)
	local_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	local_note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(local_note)
	var filter_grid := GridContainer.new()
	filter_grid.columns = 4
	filter_grid.add_theme_constant_override("h_separation", 6)
	filter_grid.add_theme_constant_override("v_separation", 6)
	filter_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for filter_id in ["all", "skins", "trails", "auras", "themes", "finish", "bundles"]:
		var filter_button := _button(_store_filter_title(str(filter_id)), Callable(self, "show_store").bind(str(filter_id)), false, GOLD if store_filter == str(filter_id) else MUTED)
		filter_button.custom_minimum_size = Vector2(0, 43)
		filter_button.add_theme_font_size_override("font_size", 12)
		filter_grid.add_child(filter_button)
	screen_root.add_child(filter_grid)
	var scroll := TouchScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var list := VBoxContainer.new()
	list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	list.add_theme_constant_override("separation", 10)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	var last_section := ""
	for product in ProductCatalog.list_store_products():
		var section: String = _store_section_for_kind(str(product.get("kind", "")))
		if store_filter != "all" and section != store_filter:
			continue
		if section != last_section:
			last_section = section
			var section_label := _label(_store_section_title(section), 19, CYAN if section != "bundles" else GOLD)
			section_label.add_theme_constant_override("outline_size", 4)
			section_label.add_theme_color_override("font_outline_color", Color("050814"))
			list.add_child(section_label)
		list.add_child(_product_card(product))
	if not save.purchase_history.is_empty():
		list.add_child(_label(Localization.text("ÚLTIMAS COMPRAS"), 19, CYAN))
		for purchase in save.purchase_history.slice(0, mini(5, save.purchase_history.size())):
			var history_product: Dictionary = ProductCatalog.get_product(str(purchase.get("product_id", "")))
			var history_name: String = str(history_product.get("name", purchase.get("name", "Compra")))
			list.add_child(_label(Localization.f("purchase_row", [history_name, int(purchase.get("amount_sats", 0))]), 14, MUTED))

func _store_filter_title(filter_id: String) -> String:
	var language: String = Localization.current_language()
	var labels: Dictionary = {
		"es": {"all": "TODO", "skins": "SKINS", "trails": "TRAILS", "auras": "AURAS", "themes": "TEMAS", "finish": "FINALES", "bundles": "PACKS"},
		"en": {"all": "ALL", "skins": "SKINS", "trails": "TRAILS", "auras": "AURAS", "themes": "THEMES", "finish": "FINISH", "bundles": "PACKS"},
		"pt": {"all": "TUDO", "skins": "SKINS", "trails": "TRAILS", "auras": "AURAS", "themes": "TEMAS", "finish": "FINAIS", "bundles": "PACKS"},
		"fr": {"all": "TOUT", "skins": "SKINS", "trails": "TRACES", "auras": "AURAS", "themes": "THÈMES", "finish": "FINAUX", "bundles": "PACKS"},
		"de": {"all": "ALLE", "skins": "SKINS", "trails": "TRAILS", "auras": "AUREN", "themes": "THEMEN", "finish": "FINISH", "bundles": "PAKETE"},
		"it": {"all": "TUTTO", "skins": "SKIN", "trails": "SCIE", "auras": "AURE", "themes": "TEMI", "finish": "FINALI", "bundles": "PACK"},
	}
	var selected: Dictionary = labels.get(language, labels["en"])
	return str(selected.get(filter_id, filter_id.to_upper()))

func _store_section_for_kind(kind: String) -> String:
	match kind:
		"pass", "feature": return "featured"
		"bundle": return "bundles"
		"skin": return "skins"
		"trail": return "trails"
		"aura": return "auras"
		"theme": return "themes"
		"victory_fx": return "finish"
		_: return "other"

func _store_section_title(section: String) -> String:
	var language: String = Localization.current_language()
	var titles: Dictionary = {
		"es": {"featured": "DESTACADOS", "bundles": "PACKS", "skins": "SKINS", "trails": "TRAILS", "auras": "AURAS", "themes": "TEMAS", "finish": "EFECTOS DE VICTORIA", "other": "EXTRAS"},
		"en": {"featured": "FEATURED", "bundles": "PACKS", "skins": "SKINS", "trails": "TRAILS", "auras": "AURAS", "themes": "THEMES", "finish": "VICTORY EFFECTS", "other": "EXTRAS"},
		"pt": {"featured": "DESTAQUES", "bundles": "PACKS", "skins": "SKINS", "trails": "TRAILS", "auras": "AURAS", "themes": "TEMAS", "finish": "EFEITOS DE VITÓRIA", "other": "EXTRAS"},
		"fr": {"featured": "À LA UNE", "bundles": "PACKS", "skins": "SKINS", "trails": "TRACES", "auras": "AURAS", "themes": "THÈMES", "finish": "EFFETS DE VICTOIRE", "other": "EXTRAS"},
		"de": {"featured": "HIGHLIGHTS", "bundles": "PAKETE", "skins": "SKINS", "trails": "TRAILS", "auras": "AUREN", "themes": "THEMEN", "finish": "SIEGESEFFEKTE", "other": "EXTRAS"},
		"it": {"featured": "IN EVIDENZA", "bundles": "PACK", "skins": "SKIN", "trails": "SCIE", "auras": "AURE", "themes": "TEMI", "finish": "EFFETTI VITTORIA", "other": "EXTRA"},
	}
	var selected: Dictionary = titles.get(language, titles["en"])
	return str(selected.get(section, section.to_upper()))

func _is_store_product_owned(product: Dictionary) -> bool:
	var product_id := str(product.get("id", ""))
	var kind := str(product.get("kind", ""))
	if kind == "pass":
		return save.has_product("full_pass")
	if kind == "bundle":
		if save.has_product(product_id):
			return true
		var bundle_items: Array = ProductCatalog.bundle_items(product_id)
		if bundle_items.is_empty():
			return false
		for bundled_id in bundle_items:
			if not save.has_product(str(bundled_id)):
				return false
		return true
	return save.has_product(product_id)

func _product_card(product: Dictionary) -> Control:
	var product_id := str(product.get("id", ""))
	var kind := str(product.get("kind", ""))
	var owned: bool = _is_store_product_owned(product)
	var rarity_name: String = ProductCatalog.rarity(product)
	var rarity_color: Color = ProductCatalog.rarity_color(rarity_name)
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", _panel(Color("0b142a", 0.96), Color(rarity_color, 0.36), 18))
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	panel.add_child(margin)
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 12)
	margin.add_child(row)
	var preview := CosmeticPreview.new()
	preview.setup(product, false)
	row.add_child(preview)
	var copy := VBoxContainer.new()
	copy.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.add_theme_constant_override("separation", 3)
	row.add_child(copy)
	var name := _label(str(product.get("name", product_id)), 18, TEXT)
	copy.add_child(name)
	var rarity_label := _label(rarity_name, 11, rarity_color)
	copy.add_child(rarity_label)
	var desc := _label(str(product.get("description", "")), 13, MUTED)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	copy.add_child(desc)
	var action: Button
	var is_equipped := ProductCatalog.is_cosmetic_kind(kind) and str(save.equipped.get(kind, "")) == product_id
	if owned:
		if is_equipped:
			action = _button(_v5("EQUIPPED"), Callable(self, "_noop"), false, GREEN)
			action.disabled = true
		elif ProductCatalog.is_cosmetic_kind(kind):
			action = _button(Localization.text("EQUIPAR"), Callable(self, "_equip_from_store").bind(product_id), false, GREEN)
		else:
			action = _button(Localization.text("ADQUIRIDO"), Callable(self, "_noop"), false, GREEN)
			action.disabled = true
	else:
		action = _button("%d SATS" % int(product.get("price_sats", 0)), Callable(self, "show_purchase_product").bind(product_id), false, GOLD)
	action.custom_minimum_size = Vector2(128, 54)
	row.add_child(action)
	return panel

func _equip_from_store(product_id: String) -> void:
	if save.equip_product(product_id):
		show_collection()

func show_collection() -> void:
	current_screen = "collection"
	game_active = false
	_clear_screen()
	_sync_backdrop(_highest_campaign_level(), "collection")
	_add_topbar(Localization.text("MI COLECCIÓN"), func(): show_menu())
	var equipped_text := Localization.f("equipped", [
		str(save.equipped.get("skin", "default")).replace("skin_", "").to_upper(),
		str(save.equipped.get("trail", "default")).replace("trail_", "").to_upper(),
		str(save.equipped.get("theme", "auto")).replace("theme_", "").to_upper(),
		str(save.equipped.get("victory_fx", "default")).replace("victory_fx_", "").to_upper(),
	])
	var eq := _label(equipped_text, 14, CYAN)
	eq.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(eq)
	var aura_name := str(save.equipped.get("aura", "default")).replace("aura_", "").to_upper()
	var aura_line := _label(_v5("AURAS") + "  ·  " + aura_name, 13, GOLD)
	aura_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(aura_line)
	var reset_grid := GridContainer.new()
	reset_grid.columns = 3
	reset_grid.add_theme_constant_override("h_separation", 6)
	reset_grid.add_theme_constant_override("v_separation", 6)
	for reset_kind in ["skin", "trail", "aura", "theme", "victory_fx"]:
		var reset_title := _v5("RESET AURA") if reset_kind == "aura" else (_collection_reset_title(reset_kind) if reset_kind in ["theme", "victory_fx"] else ("RESET " + reset_kind.to_upper()))
		var reset_button := _button(Localization.text(reset_title), Callable(self, "_reset_equipped").bind(reset_kind), false, TEXT)
		reset_button.custom_minimum_size = Vector2(0, 44)
		reset_button.add_theme_font_size_override("font_size", 11)
		reset_grid.add_child(reset_button)
	screen_root.add_child(reset_grid)
	var cosmetics: Array[Dictionary] = []
	var owned_count := 0
	for product in ProductCatalog.list_collection_products():
		if not ProductCatalog.is_cosmetic_kind(str(product.get("kind", ""))):
			continue
		cosmetics.append(product)
		if save.has_product(str(product.get("id", ""))):
			owned_count += 1
	var progress := _label(_v5("COLLECTION PROGRESS") + "  ·  %d / %d" % [owned_count, cosmetics.size()], 14, MUTED)
	progress.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(progress)
	var scroll := TouchScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var grid := GridContainer.new()
	grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 9)
	grid.add_theme_constant_override("v_separation", 9)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(grid)
	for product in cosmetics:
		grid.add_child(_collection_tile(product))

func _collection_tile(product: Dictionary) -> Control:
	var product_id := str(product.get("id", ""))
	var kind := str(product.get("kind", ""))
	var owned := save.has_product(product_id)
	var equipped_now := owned and str(save.equipped.get(kind, "")) == product_id
	var rarity_name: String = ProductCatalog.rarity(product)
	var rarity_color: Color = ProductCatalog.rarity_color(rarity_name)
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.custom_minimum_size = Vector2(305, 248)
	panel.add_theme_stylebox_override("panel", _panel(Color("091226", 0.96), Color(rarity_color, 0.38 if owned else 0.16), 18))
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	panel.add_child(margin)
	var v := VBoxContainer.new()
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_theme_constant_override("separation", 4)
	margin.add_child(v)
	var preview := CosmeticPreview.new()
	preview.setup(product, not owned)
	preview.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.add_child(preview)
	var name := _label(str(product.get("name", product_id)), 15, TEXT if owned else MUTED)
	name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(name)
	var rarity := _label(rarity_name, 10, rarity_color if owned else MUTED)
	rarity.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(rarity)
	var status_text := _v5("EQUIPPED") if equipped_now else (_v5("OWNED") if owned else _v5("LOCKED"))
	var status := _label(status_text, 11, GREEN if owned else MUTED)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(status)
	var action: Button
	if equipped_now:
		action = _button(_v5("EQUIPPED"), Callable(self, "_noop"), false, GREEN)
		action.disabled = true
	elif owned:
		action = _button(Localization.text("EQUIPAR"), Callable(self, "_equip_from_store").bind(product_id), false, GREEN)
	else:
		var section := _store_section_for_kind(kind)
		action = _button(_v5("VIEW IN STORE"), Callable(self, "show_store").bind(section), false, rarity_color)
	action.custom_minimum_size = Vector2(0, 42)
	action.add_theme_font_size_override("font_size", 11)
	v.add_child(action)
	return panel

func _collection_reset_title(kind: String) -> String:
	var language: String = Localization.current_language()
	var labels: Dictionary = {
		"es": {"theme": "RESET TEMA", "victory_fx": "RESET FINAL"},
		"en": {"theme": "RESET THEME", "victory_fx": "RESET FINISH"},
		"pt": {"theme": "RESETAR TEMA", "victory_fx": "RESETAR FINAL"},
		"fr": {"theme": "RÉINIT. THÈME", "victory_fx": "RÉINIT. FIN"},
		"de": {"theme": "THEME RESET", "victory_fx": "FINISH RESET"},
		"it": {"theme": "RESET TEMA", "victory_fx": "RESET FINALE"},
	}
	var selected: Dictionary = labels.get(language, labels["en"])
	return str(selected.get(kind, "RESET"))

func _reset_equipped(kind: String) -> void:
	save.reset_equipped(kind)
	show_collection()

func show_stats() -> void:
	current_screen = "stats"
	game_active = false
	_clear_screen()
	_sync_backdrop(_highest_campaign_level(), "stats")
	_add_topbar(Localization.text("PERFIL & ESTADÍSTICAS"), func(): show_menu())
	var alias_name := "RUNNER-" + save.install_id.substr(0, 6).to_upper()
	screen_root.add_child(_card(alias_name, Localization.text("Tu identidad anónima para rankings globales."), CYAN))
	var focus_level := _highest_campaign_level()
	var world_index := clampi(int((focus_level - 1) / 10), 0, 9)
	screen_root.add_child(_card(_v5("CURRENT WORLD") + " · " + WORLD_NAMES[world_index], "★ %d / 30" % _world_stars(world_index), WORLD_COLORS[world_index]))
	var basic := Localization.f("full_stats", [save.total_completions, save.total_stars, save.daily_streak, save.infinite_best_round])
	var basic_label := _label(basic, 20, TEXT)
	basic_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(basic_label)
	if save.has_product("pro_stats"):
		_spacer(6)
		var pro := Localization.f("pro_stats", [save.average_efficiency(), save.total_moves, save.total_seconds / 60.0, save.total_orbs, save.achievements.size()])
		var pro_label := _label(pro, 18, GREEN)
		pro_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		screen_root.add_child(pro_label)
	else:
		screen_root.add_child(_card("PRO STATS", Localization.text("Desbloquea eficiencia global, récords, actividad y métricas avanzadas."), GOLD))
		screen_root.add_child(_button(Localization.text("DESBLOQUEAR PRO STATS · 29 SATS"), func(): show_purchase_product("pro_stats"), true, GOLD))

func show_help() -> void:
	current_screen = "help"
	game_active = false
	_clear_screen()
	_sync_backdrop(_highest_campaign_level(), "help")
	_add_topbar(Localization.text("CÓMO JUGAR"), func(): show_menu())
	var scroll := TouchScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var list := VBoxContainer.new()
	list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	list.add_theme_constant_override("separation", 10)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	for item in [
		["DOMINÁ EL LABERINTO", "Deslizá o usá el pad. Menos movimientos aumenta tu eficiencia y mejora el Ghost Run."],
		["3 ESTRELLAS", "Completá, resolvé cerca de la ruta óptima y recogé los tres orbes."],
		["MODIFICADORES", "Niebla limita la visión. Las llaves abren la meta. Los portales cambian tu posición y el hielo te desliza."],
		["GHOST RUN", "Tu mejor recorrido queda como un fantasma visual para competir contra vos mismo."],
		["DAILY & WEEKLY", "Desafíos de semilla global para comparar tiempos y movimientos en rankings."],
		["INFINITE", "Encadená laberintos cada vez más exigentes y buscá tu mejor racha."],
		["LIGHTNING STORE", "Los pagos compran desbloqueos y cosméticos permanentes. No venden soluciones ni ventajas competitivas."],
		["V5 · VISUAL POLISH", _v5("Smooth movement, reactive lighting and animated worlds.")],
	]:
		list.add_child(_card(Localization.text(str(item[0])), Localization.text(str(item[1])), CYAN))

func show_settings() -> void:
	current_screen = "settings"
	game_active = false
	_clear_screen()
	_sync_backdrop(_highest_campaign_level(), "settings")
	_add_topbar(Localization.text("AJUSTES"), func(): show_menu())
	var scroll := TouchScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var list := VBoxContainer.new()
	list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	list.add_theme_constant_override("separation", 9)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	var detected: String = Localization.current_language_name()
	var current_mode_text: String = (Localization.text("AUTOMÁTICO") + " · " + detected) if save.language_override == "auto" else detected
	list.add_child(_card(Localization.text("IDIOMA"), Localization.text("IDIOMA DEL DISPOSITIVO") + ": " + current_mode_text, CYAN))
	list.add_child(_button(Localization.text("AUTOMÁTICO") + " · " + str(Localization.LANGUAGE_NAMES[Localization.detect_device_language()]), Callable(self, "_set_language").bind("auto"), true, GOLD if save.language_override == "auto" else TEXT))
	for code in Localization.SUPPORTED_LANGUAGES:
		var accent: Color = GREEN if save.language_override == code else CYAN
		list.add_child(_button(str(Localization.LANGUAGE_NAMES[code]), Callable(self, "_set_language").bind(code), false, accent))
	_spacer_into(list, 8)
	list.add_child(_card(_v5("REDUCED MOTION"), _v5("Reduce transitions and continuous movement effects."), PINK))
	var motion_state := _v5("ON") if save.reduced_motion else _v5("OFF")
	list.add_child(_button(_v5("REDUCED MOTION") + " · " + motion_state, func(): _toggle_reduced_motion(), false, PINK if save.reduced_motion else TEXT))
	list.add_child(_card(_v5("MINIMAP"), _v5("Show a compact explored-area map on large mazes."), CYAN))
	var map_state := _v5("ON") if save.show_minimap else _v5("OFF")
	list.add_child(_button(_v5("MINIMAP") + " · " + map_state, func(): _toggle_minimap(), false, CYAN if save.show_minimap else TEXT))

func _set_language(code: String) -> void:
	save.set_language_override(code)
	Localization.configure(code)
	show_settings()

func show_purchase_product(product_id: String) -> void:
	current_product = ProductCatalog.get_product(product_id)
	if current_product.is_empty():
		return
	current_screen = "purchase"
	game_active = false
	payment.stop_polling()
	_clear_screen()
	_sync_backdrop(_highest_campaign_level(), "store")
	_add_topbar(Localization.text("COMPRA LIGHTNING"), func(): _purchase_back())
	_spacer(8)
	if ProductCatalog.is_cosmetic_kind(str(current_product.get("kind", ""))) or str(current_product.get("kind", "")) in ["bundle", "pass", "feature"]:
		var preview := CosmeticPreview.new()
		preview.setup(current_product, false)
		preview.custom_minimum_size = Vector2(0, 150)
		preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		screen_root.add_child(preview)
	else:
		var icon := _label(str(current_product.get("icon", "◇")), 82, Color(str(current_product.get("accent", "ffd166"))))
		icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		screen_root.add_child(icon)
	var rarity_name: String = ProductCatalog.rarity(current_product)
	var rarity := _label(rarity_name, 12, ProductCatalog.rarity_color(rarity_name))
	rarity.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(rarity)
	var title := _label(str(current_product.get("name", "Contenido")), 31, TEXT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(title)
	var price := _label("%d SATS" % int(current_product.get("price_sats", 0)), 45, GOLD)
	price.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(price)
	var desc := _label(str(current_product.get("description", "")), 17, MUTED)
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(desc)
	payment_status_label = _label("Pago Lightning directo. Solo se habilita contenido después de una verificación criptográfica del invoice.", 15, TEXT)
	payment_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	payment_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(payment_status_label)
	purchase_actions = VBoxContainer.new()
	purchase_actions.add_theme_constant_override("separation", 9)
	screen_root.add_child(purchase_actions)
	purchase_actions.add_child(_button("GENERAR INVOICE", func(): payment.start_purchase(str(current_product.get("id", ""))), true, GOLD))
	var note := _label("No pagues si el proveedor no ofrece verificación automática. El juego bloqueará el cobro antes de abrir tu wallet.", 13, MUTED)
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(note)

func _purchase_back() -> void:
	if str(current_product.get("kind", "")) == "level": show_levels()
	else: show_store()

func _on_invoice_ready(_invoice: String, amount: int, _expires_at: int) -> void:
	for c in purchase_actions.get_children(): c.queue_free()
	purchase_actions.add_child(_button(Localization.f("open_wallet", [amount]), func(): payment.open_wallet(), true, GOLD))
	purchase_actions.add_child(_button("COPIAR INVOICE", func(): payment.copy_invoice(), false, CYAN))
	purchase_actions.add_child(_button("COMPROBAR AHORA", func(): payment.check_payment(), false, TEXT))
	payment.open_wallet()

func _on_payment_verified(product_id: String, payment_id: String, amount: int) -> void:
	save.grant_product(product_id, payment_id, amount)
	var product := ProductCatalog.get_product(product_id)
	if ProductCatalog.is_cosmetic_kind(str(product.get("kind", ""))):
		save.equip_product(product_id)
	_play(audio_win)
	show_purchase_success(product)

func show_purchase_success(product: Dictionary) -> void:
	payment.stop_polling()
	current_screen = "purchase"
	game_active = false
	_clear_screen()
	_sync_backdrop(_highest_campaign_level(), "store")
	_spacer(42)
	var preview := CosmeticPreview.new()
	preview.setup(product, false)
	preview.custom_minimum_size = Vector2(0, 150)
	preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	screen_root.add_child(preview)
	var bolt := _label("✓", 72, GREEN)
	bolt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(bolt)
	var t := _label(Localization.text("COMPRA CONFIRMADA"), 32, TEXT)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(t)
	var message := _label(Localization.f("purchase_success", [str(product.get("name", "Contenido"))]), 17, MUTED)
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(message)
	if str(product.get("kind", "")) == "level":
		var unlocked_level := int(product.get("level", 1))
		screen_root.add_child(_button(Localization.text("JUGAR AHORA"), Callable(self, "start_level").bind(unlocked_level), true, CYAN))
	else:
		screen_root.add_child(_button(Localization.text("VER COLECCIÓN"), func(): show_collection(), true, CYAN))
		screen_root.add_child(_button(Localization.text("VOLVER A LA TIENDA"), func(): show_store(), false, TEXT))

func _on_payment_status(text: String) -> void:
	if payment_status_label != null and is_instance_valid(payment_status_label):
		payment_status_label.text = Localization.text(text)

func _on_payment_error(text: String) -> void:
	_on_payment_status("⚠ " + text)

func _on_board_moved(_moves: int, _orbs: int) -> void:
	_play(audio_move)

func _on_goal_reached(moves: int, orbs: int) -> void:
	if not game_active:
		return
	game_active = false
	var elapsed := (Time.get_ticks_msec() - game_started_ms) / 1000.0
	var shortest: int = int(current_maze.get("shortest", 1))
	var efficiency := clampf(float(shortest) / maxf(float(moves), 1.0), 0.0, 1.0) * 100.0
	var stars := 1
	if moves <= int(ceil(float(shortest) * 1.25)):
		stars += 1
	if orbs == 3:
		stars += 1
	var perfect := board.bump_count == 0
	var result := save.record_result(current_run_key, moves, elapsed, stars, shortest, orbs, board.get_run_path(), current_mode == "daily", current_mode == "campaign")
	if current_mode in ["daily", "weekly"]:
		save.record_challenge(current_run_key, moves, elapsed, efficiency)
		leaderboard.submit_score(current_run_key, "RUNNER-" + save.install_id.substr(0, 6).to_upper(), save.install_id, moves, elapsed, efficiency, board.get_run_path())
	if current_mode == "infinite":
		save.record_infinite_round(infinite_round)
	_play(audio_win)
	if not save.reduced_motion:
		await get_tree().create_timer(0.34).timeout
	show_result(moves, elapsed, orbs, stars, shortest, perfect, bool(result.get("improved", false)))

func show_result(moves: int, elapsed: float, orbs: int, stars: int, shortest: int, perfect: bool, improved: bool) -> void:
	current_screen = "result"
	game_active = false
	_clear_screen()
	_sync_backdrop(current_level, "result")
	_spacer(18)
	var victory_fx := str(save.equipped.get("victory_fx", "default"))
	var crown_text := "✦"
	match victory_fx:
		"victory_fx_supernova": crown_text = "✦  ✹  ✦"
		"victory_fx_thunder": crown_text = "ϟ  ✦  ϟ"
		"victory_fx_portal": crown_text = "⟲  ◉  ⟳"
		"victory_fx_sats": crown_text = "₿  ✦  ₿"
	var crown := _label(crown_text, 64, GOLD)
	crown.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(crown)
	var title := _label(Localization.text("¡ESCAPASTE!"), 34, TEXT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(title)
	var world_index := clampi(int((current_level - 1) / 10), 0, 9)
	var world := _label("WORLD %02d · %s" % [world_index + 1, WORLD_NAMES[world_index]], 13, WORLD_COLORS[world_index])
	world.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(world)
	var star_row := HBoxContainer.new()
	star_row.alignment = BoxContainer.ALIGNMENT_CENTER
	star_row.add_theme_constant_override("separation", 10)
	var star_nodes: Array[Label] = []
	for i in 3:
		var earned := i < stars
		var star := _label("★" if earned else "☆", 44, GOLD if earned else MUTED)
		star.modulate = Color(1, 1, 1, 0.15 if earned and not save.reduced_motion else 1.0)
		star_nodes.append(star)
		star_row.add_child(star)
	screen_root.add_child(star_row)
	if not save.reduced_motion:
		call_deferred("_animate_result_stars", star_nodes, stars)
	var efficiency := clampf(float(shortest) / maxf(float(moves), 1.0), 0.0, 1.0) * 100.0
	var target_time := float(current_maze.get("target_time", float(shortest) * 0.78 + 8.0))
	var medal := "ORO" if elapsed <= target_time else ("PLATA" if elapsed <= target_time * 1.35 else "BRONCE")
	var medal_color := GOLD if medal == "ORO" else (CYAN if medal == "PLATA" else Color("d38b5d"))
	var medal_label := _label(Localization.text("MEDALLA") + " " + Localization.text(medal), 20, medal_color)
	medal_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(medal_label)
	var perf_title := _label(_v5("PERFORMANCE") + "  ·  %.1f%%" % efficiency, 13, TEXT)
	perf_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(perf_title)
	screen_root.add_child(_efficiency_bar(efficiency, medal_color))
	var badges: Array[String] = []
	if perfect:
		badges.append("PERFECT RUN")
	if improved:
		badges.append(_v5("NEW PERSONAL BEST"))
	if orbs == 3:
		badges.append("ORB MASTER")
	if bool(current_maze.get("boss", false)) and elapsed <= float(current_maze.get("target_time", 999999.0)):
		badges.append("BOSS TIME")
	if current_mode == "campaign" and current_level % 10 == 0:
		badges.append(_v5("WORLD COMPLETE"))
	var badge_text := " · ".join(badges) if not badges.is_empty() else Localization.text("RUN COMPLETADO")
	var badge := _label(badge_text, 14, GREEN if perfect else CYAN)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(badge)
	var stat := _label(Localization.f("result_stats", [moves, elapsed, shortest, efficiency, orbs]), 16, MUTED)
	stat.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stat.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(stat)
	_spacer(6)
	if current_mode == "campaign" and current_level < AppConfig.TOTAL_LEVELS:
		var next := current_level + 1
		var next_text := Localization.text("SIGUIENTE NIVEL") if save.is_unlocked(next) else Localization.f("next_sats", [AppConfig.LEVEL_PRICE_SATS])
		screen_root.add_child(_button(next_text, func(): _select_level(next), true, CYAN if save.is_unlocked(next) else GOLD))
	elif current_mode == "infinite":
		screen_root.add_child(_button("CONTINUAR · RUN %02d" % (infinite_round + 1), func(): start_infinite(infinite_round + 1), true, PINK))
	elif current_mode in ["daily", "weekly"]:
		screen_root.add_child(_button(Localization.text("VER DESAFÍOS & RANKING"), func(): show_daily(), true, GOLD))
	screen_root.add_child(_button(Localization.text("REPETIR · GHOST RUN"), func(): _restart_current(), false, PINK))
	screen_root.add_child(_button(Localization.text("MENÚ"), func(): show_menu(), false, TEXT))

func _on_leaderboard_ready(_challenge_key: String, entries: Array) -> void:
	if leaderboard_box == null or not is_instance_valid(leaderboard_box):
		return
	for child in leaderboard_box.get_children(): child.queue_free()
	leaderboard_box.add_child(_label(Localization.text("TOP DAILY"), 18, CYAN))
	if entries.is_empty():
		leaderboard_box.add_child(_label(Localization.text("Todavía no hay tiempos publicados."), 14, MUTED))
		return
	for i in range(mini(entries.size(), 5)):
		var e: Dictionary = entries[i]
		leaderboard_box.add_child(_label(Localization.f("score_row", [i+1, str(e.get("alias", "RUNNER")), float(e.get("seconds", 0.0)), int(e.get("moves", 0))]), 14, TEXT))

func _on_leaderboard_error(message: String) -> void:
	if leaderboard_box != null and is_instance_valid(leaderboard_box):
		leaderboard_box.add_child(_label(message, 13, MUTED))

func _dir_button(text: String, dir: Vector2i) -> Button:
	var cb := func():
		if board != null:
			board.move_player(dir)
	var b := _button(text, cb, false, CYAN)
	b.custom_minimum_size = Vector2(88, 58)
	b.add_theme_font_size_override("font_size", 25)
	return b

func _back() -> void:
	match current_screen:
		"game": _leave_game()
		"levels", "daily", "store", "collection", "stats", "help", "settings": show_menu()
		"purchase": _purchase_back()
		"result": show_menu()
		_: get_tree().quit()

func _add_topbar(title: String, back_cb: Callable) -> void:
	var h := HBoxContainer.new()
	var b := _button("‹", back_cb, false, TEXT); b.custom_minimum_size = Vector2(62, 52); h.add_child(b)
	var l := _label(title, 25, TEXT); l.size_flags_horizontal = Control.SIZE_EXPAND_FILL; l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; h.add_child(l)
	var ghost := Control.new(); ghost.custom_minimum_size = Vector2(62, 52); h.add_child(ghost)
	screen_root.add_child(h)

func _button(text: String, cb: Callable, big := false, accent := CYAN) -> Button:
	var b := Button.new()
	b.mouse_filter = Control.MOUSE_FILTER_PASS
	b.mouse_force_pass_scroll_events = true
	b.text = Localization.text(text)
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(0, 72 if big else 55)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_font_size_override("font_size", 20 if big else 16)
	b.add_theme_color_override("font_color", Color("f5fbff"))
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", Color.WHITE)
	b.add_theme_stylebox_override("normal", _panel(Color("111a34", 0.95), Color(accent, 0.42), 17))
	b.add_theme_stylebox_override("hover", _panel(Color("19254a", 0.98), Color(accent, 0.82), 17))
	b.add_theme_stylebox_override("pressed", _panel(Color("0d1328"), accent, 17))
	b.button_down.connect(Callable(self, "_button_visual_down").bind(b))
	b.button_up.connect(Callable(self, "_button_visual_up").bind(b))
	b.pressed.connect(cb)
	return b
func _card(title: String, body: String, accent: Color) -> Control:
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", _panel(Color("10182f"), Color(accent, 0.30), 18))
	var m := MarginContainer.new(); m.mouse_filter = Control.MOUSE_FILTER_IGNORE; m.add_theme_constant_override("margin_left", 17); m.add_theme_constant_override("margin_right", 17); m.add_theme_constant_override("margin_top", 14); m.add_theme_constant_override("margin_bottom", 14); panel.add_child(m)
	var v := VBoxContainer.new(); v.mouse_filter = Control.MOUSE_FILTER_IGNORE; v.add_theme_constant_override("separation", 6); m.add_child(v)
	v.add_child(_label(title, 20, accent))
	var d := _label(body, 15, TEXT); d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; v.add_child(d)
	return panel

func _label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	l.text = Localization.text(text)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	return l

func _panel(bg: Color, border: Color, radius: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.border_width_left = 2; s.border_width_right = 2; s.border_width_top = 2; s.border_width_bottom = 2
	s.corner_radius_top_left = radius; s.corner_radius_top_right = radius; s.corner_radius_bottom_left = radius; s.corner_radius_bottom_right = radius
	s.content_margin_left = 12; s.content_margin_right = 12; s.content_margin_top = 8; s.content_margin_bottom = 8
	return s

func _spacer(height: float) -> void:
	var c := Control.new(); c.custom_minimum_size = Vector2(0, height); screen_root.add_child(c)

func _clear_screen() -> void:
	for child in screen_root.get_children():
		screen_root.remove_child(child)
		child.queue_free()
	board = null
	hud_label = null
	payment_status_label = null
	purchase_actions = null
	leaderboard_box = null
	if save.reduced_motion:
		screen_root.modulate = Color.WHITE
	else:
		screen_root.modulate = Color(1, 1, 1, 0)
		call_deferred("_animate_screen_in")

func _v5(source: String) -> String:
	var language_dictionary: Dictionary = V5_TEXT.get(Localization.current_language(), {})
	if language_dictionary.has(source):
		return str(language_dictionary[source])
	var english: Dictionary = V5_TEXT.get("en", {})
	return str(english.get(source, source))

func _sync_backdrop(level: int, mode: String) -> void:
	if backdrop == null:
		return
	backdrop.set_context(level, str(save.equipped.get("theme", "auto")), mode, save.reduced_motion)

func _highest_campaign_level() -> int:
	var highest := 1
	for raw_key in save.best_stars.keys():
		var key := str(raw_key)
		if not key.is_valid_int():
			continue
		var level := int(key)
		if level >= 1 and level <= AppConfig.TOTAL_LEVELS and int(save.best_stars.get(key, 0)) > 0:
			highest = maxi(highest, level)
	return highest

func _world_stars(world_index: int) -> int:
	var total := 0
	var first_level := world_index * 10 + 1
	for level in range(first_level, first_level + 10):
		total += save.get_level_stars(level)
	return total

func _efficiency_bar(value: float, accent: Color) -> Control:
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 35)
	margin.add_theme_constant_override("margin_right", 35)
	var bar := ProgressBar.new()
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.custom_minimum_size = Vector2(0, 22)
	bar.min_value = 0.0
	bar.max_value = 100.0
	bar.value = value
	bar.show_percentage = false
	bar.add_theme_stylebox_override("background", _panel(Color("081020"), Color("2b3855"), 10))
	bar.add_theme_stylebox_override("fill", _panel(Color(accent, 0.72), accent, 10))
	margin.add_child(bar)
	return margin

func _animate_result_stars(star_nodes: Array[Label], earned_stars: int) -> void:
	for i in range(mini(earned_stars, star_nodes.size())):
		var star: Label = star_nodes[i]
		if not is_instance_valid(star):
			continue
		var tween := create_tween()
		tween.tween_interval(float(i) * 0.12)
		tween.tween_property(star, "modulate", Color.WHITE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _animate_game_board() -> void:
	if board == null or not is_instance_valid(board) or save.reduced_motion:
		return
	var tween := create_tween().set_parallel(true)
	tween.tween_property(board, "modulate", Color.WHITE, 0.22).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(board, "scale", Vector2.ONE, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _animate_screen_in() -> void:
	if save.reduced_motion or screen_root == null:
		if screen_root != null:
			screen_root.modulate = Color.WHITE
		return
	var tween := create_tween()
	tween.tween_property(screen_root, "modulate", Color.WHITE, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _button_visual_down(button: Button) -> void:
	if not is_instance_valid(button):
		return
	if save.reduced_motion:
		button.modulate = Color(0.88, 0.92, 1.0, 1.0)
		return
	var tween := create_tween()
	tween.tween_property(button, "modulate", Color(0.82, 0.88, 1.0, 1.0), 0.045)

func _button_visual_up(button: Button) -> void:
	if not is_instance_valid(button):
		return
	if save.reduced_motion:
		button.modulate = Color.WHITE
		return
	var tween := create_tween()
	tween.tween_property(button, "modulate", Color.WHITE, 0.11).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _spacer_into(container: VBoxContainer, height: float) -> void:
	var spacer := Control.new()
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spacer.custom_minimum_size = Vector2(0, height)
	container.add_child(spacer)

func _toggle_reduced_motion() -> void:
	save.set_reduced_motion(not save.reduced_motion)
	show_settings()

func _toggle_minimap() -> void:
	save.set_show_minimap(not save.show_minimap)
	show_settings()

func _noop() -> void:
	pass

func _play(player: AudioStreamPlayer) -> void:
	if player != null:
		player.stop()
		player.play()
