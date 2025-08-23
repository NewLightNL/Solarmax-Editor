extends Marker2D

const UNIT_WIDTH : float = 99.4
const LASERLINELENTH : float = 20.0

var is_lasergun : bool = false

var lasergun_angle : float
var lasergun_rotate_skip : float
var lasergun_range : float

var lasergun_line_positions_array : Array[Array]


func _draw() -> void:
	if is_lasergun:
		_calculate_line_positions()
		for lasergun_line_positions in lasergun_line_positions_array:
			var lasergunline_start_position : Vector2 = lasergun_line_positions[0]
			var lasergunline_end_position : Vector2 = lasergun_line_positions[1]
			draw_line(
					lasergunline_start_position,
					lasergunline_end_position,
					Color.WHITE,
					1.0,
					true
			)


func _calculate_line_positions():
	lasergun_line_positions_array.clear()
	
	var lines_number : int
	if not is_zero_approx(lasergun_rotate_skip):
		lines_number = int(lasergun_range / lasergun_rotate_skip) + 1
	else:
		lines_number = 1
	
	if lines_number < 0:
		lines_number = 0
	
	var start_position : Vector2 = Vector2.ZERO
	var start_angle : float = lasergun_angle
	for i in range(lines_number):
		var angle : float = start_angle + lasergun_rotate_skip * i
		var radian : float = deg_to_rad(angle)
		# 射线是逆时针转的
		var end_position : Vector2 = Vector2.ZERO
		end_position.x = LASERLINELENTH * UNIT_WIDTH * cos(- radian)
		end_position.y = LASERLINELENTH * UNIT_WIDTH * sin(- radian)
		var lasergun_line_positions : Array = [start_position, end_position]
		lasergun_line_positions_array.append(lasergun_line_positions)
		
