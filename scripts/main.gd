extends Control

const StudioIntroFXScript = preload("res://scripts/studio_intro_fx.gd")

var save := SaveManager.new()
var payment: PaymentManager
var leaderboard: LeaderboardManager
var screen_root: VBoxContainer
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
var audio_bump: AudioStreamPlayer
var audio_orb: AudioStreamPlayer
var audio_win: AudioStreamPlayer
var audio_intro: AudioStreamPlayer
var intro_tween: Tween
var intro_tweens: Array[Tween] = []
var intro_fx: Control
var exit_overlay: Control

const TEXT := Color("eaf5ff")
const MUTED := Color("91a8c7")
const CYAN := Color("58e7ff")
const PINK := Color("ff5fce")
const GOLD := Color("ffd166")
const GREEN := Color("52ff9a")
const DANGER := Color("ff718d")

func _ready() -> void:
	set_process(true)
	# Android must not close the app automatically when the system Back action is used.
	get_tree().quit_on_go_back = false
	get_window().go_back_requested.connect(_on_system_back_requested)
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
	show_studio_intro()

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

func _on_system_back_requested() -> void:
	_back()

func _input(_event: InputEvent) -> void:
	# The studio/game presentation is mandatory. Consume every regular input while it plays
	# so touch, mouse and keyboard cannot shorten or bypass the sequence.
	if current_screen == "intro":
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_back()

func _build_shell() -> void:
	var backdrop := Backdrop.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.z_index = 0
	add_child(backdrop)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 22)
	margin.z_index = 2
	add_child(margin)
	screen_root = VBoxContainer.new()
	screen_root.z_index = 2
	screen_root.add_theme_constant_override("separation", 14)
	margin.add_child(screen_root)

func _build_audio() -> void:
	audio_move = AudioStreamPlayer.new()
	audio_move.stream = load("res://assets/audio/move.wav")
	audio_move.volume_db = -12
	add_child(audio_move)
	audio_bump = AudioStreamPlayer.new()
	audio_bump.stream = load("res://assets/audio/bump.wav")
	audio_bump.volume_db = -8
	add_child(audio_bump)
	audio_orb = AudioStreamPlayer.new()
	audio_orb.stream = load("res://assets/audio/orb.wav")
	audio_orb.volume_db = -7
	add_child(audio_orb)
	audio_win = AudioStreamPlayer.new()
	audio_win.stream = load("res://assets/audio/win.wav")
	audio_win.volume_db = -5
	add_child(audio_win)
	audio_intro = AudioStreamPlayer.new()
	audio_intro.stream = load("res://assets/audio/illu_intro.wav")
	audio_intro.volume_db = -8
	add_child(audio_intro)

func show_studio_intro() -> void:
	current_screen = "intro"
	game_active = false
	_clear_screen()
	_kill_intro_tweens()
	_cleanup_intro_fx()

	intro_fx = StudioIntroFXScript.new()
	intro_fx.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	intro_fx.z_index = 1
	add_child(intro_fx)

	var top_fill := Control.new()
	top_fill.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(top_fill)

	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", _panel(Color(0.035, 0.055, 0.13, 0.82), Color(CYAN, 0.46), 32))
	panel.custom_minimum_size = Vector2(0, 430)
	panel.modulate = Color(1, 1, 1, 0)
	screen_root.add_child(panel)

	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_bottom", 28)
	panel.add_child(margin)

	var stage := Control.new()
	stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.custom_minimum_size = Vector2(0, 360)
	margin.add_child(stage)

	var studio_center := CenterContainer.new()
	studio_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	studio_center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stage.add_child(studio_center)
	var studio_brand := VBoxContainer.new()
	studio_brand.mouse_filter = Control.MOUSE_FILTER_IGNORE
	studio_brand.alignment = BoxContainer.ALIGNMENT_CENTER
	studio_brand.add_theme_constant_override("separation", 5)
	studio_center.modulate = Color(1, 1, 1, 0)
	studio_center.position.y = 18.0
	studio_center.add_child(studio_brand)

	var symbol := _label("✦", 62, GOLD)
	symbol.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	symbol.modulate = Color(1, 1, 1, 0)
	symbol.rotation = -0.16
	studio_brand.add_child(symbol)
	var illu := _label("ILLU", 78, TEXT)
	illu.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	illu.add_theme_color_override("font_shadow_color", Color(CYAN, 0.62))
	illu.add_theme_constant_override("shadow_offset_x", 4)
	illu.add_theme_constant_override("shadow_offset_y", 4)
	illu.modulate = Color(1, 1, 1, 0)
	studio_brand.add_child(illu)
	var entertainment := _label("E N T E R T A I N M E N T", 20, CYAN)
	entertainment.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	entertainment.modulate = Color(1, 1, 1, 0)
	studio_brand.add_child(entertainment)
	var studio_tagline := _label(Localization.text("JUEGOS · LIGHTNING · ARCADE"), 13, Color(MUTED, 0.88))
	studio_tagline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	studio_tagline.modulate = Color(1, 1, 1, 0)
	studio_brand.add_child(studio_tagline)

	var game_center := CenterContainer.new()
	game_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	game_center.modulate = Color(1, 1, 1, 0)
	game_center.position.y = 18.0
	stage.add_child(game_center)
	var game_brand := VBoxContainer.new()
	game_brand.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_brand.alignment = BoxContainer.ALIGNMENT_CENTER
	game_brand.add_theme_constant_override("separation", 7)
	game_center.add_child(game_brand)
	var presents := _label("ILLU ENTERTAINMENT · " + Localization.text("PRESENTA"), 13, Color(MUTED, 0.90))
	presents.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_brand.add_child(presents)
	var maze_title := _label("SATOSHI\nMAZE", 58, TEXT)
	maze_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	maze_title.add_theme_color_override("font_shadow_color", Color(PINK, 0.42))
	maze_title.add_theme_constant_override("shadow_offset_x", 4)
	maze_title.add_theme_constant_override("shadow_offset_y", 4)
	game_brand.add_child(maze_title)
	var game_tagline := _label(Localization.text("ENTRÁ AL LABERINTO"), 15, GOLD)
	game_tagline.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_brand.add_child(game_tagline)

	var bottom_fill := Control.new()
	bottom_fill.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(bottom_fill)

	_play(audio_intro)

	# Background reveal and energy flash.
	var fx_tween := create_tween()
	intro_tweens.append(fx_tween)
	fx_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	fx_tween.tween_property(intro_fx, "reveal", 1.0, 1.15)
	fx_tween.tween_interval(0.38)
	fx_tween.tween_property(intro_fx, "flash", 1.0, 0.10)
	fx_tween.set_ease(Tween.EASE_IN_OUT)
	fx_tween.tween_property(intro_fx, "flash", 0.0, 0.30)
	fx_tween.tween_interval(1.20)
	fx_tween.set_ease(Tween.EASE_IN)
	fx_tween.tween_property(intro_fx, "exit_amount", 1.0, 0.48)

	# Frame / glass panel entrance.
	var panel_tween := create_tween()
	intro_tweens.append(panel_tween)
	panel_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	panel_tween.tween_property(panel, "modulate", Color.WHITE, 0.34)

	# Studio identity arrives in layers rather than as one flat fade.
	var studio_tween := create_tween()
	intro_tweens.append(studio_tween)
	studio_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	studio_tween.tween_interval(0.12)
	studio_tween.tween_property(studio_center, "modulate", Color.WHITE, 0.24)
	studio_tween.parallel().tween_property(studio_center, "position", Vector2(0.0, 0.0), 0.40)
	studio_tween.tween_property(symbol, "modulate", Color.WHITE, 0.18)
	studio_tween.parallel().tween_property(symbol, "rotation", 0.0, 0.40)
	studio_tween.tween_property(illu, "modulate", Color.WHITE, 0.30)
	studio_tween.tween_property(entertainment, "modulate", Color.WHITE, 0.25)
	studio_tween.tween_property(studio_tagline, "modulate", Color.WHITE, 0.23)
	studio_tween.tween_interval(0.36)
	studio_tween.set_ease(Tween.EASE_IN)
	studio_tween.tween_property(studio_center, "modulate", Color(1, 1, 1, 0), 0.24)
	studio_tween.parallel().tween_property(studio_center, "position", Vector2(0.0, -14.0), 0.24)

	# Satoshi Maze follows immediately after the ILLU flash.
	var game_tween := create_tween()
	intro_tweens.append(game_tween)
	game_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	game_tween.tween_interval(2.02)
	game_tween.tween_property(game_center, "modulate", Color.WHITE, 0.30)
	game_tween.parallel().tween_property(game_center, "position", Vector2(0.0, 0.0), 0.40)
	game_tween.tween_interval(0.65)
	game_tween.set_ease(Tween.EASE_IN)
	game_tween.tween_property(game_center, "modulate", Color(1, 1, 1, 0), 0.34)

	intro_tween = create_tween()
	intro_tween.tween_interval(3.30)
	intro_tween.tween_property(panel, "modulate", Color(1, 1, 1, 0), 0.32)
	intro_tween.tween_callback(Callable(self, "_intro_complete"))

func _intro_complete() -> void:
	if current_screen != "intro":
		return
	# The timeline that invoked this callback is already completing; do not kill it from inside itself.
	intro_tween = null
	_kill_intro_tweens()
	_cleanup_intro_fx()
	if audio_intro != null:
		audio_intro.stop()
	show_menu(true)

func _kill_intro_tweens() -> void:
	for tween in intro_tweens:
		if tween != null and tween.is_valid():
			tween.kill()
	intro_tweens.clear()
	if intro_tween != null and intro_tween.is_valid():
		intro_tween.kill()
	intro_tween = null

func _cleanup_intro_fx() -> void:
	if intro_fx != null and is_instance_valid(intro_fx):
		intro_fx.visible = false
		intro_fx.queue_free()
	intro_fx = null

func show_menu(animate_entry: bool = false) -> void:
	current_screen = "menu"
	game_active = false
	_clear_screen()
	_spacer(16)
	var badge := _label("⚡  LIGHTNING ARCADE  ·  SEASON 01", 15, GOLD)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(badge)
	var title := _label("SATOSHI\nMAZE", 59, TEXT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_shadow_color", Color(CYAN, 0.45))
	title.add_theme_constant_override("shadow_offset_x", 3)
	title.add_theme_constant_override("shadow_offset_y", 3)
	screen_root.add_child(title)
	var subtitle := _label("100 laberintos · retos globales · Ghost Run · colección premium", 17, MUTED)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(subtitle)
	var summary := _label(Localization.f("menu_summary", [save.total_stars, save.daily_streak, save.infinite_best_round]), 17, TEXT)
	summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(summary)
	_spacer(8)
	screen_root.add_child(_button("CAMPAÑA · 100 LABERINTOS", func(): show_levels(), true, CYAN))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.add_child(_button("DAILY", func(): show_daily(), false, GOLD))
	row.add_child(_button("INFINITE", func(): start_infinite(1), false, PINK))
	screen_root.add_child(row)
	screen_root.add_child(_button("TIENDA · SKINS · TRAILS · TEMAS", func(): show_store(), true, GOLD))
	var row2 := HBoxContainer.new()
	row2.add_theme_constant_override("separation", 10)
	row2.add_child(_button("COLECCIÓN", func(): show_collection(), false, CYAN))
	row2.add_child(_button("ESTADÍSTICAS", func(): show_stats(), false, TEXT))
	screen_root.add_child(row2)
	screen_root.add_child(_button("CÓMO JUGAR", func(): show_help(), false, TEXT))
	screen_root.add_child(_button("AJUSTES", func(): show_settings(), false, MUTED))
	var studio := _label("ILLU ENTERTAINMENT", 12, Color(MUTED, 0.70))
	studio.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(studio)

	if animate_entry:
		_animate_menu_entry(badge, title, subtitle, summary)

func _animate_menu_entry(badge: Label, title: Label, subtitle: Label, summary: Label) -> void:
	var nodes: Array[Control] = [badge, title, subtitle, summary]
	for node in nodes:
		node.modulate = Color(1, 1, 1, 0)
	var delay: float = 0.0
	for node in nodes:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_interval(delay)
		tween.tween_property(node, "modulate", Color.WHITE, 0.30)
		delay += 0.075

func show_levels() -> void:
	current_screen = "levels"
	game_active = false
	_clear_screen()
	_add_topbar("CAMPAÑA", func(): show_menu())
	var info := _label("Los niveles normales son gratis. Solo los Boss Maze requieren pago y la campaña debe completarse estrictamente en orden.", 15, MUTED)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(info)

	var progress: int = save.completed_campaign_prefix()
	var progress_copy: String = "%s · %d / %d" % [Localization.text("PROGRESO SECUENCIAL"), progress, AppConfig.TOTAL_LEVELS]
	var progress_text := _label(progress_copy, 14, CYAN)
	progress_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(progress_text)

	var scroll := TouchScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 9)
	grid.add_theme_constant_override("v_separation", 9)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(grid)

	var next_level: int = save.next_campaign_level()
	for lvl in range(1, AppConfig.TOTAL_LEVELS + 1):
		var boss: bool = AppConfig.is_boss_level(lvl)
		var completed_in_sequence: bool = lvl <= progress
		var playable: bool = save.can_play_level(lvl)
		var is_next: bool = lvl == next_level and lvl <= AppConfig.TOTAL_LEVELS
		var boss_needs_payment: bool = is_next and boss and not save.has_boss_access(lvl)
		var stars: int = save.get_level_stars(lvl)
		var marker: String = "★".repeat(stars) + "☆".repeat(3 - stars) if stars > 0 else Localization.text("COMPLETADO")
		var bottom: String = ""
		if completed_in_sequence:
			bottom = marker
		elif boss_needs_payment:
			bottom = "⚡ %d SATS" % AppConfig.boss_price_sats(lvl)
		elif is_next and playable:
			bottom = "▶ " + Localization.text("DISPONIBLE")
		else:
			bottom = "🔒 " + Localization.text("EN SECUENCIA")
		var prefix: String = "BOSS " if boss else ""
		var label: String = "%s%02d\n%s" % [prefix, lvl, bottom]
		var accent: Color = PINK if boss else (CYAN if playable or completed_in_sequence else MUTED)
		var b: Button = _button(label, Callable(self, "_select_level").bind(lvl), false, accent)
		b.custom_minimum_size = Vector2(150, 88)
		b.add_theme_font_size_override("font_size", 13)
		# Future levels cannot be activated. The current unpaid Boss remains clickable
		# only so it can open its Lightning purchase screen.
		b.disabled = not (playable or boss_needs_payment)
		grid.add_child(b)

func show_daily() -> void:
	current_screen = "daily"
	game_active = false
	_clear_screen()
	_add_topbar("GLOBAL CHALLENGES", func(): show_menu())
	var daily := ChallengeManager.daily_maze()
	var daily_card := _card("DAILY MAZE", Localization.text("Mismo laberinto para todos hoy.") + "\n" + ChallengeManager.modifier_text(daily), GOLD)
	screen_root.add_child(daily_card)
	var daily_best := _label(Localization.f("daily_best", [save.get_best_text(ChallengeManager.daily_key()), save.daily_streak]), 16, MUTED)
	daily_best.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(daily_best)
	screen_root.add_child(_button("JUGAR DAILY", func(): start_daily(), true, GOLD))
	_spacer(12)
	var weekly := ChallengeManager.weekly_maze()
	screen_root.add_child(_card("WEEKLY SPEEDRUN", Localization.text("Reto técnico semanal. Ghost Run y ranking global.") + "\n" + ChallengeManager.modifier_text(weekly), PINK))
	var weekly_best := _label(Localization.f("weekly_best", [save.get_best_text(ChallengeManager.weekly_key())]), 16, MUTED)
	weekly_best.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(weekly_best)
	screen_root.add_child(_button("JUGAR WEEKLY", func(): start_weekly(), true, PINK))
	_spacer(10)
	leaderboard_box = VBoxContainer.new()
	leaderboard_box.add_theme_constant_override("separation", 6)
	screen_root.add_child(leaderboard_box)
	leaderboard_box.add_child(_label("TOP DAILY", 18, CYAN))
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
	if save.can_play_level(level):
		start_level(level)
		return
	# Only the immediate next Boss may open a payment gate.
	if save.is_next_campaign_level(level) and AppConfig.is_boss_level(level) and not save.has_boss_access(level):
		show_purchase_product("level_%d" % level)

func start_level(level: int) -> void:
	# Defense in depth: even direct calls cannot bypass sequential campaign rules.
	if not save.can_play_level(level):
		if save.is_next_campaign_level(level) and AppConfig.is_boss_level(level) and not save.has_boss_access(level):
			show_purchase_product("level_%d" % level)
		else:
			show_levels()
		return
	_start_maze(MazeGenerator.generate(level), level, str(level), "campaign", Localization.f("maze_number", [level]))

func _start_maze(maze: Dictionary, level_for_palette: int, run_key: String, mode: String, title_text: String) -> void:
	current_screen = "game"
	current_mode = mode
	current_level = level_for_palette
	current_run_key = run_key
	current_maze = maze
	_clear_screen()
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
	var mods := _label(ChallengeManager.modifier_text(maze), 14, GOLD if bool(maze.get("boss", false)) else MUTED)
	mods.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(mods)
	hud_label = _label("MOV 0   ·   0.0s   ·   ORB 0/3", 16, MUTED)
	hud_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(hud_label)
	board = MazeBoard.new()
	board.custom_minimum_size = Vector2(0, 680)
	board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	board.setup(current_maze, current_level, save.equipped, save.get_ghost(current_run_key))
	board.moved.connect(_on_board_moved)
	board.bumped.connect(_on_board_bumped)
	board.orb_collected.connect(func(): _play(audio_orb))
	board.key_collected.connect(func(): _play(audio_orb))
	board.goal_reached.connect(_on_goal_reached)
	screen_root.add_child(board)
	var pad := GridContainer.new()
	pad.columns = 3
	pad.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	pad.add_theme_constant_override("h_separation", 8)
	pad.add_theme_constant_override("v_separation", 7)
	var e1 := Control.new(); e1.custom_minimum_size = Vector2(88, 58); pad.add_child(e1)
	pad.add_child(_dir_button("▲", Vector2i.UP))
	var e2 := Control.new(); e2.custom_minimum_size = Vector2(88, 58); pad.add_child(e2)
	pad.add_child(_dir_button("◀", Vector2i.LEFT))
	pad.add_child(_dir_button("▼", Vector2i.DOWN))
	pad.add_child(_dir_button("▶", Vector2i.RIGHT))
	screen_root.add_child(pad)
	var ghost_note := "Ghost Run activo: competís contra tu mejor recorrido." if not save.get_ghost(current_run_key).is_empty() else "Tu mejor recorrido quedará guardado como Ghost Run."
	var tip := _label(ghost_note, 13, MUTED)
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
	_clear_screen()
	_spacer(75)
	var icon := _label("×", 86, DANGER); icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(icon)
	var title := _label("RACHA TERMINADA", 34, TEXT); title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(title)
	var reached := maxi(infinite_round - 1, 0)
	var info := _label(Localization.f("infinite_failed", [reached, save.infinite_best_round]), 18, MUTED); info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(info)
	screen_root.add_child(_button("NUEVA RACHA", func(): start_infinite(1), true, PINK))
	screen_root.add_child(_button("MENÚ", func(): show_menu(), false, TEXT))

func show_store(filter: String = "") -> void:
	if not filter.is_empty():
		store_filter = filter
	current_screen = "store"
	game_active = false
	_clear_screen()
	_add_topbar("LIGHTNING STORE", func(): show_menu())
	var intro := _label("Compras permanentes. Sin loot boxes, sin pay-to-win. Personalizá tu identidad dentro del laberinto.", 15, MUTED)
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(intro)
	var local_note := _label("Las compras se guardan en este dispositivo. Sin servidor no hay restauración segura tras borrar la app o cambiar de teléfono.", 13, MUTED)
	local_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	local_note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(local_note)
	var filter_grid := GridContainer.new()
	filter_grid.columns = 3
	filter_grid.add_theme_constant_override("h_separation", 7)
	filter_grid.add_theme_constant_override("v_separation", 7)
	filter_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for filter_id in ["all", "skins", "trails", "themes", "finish", "bundles"]:
		var filter_button := _button(_store_filter_title(str(filter_id)), Callable(self, "show_store").bind(str(filter_id)), false, GOLD if store_filter == str(filter_id) else MUTED)
		filter_button.custom_minimum_size = Vector2(0, 45)
		filter_button.add_theme_font_size_override("font_size", 13)
		filter_grid.add_child(filter_button)
	screen_root.add_child(filter_grid)
	var scroll := TouchScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var list := VBoxContainer.new()
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
		list.add_child(_label("ÚLTIMAS COMPRAS", 19, CYAN))
		for purchase in save.purchase_history.slice(0, mini(5, save.purchase_history.size())):
			var history_product: Dictionary = ProductCatalog.get_product(str(purchase.get("product_id", "")))
			var history_name: String = str(history_product.get("name", purchase.get("name", "Compra")))
			list.add_child(_label(Localization.f("purchase_row", [history_name, int(purchase.get("amount_sats", 0))]), 14, MUTED))

func _store_filter_title(filter_id: String) -> String:
	var language: String = Localization.current_language()
	var labels: Dictionary = {
		"es": {"all": "TODO", "skins": "SKINS", "trails": "TRAILS", "themes": "TEMAS", "finish": "FINALES", "bundles": "PACKS"},
		"en": {"all": "ALL", "skins": "SKINS", "trails": "TRAILS", "themes": "THEMES", "finish": "FINISH", "bundles": "PACKS"},
		"pt": {"all": "TUDO", "skins": "SKINS", "trails": "TRAILS", "themes": "TEMAS", "finish": "FINAIS", "bundles": "PACKS"},
		"fr": {"all": "TOUT", "skins": "SKINS", "trails": "TRACES", "themes": "THÈMES", "finish": "FINAUX", "bundles": "PACKS"},
		"de": {"all": "ALLE", "skins": "SKINS", "trails": "TRAILS", "themes": "THEMEN", "finish": "FINISH", "bundles": "PAKETE"},
		"it": {"all": "TUTTO", "skins": "SKIN", "trails": "SCIE", "themes": "TEMI", "finish": "FINALI", "bundles": "PACK"},
	}
	var selected: Dictionary = labels.get(language, labels["en"])
	return str(selected.get(filter_id, filter_id.to_upper()))

func _store_section_for_kind(kind: String) -> String:
	match kind:
		"feature": return "featured"
		"bundle": return "bundles"
		"skin": return "skins"
		"trail": return "trails"
		"theme": return "themes"
		"victory_fx": return "finish"
		_: return "other"

func _store_section_title(section: String) -> String:
	var language: String = Localization.current_language()
	var titles: Dictionary = {
		"es": {"featured": "DESTACADOS", "bundles": "PACKS", "skins": "SKINS", "trails": "TRAILS", "themes": "TEMAS", "finish": "EFECTOS DE VICTORIA", "other": "EXTRAS"},
		"en": {"featured": "FEATURED", "bundles": "PACKS", "skins": "SKINS", "trails": "TRAILS", "themes": "THEMES", "finish": "VICTORY EFFECTS", "other": "EXTRAS"},
		"pt": {"featured": "DESTAQUES", "bundles": "PACKS", "skins": "SKINS", "trails": "TRAILS", "themes": "TEMAS", "finish": "EFEITOS DE VITÓRIA", "other": "EXTRAS"},
		"fr": {"featured": "À LA UNE", "bundles": "PACKS", "skins": "SKINS", "trails": "TRACES", "themes": "THÈMES", "finish": "EFFETS DE VICTOIRE", "other": "EXTRAS"},
		"de": {"featured": "HIGHLIGHTS", "bundles": "PAKETE", "skins": "SKINS", "trails": "TRAILS", "themes": "THEMEN", "finish": "SIEGESEFFEKTE", "other": "EXTRAS"},
		"it": {"featured": "IN EVIDENZA", "bundles": "PACK", "skins": "SKIN", "trails": "SCIE", "themes": "TEMI", "finish": "EFFETTI VITTORIA", "other": "EXTRA"},
	}
	var selected: Dictionary = titles.get(language, titles["en"])
	return str(selected.get(section, selected["other"]))

func _is_store_product_owned(product: Dictionary) -> bool:
	var product_id := str(product.get("id", ""))
	var kind := str(product.get("kind", ""))
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
	var product_id := str(product.id)
	var owned: bool = _is_store_product_owned(product)
	var panel := PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", _panel(Color("10182f"), Color(product.accent, 0.34), 18))
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_theme_constant_override("margin_left", 14); margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 12); margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)
	var row := HBoxContainer.new(); row.mouse_filter = Control.MOUSE_FILTER_IGNORE; row.add_theme_constant_override("separation", 12); margin.add_child(row)
	var icon := _label(str(product.icon), 35, Color(product.accent)); icon.custom_minimum_size = Vector2(48, 0); icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; row.add_child(icon)
	var copy := VBoxContainer.new(); copy.mouse_filter = Control.MOUSE_FILTER_IGNORE; copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(copy)
	copy.add_child(_label(str(product.name), 18, TEXT))
	var desc := _label(str(product.description), 13, MUTED); desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; copy.add_child(desc)
	var action: Button
	if owned:
		if ProductCatalog.is_cosmetic_kind(str(product.kind)):
			action = _button("EQUIPAR", Callable(self, "_equip_from_store").bind(product_id), false, GREEN)
		else:
			action = _button("ADQUIRIDO", Callable(self, "_noop"), false, GREEN)
			action.disabled = true
	else:
		action = _button("%d SATS" % int(product.price_sats), Callable(self, "show_purchase_product").bind(product_id), false, GOLD)
	action.custom_minimum_size = Vector2(132, 54)
	row.add_child(action)
	return panel

func _equip_from_store(product_id: String) -> void:
	if save.equip_product(product_id):
		show_collection()

func show_collection() -> void:
	current_screen = "collection"
	_clear_screen()
	_add_topbar("MI COLECCIÓN", func(): show_menu())
	var equipped_text := Localization.f("equipped", [
		str(save.equipped.get("skin", "default")).replace("skin_", "").to_upper(),
		str(save.equipped.get("trail", "default")).replace("trail_", "").to_upper(),
		str(save.equipped.get("theme", "auto")).replace("theme_", "").to_upper(),
		str(save.equipped.get("victory_fx", "default")).replace("victory_fx_", "").to_upper(),
	])
	var eq := _label(equipped_text, 16, CYAN); eq.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(eq)
	var reset_row := HBoxContainer.new(); reset_row.add_theme_constant_override("separation", 8)
	reset_row.add_child(_button("RESET SKIN", Callable(self, "_reset_equipped").bind("skin"), false, TEXT))
	reset_row.add_child(_button("RESET TRAIL", Callable(self, "_reset_equipped").bind("trail"), false, TEXT))
	screen_root.add_child(reset_row)
	var reset_row_extra := HBoxContainer.new(); reset_row_extra.add_theme_constant_override("separation", 8)
	reset_row_extra.add_child(_button(_collection_reset_title("theme"), Callable(self, "_reset_equipped").bind("theme"), false, TEXT))
	reset_row_extra.add_child(_button(_collection_reset_title("victory_fx"), Callable(self, "_reset_equipped").bind("victory_fx"), false, TEXT))
	screen_root.add_child(reset_row_extra)
	var scroll := TouchScrollContainer.new(); scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL; screen_root.add_child(scroll)
	var list := VBoxContainer.new(); list.add_theme_constant_override("separation", 9); list.size_flags_horizontal = Control.SIZE_EXPAND_FILL; scroll.add_child(list)
	var owned_count := 0
	for product in ProductCatalog.list_collection_products():
		if save.has_product(str(product.id)) and ProductCatalog.is_cosmetic_kind(str(product.kind)):
			owned_count += 1
			list.add_child(_product_card(product))
	if owned_count == 0:
		list.add_child(_card("TU COLECCIÓN EMPIEZA ACÁ", "Las skins y efectos premium aparecerán en esta vitrina.", CYAN))
		list.add_child(_button("EXPLORAR TIENDA", func(): show_store(), true, GOLD))

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
	_clear_screen()
	_add_topbar("PERFIL & ESTADÍSTICAS", func(): show_menu())
	var alias_name := "RUNNER-" + save.install_id.substr(0, 6).to_upper()
	screen_root.add_child(_card(alias_name, "Tu identidad anónima para rankings globales.", CYAN))
	var basic := Localization.f("full_stats", [save.total_completions, save.total_stars, save.daily_streak, save.infinite_best_round])
	var basic_label := _label(basic, 20, TEXT); basic_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(basic_label)
	if save.has_product("pro_stats"):
		_spacer(6)
		var pro := Localization.f("pro_stats", [save.average_efficiency(), save.total_moves, save.total_seconds / 60.0, save.total_orbs, save.achievements.size()])
		var pro_label := _label(pro, 18, GREEN); pro_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(pro_label)
	else:
		screen_root.add_child(_card("PRO STATS", "Desbloquea eficiencia global, récords, actividad y métricas avanzadas.", GOLD))
		screen_root.add_child(_button("DESBLOQUEAR PRO STATS · 29 SATS", func(): show_purchase_product("pro_stats"), true, GOLD))

func show_help() -> void:
	current_screen = "help"
	_clear_screen()
	_add_topbar("CÓMO JUGAR", func(): show_menu())
	var scroll := TouchScrollContainer.new(); scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL; screen_root.add_child(scroll)
	var list := VBoxContainer.new(); list.add_theme_constant_override("separation", 10); list.size_flags_horizontal = Control.SIZE_EXPAND_FILL; scroll.add_child(list)
	for item in [
		["DOMINÁ EL LABERINTO", "Deslizá o usá el pad. Menos movimientos aumenta tu eficiencia y mejora el Ghost Run."],
		["3 ESTRELLAS", "Completá, resolvé cerca de la ruta óptima y recogé los tres orbes."],
		["MODIFICADORES", "Niebla limita la visión. Las llaves abren la meta. Los portales cambian tu posición y el hielo te desliza."],
		["GHOST RUN", "Tu mejor recorrido queda como un fantasma visual para competir contra vos mismo."],
		["DAILY & WEEKLY", "Desafíos de semilla global para comparar tiempos y movimientos en rankings."],
		["INFINITE", "Encadená laberintos cada vez más exigentes y buscá tu mejor racha."],
		["CAMPAÑA SECUENCIAL", "Los niveles normales son gratis. Debés completar cada nivel en orden; solo los Boss Maze requieren pago."],
		["LIGHTNING STORE", "Los pagos compran acceso a Boss Maze y cosméticos permanentes. No venden soluciones ni ventajas competitivas."],
	]:
		list.add_child(_card(item[0], item[1], CYAN))


func show_settings() -> void:
	current_screen = "settings"
	game_active = false
	_clear_screen()
	_add_topbar("AJUSTES", func(): show_menu())
	var scroll := TouchScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 10)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)

	var detected: String = Localization.current_language_name()
	var current_mode_text: String = (Localization.text("AUTOMÁTICO") + " · " + detected) if save.language_override == "auto" else detected
	list.add_child(_card(Localization.text("IDIOMA"), Localization.text("IDIOMA DEL DISPOSITIVO") + ": " + current_mode_text, CYAN))
	list.add_child(_button(Localization.text("AUTOMÁTICO") + " · " + str(Localization.LANGUAGE_NAMES[Localization.detect_device_language()]), Callable(self, "_set_language").bind("auto"), true, GOLD if save.language_override == "auto" else TEXT))
	for code in Localization.SUPPORTED_LANGUAGES:
		var accent: Color = GREEN if save.language_override == code else CYAN
		list.add_child(_button(str(Localization.LANGUAGE_NAMES[code]), Callable(self, "_set_language").bind(code), false, accent))

	list.add_child(_card(Localization.text("FEEDBACK HÁPTICO"), Localization.text("Vibración breve al chocar contra una pared."), PINK))
	var haptic_label: String = Localization.text("ACTIVADO") if save.haptics_enabled else Localization.text("DESACTIVADO")
	list.add_child(_button(haptic_label, func(): _toggle_haptics(), true, GREEN if save.haptics_enabled else MUTED))

	list.add_child(_card("ILLU ENTERTAINMENT", "Satoshi Maze es un juego de ILLU ENTERTAINMENT.", PINK))
	list.add_child(_button("POLÍTICA DE PRIVACIDAD", func(): show_privacy_policy(), true, CYAN))
	list.add_child(_button("TÉRMINOS Y CONDICIONES", func(): show_terms(), true, GOLD))

func show_privacy_policy() -> void:
	current_screen = "privacy"
	game_active = false
	_clear_screen()
	_add_topbar(LegalContent.privacy_title(), func(): show_settings())
	_show_legal_document(LegalContent.privacy_intro(), LegalContent.privacy_sections(), CYAN)

func show_terms() -> void:
	current_screen = "terms"
	game_active = false
	_clear_screen()
	_add_topbar(LegalContent.terms_title(), func(): show_settings())
	_show_legal_document(LegalContent.terms_intro(), LegalContent.terms_sections(), GOLD)

func _show_legal_document(intro: String, sections: Array, accent: Color) -> void:
	var scroll := TouchScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 10)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	var intro_label := _label(intro, 15, MUTED)
	intro_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	list.add_child(intro_label)
	for raw_section in sections:
		var section: Dictionary = raw_section
		list.add_child(_card(str(section.get("title", "")), str(section.get("body", "")), accent))
	var end_note := _label("ILLU ENTERTAINMENT · Satoshi Maze", 12, Color(MUTED, 0.72))
	end_note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	list.add_child(end_note)

func _set_language(code: String) -> void:
	save.set_language_override(code)
	Localization.configure(code)
	show_settings()

func _toggle_haptics() -> void:
	save.set_haptics_enabled(not save.haptics_enabled)
	if save.haptics_enabled and OS.get_name() == "Android":
		Input.vibrate_handheld(20, 0.25)
	show_settings()

func show_purchase_product(product_id: String) -> void:
	current_product = ProductCatalog.get_product(product_id)
	if current_product.is_empty():
		return
	current_screen = "purchase"
	game_active = false
	payment.stop_polling()
	_clear_screen()
	_add_topbar("COMPRA LIGHTNING", func(): _purchase_back())
	_spacer(24)
	var icon := _label(str(current_product.icon), 82, Color(current_product.accent)); icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(icon)
	var title := _label(str(current_product.name), 31, TEXT); title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(title)
	var price := _label("%d SATS" % int(current_product.price_sats), 45, GOLD); price.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(price)
	var desc := _label(str(current_product.description), 17, MUTED); desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; screen_root.add_child(desc)
	payment_status_label = _label("Pago Lightning directo. Solo se habilita contenido después de una verificación criptográfica del invoice.", 15, TEXT)
	payment_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; payment_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; screen_root.add_child(payment_status_label)
	purchase_actions = VBoxContainer.new(); purchase_actions.add_theme_constant_override("separation", 9); screen_root.add_child(purchase_actions)
	purchase_actions.add_child(_button("GENERAR INVOICE", func(): payment.start_purchase(str(current_product.get("id", ""))), true, GOLD))
	var note := _label("No pagues si el proveedor no ofrece verificación automática. El juego bloqueará el cobro antes de abrir tu wallet.", 13, MUTED)
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; screen_root.add_child(note)

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
	_clear_screen()
	_spacer(95)
	var bolt := _label("✓", 92, GREEN); bolt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(bolt)
	var t := _label("COMPRA CONFIRMADA", 34, TEXT); t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(t)
	var s := _label(Localization.f("purchase_success", [str(product.get("name", "Contenido"))]), 17, MUTED)
	s.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(s)
	if str(product.get("kind", "")) == "level":
		var unlocked_level := int(product.get("level", 1))
		screen_root.add_child(_button("JUGAR AHORA", Callable(self, "_select_level").bind(unlocked_level), true, CYAN))
	else:
		screen_root.add_child(_button("VER COLECCIÓN", func(): show_collection(), true, CYAN))
		screen_root.add_child(_button("VOLVER A LA TIENDA", func(): show_store(), false, TEXT))

func _on_payment_status(text: String) -> void:
	if payment_status_label != null and is_instance_valid(payment_status_label):
		payment_status_label.text = Localization.text(text)

func _on_payment_error(text: String) -> void:
	_on_payment_status("⚠ " + text)

func _on_board_moved(_moves: int, _orbs: int) -> void:
	_play(audio_move)

func _on_board_bumped() -> void:
	_play(audio_bump)
	if save.haptics_enabled and OS.get_name() == "Android":
		Input.vibrate_handheld(28, 0.38)

func _on_goal_reached(moves: int, orbs: int) -> void:
	if not game_active:
		return
	game_active = false
	var elapsed := (Time.get_ticks_msec() - game_started_ms) / 1000.0
	var shortest: int = int(current_maze.shortest)
	var efficiency := clampf(float(shortest) / maxf(float(moves), 1.0), 0.0, 1.0) * 100.0
	var stars := 1
	if moves <= int(ceil(float(shortest) * 1.25)): stars += 1
	if orbs == 3: stars += 1
	var perfect := board.bump_count == 0
	var result := save.record_result(current_run_key, moves, elapsed, stars, shortest, orbs, board.get_run_path(), current_mode == "daily", current_mode == "campaign")
	if current_mode in ["daily", "weekly"]:
		save.record_challenge(current_run_key, moves, elapsed, efficiency)
		leaderboard.submit_score(current_run_key, "RUNNER-" + save.install_id.substr(0, 6).to_upper(), save.install_id, moves, elapsed, efficiency, board.get_run_path())
	if current_mode == "infinite":
		save.record_infinite_round(infinite_round)
	_play(audio_win)
	show_result(moves, elapsed, orbs, stars, shortest, perfect, bool(result.improved))

func show_result(moves: int, elapsed: float, orbs: int, stars: int, shortest: int, perfect: bool, improved: bool) -> void:
	current_screen = "result"
	_clear_screen()
	_spacer(30)
	var victory_fx := str(save.equipped.get("victory_fx", "default"))
	var crown_text := "✦"
	match victory_fx:
		"victory_fx_supernova": crown_text = "✦  ✹  ✦"
		"victory_fx_thunder": crown_text = "ϟ  ✦  ϟ"
		"victory_fx_portal": crown_text = "⟲  ◉  ⟳"
		"victory_fx_sats": crown_text = "₿  ✦  ₿"
	var crown := _label(crown_text, 76, GOLD); crown.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(crown)
	var title := _label("¡ESCAPASTE!", 37, TEXT); title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(title)
	var star_text := "★".repeat(stars) + "☆".repeat(3-stars)
	var star_label := _label(star_text, 43, GOLD); star_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(star_label)
	var efficiency := clampf(float(shortest) / maxf(float(moves), 1.0), 0.0, 1.0) * 100.0
	var target_time := float(current_maze.get("target_time", float(shortest) * 0.78 + 8.0))
	var medal := "ORO" if elapsed <= target_time else ("PLATA" if elapsed <= target_time * 1.35 else "BRONCE")
	var medal_color := GOLD if medal == "ORO" else (CYAN if medal == "PLATA" else Color("d38b5d"))
	var medal_label := _label(Localization.text("MEDALLA") + " " + Localization.text(medal), 20, medal_color); medal_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(medal_label)
	var badges: Array[String] = []
	if perfect: badges.append("PERFECT RUN")
	if improved: badges.append("NUEVO GHOST")
	if orbs == 3: badges.append("ORB MASTER")
	if bool(current_maze.get("boss", false)) and elapsed <= float(current_maze.get("target_time", 999999.0)): badges.append("BOSS TIME")
	var badge_text := " · ".join(badges) if not badges.is_empty() else "RUN COMPLETADO"
	var badge := _label(badge_text, 15, GREEN if perfect else CYAN); badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(badge)
	var stat := _label(Localization.f("result_stats", [moves, elapsed, shortest, efficiency, orbs]), 17, MUTED)
	stat.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; stat.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; screen_root.add_child(stat)
	_spacer(12)
	if current_mode == "campaign" and current_level < AppConfig.TOTAL_LEVELS:
		var next := current_level + 1
		var next_is_paid_boss: bool = AppConfig.is_boss_level(next) and not save.has_boss_access(next)
		var next_text: String = ("BOSS · %d SATS" % AppConfig.boss_price_sats(next)) if next_is_paid_boss else Localization.text("SIGUIENTE NIVEL")
		screen_root.add_child(_button(next_text, func(): _select_level(next), true, GOLD if next_is_paid_boss else CYAN))
	elif current_mode == "infinite":
		screen_root.add_child(_button("CONTINUAR · RUN %02d" % (infinite_round + 1), func(): start_infinite(infinite_round + 1), true, PINK))
	elif current_mode in ["daily", "weekly"]:
		screen_root.add_child(_button("VER DESAFÍOS & RANKING", func(): show_daily(), true, GOLD))
	screen_root.add_child(_button("REPETIR · GHOST RUN", func(): _restart_current(), false, PINK))
	screen_root.add_child(_button("MENÚ", func(): show_menu(), false, TEXT))

func _on_leaderboard_ready(_challenge_key: String, entries: Array) -> void:
	if leaderboard_box == null or not is_instance_valid(leaderboard_box):
		return
	for child in leaderboard_box.get_children(): child.queue_free()
	leaderboard_box.add_child(_label("TOP DAILY", 18, CYAN))
	if entries.is_empty():
		leaderboard_box.add_child(_label("Todavía no hay tiempos publicados.", 14, MUTED))
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
	# Back closes the exit prompt first instead of leaving the application.
	if exit_overlay != null and is_instance_valid(exit_overlay):
		_dismiss_exit_confirmation()
		return
	match current_screen:
		"game": _leave_game()
		"intro": return # Mandatory presentation: Back is ignored until it finishes.
		"levels", "daily", "store", "collection", "stats", "help", "settings": show_menu()
		"privacy", "terms": show_settings()
		"purchase": _purchase_back()
		"result": show_menu()
		"menu": _show_exit_confirmation()
		_: show_menu()

func _show_exit_confirmation() -> void:
	if exit_overlay != null and is_instance_valid(exit_overlay):
		return

	exit_overlay = Control.new()
	exit_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	exit_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	exit_overlay.z_index = 100
	add_child(exit_overlay)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.01, 0.015, 0.05, 0.78)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	exit_overlay.add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	exit_overlay.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(560, 0)
	panel.add_theme_stylebox_override("panel", _panel(Color("111a34"), Color(PINK, 0.72), 24))
	panel.modulate = Color(1, 1, 1, 0)
	panel.scale = Vector2(0.94, 0.94)
	panel.pivot_offset = Vector2(280, 150)
	center.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	panel.add_child(margin)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	margin.add_child(content)

	var icon := _label("↩", 48, GOLD)
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(icon)
	var title := _label("¿SALIR DE SATOSHI MAZE?", 27, TEXT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)
	var message := _label("¿Querés cerrar el juego?", 16, MUTED)
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(message)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 10)
	content.add_child(actions)
	actions.add_child(_button("CANCELAR", func(): _dismiss_exit_confirmation(), false, CYAN))
	actions.add_child(_button("SALIR", func(): _confirm_exit_game(), false, DANGER))

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate", Color.WHITE, 0.16)
	tween.parallel().tween_property(panel, "scale", Vector2.ONE, 0.22)

func _dismiss_exit_confirmation() -> void:
	if exit_overlay == null or not is_instance_valid(exit_overlay):
		exit_overlay = null
		return
	var overlay := exit_overlay
	exit_overlay = null
	overlay.queue_free()

func _confirm_exit_game() -> void:
	_dismiss_exit_confirmation()
	get_tree().quit()

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
	b.add_theme_stylebox_override("normal", _panel(Color("111a34"), Color(accent, 0.42), 17))
	b.add_theme_stylebox_override("hover", _panel(Color("19254a"), Color(accent, 0.82), 17))
	b.add_theme_stylebox_override("pressed", _panel(Color("0d1328"), accent, 17))
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
	_dismiss_exit_confirmation()
	for child in screen_root.get_children():
		screen_root.remove_child(child)
		child.queue_free()
	board = null
	hud_label = null
	payment_status_label = null
	purchase_actions = null
	leaderboard_box = null

func _noop() -> void:
	pass

func _play(player: AudioStreamPlayer) -> void:
	if player != null:
		player.stop()
		player.play()
