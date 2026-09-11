extends Control
class_name Backdrop

var t := 0.0
var stars: Array[Dictionary] = []
var context_level := 1
var context_theme := "auto"
var context_mode := "menu"
var reduced_motion := false

const WORLD_BACKGROUNDS := [
	{"top": Color("050b1d"), "bottom": Color("101a38"), "accent": Color("58e7ff"), "secondary": Color("ff5fce")},
	{"top": Color("12081f"), "bottom": Color("2a1138"), "accent": Color("ff70d9"), "secondary": Color("78ffd6")},
	{"top": Color("02100a"), "bottom": Color("08261a"), "accent": Color("52ff9a"), "secondary": Color("f7ff58")},
	{"top": Color("070b1b"), "bottom": Color("1a1535"), "accent": Color("a78bfa"), "secondary": Color("38bdf8")},
	{"top": Color("150605"), "bottom": Color("31120b"), "accent": Color("ff6b35"), "secondary": Color("ffd166")},
	{"top": Color("03101b"), "bottom": Color("0b2938"), "accent": Color("9ee7ff"), "secondary": Color("b8a7ff")},
	{"top": Color("170d03"), "bottom": Color("35200a"), "accent": Color("ffbd2e"), "secondary": Color("ff6b6b")},
	{"top": Color("050505"), "bottom": Color("16191f"), "accent": Color("f5f5f5"), "secondary": Color("00e5ff")},
	{"top": Color("01101a"), "bottom": Color("073044"), "accent": Color("4deeea"), "secondary": Color("48bfe3")},
	{"top": Color("10031b"), "bottom": Color("30083e"), "accent": Color("ff4fd8"), "secondary": Color("58e7ff")},
]

const THEME_WORLDS := {
	"theme_sunset": 1,
	"theme_mono": 7,
	"theme_matrix": 2,
	"theme_deep": 3,
	"theme_arctic": 5,
	"theme_lava": 4,
	"theme_ocean": 8,
	"theme_synthwave": 9,
}

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(true)
	var rng := RandomNumberGenerator.new()
	rng.seed = 20260911
	for _i in 92:
		stars.append({
			"x": rng.randf(),
			"y": rng.randf(),
			"r": rng.randf_range(0.65, 2.4),
			"p": rng.randf_range(0.0, TAU),
			"speed": rng.randf_range(1.5, 5.5),
		})

func set_context(new_level: int, new_theme: String = "auto", new_mode: String = "menu", reduce_motion: bool = false) -> void:
	context_level = maxi(new_level, 1)
	context_theme = new_theme
	context_mode = new_mode
	reduced_motion = reduce_motion
	queue_redraw()

func _process(delta: float) -> void:
	if reduced_motion:
		return
	t += delta
	queue_redraw()

func _world_index() -> int:
	if THEME_WORLDS.has(context_theme):
		return int(THEME_WORLDS[context_theme])
	return clampi(int((context_level - 1) / 10), 0, WORLD_BACKGROUNDS.size() - 1)

func _draw() -> void:
	var s := size
	if s.x <= 0.0 or s.y <= 0.0:
		return
	var world: Dictionary = WORLD_BACKGROUNDS[_world_index()]
	var top: Color = world.top
	var bottom: Color = world.bottom
	var accent: Color = world.accent
	var secondary: Color = world.secondary
	var bands := 32
	for i in bands:
		var f := float(i) / float(bands - 1)
		var c := top.lerp(bottom, f)
		draw_rect(Rect2(0.0, f * s.y, s.x, s.y / float(bands) + 2.0), c)

	# Nebula volumes kept subtle so UI remains legible.
	draw_circle(Vector2(s.x * 0.13, s.y * 0.18), s.x * 0.42, Color(accent, 0.055))
	draw_circle(Vector2(s.x * 0.88, s.y * 0.70), s.x * 0.48, Color(secondary, 0.045))
	_draw_world_fx(_world_index(), s, accent, secondary)

	for st in stars:
		var phase: float = float(st.p)
		var alpha := 0.22 + 0.48 * (0.5 + 0.5 * sin(t * 1.35 + phase))
		if reduced_motion:
			alpha = 0.40
		var drift := 0.0 if reduced_motion else t * float(st.speed)
		var pos := Vector2(float(st.x) * s.x, fmod(float(st.y) * s.y + drift, s.y))
		draw_circle(pos, float(st.r), Color(0.76, 0.92, 1.0, alpha))

	# Soft vignette strips for a more focused mobile composition.
	draw_rect(Rect2(0, 0, s.x, s.y * 0.09), Color(0, 0, 0, 0.12))
	draw_rect(Rect2(0, s.y * 0.91, s.x, s.y * 0.09), Color(0, 0, 0, 0.16))

func _draw_world_fx(index: int, s: Vector2, accent: Color, secondary: Color) -> void:
	match index:
		0:
			var horizon := s.y * 0.72
			for i in range(1, 8):
				var y := horizon + pow(float(i) / 8.0, 1.7) * s.y * 0.28
				draw_line(Vector2(0, y), Vector2(s.x, y), Color(accent, 0.055), 1.0)
			for i in range(-5, 6):
				var x_bottom := s.x * 0.5 + float(i) * s.x * 0.18
				draw_line(Vector2(s.x * 0.5, horizon), Vector2(x_bottom, s.y), Color(accent, 0.045), 1.0)
		1:
			for i in 4:
				var center := Vector2(s.x * (0.23 + float(i) * 0.21), s.y * (0.18 + 0.05 * sin(float(i))))
				draw_arc(center, 70.0 + float(i) * 18.0, 0.0, TAU, 48, Color(secondary, 0.055), 2.0)
		2:
			for i in 15:
				var x := (float(i) + 0.5) / 15.0 * s.x
				var y0 := fmod(float(i * 79) + t * 16.0, s.y)
				draw_line(Vector2(x, y0), Vector2(x, minf(y0 + 55.0, s.y)), Color(accent, 0.055), 1.0)
		3:
			var center := Vector2(s.x * 0.75, s.y * 0.25)
			for i in 3:
				var start := t * (0.18 + float(i) * 0.05)
				draw_arc(center, 90.0 + float(i) * 42.0, start, start + PI * 1.55, 64, Color(accent if i % 2 == 0 else secondary, 0.07), 2.0)
		4:
			for i in 18:
				var x := fmod(float(i * 97) + t * 11.0, s.x)
				var y := s.y - fmod(float(i * 131) + t * (18.0 + float(i % 5) * 4.0), s.y * 0.55)
				draw_circle(Vector2(x, y), 1.5 + float(i % 3), Color(accent, 0.10))
		5:
			for i in 3:
				var y := s.y * (0.15 + float(i) * 0.08) + sin(t * 0.35 + float(i)) * 16.0
				draw_arc(Vector2(s.x * 0.5, y), s.x * (0.42 + float(i) * 0.10), 0.08, PI - 0.08, 80, Color(accent if i != 1 else secondary, 0.055), 5.0)
		6:
			var sun := Vector2(s.x * 0.82, s.y * 0.18)
			draw_circle(sun, 74.0, Color(accent, 0.035))
			draw_circle(sun, 42.0, Color(accent, 0.055))
			for i in 8:
				var a := float(i) * TAU / 8.0 + t * 0.05
				draw_line(sun + Vector2.from_angle(a) * 86.0, sun + Vector2.from_angle(a) * 126.0, Color(accent, 0.045), 2.0)
		7:
			for y in range(0, int(s.y), 18):
				draw_line(Vector2(0, float(y)), Vector2(s.x, float(y)), Color(accent, 0.022), 1.0)
		8:
			for i in 14:
				var x := fmod(float(i * 83) + 30.0 * sin(t * 0.15 + float(i)), s.x)
				var y := s.y - fmod(float(i * 101) + t * 12.0, s.y)
				draw_arc(Vector2(x, y), 3.0 + float(i % 4) * 2.0, 0.0, TAU, 16, Color(accent, 0.075), 1.0)
		9:
			var sun := Vector2(s.x * 0.79, s.y * 0.24)
			draw_circle(sun, 62.0, Color(secondary, 0.055))
			for i in range(-4, 5):
				var yy := sun.y + float(i) * 12.0
				draw_line(Vector2(sun.x - 56.0, yy), Vector2(sun.x + 56.0, yy), Color(bottom_color_for_synth(), 0.11), 2.0)
			var horizon := s.y * 0.73
			for i in range(1, 7):
				var y := horizon + pow(float(i) / 7.0, 1.6) * s.y * 0.27
				draw_line(Vector2(0, y), Vector2(s.x, y), Color(accent, 0.05), 1.0)

func bottom_color_for_synth() -> Color:
	return Color("12031f")
