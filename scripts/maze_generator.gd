extends RefCounted
class_name MazeGenerator

const N := 1
const E := 2
const S := 4
const W := 8
const ALL := N | E | S | W
const DIRS: Array[Vector2i] = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]

static func generate(level: int) -> Dictionary:
	var seed := 0x51A705E + level * 104729
	return generate_custom(level, seed, _modifiers_for_level(level))

static func generate_custom(level: int, seed: int, modifiers: Dictionary) -> Dictionary:
	var size_step := int((level - 1) / 8)
	var width := clampi(7 + size_step * 2, 7, 25)
	var height := width
	var rng := RandomNumberGenerator.new()
	rng.seed = seed

	var walls: Array[int] = []
	walls.resize(width * height)
	for i in walls.size():
		walls[i] = ALL

	var visited: Array[bool] = []
	visited.resize(width * height)
	visited.fill(false)

	var stack: Array[Vector2i] = [Vector2i.ZERO]
	visited[0] = true
	while not stack.is_empty():
		var current: Vector2i = stack.back()
		var options: Array[Vector2i] = []
		for d in DIRS:
			var candidate: Vector2i = current + d
			if _inside(candidate, width, height) and not visited[candidate.y * width + candidate.x]:
				options.append(candidate)
		if options.is_empty():
			stack.pop_back()
			continue
		var next_cell: Vector2i = options[rng.randi_range(0, options.size() - 1)]
		_carve(walls, width, current, next_cell)
		visited[next_cell.y * width + next_cell.x] = true
		stack.append(next_cell)

	var extra_loops := int(level / 12)
	for _i in extra_loops:
		var c := Vector2i(rng.randi_range(1, width - 2), rng.randi_range(1, height - 2))
		var candidates: Array[Vector2i] = [Vector2i.RIGHT, Vector2i.DOWN]
		var d: Vector2i = candidates[rng.randi_range(0, candidates.size() - 1)]
		_carve(walls, width, c, c + d)

	var start := Vector2i.ZERO
	var goal := Vector2i(width - 1, height - 1)
	var shortest_path := _shortest_path(walls, width, height, start, goal)
	var shortest := maxi(shortest_path.size() - 1, 1)
	var occupied: Array[Vector2i] = [start, goal]

	var orbs := _pick_cells(rng, width, height, occupied, 3)
	occupied.append_array(orbs)

	var key_pos := Vector2i(-1, -1)
	if bool(modifiers.get("requires_key", false)):
		if shortest_path.size() > 4:
			var key_index := clampi(int(shortest_path.size() * 0.42), 2, shortest_path.size() - 2)
			key_pos = shortest_path[key_index]
		else:
			var key_cells := _pick_cells(rng, width, height, occupied, 1)
			if not key_cells.is_empty():
				key_pos = key_cells[0]
		occupied.append(key_pos)

	var portal_a := Vector2i(-1, -1)
	var portal_b := Vector2i(-1, -1)
	if bool(modifiers.get("portals", false)):
		var portal_cells := _pick_cells(rng, width, height, occupied, 2)
		if portal_cells.size() == 2:
			portal_a = portal_cells[0]
			portal_b = portal_cells[1]
			occupied.append_array(portal_cells)

	var ice_cells: Array[Vector2i] = []
	if bool(modifiers.get("ice", false)):
		var ice_count := clampi(int(width / 2), 3, 10)
		ice_cells = _pick_cells(rng, width, height, occupied, ice_count)

	var boss := bool(modifiers.get("boss", false))
	var target_time := float(shortest) * (0.58 if boss else 0.78) + 8.0

	return {
		"width": width,
		"height": height,
		"walls": walls,
		"start": start,
		"goal": goal,
		"orbs": orbs,
		"shortest": shortest,
		"seed": seed,
		"fog": bool(modifiers.get("fog", false)),
		"requires_key": bool(modifiers.get("requires_key", false)),
		"key_pos": key_pos,
		"portals": bool(modifiers.get("portals", false)) and portal_a.x >= 0,
		"portal_a": portal_a,
		"portal_b": portal_b,
		"ice": bool(modifiers.get("ice", false)),
		"ice_cells": ice_cells,
		"boss": boss,
		"challenge": str(modifiers.get("challenge", "campaign")),
		"target_time": target_time,
	}

static func _modifiers_for_level(level: int) -> Dictionary:
	var boss := level % 10 == 0
	return {
		"fog": level >= 6 and (level % 13 == 0 or boss),
		"requires_key": level >= 5 and (level % 7 == 0 or boss),
		"portals": level >= 8 and (level % 9 == 0 or boss),
		"ice": level >= 12 and (level % 11 == 0 or (boss and level >= 30)),
		"boss": boss,
		"challenge": "campaign",
	}

static func can_move(data: Dictionary, pos: Vector2i, dir: Vector2i) -> bool:
	var width: int = int(data.width)
	var height: int = int(data.height)
	var next_cell: Vector2i = pos + dir
	if not _inside(next_cell, width, height):
		return false
	var mask := _dir_mask(dir)
	return (int(data.walls[pos.y * width + pos.x]) & mask) == 0

static func _carve(walls: Array[int], width: int, a: Vector2i, b: Vector2i) -> void:
	var d: Vector2i = b - a
	var ma := _dir_mask(d)
	var mb := _dir_mask(-d)
	if ma == 0 or mb == 0:
		return
	var ia := a.y * width + a.x
	var ib := b.y * width + b.x
	walls[ia] = walls[ia] & ~ma
	walls[ib] = walls[ib] & ~mb

static func _dir_mask(dir: Vector2i) -> int:
	if dir == Vector2i.UP: return N
	if dir == Vector2i.RIGHT: return E
	if dir == Vector2i.DOWN: return S
	if dir == Vector2i.LEFT: return W
	return 0

static func _inside(p: Vector2i, width: int, height: int) -> bool:
	return p.x >= 0 and p.y >= 0 and p.x < width and p.y < height

static func _shortest_path(walls: Array[int], width: int, height: int, start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	var queue: Array[Vector2i] = [start]
	var previous: Dictionary = {start: Vector2i(-1, -1)}
	var head := 0
	while head < queue.size():
		var p: Vector2i = queue[head]
		head += 1
		if p == goal:
			break
		for d in DIRS:
			var n: Vector2i = p + d
			if not _inside(n, width, height):
				continue
			if (walls[p.y * width + p.x] & _dir_mask(d)) != 0:
				continue
			if not previous.has(n):
				previous[n] = p
				queue.append(n)
	if not previous.has(goal):
		return [start, goal]
	var path: Array[Vector2i] = []
	var cursor := goal
	while cursor != Vector2i(-1, -1):
		path.push_front(cursor)
		cursor = previous.get(cursor, Vector2i(-1, -1))
	return path

static func _pick_cells(rng: RandomNumberGenerator, width: int, height: int, blocked: Array[Vector2i], count: int) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	var attempts := 0
	while out.size() < count and attempts < 1000:
		attempts += 1
		var p := Vector2i(rng.randi_range(1, width - 2), rng.randi_range(1, height - 2))
		if not blocked.has(p) and not out.has(p):
			out.append(p)
	return out
