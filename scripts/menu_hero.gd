extends Control
class_name MenuHero

var t := 0.0
var reduced_motion := false
var cosmetics: Dictionary = {}

const PATH := [
	Vector2(0.10, 0.72), Vector2(0.22, 0.72), Vector2(0.22, 0.48),
	Vector2(0.39, 0.48), Vector2(0.39, 0.30), Vector2(0.57, 0.30),
	Vector2(0.57, 0.60), Vector2(0.74, 0.60), Vector2(0.74, 0.36),
	Vector2(0.89, 0.36),
]

func setup(new_cosmetics: Dictionary, reduce_motion: bool) -> void:
	cosmetics = new_cosmetics.duplicate(true)
	reduced_motion = reduce_motion
	queue_redraw()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(true)

func _process(delta: float) -> void:
	if reduced_motion:
		return
	t += delta
	queue_redraw()

func _draw() -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		return
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color("071020", 0.92)
	panel.border_color = Color("58e7ff", 0.24)
	panel.border_width_left = 2
	panel.border_width_right = 2
	panel.border_width_top = 2
	panel.border_width_bottom = 2
	panel.corner_radius_top_left = 24
	panel.corner_radius_top_right = 24
	panel.corner_radius_bottom_left = 24
	panel.corner_radius_bottom_right = 24
	draw_style_box(panel, Rect2(Vector2.ZERO, size))

	# layered horizon / floor
	for i in 6:
		var y := size.y * (0.58 + float(i) * 0.07)
		draw_line(Vector2(size.x * 0.04, y), Vector2(size.x * 0.96, y), Color("58e7ff", 0.035), 1.0)
	for i in 9:
		var x := size.x * (0.08 + float(i) * 0.105)
		draw_line(Vector2(size.x * 0.5, size.y * 0.55), Vector2(x, size.y * 0.98), Color("58e7ff", 0.03), 1.0)

	var points := PackedVector2Array()
	for p in PATH:
		points.append(Vector2(p.x * size.x, p.y * size.y))
	for i in range(1, points.size()):
		draw_line(points[i - 1], points[i], Color("58e7ff", 0.10), 14.0, true)
		draw_line(points[i - 1], points[i], Color("58e7ff", 0.92), 2.4, true)

	# collectible sats
	for idx in [2, 5, 7]:
		var cp := points[idx]
		draw_circle(cp, 13.0, Color("ffd166", 0.10))
		draw_circle(cp, 7.5, Color("ffbd2e"))
		draw_string(ThemeDB.fallback_font, cp + Vector2(-4.8, 5.0), "₿", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("4a2a00"))

	# destination diamond
	var goal := points[points.size() - 1]
	var gr := 11.0 + 1.8 * sin(t * 3.0)
	var diamond := PackedVector2Array([goal + Vector2(0, -gr), goal + Vector2(gr, 0), goal + Vector2(0, gr), goal + Vector2(-gr, 0)])
	draw_circle(goal, gr * 2.1, Color("ffd166", 0.08))
	draw_colored_polygon(diamond, Color("ffd166"))

	var progress := 0.36 if reduced_motion else fmod(t * 0.115, 1.0)
	var scaled := progress * float(points.size() - 1)
	var index := mini(int(floor(scaled)), points.size() - 2)
	var frac := scaled - float(index)
	var orb := points[index].lerp(points[index + 1], frac)
	var color := _skin_color()
	draw_circle(orb, 23.0, Color(color, 0.06))
	draw_circle(orb, 14.0, Color(color, 0.18))
	draw_circle(orb, 8.5, color)
	draw_circle(orb - Vector2(2.5, 2.5), 2.7, Color.WHITE)

	# small premium identity strip
	draw_string(ThemeDB.fallback_font, Vector2(24, 31), "LIVE MAZE", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("91a8c7"))
	draw_string(ThemeDB.fallback_font, Vector2(size.x - 112, 31), "THINK · MOVE · WIN", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("ffd166", 0.92))

func _skin_color() -> Color:
	match str(cosmetics.get("skin", "default")):
		"skin_btc_gold": return Color("ffbd2e")
		"skin_plasma": return Color("ff5fce")
		"skin_emerald": return Color("4dff9d")
		"skin_void": return Color("a78bfa")
		"skin_ruby": return Color("ff466f")
		"skin_ice": return Color("9ee7ff")
		"skin_solar": return Color("ffad33")
		"skin_quantum": return Color("6de7ff")
		"skin_nova": return Color("84f7ff")
		_: return Color("58e7ff")
