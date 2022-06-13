extends PointContainer
class_name MST


func _init():
	pass

func from_arr(_arr: Array):
	var pos_arr = _arr.duplicate()
	var p_dict = Dictionary()
	var fp = get_available_point_id()
	var fpos = pos_arr.pop_back()
	
	add_point(fp, fpos)
	p_dict[fpos] = fp
	
	while pos_arr.size() > 0:
		var min_dist = INF
		var min_pos = null
		var pos = null

		for p1 in get_points():
			p1 = get_point_position(p1)

			for p2 in pos_arr:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_pos = p2
					pos = p1

		var new_point = get_available_point_id()
		add_point(new_point, min_pos)
		p_dict[min_pos] = new_point
		connect_points(get_closest_point(pos), new_point)
		pos_arr.erase(min_pos)

	from_pos_point_dict(p_dict, Structure.POINT_KEY)

# this will keep input pointcontainer point structure, so references can be made between them
func from_point_container(pc: PointContainer):
	
	var pc_points = _inverse(pc.point_dict)
	var pos_arr = pc_points.keys().duplicate()
	# first point add
	var fp = pos_arr.pop_back()
	add_point(pc_points[fp], fp)
	
	while pos_arr.size() > 0:
		var min_dist = INF
		var min_pos = null
		var pos = null

		for p1 in get_points():
			p1 = get_point_position(p1)

			for p2 in pos_arr:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_pos = p2
					pos = p1

		var new_point = pc_points[min_pos]
		add_point(new_point, min_pos)
		connect_points(get_closest_point(pos), new_point)
		pos_arr.erase(min_pos)
	
	from_pos_point_dict(pc_points, Structure.POINT_KEY)
