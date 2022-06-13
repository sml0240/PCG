extends Node
class_name GenUtils

enum Edge {
	NORTH,
	SOUTH,
	WEST,
	EAST
}
enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST
}
enum Corner {
	SOUTHEAST,
	NORTHEAST,
	SOUTHWEST,
	NORTHWEST
}
# not in use
var corner_neighbours = [
	Vector3(1, 0, 1),
	Vector3(1, 0, -1),
	Vector3(-1, 0, 1),
	Vector3(-1, 0, -1),
]
# not in use
var horizontal_neighbours = [
	Vector3(1, 0, 0),
	Vector3(-1, 0, 0),
	Vector3(0, 0, 1),
	Vector3(0, 0, -1),
]
var valid_edges := {
	Vector3(1, 0, 0): Edge.WEST,
	Vector3(-1, 0, 0): Edge.EAST,
	Vector3(0, 0, 1): Edge.NORTH,
	Vector3(0, 0, -1): Edge.SOUTH,
}

################################ CORNERS #######################################
################################################################################

func get_corner_dict(bounds: AABB) -> Dictionary:
	var y = 0
	var new_corners = {
		Corner.SOUTHEAST: Vector3(bounds.position.x, y, bounds.position.z),
		Corner.SOUTHWEST: Vector3(bounds.end.x, y, bounds.position.z),
		Corner.NORTHEAST: Vector3(bounds.position.x, y, bounds.end.z),
		Corner.NORTHWEST: Vector3(bounds.end.x, y, bounds.end.z)
		}
	return new_corners

func get_rand_corner(rng: RandomNumberGenerator):
	var corners = Corner.keys()
	return corners[rng.randi()%corners.size()]

func get_corner_position(bounds: AABB, corner: int):
	match corner:
		Corner.SOUTHEAST:
			Vector3(bounds.position.x, bounds.position.y, bounds.position.z)
		Corner.SOUTHWEST: 
			Vector3(bounds.end.x, bounds.position.y, bounds.position.z)
		Corner.NORTHEAST: 
			Vector3(bounds.position.x, bounds.position.y, bounds.end.z)
		Corner.NORTHWEST: 
			Vector3(bounds.end.x, bounds.position.y, bounds.end.z)

# returns array with col positions
func get_column(bounds, posx) -> Array:
	var col_arr = []
	for z in range(bounds.position.z, bounds.end.z):
		var col_vec = Vector3(posx, 0, z)
		col_arr.append(col_vec)
	return col_arr
# returns array with row positions
func get_row(bounds, posz) -> Array:
	var row_arr = []
	for x in range(bounds.position.x, bounds.end.x):
		var row_vec = Vector3(x, 0, posz)
		row_arr.append(row_vec)
	return row_arr
################################### EDGES ######################################
################################################################################
func get_rand_edge(rng: RandomNumberGenerator):
	var edges = Edge.values()
	return edges[rng.randi()%edges.size()]

# if edge is not in edges return false
func is_edge_valid(edge: int) -> bool:
	var edge_size = Edge.size()
	return edge > -1 and edge < edge_size-1 

# needs a normalized vector
func is_pos_edge(pos: Vector3) -> bool:
	return valid_edges.has(pos)

func get_edges():
	return Edge.values()

func get_edge_positions(bounds: AABB, edge: int):
	match edge:
		Edge.NORTH:
			return get_row(bounds, bounds.end.z)
		Edge.SOUTH:
			return get_row(bounds, bounds.position.z)
		Edge.EAST:
			return get_column(bounds, bounds.position.x)
		Edge.WEST:
			return get_column(bounds, bounds.end.x)
		_: 
			print("error: no such edge as: ", edge)

func get_edge_from_vec3(direction: Vector3):
	match direction:
		Vector3(0, 0, 1):
			return Edge.NORTH
		Vector3(0, 0, -1):
			return Edge.SOUTH
		Vector3(1, 0, 0):
			return Edge.WEST
		Vector3(-1, 0, 0):
			return Edge.EAST
		_:
			return null

func get_dir_from_edge(edge: int):
	match edge:
		Edge.NORTH:
			return Vector3(0, 0, 1)
		Edge.SOUTH:
			return Vector3(0, 0, -1)
		Edge.WEST:
			return Vector3(1, 0, 0)
		Edge.EAST:
			return Vector3(-1, 0, 0)
		_:
			return null

# returns local space coordinates
func get_middle_edge_position(size_rect: AABB, edge: int):
	match edge:
		Edge.NORTH:
			return Vector3(int(size_rect.size.x/2), 0, int(size_rect.size.z))
		Edge.SOUTH:
			return Vector3(int(size_rect.size.x/2), 0, 0)
		Edge.EAST:
			return Vector3(0, 0, int(size_rect.size.z/2))
		Edge.WEST:
			return Vector3(int(size_rect.size.x), 0, int(size_rect.size.z/2))

# returns global coordinates
func get_middle_edge_position_global(size_rect: AABB, edge: int):
	var pos = Vector3(size_rect.position)
	match edge:
		Edge.NORTH:
			return pos + Vector3(int(size_rect.size.x/2), 0, int(size_rect.size.z))
		Edge.SOUTH:
			return pos + Vector3(int(size_rect.size.x/2), 0, 0)
		Edge.EAST:
			return pos + Vector3(0, 0, int(size_rect.size.z/2))
		Edge.WEST:
			return pos + Vector3(int(size_rect.size.x), 0, int(size_rect.size.z/2))
# if wanted side is facing north by default
# this is inverted for wall placement, wanted side will be placed inwards
func get_default_edge_rotation(edge: int):
	match edge:
		Edge.EAST:
			return 90
		Edge.WEST:
			return -90
		Edge.NORTH:
			return 180
		Edge.SOUTH:
			return 0
func get_all_edge_rotations():
	return {
		Edge.NORTH: get_default_edge_rotation(Edge.NORTH),
		Edge.SOUTH: get_default_edge_rotation(Edge.SOUTH),
		Edge.WEST: get_default_edge_rotation(Edge.WEST),
		Edge.EAST: get_default_edge_rotation(Edge.EAST)
		}
func get_opposite_edge(edge):
	match edge:
		Edge.NORTH:
			return Edge.SOUTH
		Edge.SOUTH:
			return Edge.NORTH
		Edge.EAST:
			return Edge.WEST
		Edge.WEST:
			return Edge.EAST
func get_edge_name(edge):
	match edge:
		Edge.NORTH:
			return "NORTH"
		Edge.SOUTH:
			return "SOUTH"
		Edge.EAST:
			return "EAST"
		Edge.WEST:
			return "WEST"

func is_position_corner(bounds: AABB, position: Vector3) -> bool:
	var x_corner: bool = false
	var z_corner: bool = false
	if position.x == bounds.position.x or position.x == bounds.end.x:
		x_corner = true
	if position.z == bounds.position.z or position.z == bounds.end.z:
		z_corner = true	
	return x_corner and z_corner

func is_position_wall():
	pass

func get_next_wall_left():
	pass
func get_next_wall_right():
	pass

################################################################################
################################################################################
# with global positions, using step by grid size
func grid_positions_from_global(base_size, cell_size, return_global: bool):
	var positions = []
	for x in range(base_size.position.x, base_size.end.x, cell_size.x):
		for y in range(base_size.position.y, base_size.end.y, cell_size.y):
			for z in range(base_size.position.z, base_size.end.z, cell_size.z):
				var pos = Vector3(x, y, z)
				if return_global:
					pos = pos * cell_size
				positions.append(pos)
	return positions

func grid_positions_from_local(bounds):
	var positions = []
	for x in range(bounds.position.x, bounds.end.x):
		for y in range(bounds.position.y, bounds.end.y):
			for z in range(bounds.position.z, bounds.end.z):
				var pos = Vector3(x, y, z)
				positions.append(pos)
	return positions

func vec3_to_global(pos: Vector3, cell_size: Vector3) -> Vector3:
	return pos*cell_size

func vec3_to_local(pos: Vector3, cell_size: Vector3) -> Vector3:
	return pos/cell_size

func get_aabb_position_dict(building_grid_size: AABB):
	var positions: Dictionary = {}
	for x in range(building_grid_size.position.x, building_grid_size.end.x+1):
		for y in range(building_grid_size.position.y, building_grid_size.end.y+1):
			for z in range(building_grid_size.position.z, building_grid_size.end.z+1):
				var current = Vector3(x,y,z)
				positions[current] = null
	return positions

# --------------------- RAND -------------------------
func get_multiple_rand_aabb_positions(bounds: AABB, count: int, rng: RandomNumberGenerator):
	var arr = []
	for c in count:
		arr.append(rand_aabb_pos(bounds, rng))
	return arr

func rand_aabb_pos(bounds, rng: RandomNumberGenerator):
	return Vector3(rng.randi_range(bounds.position.x, bounds.end.x), 0, rng.randi_range(bounds.position.z, bounds.end.z))

func randi_range_vec3(min_size: Vector3, max_size: Vector3, rng) -> Vector3:
	var vec = Vector3()
	vec.x = rng.randi_range(min_size.x, max_size.x)
	vec.y = rng.randi_range(min_size.y, max_size.y)
	vec.z = rng.randi_range(min_size.z, max_size.z)
	return vec

func rand_list_item(list: Array, rng: RandomNumberGenerator):
	return list[rng.randi()% list.size()]
