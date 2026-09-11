extends RefCounted
class_name MazeGenerator

const N := 1
const E := 2
const S := 4
const W := 8
const ALL := N | E | S | W

static func generate(level: int) -> Dictionary:
	var size_step := int((level - 1) / 8)
	var width := clampi(7 + size_step * 2, 7, 25)
	var height := width
	var rng := RandomNumberGenerator.new()
	rng.seed = 0x51A705E + level * 104729

	var walls: Array[int] = []
	walls.resize(width * height)
	for i in walls.size():
		walls[i] = ALL

	var visited: Array[bool] = []
	visited.resize(width * height)
	visited.fill(false)

	var stack: Array[Vector2i] = [Vector2i(0, 0)]
	visited[0] = true
	while not stack.is_empty():
		var current: Vector2i = stack.back()
		var options: Array[Vector2i] = []
		var dirs: Array[Vector2i] = [
			Vector2i(0, -1),
			Vector2i(1, 0),
			Vector2i(0, 1),
			Vector2i(-1, 0),
		]
		for d in dirs:
			var candidate: Vector2i = current + d
			if candidate.x >= 0 and candidate.y >= 0 and candidate.x < width and candidate.y < height:
				if not visited[candidate.y * width + candidate.x]:
					options.append(candidate)
		if options.is_empty():
			stack.pop_back()
			continue
		var chosen: Vector2i = options[rng.randi_range(0, options.size() - 1)]
		_carve(walls, width, current, chosen)
		visited[chosen.y * width + chosen.x] = true
		stack.append(chosen)

	# Añade unos pocos bucles en niveles altos para evitar que todos los laberintos
	# se sientan como un árbol perfecto, sin volverlos triviales.
	var extra_loops := int(level / 12)
	for _i in extra_loops:
		var c := Vector2i(rng.randi_range(1, width - 2), rng.randi_range(1, height - 2))
		var candidates: Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 1)]
		var d: Vector2i = candidates[rng.randi_range(0, candidates.size() - 1)]
		_carve(walls, width, c, c + d)

	var start := Vector2i(0, 0)
	var goal := Vector2i(width - 1, height - 1)
	var shortest := _shortest_path_length(walls, width, height, start, goal)

	var orbs: Array[Vector2i] = []
	var attempts := 0
	while orbs.size() < 3 and attempts < 200:
		attempts += 1
		var p := Vector2i(rng.randi_range(1, width - 2), rng.randi_range(1, height - 2))
		if p != start and p != goal and not orbs.has(p):
			orbs.append(p)

	return {
		"width": width,
		"height": height,
		"walls": walls,
		"start": start,
		"goal": goal,
		"orbs": orbs,
		"shortest": shortest,
		"seed": rng.seed,
	}

static func can_move(data: Dictionary, pos: Vector2i, dir: Vector2i) -> bool:
	var width: int = data.width
	var height: int = data.height
	var next: Vector2i = pos + dir
	if next.x < 0 or next.y < 0 or next.x >= width or next.y >= height:
		return false
	var mask := _dir_mask(dir)
	return (int(data.walls[pos.y * width + pos.x]) & mask) == 0

static func _carve(walls: Array[int], width: int, a: Vector2i, b: Vector2i) -> void:
	var d := b - a
	var ma := _dir_mask(d)
	var mb := _dir_mask(-d)
	if ma == 0 or mb == 0:
		return
	var ia := a.y * width + a.x
	var ib := b.y * width + b.x
	walls[ia] = walls[ia] & ~ma
	walls[ib] = walls[ib] & ~mb

static func _dir_mask(dir: Vector2i) -> int:
	if dir == Vector2i(0, -1): return N
	if dir == Vector2i(1, 0): return E
	if dir == Vector2i(0, 1): return S
	if dir == Vector2i(-1, 0): return W
	return 0

static func _shortest_path_length(walls: Array[int], width: int, height: int, start: Vector2i, goal: Vector2i) -> int:
	var queue: Array[Vector2i] = [start]
	var distance: Dictionary = {start: 0}
	var directions: Array[Vector2i] = [
		Vector2i(0, -1),
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(-1, 0),
	]
	var head := 0
	while head < queue.size():
		var p: Vector2i = queue[head]
		head += 1
		if p == goal:
			return int(distance[p])
		for d in directions:
			var n: Vector2i = p + d
			if n.x < 0 or n.y < 0 or n.x >= width or n.y >= height:
				continue
			if (walls[p.y * width + p.x] & _dir_mask(d)) != 0:
				continue
			if not distance.has(n):
				distance[n] = int(distance[p]) + 1
				queue.append(n)
	return width * height
