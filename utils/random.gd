extends RandomNumberGenerator
class_name Random

func _init(_seed = null) -> void:
	if _seed:
		self.seed = _seed
# seed
func reseed(new_seed) -> void:
	match typeof(new_seed):
		TYPE_INT:
			self.seed = new_seed
		TYPE_STRING:
			self.seed = hash(new_seed)
func reseed_auto() -> void:
	var roll = self.randi() % 350000
	self.seed = hash(roll)

# AABB
func rand_aabb_position(bounds, ignore_y: bool = true):
	return Vector3(randi_range(bounds.position.x, bounds.end.x), 0, randi_range(bounds.position.z, bounds.end.z))
func rand_aabb_positions(bounds: AABB, count: int, ignore_y: bool = true):
	var arr = []
	for c in count:
		arr.append(rand_aabb_position(bounds))
	return arr
	
# Rect2
func rand_rect_position(bounds: Rect2) -> Vector2:
	return Vector2(randi_range(bounds.position.x, bounds.end.x), randi_range(bounds.position.y, bounds.end.y))
func rand_rect_positions(bounds: Rect2, count: int) -> Array:
	var arr = []
	for c in count:
		arr.append(rand_rect_position(bounds))
	return arr

# Vector
func randi_range_vec3(min_size: Vector3, max_size: Vector3, rng) -> Vector3:
	var vec = Vector3()
	vec.x = randi_range(min_size.x, max_size.x)
	vec.y = randi_range(min_size.y, max_size.y)
	vec.z = randi_range(min_size.z, max_size.z)
	return vec
func randf_range_vec3(min_size: Vector3, max_size: Vector3, rng) -> Vector3:
	var vec = Vector3()
	vec.x = randf_range(min_size.x, max_size.x)
	vec.y = randf_range(min_size.y, max_size.y)
	vec.z = randf_range(min_size.z, max_size.z)
	return vec
func randi_range_vec2(min_size: Vector2, max_size: Vector2, rng) -> Vector2:
	var vec = Vector3()
	vec.x = randi_range(min_size.x, max_size.x)
	vec.y = randi_range(min_size.y, max_size.y)
	return vec
func randf_range_vec2(min_size: Vector2, max_size: Vector2, rng) -> Vector2:
	var vec = Vector3()
	vec.x = randf_range(min_size.x, max_size.x)
	vec.y = randf_range(min_size.y, max_size.y)
	return vec

# Array
func rand_list_item(list: Array):
	return list[self.randi()% list.size()]
func rand_list_items(list: Array, amt: int):
	var arr = []
	for i in amt:
		arr.append(list[self.randi()%list.size()])
	return arr
