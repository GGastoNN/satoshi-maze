extends Control
class_name CosmeticPreview

var product: Dictionary = {}
var t := 0.0
var dimmed := false
var redraw_accumulator := 0.0

func setup(new_product: Dictionary, new_dimmed: bool = false) -> void:
	product = new_product.duplicate(true)
	dimmed = new_dimmed
	custom_minimum_size = Vector2(96, 86)
	queue_redraw()

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(true)

func _process(delta: float) -> void:
	t += delta
	redraw_accumulator += delta
	if redraw_accumulator < (1.0 / 24.0):
		return
	redraw_accumulator = 0.0
	if get_global_rect().intersects(get_viewport_rect()):
		queue_redraw()

func _draw() -> void:
	if product.is_empty():
		return
	var accent := Color(str(product.get("accent", "58e7ff")))
	var alpha := 0.34 if dimmed else 1.0
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color("060d1d", 0.72)
	panel.border_color = Color(accent, 0.22 * alpha)
	panel.border_width_left = 1
	panel.border_width_right = 1
	panel.border_width_top = 1
	panel.border_width_bottom = 1
	panel.corner_radius_top_left = 15
	panel.corner_radius_top_right = 15
	panel.corner_radius_bottom_left = 15
	panel.corner_radius_bottom_right = 15
	draw_style_box(panel, Rect2(Vector2.ZERO, size))
	var center := size * 0.5
	var kind := str(product.get("kind", ""))
	match kind:
		"skin": _draw_skin(center, accent, alpha)
		"trail": _draw_trail(center, accent, alpha)
		"theme": _draw_theme(center, accent, alpha)
		"victory_fx": _draw_finish(center, accent, alpha)
		"aura": _draw_aura(center, accent, alpha)
		"bundle": _draw_bundle(center, accent, alpha)
		"pass": _draw_pass(center, accent, alpha)
		"feature": _draw_feature(center, accent, alpha)
		_: _draw_skin(center, accent, alpha)

func _draw_skin(center: Vector2, accent: Color, alpha: float) -> void:
	var radius := 17.0 + 1.4 * sin(t * 3.2)
	draw_circle(center, radius * 1.75, Color(accent, 0.055 * alpha))
	draw_circle(center, radius * 1.20, Color(accent, 0.16 * alpha))
	draw_circle(center, radius, Color(accent, alpha))
	draw_circle(center - Vector2(5, 5), 5.0, Color(1, 1, 1, 0.82 * alpha))

func _draw_trail(center: Vector2, accent: Color, alpha: float) -> void:
	var points := PackedVector2Array()
	for i in 6:
		var x := center.x - 31.0 + float(i) * 12.5
		var y := center.y + sin(t * 2.8 + float(i) * 0.72) * 10.0
		points.append(Vector2(x, y))
	for i in range(1, points.size()):
		draw_line(points[i - 1], points[i], Color(accent, 0.16 * alpha), 8.0, true)
		draw_line(points[i - 1], points[i], Color(accent, 0.78 * alpha), 2.0, true)
	draw_circle(points[points.size() - 1], 7.0, Color(accent, alpha))

func _draw_theme(center: Vector2, accent: Color, alpha: float) -> void:
	for i in range(-2, 3):
		var y := center.y + float(i) * 10.0
		draw_line(Vector2(center.x - 32, y), Vector2(center.x + 32, y), Color(accent, 0.26 * alpha), 1.4)
	for i in range(-3, 4):
		var x := center.x + float(i) * 10.0
		draw_line(Vector2(x, center.y - 25), Vector2(x, center.y + 25), Color(accent, 0.18 * alpha), 1.0)
	var sun := center + Vector2(18, -12)
	draw_circle(sun, 10.0, Color(accent, 0.42 * alpha))

func _draw_finish(center: Vector2, accent: Color, alpha: float) -> void:
	for i in 10:
		var a := t * 0.7 + float(i) * TAU / 10.0
		var inner := center + Vector2.from_angle(a) * 10.0
		var outer := center + Vector2.from_angle(a) * (29.0 + 3.0 * sin(t * 4.0 + float(i)))
		draw_line(inner, outer, Color(accent, 0.68 * alpha), 2.2, true)
	draw_circle(center, 9.0, Color(accent, alpha))

func _draw_aura(center: Vector2, accent: Color, alpha: float) -> void:
	draw_circle(center, 9.0, Color("eaf5ff", 0.82 * alpha))
	for i in 3:
		var radius := 17.0 + float(i) * 7.0
		var start := t * (1.0 + float(i) * 0.28)
		draw_arc(center, radius, start, start + PI * 1.25, 28, Color(accent, (0.72 - float(i) * 0.17) * alpha), 2.0, true)

func _draw_bundle(center: Vector2, accent: Color, alpha: float) -> void:
	for i in 3:
		var a := -PI * 0.55 + float(i) * PI * 0.55
		var p := center + Vector2.from_angle(a) * 19.0
		draw_circle(p, 10.0, Color(accent.lightened(float(i) * 0.10), 0.84 * alpha))
	draw_arc(center, 30.0, 0.0, TAU, 36, Color(accent, 0.30 * alpha), 2.0)

func _draw_pass(center: Vector2, accent: Color, alpha: float) -> void:
	draw_arc(center, 25.0, 0.0, TAU, 48, Color(accent, 0.78 * alpha), 3.0)
	draw_string(ThemeDB.fallback_font, center + Vector2(-14, 10), "∞", HORIZONTAL_ALIGNMENT_LEFT, -1, 31, Color(accent, alpha))

func _draw_feature(center: Vector2, accent: Color, alpha: float) -> void:
	for i in 4:
		var h := 12.0 + float(i) * 8.0
		var r := Rect2(center.x - 26.0 + float(i) * 14.0, center.y + 23.0 - h, 8.0, h)
		draw_rect(r, Color(accent, (0.45 + float(i) * 0.12) * alpha))
