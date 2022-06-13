extends GridMap
class_name ExtendedGridMap

func _init(create_meshlib: bool = false) -> void:
	if create_meshlib:
		create_dummy_meshlib()

func create_dummy_meshlib():
	var ml = MeshLibrary.new()
	ml.create_item(0)
	ml.set_item_name(0, "floor")
	ml.create_item(1)
	ml.set_item_name(1, "wall")
	ml.create_item(2)
	ml.set_item_name(2, "door")
	mesh_library = ml

func is_cell_item(cell: Vector3, item: int):
	return get_cell_item(cell.x, cell.y, cell.z) == item

func set_aabb(bounds: AABB, to_item: int, horizontal_only: bool = true) -> void:
	if horizontal_only:
		for x in range(bounds.position.x, bounds.end.x):
			for z in range(bounds.position.z, bounds.end.z):
				set_cell_item(x, int(bounds.position.y), z, to_item)
	else:
		for x in range(bounds.position.x, bounds.end.x):
			for y in range(bounds.position.y, bounds.end.y):
				for z in range(bounds.position.z, bounds.end.z):
					set_cell_item(x, y, z, to_item)

func set_vec3_arr(items: Array, to_item: int):
	for i in items:
		set_cell_item(i.x, i.y, i.z, to_item)
