extends Resource
class_name BinarySpacePartitioning2D

### makes binary space partitioning on an initial AABB ###
var rng: RandomNumberGenerator #= RandomNumberGenerator.new()
export var parameters: Dictionary = {
	"space": Rect2(),
	"min_room_size": Vector2(),
	"hor_vert_chance": 0.5,
}

func _init(_rng = RandomNumberGenerator.new()):	
	rng = _rng
	
func pre_check():
	if (parameters.space.size > Vector2.ZERO and
		parameters.min_room_size > Vector2.ZERO
		):
			return true
	
	return false

### returns an array with AABB's splitted according to inp params
func partition() -> Array:
	if not pre_check(): return []
	var queue = Array()
	queue.push_back(parameters.space)
	var list = Array()

	while queue.size() > 0:
		var room = queue.pop_front()
		var vert_allowed: bool = false
		var hor_allowed: bool = false

		if room.size.x >= parameters.min_room_size.x * 2:
			vert_allowed = true
		if room.size.y >= parameters.min_room_size.y * 2:
			hor_allowed = true

		var roll = rng.randf()

		if room.size.x >= parameters.min_room_size.x && room.size.y >= parameters.min_room_size.y:
			if rng.randf() < 0.3:
				list.append(room)
				continue
			if roll < parameters.hor_vert_chance:
				if hor_allowed:
					split_horizontally(parameters.min_room_size, room, queue)
				elif vert_allowed:
					split_vertically(parameters.min_room_size, room, queue)		
				else:
					list.append(room)

			elif roll > parameters.hor_vert_chance:
				if rng.randf() < 0.3:
					list.append(room)
					continue
				if vert_allowed:
					split_vertically(parameters.min_room_size, room, queue)
				elif hor_allowed:
					split_horizontally(parameters.min_room_size, room, queue)
				else:
					list.append(room)

	return list

### splits AABB on the z axis, appends borth splitted AABB's to queue
func split_vertically(min_room_size: Vector2, room: Rect2, queue: Array) -> void:
	var xsplit = rng.randi_range(int(min_room_size.x), int(room.size.x - min_room_size.x))
	var r1 = Rect2(Vector2(room.position.x, room.position.y), Vector2(xsplit, room.size.y))
	var r2 = Rect2(Vector2(room.position.x + xsplit, r1.position.y), Vector2(room.size.x - xsplit, room.size.y))
	queue.push_back(r1)
	queue.push_back(r2)

### splits AABB on the x axis, appends borth splitted AABB's to queue
func split_horizontally(min_room_size, room: Rect2, queue: Array) -> void:
	#var max_split = room.size.y - min_room_size.y
	var ysplit = rng.randi_range(int(min_room_size.y), int(room.size.y - min_room_size.y))
	var r1 = Rect2(Vector2(room.position.x, room.position.y), Vector2(room.size.x, ysplit))
	var r2 = Rect2(Vector2(room.position.x, room.position.y + ysplit), Vector2(room.size.x, room.size.y - ysplit))

	queue.push_back(r1)
	queue.push_back(r2)
