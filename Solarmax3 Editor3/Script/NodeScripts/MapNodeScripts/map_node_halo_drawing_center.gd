extends Marker2D

var camps_number : int
var halo_arguments : Array
# halo_argument = [起始弧度, 终止弧度, 颜色]
var star_scale : float

# draw_arc(center: Vector2, radius: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = -1.0, antialiased: bool = false)
func _draw():
	# draw_arc()函数是顺时针画弧的
	if camps_number >= 2:# 只有当阵营数达到2及2以上才会开始画环
		for halo_argument in halo_arguments:
			draw_arc(Vector2(0, 0), (231.0-3)/2 * star_scale, -halo_argument[0], -halo_argument[1], 128, halo_argument[2], 1, true)
