extends Control

var save := SaveManager.new()
var payment: PaymentManager
var screen_root: VBoxContainer
var current_screen := "menu"
var current_level := 1
var current_maze: Dictionary = {}
var board: MazeBoard
var hud_label: Label
var game_started_ms := 0
var game_active := false
var payment_status_label: Label
var purchase_actions: VBoxContainer
var audio_move: AudioStreamPlayer
var audio_orb: AudioStreamPlayer
var audio_win: AudioStreamPlayer

const TEXT := Color("eaf5ff")
const MUTED := Color("91a8c7")
const CYAN := Color("58e7ff")
const PINK := Color("ff5fce")
const GOLD := Color("ffd166")

func _ready() -> void:
	set_process(true)
	save.load_data()
	_build_shell()
	_build_audio()
	payment = PaymentManager.new()
	add_child(payment)
	payment.status_changed.connect(_on_payment_status)
	payment.invoice_ready.connect(_on_invoice_ready)
	payment.payment_verified.connect(_on_payment_verified)
	payment.payment_error.connect(_on_payment_error)
	show_menu()

func _process(_delta: float) -> void:
	if game_active and hud_label != null and board != null:
		var elapsed := (Time.get_ticks_msec() - game_started_ms) / 1000.0
		hud_label.text = "MOV %d   ·   %.1fs   ·   ORB %d/3" % [board.moves, elapsed, board.collected.size()]

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_back()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_back()

func _build_shell() -> void:
	var backdrop := Backdrop.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_bottom", 26)
	add_child(margin)

	screen_root = VBoxContainer.new()
	screen_root.add_theme_constant_override("separation", 16)
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
	_spacer(35)
	var badge := _label("⚡  BITCOIN LIGHTNING MAZE  ⚡", 17, GOLD)
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(badge)
	var title := _label("SATOSHI\nMAZE", 64, TEXT)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_shadow_color", Color(CYAN, 0.5))
	title.add_theme_constant_override("shadow_offset_x", 3)
	title.add_theme_constant_override("shadow_offset_y", 3)
	screen_root.add_child(title)
	var subtitle := _label("Escapa. Colecciona energía. Domina 100 laberintos.", 20, MUTED)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	screen_root.add_child(subtitle)
	_spacer(28)
	screen_root.add_child(_button("JUGAR", func(): show_levels(), true, CYAN))
	screen_root.add_child(_button("CONTINUAR NIVEL %d" % _suggest_level(), func(): _select_level(_suggest_level()), true, PINK))
	screen_root.add_child(_button("CÓMO JUGAR", func(): show_help(), false, TEXT))
	_spacer(18)
	var stats := _label("★ %d estrellas   ·   3 gratis   ·   niveles 4–100: %d sats c/u" % [save.total_stars, AppConfig.PRICE_SATS], 17, MUTED)
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(stats)
	var addr := _label("Pagos: " + AppConfig.PAYMENT_ADDRESS, 15, Color(CYAN, 0.8))
	addr.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(addr)

func show_levels() -> void:
	current_screen = "levels"
	game_active = false
	_clear_screen()
	_add_topbar("100 LABERINTOS", func(): show_menu())
	var info := _label("Los niveles 1–3 son gratis. Cada laberinto premium cuesta solo %d sats." % AppConfig.PRICE_SATS, 17, MUTED)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(info)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(scroll)
	var grid := GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(grid)

	for lvl in range(1, AppConfig.TOTAL_LEVELS + 1):
		var unlocked := save.is_unlocked(lvl)
		var label := "%02d\n%s" % [lvl, save.get_best_text(lvl) if unlocked else "⚡ %d sats" % AppConfig.PRICE_SATS]
		var b := _button(label, Callable(self, "_select_level").bind(lvl), false, CYAN if unlocked else GOLD)
		b.custom_minimum_size = Vector2(150, 92)
		b.add_theme_font_size_override("font_size", 15)
		grid.add_child(b)

func show_help() -> void:
	current_screen = "help"
	_clear_screen()
	_add_topbar("CÓMO JUGAR", func(): show_menu())
	var card := VBoxContainer.new()
	card.add_theme_constant_override("separation", 18)
	card.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_root.add_child(card)
	for item in [
		["DESLIZA O USA LAS FLECHAS", "Mueve la esfera por el laberinto con swipe, teclado o el pad táctil."],
		["RECOGE 3 ORBES", "No son obligatorios para escapar, pero te dan la tercera estrella del nivel."],
		["BUSCA LA META", "El diamante luminoso marca la salida. Menos movimientos = mejor puntuación."],
		["MICROPAGOS LIGHTNING", "Los niveles 1–3 son gratuitos. Los demás cuestan 2 sats y se pagan a %s." % AppConfig.PAYMENT_ADDRESS],
	]:
		var p := PanelContainer.new()
		p.add_theme_stylebox_override("panel", _panel(Color("101a35"), Color(CYAN, 0.25), 18))
		var m := MarginContainer.new()
		m.add_theme_constant_override("margin_left", 18); m.add_theme_constant_override("margin_right", 18)
		m.add_theme_constant_override("margin_top", 16); m.add_theme_constant_override("margin_bottom", 16)
		p.add_child(m)
		var v := VBoxContainer.new(); v.add_theme_constant_override("separation", 7); m.add_child(v)
		v.add_child(_label(item[0], 20, CYAN))
		var d := _label(item[1], 17, TEXT); d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; v.add_child(d)
		card.add_child(p)

func _select_level(level: int) -> void:
	if save.is_unlocked(level):
		start_level(level)
	else:
		show_purchase(level)

func start_level(level: int) -> void:
	current_screen = "game"
	current_level = level
	current_maze = MazeGenerator.generate(level)
	_clear_screen()
	var top := HBoxContainer.new()
	var back := _button("‹", func(): show_levels(), false, TEXT)
	back.custom_minimum_size = Vector2(64, 54)
	top.add_child(back)
	var name := _label("LABERINTO %02d" % level, 24, CYAN); name.size_flags_horizontal = Control.SIZE_EXPAND_FILL; name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; top.add_child(name)
	var reset := _button("↻", func(): start_level(level), false, GOLD); reset.custom_minimum_size = Vector2(64,54); top.add_child(reset)
	screen_root.add_child(top)

	hud_label = _label("MOV 0   ·   0.0s   ·   ORB 0/3", 17, MUTED)
	hud_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(hud_label)

	board = MazeBoard.new()
	board.custom_minimum_size = Vector2(0, 690)
	board.size_flags_vertical = Control.SIZE_EXPAND_FILL
	board.setup(current_maze, level)
	board.moved.connect(_on_board_moved)
	board.orb_collected.connect(func(): _play(audio_orb))
	board.goal_reached.connect(_on_goal_reached)
	screen_root.add_child(board)

	var pad := GridContainer.new()
	pad.columns = 3
	pad.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	pad.add_theme_constant_override("h_separation", 10)
	pad.add_theme_constant_override("v_separation", 8)
	var empty1 := Control.new(); empty1.custom_minimum_size = Vector2(92, 62); pad.add_child(empty1)
	pad.add_child(_dir_button("▲", Vector2i.UP))
	var empty2 := Control.new(); empty2.custom_minimum_size = Vector2(92, 62); pad.add_child(empty2)
	pad.add_child(_dir_button("◀", Vector2i.LEFT))
	pad.add_child(_dir_button("▼", Vector2i.DOWN))
	pad.add_child(_dir_button("▶", Vector2i.RIGHT))
	screen_root.add_child(pad)
	var tip := _label("También podés deslizar directamente sobre el laberinto", 14, MUTED)
	tip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(tip)
	game_started_ms = Time.get_ticks_msec()
	game_active = true

func show_purchase(level: int) -> void:
	current_screen = "purchase"
	current_level = level
	game_active = false
	if payment != null:
		payment.stop_polling()
	_clear_screen()
	_add_topbar("DESBLOQUEAR %02d" % level, func(): show_levels())
	_spacer(25)
	var bolt := _label("⚡", 92, GOLD); bolt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(bolt)
	var title := _label("2 SATS", 54, TEXT); title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(title)
	var desc := _label("Un micropago Lightning desbloquea este laberinto en este dispositivo.", 19, MUTED)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(desc)
	var addr := _label(AppConfig.PAYMENT_ADDRESS, 20, CYAN); addr.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(addr)

	payment_status_label = _label("Tocá el botón para generar un invoice de exactamente 2 sats.", 17, TEXT)
	payment_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	payment_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	screen_root.add_child(payment_status_label)
	purchase_actions = VBoxContainer.new(); purchase_actions.add_theme_constant_override("separation", 10); screen_root.add_child(purchase_actions)
	purchase_actions.add_child(_button("PAGAR 2 SATS", func(): payment.start_purchase(level), true, GOLD))
	var note := _label("El APK no contiene claves privadas ni credenciales de tu wallet.", 14, MUTED)
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; screen_root.add_child(note)

func _on_invoice_ready(_invoice: String, verify_url: String) -> void:
	for c in purchase_actions.get_children(): c.queue_free()
	purchase_actions.add_child(_button("ABRIR WALLET LIGHTNING", func(): payment.open_wallet(), true, GOLD))
	purchase_actions.add_child(_button("COPIAR INVOICE", func(): payment.copy_invoice(), false, CYAN))
	if not verify_url.is_empty():
		purchase_actions.add_child(_button("COMPROBAR AHORA", func(): payment.check_payment(), false, TEXT))
	elif AppConfig.ALLOW_MANUAL_PAYMENT_FALLBACK:
		purchase_actions.add_child(_button("YA PAGUÉ · FALLBACK LOCAL", func(): _manual_unlock(), false, PINK))
	var warn := _label("Si tu wallet no se abre, copiá el invoice y pegalo manualmente.", 14, MUTED)
	warn.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	purchase_actions.add_child(warn)
	payment.open_wallet()

func _on_payment_verified() -> void:
	save.unlock(current_level)
	_play(audio_win)
	show_unlock_success(false)

func _manual_unlock() -> void:
	save.unlock(current_level)
	show_unlock_success(true)

func show_unlock_success(was_manual: bool) -> void:
	payment.stop_polling()
	_clear_screen()
	_spacer(120)
	var bolt := _label("⚡", 100, GOLD); bolt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(bolt)
	var t := _label("¡DESBLOQUEADO!", 42, TEXT); t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(t)
	var s := _label("Nivel %02d listo para jugar.%s" % [current_level, "\nModo fallback local: úsalo solo para pruebas." if was_manual else ""], 18, MUTED)
	s.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(s)
	screen_root.add_child(_button("JUGAR AHORA", func(): start_level(current_level), true, CYAN))

func _on_payment_status(text: String) -> void:
	if payment_status_label != null and is_instance_valid(payment_status_label):
		payment_status_label.text = text

func _on_payment_error(text: String) -> void:
	_on_payment_status("Error: " + text)

func _on_board_moved(_moves: int, _orbs: int) -> void:
	_play(audio_move)

func _on_goal_reached(moves: int, orbs: int) -> void:
	if not game_active:
		return
	game_active = false
	var elapsed := (Time.get_ticks_msec() - game_started_ms) / 1000.0
	var shortest: int = current_maze.shortest
	var stars := 1
	if moves <= int(ceil(shortest * 1.35)):
		stars += 1
	if orbs == 3:
		stars += 1
	save.record_result(current_level, moves, elapsed, stars)
	_play(audio_win)
	show_result(moves, elapsed, orbs, stars, shortest)

func show_result(moves: int, elapsed: float, orbs: int, stars: int, shortest: int) -> void:
	current_screen = "result"
	_clear_screen()
	_spacer(50)
	var crown := _label("✦", 92, GOLD); crown.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(crown)
	var title := _label("¡ESCAPASTE!", 43, TEXT); title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(title)
	var star_text := "★".repeat(stars) + "☆".repeat(3-stars)
	var star_label := _label(star_text, 48, GOLD); star_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(star_label)
	var stat := _label("%d movimientos   ·   %.1f s\nRuta ideal: %d   ·   Orbes: %d/3" % [moves, elapsed, shortest, orbs], 19, MUTED)
	stat.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; screen_root.add_child(stat)
	_spacer(20)
	if current_level < AppConfig.TOTAL_LEVELS:
		var next := current_level + 1
		var text := "SIGUIENTE NIVEL" if save.is_unlocked(next) else "SIGUIENTE · 2 SATS"
		screen_root.add_child(_button(text, func(): _select_level(next), true, CYAN if save.is_unlocked(next) else GOLD))
	screen_root.add_child(_button("REPETIR", func(): start_level(current_level), false, PINK))
	screen_root.add_child(_button("VER 100 NIVELES", func(): show_levels(), false, TEXT))

func _dir_button(text: String, dir: Vector2i) -> Button:
	var cb := func():
		if board != null:
			board.move_player(dir)
	var b := _button(text, cb, false, CYAN)
	b.custom_minimum_size = Vector2(92, 62)
	b.add_theme_font_size_override("font_size", 27)
	return b

func _back() -> void:
	match current_screen:
		"game", "purchase", "result": show_levels()
		"levels", "help": show_menu()
		_: get_tree().quit()

func _suggest_level() -> int:
	for lvl in range(1, AppConfig.TOTAL_LEVELS + 1):
		if save.is_unlocked(lvl) and not save.best_moves.has(str(lvl)):
			return lvl
	return 1

func _add_topbar(title: String, back_cb: Callable) -> void:
	var h := HBoxContainer.new()
	var b := _button("‹", back_cb, false, TEXT); b.custom_minimum_size = Vector2(66, 54); h.add_child(b)
	var l := _label(title, 28, TEXT); l.size_flags_horizontal = Control.SIZE_EXPAND_FILL; l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; h.add_child(l)
	var ghost := Control.new(); ghost.custom_minimum_size = Vector2(66, 54); h.add_child(ghost)
	screen_root.add_child(h)

func _button(text: String, cb: Callable, big := false, accent := CYAN) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(0, 76 if big else 58)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_font_size_override("font_size", 22 if big else 18)
	b.add_theme_color_override("font_color", Color("f5fbff"))
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_stylebox_override("normal", _panel(Color("111a34"), Color(accent, 0.45), 17))
	b.add_theme_stylebox_override("hover", _panel(Color("19254a"), Color(accent, 0.85), 17))
	b.add_theme_stylebox_override("pressed", _panel(Color("0d1328"), accent, 17))
	b.pressed.connect(cb)
	return b

func _label(text: String, size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
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

func _play(player: AudioStreamPlayer) -> void:
	if player != null:
		player.stop()
		player.play()
