extends Control
class_name MazeBoard

signal moved(moves: int, orbs_collected: int)
signal orb_collected
signal key_collected
signal goal_reached(moves: int, orbs_collected: int)
signal bumped

var maze: Dictionary = {}
var level := 1
var player := Vector2i.ZERO
var moves := 0
var collected: Array[Vector2i] = []
var visual_trail: Array[Vector2i] = []
var run_path: Array[Vector2i] = []
var seen_cells: Array[Vector2i] = []
var palette: Dictionary = {}
var cosmetics: Dictionary = {}
var pulse := 0.0
var touch_start := Vector2.ZERO
var particles: Array[Dictionary] = []
var has_key := false
var bump_count := 0
var ghost_path: Array[Vector2i] = []
var ghost_total_time := 0.0
var ghost_elapsed := 0.0
var visual_player_pos := Vector2.ZERO
var visual_from := Vector2.ZERO
var visual_to := Vector2.ZERO
var move_anim_t := 1.0
var move_anim_duration := 0.105
var bump_flash := 0.0
var portal_flash := 0.0
var reduced_motion := false
var show_minimap := true

const BASE_PALETTES := [
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

const SPECIAL_THEMES := {
	"theme_sunset": {"bg": Color("260d28"), "floor": Color("3b143a"), "wall": Color("ff8a5b"), "accent": Color("c77dff"), "goal": Color("ffd166")},
	"theme_mono": {"bg": Color("07090d"), "floor": Color("11151b"), "wall": Color("f4f7fb"), "accent": Color("58e7ff"), "goal": Color("ffffff")},
	"theme_matrix": {"bg": Color("020b06"), "floor": Color("07180e"), "wall": Color("52ff9a"), "accent": Color("b7ffcf"), "goal": Color("f7ff58")},
	"theme_deep": {"bg": Color("050716"), "floor": Color("0b1030"), "wall": Color("8b5cf6"), "accent": Color("84f7ff"), "goal": Color("ffd166")},
	"theme_arctic": {"bg": Color("071622"), "floor": Color("0d2938"), "wall": Color("d8f7ff"), "accent": Color("78dfff"), "goal": Color("f7fdff")},
	"theme_lava": {"bg": Color("160604"), "floor": Color("2a0d08"), "wall": Color("ff6b35"), "accent": Color("ffb347"), "goal": Color("ffe66d")},
	"theme_ocean": {"bg": Color("02111d"), "floor": Color("062638"), "wall": Color("4deeea"), "accent": Color("48bfe3"), "goal": Color("b8ffda")},
	"theme_synthwave": {"bg": Color("13051f"), "floor": Color("25083d"), "wall": Color("ff4fd8"), "accent": Color("58e7ff"), "goal": Color("ffe66d")},
}

func setup(new_maze: Dictionary, new_level: int, new_cosmetics: Dictionary, ghost: Dictionary = {}) -> void:
	maze = new_maze
	level = new_level
	cosmetics = new_cosmetics.duplicate(true)
	reduced_motion = bool(cosmetics.get("_reduced_motion", false))
	show_minimap = bool(cosmetics.get("_show_minimap", true))
	player = maze.start
	visual_player_pos = Vector2(player)
	visual_from = visual_player_pos
	visual_to = visual_player_pos
	move_anim_t = 1.0
	bump_flash = 0.0
	portal_flash = 0.0
	moves = 0
	collected.clear()
	visual_trail = [player]
	run_path = [player]
	seen_cells.clear()
	_mark_seen(player)
	particles.clear()
	has_key = false
	bump_count = 0
	ghost_elapsed = 0.0
	ghost_path.clear()
	for ghost_point in ghost.get("path", []):
		if ghost_point is Vector2i:
			ghost_path.append(ghost_point)
	ghost_total_time = float(ghost.get("total_time", 0.0))
	palette = _resolve_palette()
	grab_focus()
	queue_redraw()

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process(true)

func _process(delta: float) -> void:
	if not reduced_motion:
		pulse += delta
		ghost_elapsed += delta
	if move_anim_t < 1.0:
		move_anim_t = minf(1.0, move_anim_t + delta / move_anim_duration)
		var eased := 1.0 - pow(1.0 - move_anim_t, 3.0)
		visual_player_pos = visual_from.lerp(visual_to, eased)
	else:
		visual_player_pos = visual_to
	bump_flash = maxf(0.0, bump_flash - delta * 4.8)
	portal_flash = maxf(0.0, portal_flash - delta * 2.8)
	for p in particles:
		p.pos += p.vel * delta
		p.life -= delta
	particles = particles.filter(func(p): return float(p.life) > 0.0)
	queue_redraw()

func move_player(dir: Vector2i) -> void:
	if maze.is_empty() or not MazeGenerator.can_move(maze, player, dir):
		bump_count += 1
		_spawn_bump()
		bumped.emit()
		return
	_step(dir)
	var safety := 0
	while bool(maze.get("ice", false)) and maze.get("ice_cells", []).has(player) and MazeGenerator.can_move(maze, player, dir) and safety < 20:
		safety += 1
		_step(dir)
	queue_redraw()

func _step(dir: Vector2i) -> void:
	visual_from = visual_player_pos
	player += dir
	visual_to = Vector2(player)
	if reduced_motion:
		visual_player_pos = visual_to
		move_anim_t = 1.0
	else:
		move_anim_t = 0.0
	moves += 1
	run_path.append(player)
	visual_trail.append(player)
	if visual_trail.size() > 18:
		visual_trail.pop_front()
	_mark_seen(player)
	_spawn_sparks(8)
	_collect_here()
	_apply_portal()
	moved.emit(moves, collected.size())
	if player == maze.goal:
		if bool(maze.get("requires_key", false)) and not has_key:
			_spawn_bump()
			return
		_spawn_victory_effect(55 if bool(maze.get("boss", false)) else 40)
		goal_reached.emit(moves, collected.size())

func _collect_here() -> void:
	if maze.orbs.has(player) and not collected.has(player):
		collected.append(player)
		_spawn_sparks(20)
		orb_collected.emit()
	if bool(maze.get("requires_key", false)) and not has_key and player == maze.get("key_pos", Vector2i(-1, -1)):
		has_key = true
		_spawn_sparks(30)
		key_collected.emit()

func _apply_portal() -> void:
	if not bool(maze.get("portals", false)):
		return
	var a: Vector2i = maze.get("portal_a", Vector2i(-1, -1))
	var b: Vector2i = maze.get("portal_b", Vector2i(-1, -1))
	var destination := Vector2i(-1, -1)
	if player == a:
		destination = b
	elif player == b:
		destination = a
	if destination.x < 0:
		return
	player = destination
	visual_player_pos = Vector2(player)
	visual_from = visual_player_pos
	visual_to = visual_player_pos
	move_anim_t = 1.0
	portal_flash = 1.0
	run_path.append(player)
	visual_trail.append(player)
	_mark_seen(player)
	_spawn_sparks(26)
	_collect_here()

func _mark_seen(center: Vector2i) -> void:
	for y in range(center.y - 2, center.y + 3):
		for x in range(center.x - 2, center.x + 3):
			var p := Vector2i(x, y)
			if x >= 0 and y >= 0 and x < int(maze.get("width", 1)) and y < int(maze.get("height", 1)) and not seen_cells.has(p):
				seen_cells.append(p)

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
	if absf(delta.x) > absf(delta.y):
		move_player(Vector2i.RIGHT if delta.x > 0 else Vector2i.LEFT)
	else:
		move_player(Vector2i.DOWN if delta.y > 0 else Vector2i.UP)

func _geometry() -> Dictionary:
	var pad := 16.0
	var w: int = int(maze.get("width", 1))
	var h: int = int(maze.get("height", 1))
	var cell: float = minf((size.x - pad * 2.0) / float(w), (size.y - pad * 2.0) / float(h))
	var board_size := Vector2(cell * w, cell * h)
	var origin := (size - board_size) * 0.5
	if bump_flash > 0.0 and not reduced_motion:
		origin += Vector2(sin(pulse * 47.0), cos(pulse * 41.0)) * bump_flash * 3.8
	return {"cell": cell, "origin": origin}

func _cell_center(p: Vector2i) -> Vector2:
	return _grid_center(Vector2(p))

func _grid_center(p: Vector2) -> Vector2:
	var g := _geometry()
	return g.origin + Vector2((p.x + 0.5) * g.cell, (p.y + 0.5) * g.cell)

func _visual_center() -> Vector2:
	return _grid_center(visual_player_pos)

func _draw() -> void:
	if maze.is_empty():
		return
	var g := _geometry()
	var cell: float = g.cell
	var origin: Vector2 = g.origin
	var w: int = int(maze.width)
	var h: int = int(maze.height)
	draw_style_box(_panel_style(palette.bg), Rect2(origin - Vector2(9,9), Vector2(cell*w+18, cell*h+18)))
	_draw_board_ambient(origin, cell, w, h)

	for y in h:
		for x in w:
			var pos := Vector2i(x, y)
			if not _visible_cell(pos):
				continue
			var c: Color = palette.floor
			if (x + y) % 2 == 0:
				c = c.lightened(0.045)
			if maze.get("ice_cells", []).has(pos):
				c = c.lightened(0.11)
			draw_rect(Rect2(origin + Vector2(x*cell,y*cell), Vector2(cell+0.5,cell+0.5)), c)

	_draw_player_light(cell)
	_draw_specials(cell)
	_draw_trail(cell)
	_draw_walls(origin, cell, w, h)
	_draw_fog_memory(origin, cell)
	_draw_ghost(cell)
	_draw_aura(cell)
	_draw_player(cell)
	_draw_minimap()
	_draw_bump_feedback(cell)
	_draw_particles()

func _draw_board_ambient(origin: Vector2, cell: float, w: int, h: int) -> void:
	var world := clampi(int((level - 1) / 10), 0, 9)
	var rect := Rect2(origin, Vector2(cell * w, cell * h))
	match world:
		2:
			for i in range(0, w, 2):
				var x := origin.x + (float(i) + 0.5) * cell
				draw_line(Vector2(x, rect.position.y), Vector2(x, rect.end.y), Color(palette.wall, 0.022), 1.0)
		4:
			for i in 10:
				var fx := origin.x + fmod(float(i * 71) + pulse * 9.0, rect.size.x)
				var fy := rect.end.y - fmod(float(i * 43) + pulse * 15.0, rect.size.y)
				draw_circle(Vector2(fx, fy), maxf(1.0, cell * 0.035), Color(palette.accent, 0.075))
		5:
			for i in 12:
				var sx := origin.x + fmod(float(i * 53) + pulse * 2.0, rect.size.x)
				var sy := origin.y + fmod(float(i * 83) + pulse * 8.0, rect.size.y)
				draw_line(Vector2(sx - 3.0, sy), Vector2(sx + 3.0, sy), Color(palette.wall, 0.08), 1.0)
		8:
			for i in 9:
				var bx := origin.x + fmod(float(i * 79) + 12.0 * sin(pulse * 0.3 + float(i)), rect.size.x)
				var by := rect.end.y - fmod(float(i * 59) + pulse * 7.0, rect.size.y)
				draw_arc(Vector2(bx, by), maxf(2.0, cell * 0.09), 0.0, TAU, 12, Color(palette.wall, 0.055), 1.0)
		9:
			for y in range(0, h, 2):
				var yy := origin.y + float(y) * cell
				draw_line(Vector2(origin.x, yy), Vector2(rect.end.x, yy), Color(palette.accent, 0.028), 1.0)
		_:
			pass

func _draw_player_light(cell: float) -> void:
	var center := _visual_center()
	draw_circle(center, cell * 2.25, Color(palette.accent, 0.020))
	draw_circle(center, cell * 1.45, Color(palette.accent, 0.034))
	draw_circle(center, cell * 0.78, Color(palette.accent, 0.050))

func _draw_fog_memory(origin: Vector2, cell: float) -> void:
	if not bool(maze.get("fog", false)):
		return
	for pos in seen_cells:
		var distance: int = absi(pos.x - player.x) + absi(pos.y - player.y)
		if distance <= 2:
			continue
		var darkness: float = clampf(0.10 + float(distance - 2) * 0.025, 0.10, 0.34)
		draw_rect(Rect2(origin + Vector2(pos.x * cell, pos.y * cell), Vector2(cell + 0.6, cell + 0.6)), Color(palette.bg, darkness))

func _draw_aura(cell: float) -> void:
	var aura := str(cosmetics.get("aura", "default"))
	if aura == "default":
		return
	var center := _visual_center()
	var base_r := cell * 0.34
	match aura:
		"aura_lightning":
			for i in 3:
				var start := pulse * (2.2 + float(i) * 0.3) + float(i)
				draw_arc(center, base_r + float(i) * cell * 0.07, start, start + PI * 0.78, 16, Color("ffe66d", 0.70 - float(i) * 0.13), maxf(1.0, cell * 0.035), true)
		"aura_quantum":
			draw_arc(center, base_r * 1.10, pulse * 1.8, pulse * 1.8 + PI * 1.5, 28, Color("6de7ff", 0.62), maxf(1.0, cell * 0.032), true)
			draw_arc(center, base_r * 1.35, -pulse * 2.0, -pulse * 2.0 + PI * 1.35, 28, Color("a78bfa", 0.52), maxf(1.0, cell * 0.030), true)
		"aura_sats":
			draw_arc(center, base_r * 1.38, 0.0, TAU, 32, Color("ffbd2e", 0.28), maxf(1.0, cell * 0.026), true)
			for i in 4:
				var a := pulse * 1.25 + float(i) * TAU / 4.0
				var sat := center + Vector2.from_angle(a) * base_r * 1.38
				draw_circle(sat, maxf(2.2, cell * 0.055), Color("ffbd2e", 0.85))
		"aura_prism":
			for i in 3:
				var colors: Array[Color] = [Color("58e7ff"), Color("ff5fce"), Color("a78bfa")]
				var prism_color: Color = colors[i]
				draw_arc(center, base_r * (1.0 + float(i) * 0.18), pulse * (1.1 + float(i) * 0.22) + float(i), pulse * (1.1 + float(i) * 0.22) + float(i) + PI * 1.22, 26, Color(prism_color, 0.54), maxf(1.0, cell * 0.026), true)
		"aura_master":
			draw_arc(center, base_r * 1.25, 0.0, TAU, 32, Color("ffd166", 0.42), maxf(1.0, cell * 0.032), true)
			var crown_y := center.y - base_r * 1.35
			var crown := PackedVector2Array([
				Vector2(center.x - base_r * 0.52, crown_y + base_r * 0.34),
				Vector2(center.x - base_r * 0.36, crown_y),
				Vector2(center.x, crown_y + base_r * 0.22),
				Vector2(center.x + base_r * 0.36, crown_y),
				Vector2(center.x + base_r * 0.52, crown_y + base_r * 0.34),
			])
			draw_polyline(crown, Color("ffd166", 0.88), maxf(1.0, cell * 0.035), true)

func _draw_minimap() -> void:
	if not show_minimap:
		return
	var w := int(maze.get("width", 1))
	var h := int(maze.get("height", 1))
	if maxi(w, h) < 17:
		return
	var map_size := 92.0
	var margin := 13.0
	var origin := Vector2(size.x - map_size - margin, margin)
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color("040814", 0.78)
	panel.border_color = Color(palette.wall, 0.25)
	panel.border_width_left = 1
	panel.border_width_right = 1
	panel.border_width_top = 1
	panel.border_width_bottom = 1
	panel.corner_radius_top_left = 11
	panel.corner_radius_top_right = 11
	panel.corner_radius_bottom_left = 11
	panel.corner_radius_bottom_right = 11
	draw_style_box(panel, Rect2(origin, Vector2(map_size, map_size)))
	var usable := map_size - 14.0
	var px := usable / float(w)
	var py := usable / float(h)
	var start := origin + Vector2(7, 7)
	for y in h:
		for x in w:
			var pos := Vector2i(x, y)
			if bool(maze.get("fog", false)) and not seen_cells.has(pos):
				continue
			draw_rect(Rect2(start + Vector2(float(x) * px, float(y) * py), Vector2(maxf(1.0, px * 0.72), maxf(1.0, py * 0.72))), Color(palette.wall, 0.16))
	var player_dot := start + Vector2((float(player.x) + 0.5) * px, (float(player.y) + 0.5) * py)
	draw_circle(player_dot, maxf(2.0, minf(px, py) * 0.8), palette.accent)
	if not bool(maze.get("fog", false)) or seen_cells.has(maze.goal):
		var goal_dot := start + Vector2((float(maze.goal.x) + 0.5) * px, (float(maze.goal.y) + 0.5) * py)
		draw_circle(goal_dot, maxf(1.8, minf(px, py) * 0.7), palette.goal)

func _draw_bump_feedback(cell: float) -> void:
	if bump_flash <= 0.0:
		return
	var center := _visual_center()
	var radius := cell * (0.28 + (1.0 - bump_flash) * 0.75)
	draw_arc(center, radius, 0.0, TAU, 28, Color("ff718d", bump_flash * 0.62), maxf(1.0, cell * 0.035), true)

func _draw_specials(cell: float) -> void:
	for orb in maze.orbs:
		if collected.has(orb) or not _visible_cell(orb):
			continue
		var op := _cell_center(orb)
		var rr := cell * (0.12 + 0.025 * sin(pulse * 4.0 + orb.x))
		draw_circle(op, rr * 2.0, Color(palette.goal, 0.10))
		draw_circle(op, rr, palette.goal)
		draw_circle(op - Vector2(rr*0.25, rr*0.25), rr*0.30, Color.WHITE)

	if bool(maze.get("requires_key", false)) and not has_key:
		var key_pos: Vector2i = maze.get("key_pos", Vector2i(-1,-1))
		if key_pos.x >= 0 and _visible_cell(key_pos):
			var kp := _cell_center(key_pos)
			draw_circle(kp, cell * 0.16, Color("ffd166"))
			draw_line(kp, kp + Vector2(cell*0.18, 0), Color("ffd166"), maxf(2.0, cell*0.05), true)
			draw_circle(kp, cell * 0.06, palette.bg)

	if bool(maze.get("portals", false)):
		var portal_points: Array[Vector2i] = [maze.portal_a, maze.portal_b]
		for portal in portal_points:
			if _visible_cell(portal):
				var pp := _cell_center(portal)
				var rr := cell * (0.16 + 0.02 * sin(pulse * 5.0))
				draw_circle(pp, rr * 1.7, Color(palette.accent, 0.045 + portal_flash * 0.08))
				draw_arc(pp, rr, pulse * 1.8, pulse * 1.8 + PI * 1.55, 32, palette.wall, maxf(2.0, cell*0.05), true)
				draw_arc(pp, rr * 0.62, -pulse * 2.3, -pulse * 2.3 + PI * 1.45, 24, palette.accent, maxf(1.0, cell*0.035), true)

	var gp := _cell_center(maze.goal)
	if _visible_cell(maze.goal):
		var locked := bool(maze.get("requires_key", false)) and not has_key
		var goal_color: Color = Color("77839b") if locked else palette.goal
		var gr := cell * (0.22 + 0.025 * sin(pulse * 4.0))
		draw_circle(gp, gr * 1.9, Color(goal_color, 0.12))
		var pts := PackedVector2Array([gp+Vector2(0,-gr), gp+Vector2(gr,0), gp+Vector2(0,gr), gp+Vector2(-gr,0)])
		draw_colored_polygon(pts, goal_color)
		draw_circle(gp, gr * 0.28, Color.WHITE if not locked else Color("c0c5ce"))

func _draw_trail(cell: float) -> void:
	var trail_id := str(cosmetics.get("trail", "default"))
	if visual_trail.is_empty():
		return
	if trail_id == "trail_lightning" and visual_trail.size() > 1:
		for i in range(1, visual_trail.size()):
			var a: float = float(i) / float(visual_trail.size())
			draw_line(_cell_center(visual_trail[i - 1]), _cell_center(visual_trail[i]), Color(palette.accent, a * 0.45), maxf(1.0, cell * 0.05), true)
	elif trail_id == "trail_neon" and visual_trail.size() > 1:
		for i in range(1, visual_trail.size()):
			var alpha_neon: float = float(i) / float(visual_trail.size())
			draw_line(_cell_center(visual_trail[i - 1]), _cell_center(visual_trail[i]), Color(palette.accent, alpha_neon * 0.13), maxf(3.0, cell * 0.13), true)
			draw_line(_cell_center(visual_trail[i - 1]), _cell_center(visual_trail[i]), Color(palette.accent, alpha_neon * 0.60), maxf(1.0, cell * 0.035), true)
	elif trail_id == "trail_glitch":
		for i in visual_trail.size():
			var alpha_glitch: float = float(i + 1) / float(visual_trail.size())
			var center_glitch: Vector2 = _cell_center(visual_trail[i])
			var offset_glitch := Vector2(sin(float(i) * 3.1) * cell * 0.10, cos(float(i) * 2.7) * cell * 0.05)
			draw_rect(Rect2(center_glitch + offset_glitch - Vector2(cell * 0.08, cell * 0.025), Vector2(cell * 0.16, cell * 0.05)), Color(palette.accent, alpha_glitch * 0.42))
	else:
		for i in visual_trail.size():
			var alpha: float = float(i + 1) / float(visual_trail.size())
			var radius: float = cell * (0.055 + alpha * 0.055)
			if trail_id == "trail_comet": radius *= 1.35
			if trail_id == "trail_pixels": radius *= 0.75
			if trail_id == "trail_stars": radius *= 0.62 + 0.35 * sin(float(i) * 2.2)
			if trail_id == "trail_firefly": radius *= 0.55 + 0.50 * absf(sin(pulse * 5.0 + float(i)))
			var center: Vector2 = _cell_center(visual_trail[i])
			if trail_id == "trail_orbit":
				var orbit_angle: float = pulse * 3.0 + float(i) * 1.7
				var orbit_offset := Vector2.from_angle(orbit_angle) * cell * 0.10
				draw_circle(center + orbit_offset, radius * 0.62, Color(palette.accent, alpha * 0.44))
				draw_circle(center - orbit_offset, radius * 0.42, Color(palette.goal, alpha * 0.30))
			else:
				draw_circle(center, radius, Color(palette.accent, alpha * (0.40 if trail_id == "trail_firefly" else (0.34 if trail_id == "trail_stars" else 0.24))))

func _draw_walls(origin: Vector2, cell: float, w: int, h: int) -> void:
	for y in h:
		for x in w:
			var pos := Vector2i(x, y)
			if not _visible_cell(pos):
				continue
			var idx := y*w+x
			var mask: int = int(maze.walls[idx])
			var p := origin + Vector2(x*cell, y*cell)
			if mask & MazeGenerator.N: _wall(p, p+Vector2(cell,0))
			if mask & MazeGenerator.W: _wall(p, p+Vector2(0,cell))
			if y == h-1 and mask & MazeGenerator.S: _wall(p+Vector2(0,cell), p+Vector2(cell,cell))
			if x == w-1 and mask & MazeGenerator.E: _wall(p+Vector2(cell,0), p+Vector2(cell,cell))

func _draw_ghost(cell: float) -> void:
	if ghost_path.size() < 2 or ghost_total_time <= 0.0:
		return
	var progress := clampf(ghost_elapsed / ghost_total_time, 0.0, 1.0)
	var index := clampi(int(progress * float(ghost_path.size() - 1)), 0, ghost_path.size() - 1)
	var gp: Vector2i = ghost_path[index]
	if not _visible_cell(gp):
		return
	var center := _cell_center(gp)
	draw_circle(center, cell * 0.18, Color("ffffff", 0.08))
	draw_circle(center, cell * 0.105, Color("b9c8ff", 0.30))

func _draw_player(cell: float) -> void:
	var pp := _visual_center()
	var pr := cell * 0.22
	var skin := str(cosmetics.get("skin", "default"))
	var color: Color = palette.accent
	if skin == "skin_btc_gold": color = Color("ffbd2e")
	elif skin == "skin_nova": color = Color("84f7ff")
	elif skin == "skin_plasma": color = Color("ff5fce")
	elif skin == "skin_emerald": color = Color("4dff9d")
	elif skin == "skin_void": color = Color("8b5cf6")
	elif skin == "skin_ruby": color = Color("ff466f")
	elif skin == "skin_ice": color = Color("9ee7ff")
	elif skin == "skin_solar": color = Color("ffad33")
	elif skin == "skin_quantum": color = Color("6de7ff")
	draw_circle(pp, pr * 2.0, Color(color, 0.10))
	draw_circle(pp, pr * 1.35, Color(color, 0.22))
	if skin == "skin_nova":
		draw_circle(pp, pr, color)
		draw_arc(pp, pr * 1.18, pulse * 1.7, pulse * 1.7 + PI * 1.4, 20, Color.WHITE, maxf(1.5, pr * 0.12), true)
	elif skin == "skin_emerald":
		var emerald_points := PackedVector2Array([pp + Vector2(0, -pr), pp + Vector2(pr, 0), pp + Vector2(0, pr), pp + Vector2(-pr, 0)])
		draw_colored_polygon(emerald_points, color)
	elif skin == "skin_void":
		draw_circle(pp, pr, Color("090711"))
		draw_arc(pp, pr * 0.82, 0, TAU, 32, color, maxf(2.0, pr * 0.18), true)
	elif skin == "skin_ruby":
		var ruby_points := PackedVector2Array()
		for i in 6:
			ruby_points.append(pp + Vector2.from_angle(-PI * 0.5 + float(i) * TAU / 6.0) * pr)
		draw_colored_polygon(ruby_points, color)
		draw_circle(pp, pr * 0.28, Color.WHITE)
	elif skin == "skin_ice":
		var ice_points := PackedVector2Array([pp + Vector2(0, -pr * 1.08), pp + Vector2(pr * 0.72, 0), pp + Vector2(0, pr * 1.08), pp + Vector2(-pr * 0.72, 0)])
		draw_colored_polygon(ice_points, color)
		draw_line(pp + Vector2(-pr * 0.18, -pr * 0.45), pp + Vector2(pr * 0.18, pr * 0.45), Color.WHITE, maxf(1.2, pr * 0.10), true)
	elif skin == "skin_solar":
		draw_circle(pp, pr, color)
		for i in 8:
			var ray_angle: float = pulse * 0.7 + float(i) * TAU / 8.0
			var ray_from: Vector2 = pp + Vector2.from_angle(ray_angle) * pr * 1.08
			var ray_to: Vector2 = pp + Vector2.from_angle(ray_angle) * pr * 1.42
			draw_line(ray_from, ray_to, Color(color, 0.85), maxf(1.0, pr * 0.10), true)
	elif skin == "skin_quantum":
		draw_circle(pp, pr * 0.72, Color("081321"))
		draw_circle(pp, pr * 0.28, Color.WHITE)
		draw_arc(pp, pr * 1.05, pulse * 1.8, pulse * 1.8 + PI * 1.35, 24, color, maxf(1.2, pr * 0.10), true)
		draw_arc(pp, pr * 0.82, -pulse * 2.2, -pulse * 2.2 + PI * 1.55, 24, Color("a78bfa"), maxf(1.1, pr * 0.09), true)
	else:
		draw_circle(pp, pr, color)
		draw_circle(pp - Vector2(pr * 0.28, pr * 0.28), pr * 0.28, Color.WHITE)
	if skin == "skin_btc_gold":
		var f := ThemeDB.fallback_font
		draw_string(f, pp + Vector2(-pr * 0.44, pr * 0.40), "₿", HORIZONTAL_ALIGNMENT_LEFT, -1, int(maxf(10.0, pr * 1.35)), Color("3b2500"))

func _draw_particles() -> void:
	for p in particles:
		var a := clampf(float(p.life) / float(p.max_life), 0.0, 1.0)
		var particle_color: Color = p.get("color", palette.accent)
		draw_circle(p.pos, float(p.radius), Color(particle_color, a))

func _visible_cell(pos: Vector2i) -> bool:
	if not bool(maze.get("fog", false)):
		return true
	return seen_cells.has(pos)

func _resolve_palette() -> Dictionary:
	var theme_id := str(cosmetics.get("theme", "auto"))
	if SPECIAL_THEMES.has(theme_id):
		return SPECIAL_THEMES[theme_id]
	return BASE_PALETTES[int((level - 1) / 10) % BASE_PALETTES.size()]

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

func _spawn_sparks(count: int, spark_color: Color = Color.TRANSPARENT) -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var center := _cell_center(player)
	var resolved_color: Color = palette.accent if spark_color == Color.TRANSPARENT else spark_color
	for _i in count:
		var angle := rng.randf_range(0.0, TAU)
		var speed := rng.randf_range(25.0, 95.0)
		var life := rng.randf_range(0.25, 0.65)
		particles.append({"pos": center, "vel": Vector2.from_angle(angle) * speed, "life": life, "max_life": life, "radius": rng.randf_range(1.2, 3.0), "color": resolved_color})

func _spawn_victory_effect(base_count: int) -> void:
	var victory_id := str(cosmetics.get("victory_fx", "default"))
	match victory_id:
		"victory_fx_supernova": _spawn_sparks(base_count + 42, Color("ffd166"))
		"victory_fx_thunder": _spawn_sparks(base_count + 34, Color("ffe66d"))
		"victory_fx_portal": _spawn_sparks(base_count + 48, Color("a78bfa"))
		"victory_fx_sats": _spawn_sparks(base_count + 56, Color("ffbd2e"))
		_: _spawn_sparks(base_count)

func _spawn_bump() -> void:
	bump_flash = 1.0
	_spawn_sparks(7, Color("ff718d"))

func get_run_path() -> Array:
	return run_path.duplicate()
