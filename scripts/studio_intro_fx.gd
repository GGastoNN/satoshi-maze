extends Control
class_name StudioIntroFX

var t: float = 0.0
var reveal: float = 0.0
var flash: float = 0.0
var exit_amount: float = 0.0
var particles: Array[Dictionary] = []

const CYAN := Color("58e7ff")
const PINK := Color("ff5fce")
const GOLD := Color("ffd166")
const TEXT := Color("eaf5ff")

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(true)
	var rng := RandomNumberGenerator.new()
	rng.seed = 20260913
	for i in 52:
		particles.append({
			"x": rng.randf(),
			"y": rng.randf(),
			"speed": rng.randf_range(7.0, 26.0),
			"radius": rng.randf_range(0.8, 2.8),
			"phase": rng.randf_range(0.0, TAU),
			"tone": i % 3,
		})

func _process(delta: float) -> void:
	t += delta
	queue_redraw()

func _draw() -> void:
	var s: Vector2 = size
	if s.x <= 1.0 or s.y <= 1.0:
		return

	var fade: float = 1.0 - clampf(exit_amount, 0.0, 1.0)
	var center: Vector2 = Vector2(s.x * 0.5, s.y * 0.45)

	# Moving energy haze behind the brand.
	var breathe: float = 0.5 + 0.5 * sin(t * 1.35)
	draw_circle(Vector2(s.x * 0.18, s.y * 0.30), s.x * (0.28 + breathe * 0.025), Color(0.30, 0.04, 0.50, 0.11 * fade))
	draw_circle(Vector2(s.x * 0.82, s.y * 0.62), s.x * (0.34 + (1.0 - breathe) * 0.03), Color(0.00, 0.42, 0.52, 0.09 * fade))

	# Star particles with subtle vertical drift.
	for particle in particles:
		var px: float = float(particle.get("x", 0.0)) * s.x
		var py_base: float = float(particle.get("y", 0.0)) * s.y
		var speed: float = float(particle.get("speed", 10.0))
		var py: float = fmod(py_base - t * speed + s.y * 2.0, s.y)
		var phase: float = float(particle.get("phase", 0.0))
		var twinkle: float = 0.32 + 0.56 * (0.5 + 0.5 * sin(t * 2.2 + phase))
		var radius: float = float(particle.get("radius", 1.0))
		var tone: int = int(particle.get("tone", 0))
		var color: Color = CYAN if tone == 0 else (PINK if tone == 1 else TEXT)
		color.a = twinkle * 0.52 * fade
		draw_circle(Vector2(px, py), radius, color)

	# Expanding orbital rings around the studio mark.
	var orbit_alpha: float = clampf(reveal * 1.35, 0.0, 1.0) * fade
	for ring_index in 3:
		var ring_phase: float = t * (0.42 + float(ring_index) * 0.09) + float(ring_index) * 0.8
		var radius: float = 118.0 + float(ring_index) * 37.0 + sin(ring_phase) * 5.0
		var start_angle: float = ring_phase + float(ring_index) * 1.7
		var end_angle: float = start_angle + PI * (0.78 + float(ring_index) * 0.16)
		var ring_color: Color = CYAN if ring_index != 1 else PINK
		ring_color.a = (0.12 - float(ring_index) * 0.018) * orbit_alpha
		draw_arc(center, radius, start_angle, end_angle, 48, ring_color, 2.0, true)

	# Animated maze traces. Each line lights progressively and remains understated.
	var paths: Array[PackedVector2Array] = [
		PackedVector2Array([Vector2(0.06, 0.20), Vector2(0.19, 0.20), Vector2(0.19, 0.12), Vector2(0.36, 0.12), Vector2(0.36, 0.26), Vector2(0.47, 0.26)]),
		PackedVector2Array([Vector2(0.94, 0.24), Vector2(0.78, 0.24), Vector2(0.78, 0.15), Vector2(0.62, 0.15), Vector2(0.62, 0.31), Vector2(0.54, 0.31)]),
		PackedVector2Array([Vector2(0.04, 0.73), Vector2(0.17, 0.73), Vector2(0.17, 0.83), Vector2(0.34, 0.83), Vector2(0.34, 0.69), Vector2(0.45, 0.69)]),
		PackedVector2Array([Vector2(0.96, 0.76), Vector2(0.83, 0.76), Vector2(0.83, 0.87), Vector2(0.66, 0.87), Vector2(0.66, 0.71), Vector2(0.54, 0.71)]),
	]
	for path_index in paths.size():
		var path_reveal: float = clampf(reveal * 1.22 - float(path_index) * 0.08, 0.0, 1.0)
		_draw_revealed_path(paths[path_index], path_reveal, s, path_index, fade)

	# Central energy pulse and flash used at the studio -> game transition.
	var pulse_radius: float = 76.0 + sin(t * 3.0) * 7.0
	var pulse_color := Color(CYAN, (0.035 + 0.025 * breathe) * orbit_alpha)
	draw_circle(center, pulse_radius, pulse_color)
	if flash > 0.001:
		draw_rect(Rect2(Vector2.ZERO, s), Color(0.86, 0.98, 1.0, clampf(flash, 0.0, 1.0) * 0.62))

func _draw_revealed_path(path: PackedVector2Array, amount: float, canvas_size: Vector2, path_index: int, fade: float) -> void:
	if path.size() < 2 or amount <= 0.0:
		return
	var segment_count: int = path.size() - 1
	var scaled_progress: float = amount * float(segment_count)
	var base_color: Color = CYAN if path_index % 2 == 0 else PINK
	for segment_index in segment_count:
		var local_amount: float = clampf(scaled_progress - float(segment_index), 0.0, 1.0)
		if local_amount <= 0.0:
			continue
		var a: Vector2 = Vector2(path[segment_index].x * canvas_size.x, path[segment_index].y * canvas_size.y)
		var b_full: Vector2 = Vector2(path[segment_index + 1].x * canvas_size.x, path[segment_index + 1].y * canvas_size.y)
		var b: Vector2 = a.lerp(b_full, local_amount)
		var glow_color: Color = base_color
		glow_color.a = 0.09 * fade
		var line_color: Color = base_color
		line_color.a = 0.34 * fade
		draw_line(a, b, glow_color, 8.0, true)
		draw_line(a, b, line_color, 2.0, true)
