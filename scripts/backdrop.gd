extends Control
class_name Backdrop

var t := 0.0
var stars: Array[Dictionary] = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(true)
	var rng := RandomNumberGenerator.new()
	rng.seed = 20260910
	for i in 70:
		stars.append({
			"x": rng.randf(),
			"y": rng.randf(),
			"r": rng.randf_range(0.8, 2.7),
			"p": rng.randf_range(0.0, TAU),
		})

func _process(delta: float) -> void:
	t += delta
	queue_redraw()

func _draw() -> void:
	var s := size
	# Fondo pseudo-gradiente en bandas suaves.
	var bands := 24
	for i in bands:
		var f := float(i) / float(bands - 1)
		var c := Color(0.025 + f * 0.025, 0.03 + f * 0.02, 0.09 + f * 0.08, 1.0)
		draw_rect(Rect2(0, f * s.y, s.x, s.y / bands + 2), c)

	# Nebulosas y destellos.
	draw_circle(Vector2(s.x * 0.16, s.y * 0.22), s.x * 0.34, Color(0.18, 0.04, 0.38, 0.14))
	draw_circle(Vector2(s.x * 0.86, s.y * 0.68), s.x * 0.42, Color(0.0, 0.35, 0.45, 0.10))
	for st in stars:
		var a := 0.25 + 0.55 * (0.5 + 0.5 * sin(t * 1.7 + float(st.p)))
		var pos := Vector2(float(st.x) * s.x, fmod(float(st.y) * s.y + t * (3.0 + float(st.r)), s.y))
		draw_circle(pos, float(st.r), Color(0.72, 0.92, 1.0, a))
