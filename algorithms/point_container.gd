extends AStar2D
class_name PointContainer

enum Structure {
	POINT_KEY
	POS_KEY
}

var point_dict = Dictionary() setget set_point_dict, get_point_dict

func _init():
	pass

func set_point_dict(_points: Dictionary) -> void:
	point_dict = _points
	
func get_point_dict() -> Dictionary:
	return point_dict

func from_pos_point_dict(dict: Dictionary, structure: int):
	print("dict: ", dict)
	match structure:
		Structure.POINT_KEY:
			point_dict = _inverse(dict)
		Structure.POS_KEY:
			point_dict = _standard(dict)

	return point_dict

func _inverse(dict: Dictionary):
	var keys = dict.values().duplicate()
	var values = dict.keys().duplicate()

	var n_dict = Dictionary()
	for idx in keys.size():
		n_dict[keys[idx]] = values[idx]

	return n_dict
	
func _standard(dict: Dictionary):
	 return dict.duplicate()
