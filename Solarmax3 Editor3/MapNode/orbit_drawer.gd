extends Node2D


const ORBIT_COLOR : Color = Color(0.8, 0.8, 0.8, 0.5)
const ORBIT_WIDTH : float = 1
const UNIT_WIDTH : float = 99.4

var orbit_type : String
var star_position : Vector2 :
	set(value):
		star_position_converted = Vector2(value.x, - value.y) * UNIT_WIDTH
var orbit_param1 : Vector2:
	set(value):
		orbit_param1_converted = Vector2(value.x, - value.y) * UNIT_WIDTH
var orbit_param2 : Vector2:
	set(value):
		orbit_param2_converted = Vector2(value.x, - value.y) * UNIT_WIDTH

var star_position_converted : Vector2
var orbit_param1_converted : Vector2
var orbit_param2_converted : Vector2


func _draw() -> void:
	_draw_orbit()

func _draw_orbit():
	match orbit_type:
		"no_orbit":
			pass
		"circle":
			_draw_circle()
		"triangle":
			_draw_triangle()
		"quadrilateral":
			_draw_square()
		"ellipse":
			_draw_ellipse()
		_:
			push_error("天体携带着未知轨道类型!")


func _draw_circle():
	var radius = star_position_converted.distance_to(orbit_param1_converted)
	var center_position = orbit_param1_converted
	draw_circle(center_position, radius, ORBIT_COLOR, false, ORBIT_WIDTH, true)


func _draw_triangle():
	var vertex_vector1 : Vector2 = star_position_converted - orbit_param1_converted
	var vertex_vector2 : Vector2 = vertex_vector1.rotated(2 * PI / 3)
	var vertex_vector3 : Vector2 = vertex_vector1.rotated(2 * PI * (2.0 / 3.0))
	
	var vertex1_position : Vector2 = vertex_vector1 + orbit_param1_converted
	var vertex2_position : Vector2 = vertex_vector2 + orbit_param1_converted
	var vertex3_position : Vector2 = vertex_vector3 + orbit_param1_converted
	
	var vertex_positions : PackedVector2Array = [
		vertex1_position,
		vertex2_position,
		vertex3_position,
		vertex1_position
	]
	draw_polyline(vertex_positions, ORBIT_COLOR, ORBIT_WIDTH, true)


func _draw_square():
	var vertex_vector1 : Vector2 = star_position_converted - orbit_param1_converted
	var vertex_vector2 : Vector2 = vertex_vector1.rotated(2 * PI / 4)
	var vertex_vector3 : Vector2 = vertex_vector1.rotated(2 * PI * (2.0 / 4.0))
	var vertex_vector4 : Vector2 = vertex_vector1.rotated(2 * PI * (3.0 / 4.0))
	
	var vertex1_position : Vector2 = vertex_vector1 + orbit_param1_converted
	var vertex2_position : Vector2 = vertex_vector2 + orbit_param1_converted
	var vertex3_position : Vector2 = vertex_vector3 + orbit_param1_converted
	var vertex4_position : Vector2 = vertex_vector4 + orbit_param1_converted
	
	var vertex_positions : PackedVector2Array = [
		vertex1_position,
		vertex2_position,
		vertex3_position,
		vertex4_position,
		vertex1_position
	]
	draw_polyline(vertex_positions, ORBIT_COLOR, ORBIT_WIDTH, true)


func _draw_ellipse():
	var distance1 = star_position_converted.distance_to(orbit_param1_converted)
	var distance2 = star_position_converted.distance_to(orbit_param2_converted)
	
	var focal_distance= orbit_param1_converted.distance_to(orbit_param2_converted)
	var distance_summed = distance1 + distance2
	if is_equal_approx(focal_distance, distance_summed):
		draw_line(orbit_param1_converted, orbit_param2_converted, ORBIT_COLOR, ORBIT_WIDTH, true)
	else:
		var major_axis_length = distance1 + distance2
		var semi_major_axis_length = major_axis_length / 2
		var linear_eccentricity = focal_distance / 2
		var semi_minor_axis_length = sqrt(pow(semi_major_axis_length, 2) - pow(linear_eccentricity, 2))
		
		var a = semi_major_axis_length
		var b = semi_minor_axis_length
		
		var steps : int = 256
		var vertex_vectors : PackedVector2Array = []
		for i in range(steps):
			var radian = 2 * PI * (i / float(steps))
			var vertex_vector : Vector2 = Vector2(a * cos(radian), - (b * sin(radian)))
			vertex_vectors.append(vertex_vector)
		if vertex_vectors.size() >= 0:
			vertex_vectors.append(vertex_vectors[0])
		var ellipes_center = (orbit_param1_converted + orbit_param2_converted) / 2
		var direction_vector = orbit_param1_converted - orbit_param2_converted
		var ellipse_rotation_radian = direction_vector.angle()
		var vertex_positions : PackedVector2Array = []
		for vertex_vector in vertex_vectors:
			vertex_vector = vertex_vector.rotated(ellipse_rotation_radian)
			var vertex_position = vertex_vector + ellipes_center
			vertex_positions.append(vertex_position)
		draw_polyline(vertex_positions, ORBIT_COLOR, ORBIT_WIDTH, true)
