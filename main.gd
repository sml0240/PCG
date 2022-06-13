extends Node2D

var del = Delanuay.new()
var mst = MST.new()
var bsp = BinarySpacePartitioning2D.new()
var bsp_arr = Array()
var pos_arr = Array()
var done = false
var draw_count = 0
var draw_arr = []
var draw_dict = {}

func _ready():
	randomize()
	del_test()
	mst_from_del_test(del)
	done = true	
	$DrawTimer.start()
	bsp_test()
	
func del_test():
	var amt = 10
	for i in amt:
		pos_arr.append(get_rand_vec2())
	del.triangulate(pos_arr)
	print("del final point dict: ",del.point_dict)
	
func mst_from_del_test(del: Delanuay):
	mst.from_arr(del.point_dict.values())
	print("mst final point dict: ",mst.point_dict)
	done = true

func bsp_test():
	var space = Rect2(Vector2.ZERO, Vector2(1670, 1030))
	bsp.parameters.space = space
	bsp.parameters.min_room_size = Vector2(250, 250)
	bsp_arr = bsp.partition()
	print(bsp_arr)

func _draw():
	if done:
		# draw del points		
		draw_pc(del, 10, Color.aqua)
		
		# draw delaunay triangulation edges
		for p in del.get_points():
			var p1 = del.get_point_position(p)
			for c in del.get_point_connections(p):
				var p2 = del.get_point_position(c)
				draw_line(p1, p2, Color.aqua, 1.0)
		
		## draw mst points
		draw_pc(mst, 5, Color.crimson)
		
		# draw mst connections
		if not draw_count >= mst.get_point_count():
			draw_arr.append(mst.get_point_position(draw_count))
			if draw_dict.keys().size() > 1:
				for point in draw_dict.keys():
					var pp = mst.get_point_position(point)
					for conn in draw_dict[point]:
						var cp = mst.get_point_position(conn)

						draw_line(pp, cp, Color.crimson, 2.0)

			draw_count+=1
			if draw_count == mst.get_point_count()-1:
				$DrawTimer.stop()			
			else:
				draw_dict[draw_count] = mst.get_point_connections(draw_count)	
		else:
			$DrawTimer.stop()

func draw_next_line(from: Vector2, to: Vector2, size: float, col: Color):
	draw_line(from, to, col, size)

func draw_mst(pc: MST, line_size: float, line_color: Color):
	for point in pc.get_points():
		var pp = pc.get_point_position(point)
		for conn in pc.get_point_connections(point):
			yield(get_tree().create_timer(1.0), "timeout")
			draw_line(pp, pc.get_point_position(conn), line_color, line_size)

func draw_pc(pc: PointContainer, circle_size: float, circle_color: Color):
	for point in pc.get_points():
		draw_circle(pc.get_point_position(point), circle_size, circle_color)
	
func get_rand_col():
	return Color(randf(), randf(), randf(), 1.0)

func get_rand_vec2():
	return Vector2(randi()% 1680, randi()%1050)

func _on_DrawTimer_timeout():
	emit_signal("draw")
	update()
