extends Node2D


const ORIGIN : Vector2 = Vector2(0, 0)
const UNIT_WIDTH : float = 99.4
# 可能会有更好看的颜色
const AXIS_COLOR : Color = Color.WHITE
const MAJOR_GRIDLINES_COLOR : Color = Color(0.5, 0.5, 1, 0.85)
const MINOR_GRIDLINES_COLOR : Color = Color(1, 1, 1, 0.15)

# string_offset = 调整基线量 + 微调量
var string_offset : Vector2 = Vector2(0, 20) + Vector2(3, -1) 
var font : FontFile = load("res://Fonts/Downlink-4.otf")

var x_maximum_number : float = 9.0
var y_maximum_number : float = 5.0

var axis_width = 2
var grid_line_width = 1
# 单位大网格的分段线数
var minor_grid_lines_per_major_interval : int = 0


func _draw():
	_draw_grid()
	_draw_axis()


func _draw_axis():
	# 原点
	draw_string(font, string_offset, "0", HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color.WHITE)
	
	# 绘制x轴
	draw_line(Vector2( -(x_maximum_number + 0.2) * UNIT_WIDTH, 0), Vector2((x_maximum_number + 0.2) * UNIT_WIDTH, 0), AXIS_COLOR, axis_width, true)
	draw_line(Vector2((x_maximum_number + 0.2) * UNIT_WIDTH, 0), Vector2((x_maximum_number + 0.2) * UNIT_WIDTH - 12, 0 - 19), AXIS_COLOR, axis_width, true)
	draw_line(Vector2((x_maximum_number + 0.2) * UNIT_WIDTH, 0), Vector2((x_maximum_number + 0.2) * UNIT_WIDTH - 12, 0 + 19), AXIS_COLOR, 2, true)
	
	# 绘制x轴标签
	for i in range(-x_maximum_number, x_maximum_number + 1):
		if i != 0:
			draw_string(font, Vector2(i * UNIT_WIDTH, 0) + string_offset, str(i), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color.WHITE)
	
	# 绘制y轴
	draw_line(Vector2(0, (y_maximum_number + 0.2) * UNIT_WIDTH), Vector2(0, -((y_maximum_number + 0.2) * UNIT_WIDTH)), AXIS_COLOR, axis_width, true)
	draw_line(Vector2(0, -((y_maximum_number + 0.2) * UNIT_WIDTH)), Vector2(0 - 19, -((y_maximum_number + 0.2) * UNIT_WIDTH) + 12), AXIS_COLOR, axis_width, true)
	draw_line(Vector2(0, -((y_maximum_number + 0.2) * UNIT_WIDTH)), Vector2(0 + 19, -((y_maximum_number + 0.2) * UNIT_WIDTH) + 12), AXIS_COLOR, axis_width, true)
	
	# 绘制y轴标签
	for i in range(-y_maximum_number, y_maximum_number + 1):
		if i != 0:
			draw_string(font, -Vector2(0, i * UNIT_WIDTH) + string_offset, str(i), HORIZONTAL_ALIGNMENT_CENTER, -1, 20, Color.WHITE)


func _draw_grid():
	# 绘制列线
	draw_vertical_line()
	
	# 绘制行线
	draw_horizontal_line()


func update_grid():
	if self.visible == false:
		minor_grid_lines_per_major_interval = 0
		self.visible = true
	else:
		if minor_grid_lines_per_major_interval == 4:
			minor_grid_lines_per_major_interval = 0
			visible = false
		else:
			minor_grid_lines_per_major_interval += 1
			self.queue_redraw()


# 下面两个方法可以变成画平行线函数，并且可以加一个过不过原点的布尔判断
# 画子网格也可以变成一个函数
# 绘制列线
func draw_vertical_line():
	var number_of_major_gridlines_on_negative_x_axis : int = floor(x_maximum_number / 1)
	var number_of_major_gridlines_on_positive_x_axis : int = floor(x_maximum_number / 1)
	var step_length : float = UNIT_WIDTH / 1
	for i in range(-number_of_major_gridlines_on_negative_x_axis, number_of_major_gridlines_on_positive_x_axis + 1):
		var majorline_start_point_position : Vector2 = Vector2(i * step_length , (y_maximum_number + 0.2) * UNIT_WIDTH)
		var majorline_end_point_position : Vector2 = Vector2(i * step_length, -((y_maximum_number + 0.2) * UNIT_WIDTH))
		# 原点不绘制主网格线
		if i == 0:
			if minor_grid_lines_per_major_interval > 0 and i != number_of_major_gridlines_on_positive_x_axis:
				var minor_step_length : float = step_length / (minor_grid_lines_per_major_interval + 1)
				for minorline_index in range(minor_grid_lines_per_major_interval):
					var minorline_start_point_position : Vector2 = majorline_start_point_position\
							+ Vector2(minor_step_length * (minorline_index + 1), 0)
					var minorline_end_point_position : Vector2 = majorline_end_point_position\
							+ Vector2(minor_step_length * (minorline_index + 1), 0)
					draw_line(minorline_start_point_position, minorline_end_point_position, MINOR_GRIDLINES_COLOR, grid_line_width, true)
			continue
		
		# 绘制主网格
		draw_line(majorline_start_point_position, majorline_end_point_position, MAJOR_GRIDLINES_COLOR, grid_line_width, true)
		if minor_grid_lines_per_major_interval > 0 and i != number_of_major_gridlines_on_positive_x_axis:
			var minor_step_length : float = step_length / (minor_grid_lines_per_major_interval + 1)
			for minorline_index in range(minor_grid_lines_per_major_interval):
				var minorline_start_point_position : Vector2 = majorline_start_point_position\
						+ Vector2(minor_step_length * (minorline_index + 1), 0)
				var minorline_end_point_position : Vector2 = majorline_end_point_position\
						+ Vector2(minor_step_length * (minorline_index + 1), 0)
				draw_line(minorline_start_point_position, minorline_end_point_position, MINOR_GRIDLINES_COLOR, grid_line_width, true)

# 绘制行线
func draw_horizontal_line():
	var number_of_major_gridlines_on_negative_y_axis : int = floor(y_maximum_number / 1)
	var number_of_major_gridlines_on_positive_y_axis : int = floor(y_maximum_number / 1)
	var step_length : float = UNIT_WIDTH / 1
	for i in range(-number_of_major_gridlines_on_negative_y_axis, number_of_major_gridlines_on_positive_y_axis + 1):
		var majorline_start_point_position : Vector2 = Vector2(-(x_maximum_number + 0.2) * UNIT_WIDTH, i * step_length)
		var majorline_end_point_position : Vector2 = Vector2((x_maximum_number + 0.2) * UNIT_WIDTH, i * step_length)
		# 原点不绘制主网格线
		if i == 0:
			if minor_grid_lines_per_major_interval > 0 and i != number_of_major_gridlines_on_positive_y_axis:
				var minor_step_length : float = step_length / (minor_grid_lines_per_major_interval + 1)
				for minorline_index in range(minor_grid_lines_per_major_interval):
					var minorline_start_point_position : Vector2 = majorline_start_point_position\
							+ Vector2(0, minor_step_length * (minorline_index + 1))
					var minorline_end_point_position : Vector2 = majorline_end_point_position\
							+ Vector2(0, minor_step_length * (minorline_index + 1))
					draw_line(minorline_start_point_position, minorline_end_point_position, MINOR_GRIDLINES_COLOR, grid_line_width, true)
			continue
		
		# 绘制主网格
		draw_line(majorline_start_point_position, majorline_end_point_position, MAJOR_GRIDLINES_COLOR, grid_line_width, true)
		if minor_grid_lines_per_major_interval > 0 and i != number_of_major_gridlines_on_positive_y_axis:
			var minor_step_length : float = step_length / (minor_grid_lines_per_major_interval + 1)
			for minorline_index in range(minor_grid_lines_per_major_interval):
				var minorline_start_point_position : Vector2 = majorline_start_point_position\
						+ Vector2(0, minor_step_length * (minorline_index + 1))
				var minorline_end_point_position : Vector2 = majorline_end_point_position\
						+ Vector2(0, minor_step_length * (minorline_index + 1))
				draw_line(minorline_start_point_position, minorline_end_point_position, MINOR_GRIDLINES_COLOR, grid_line_width, true)
