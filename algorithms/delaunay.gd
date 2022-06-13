extends PointContainer
class_name Delanuay
var polygons := Dictionary()

func _init(points = null):
	if points:
		if typeof(points) == TYPE_VECTOR2_ARRAY:
			triangulate(points)
		else:
			print("points is not a PoolVector2Array, cant triangulate this shit")

func _init_points(points: PoolVector2Array) -> Dictionary:
	var p_dict = Dictionary()
	for position in points:
		var new_point = get_available_point_id()
		add_point(new_point, position)
		p_dict[position] = new_point
	return p_dict

### connects points internally.
### also stores polygons in polygons dict: polygons[p1, p2, p3] = [pos1, pos2, pos3]
func triangulate(points: PoolVector2Array) -> Dictionary:
	var temp = _init_points(points)
	
	# this returns an array with point indicies aligned as [pol1.p1, pol1.p2, pol1.p3, pol2.p1, pol2.p2, pol2.p3 etc...]
	var del_points = Geometry.triangulate_delaunay_2d(points)
	
	# indexing the Vector2 array we specified as parameter, with these returned points
	# gets the point in triangulated order 
	for index in del_points.size()/3:
		var poly = PoolVector2Array()
		var point_poly = PoolIntArray()

		for c in range(3):
			var p_pos = points[del_points[(index * 3) + c]]
			var p_id = temp[p_pos]
			poly.append(p_pos)
			point_poly.append(p_id)
		
		var p1 = temp[poly[0]]
		var p2 = temp[poly[1]]
		var p3 = temp[poly[2]]
		
		if not are_points_connected(p1, p2):
			connect_points(p1, p2)
		if not are_points_connected(p1, p3):
			connect_points(p1, p3)
		if not are_points_connected(p2, p3):
			connect_points(p2, p3)
			
		polygons[point_poly] = poly

	from_pos_point_dict(temp, Structure.POINT_KEY)	
	return polygons
