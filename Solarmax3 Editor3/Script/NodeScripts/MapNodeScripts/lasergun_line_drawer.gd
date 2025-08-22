extends Marker2D

const UNIT_WIDTH : float = 99.4

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
					-1.0,
					true
			)


func _calculate_line_positions():
	lasergun_line_positions_array.clear()
	
	var start_position : Vector2 = Vector2.ZERO
	var lines_number : int = int(lasergun_range / lasergun_rotate_skip) + 1
	for i in lines_number:
		var angle
