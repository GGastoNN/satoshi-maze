extends Control
class_name MazeBoard

signal moved(moves: int, orbs_collected: int)
signal orb_collected
signal goal_reached(moves: int, orbs_collected: int)

var maze: Dictionary = {}
var level := 1
var player := Vector2i.ZERO
var moves := 0
var collected: Array[Vector2i] = []
var trail: Array[Vector2i] = []
var palette: Dictionary = {}
var pulse := 0.0
var touch_start := Vector2.ZERO
var particles: Array[Dictionary] = []

const PALETTES := [
	{"bg": Color("10152f"), "floor": Color("172047"), "wall": Color("61e7ff"), "accent": Color("ff4fd8"), "goal": Color("ffd166")},
	{"bg": Color("241236"), "floor": Color("32164f"), "wall": Color("ff70d9"), "accent": Color("78ffd6"), "goal": Color("ffe66d")},
	{"bg": Color("071d1a"), "floor": Color("0c2a25"), "wall": Color("52ff9a"), "accent": Color("f7ff58"), "goal": Color("ffbe55")},
	{"bg": Color("111827"), "floor": Color("1f2937"), "wall": Color("a78bfa"), "accent": Color("38bdf8"), "goal": Color("fb7185")},
	{"bg": Color("2a1320"), "floor": Color("3b1824"), "wall": Color("ff8a5b"), "accent": Color("ffd36a"), "goal": Color("7cf7c5")},
	{"bg": Color("071a2b"), "floor": Color("0b2b42"), "wall": Color("84f7ff"), "accent": Color("b8a7ff"), "goal": Color("fff07a")},
	{"bg": Color("23180c"), "floor": Color("33220f"), "wall": Color("ffb347"), "accent": Color("ff5f6d"), "goal": Color("73fbd3")},
	{"bg": Color("101010"), "floor": Color("1b1b1b"), "wall": Color("f5f5f5"), "accent": Color("00e5ff"), "goal": Color("ffea00")},
	{"bg": Color("081c24"), "floor": Color("0d2a35"), "wall": Color("58d6ff"), "accent": Color("ff7ee2"), "goal": Color("b8ff5c")},
	{"bg": Color("200d2d"), "floor": Color("311044"), "wall": Color("c77dff"), "accent": Color("72efdd"), "goal": Color("ffcf56")},
]

func setup(new_maze: Dictionary, new_level: int) -> void:
	maze = new_maze
	level = new_level
	player = maze.start
	moves = 0
	collected.clear()
	trail = [player]
	particles.clear()
	palette = PALETTES[(level - 1) % PALETTES.size()]
	grab_focus()
	queue_redraw()

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)

func _process(delta: float) -> void:
	pulse += delta
	for p in particles:
		p.pos += p.vel * delta
		p.life -= delta
	particles = particles.filter(func(p): return float(p.life) > 0.0)
	queue_redraw()

func move_player(dir: Vector2i) -> void:
	if maze.is_empty() or not MazeGenerator.can_move(maze, player, dir):
		_spawn_bump()
		return
	player += dir
	moves += 1
	trail.append(player)
	if trail.size() > 14:
		trail.pop_front()
	_spawn_sparks(8)
	if maze.orbs.has(player) and not collected.has(player):
		collected.append(player)
		_spawn_sparks(20)
		orb_collected.emit()
	moved.emit(moves, collected.size())
	if player == maze.goal:
		_spawn_sparks(45)
		goal_reached.emit(moves, collected.size())
	queue_redraw()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed:
		return
	if event.keycode in [KEY_UP, KEY_W]: move_player(Vector2i.UP)
	elif event.keycode in [KEY_RIGHT, KEY_D]: move_player(Vector2i.RIGHT)
	elif event.keycode in [KEY_DOWN, KEY_S]: move_player(Vector2i.DOWN)
	elif event.keycode in [KEY_LEFT, KEY_A]: move_player(Vector2i.LEFT)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start = event.position
		else:
			_handle_swipe(event.position - touch_start)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			touch_start = event.position
		else:
			_handle_swipe(event.position - touch_start)

func _handle_swipe(delta: Vector2) -> void:
	if delta.length() < 24.0:
		return
	if abs(delta.x) > abs(delta.y):
		move_player(Vector2i.RIGHT if delta.x > 0 else Vector2i.LEFT)
	else:
		move_player(Vector2i.DOWN if delta.y > 0 else Vector2i.UP)

func _geometry() -> Dictionary:
	var pad := 16.0
	var w: int = maze.get("width", 1)
	var h: int = maze.get("height", 1)
	var cell := min((size.x - pad * 2.0) / w, (size.y - pad * 2.0) / h)
	var board_size := Vector2(cell * w, cell * h)
	var origin := (size - board_size) * 0.5
	return {"cell": cell, "origin": origin}

func _cell_center(p: Vector2i) -> Vector2:
	var g := _geometry()
	return g.origin + Vector2((p.x + 0.5) * g.cell, (p.y + 0.5) * g.cell)

func _draw() -> void:
	if maze.is_empty():
		return
	var g := _geometry()
	var cell: float = g.cell
	var origin: Vector2 = g.origin
	var w: int = maze.width
	var h: int = maze.height

	draw_style_box(_panel_style(palette.bg), Rect2(origin - Vector2(9,9), Vector2(cell*w+18, cell*h+18)))

	for y in h:
		for x in w:
			var c := palette.floor
			if (x + y) % 2 == 0:
				c = c.lightened(0.045)
			draw_rect(Rect2(origin + Vector2(x*cell,y*cell), Vector2(cell+0.5,cell+0.5)), c)

	# Orbes coleccionables.
	for orb in maze.orbs:
		if collected.has(orb):
			continue
		var op := _cell_center(orb)
		var rr := cell * (0.12 + 0.025 * sin(pulse * 4.0 + orb.x))
		draw_circle(op, rr * 2.0, Color(palette.goal, 0.10))
		draw_circle(op, rr, palette.goal)
		draw_circle(op - Vector2(rr*0.25, rr*0.25), rr*0.30, Color.WHITE)

	# Meta en forma de diamante/pulso.
	var gp := _cell_center(maze.goal)
	var gr := cell * (0.22 + 0.025 * sin(pulse * 4.0))
	draw_circle(gp, gr * 1.9, Color(palette.goal, 0.12))
	var pts := PackedVector2Array([gp+Vector2(0,-gr), gp+Vector2(gr,0), gp+Vector2(0,gr), gp+Vector2(-gr,0)])
	draw_colored_polygon(pts, palette.goal)
	draw_circle(gp, gr * 0.28, Color.WHITE)

	# Trail del jugador.
	for i in trail.size():
		var a := float(i + 1) / float(trail.size())
		var tp := _cell_center(trail[i])
		draw_circle(tp, cell * (0.07 + a*0.06), Color(palette.accent, a * 0.24))

	# Paredes neon: glow + línea principal. Dibujamos norte/oeste y cierres sur/este.
	for y in h:
		for x in w:
			var idx := y*w+x
			var mask: int = maze.walls[idx]
			var p := origin + Vector2(x*cell, y*cell)
			if mask & MazeGenerator.N: _wall(p, p+Vector2(cell,0))
			if mask & MazeGenerator.W: _wall(p, p+Vector2(0,cell))
			if y == h-1 and mask & MazeGenerator.S: _wall(p+Vector2(0,cell), p+Vector2(cell,cell))
			if x == w-1 and mask & MazeGenerator.E: _wall(p+Vector2(cell,0), p+Vector2(cell,cell))

	# Jugador.
	var pp := _cell_center(player)
	var pr := cell * 0.22
	draw_circle(pp, pr * 2.0, Color(palette.accent, 0.10))
	draw_circle(pp, pr * 1.35, Color(palette.accent, 0.22))
	draw_circle(pp, pr, palette.accent)
	draw_circle(pp - Vector2(pr*0.28, pr*0.28), pr*0.28, Color.WHITE)

	for p in particles:
		var a := clampf(float(p.life) / float(p.max_life), 0.0, 1.0)
		draw_circle(p.pos, float(p.radius), Color(palette.accent, a))

func _wall(a: Vector2, b: Vector2) -> void:
	draw_line(a, b, Color(palette.wall, 0.08), 10.0, true)
	draw_line(a, b, Color(palette.wall, 0.18), 6.0, true)
	draw_line(a, b, palette.wall, 2.3, true)

func _panel_style(color: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	s.corner_radius_top_left = 18
	s.corner_radius_top_right = 18
	s.corner_radius_bottom_left = 18
	s.corner_radius_bottom_right = 18
	s.border_width_left = 2
	s.border_width_right = 2
	s.border_width_top = 2
	s.border_width_bottom = 2
	s.border_color = Color(palette.wall, 0.28)
	return s

func _spawn_sparks(count: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var center := _cell_center(player)
	for i in count:
		var angle := rng.randf_range(0.0, TAU)
		var speed := rng.randf_range(25.0, 95.0)
		var life := rng.randf_range(0.25, 0.65)
		particles.append({"pos": center, "vel": Vector2.from_angle(angle)*speed, "life": life, "max_life": life, "radius": rng.randf_range(1.2, 3.0)})

func _spawn_bump() -> void:
	_spawn_sparks(3)
