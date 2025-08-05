extends Node2D

# string_offset = 调整基线量 + 微调量
var string_offset : Vector2 = Vector2(0, 20) + Vector2(3, -1) 
var font : FontFile = load("res://Fonts/Downlink-4.otf")

var x_maximum_number = 9
var y_maximum_number = 5

const ORIGIN : Vector2 = Vector2(0, 0)
const UNIT_WIDTH : float = 99.4
# 可能会有更好看的颜色
const AXIS_COLOR : Color = Color.WHITE
const GRID_COLOR : Color = Color(0.5, 0.5, 1, 0.85)
const TINY_COLOR : Color = Color(1, 1, 1, 0.15)

var axis_width = 2
var grid_line_width = 1
# 网格内分段线数
var grid_line_count = 0

func _draw():
	_draw_axis()
	_draw_grid()


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
	for i in range(-x_maximum_number * grid_line_count, x_maximum_number * grid_line_count + 1):
		if i == 0:
			continue
		draw_line(Vector2(i * UNIT_WIDTH / grid_line_count , (y_maximum_number + 0.2) * UNIT_WIDTH), Vector2(i * UNIT_WIDTH / grid_line_count, -((y_maximum_number + 0.2) * UNIT_WIDTH)), TINY_COLOR, grid_line_width, true)
		if i % grid_line_count == 0:
			draw_line(Vector2(i * UNIT_WIDTH / grid_line_count , (y_maximum_number + 0.2) * UNIT_WIDTH), Vector2(i * UNIT_WIDTH / grid_line_count, -((y_maximum_number + 0.2) * UNIT_WIDTH)), GRID_COLOR, grid_line_width, true)

	# 绘制行线
	for i in range(-y_maximum_number * grid_line_count, y_maximum_number * grid_line_count + 1):
		if i == 0:
			continue
		draw_line(Vector2( -(x_maximum_number + 0.2) * UNIT_WIDTH, i * UNIT_WIDTH / grid_line_count), Vector2((x_maximum_number + 0.2) * UNIT_WIDTH, i * UNIT_WIDTH / grid_line_count), TINY_COLOR, grid_line_width, true)
		if i % grid_line_count == 0:
			draw_line(Vector2( -(x_maximum_number + 0.2) * UNIT_WIDTH, i * UNIT_WIDTH / grid_line_count), Vector2((x_maximum_number + 0.2) * UNIT_WIDTH, i * UNIT_WIDTH / grid_line_count), GRID_COLOR, grid_line_width, true)


func update_grid():
	if (grid_line_count == 4):
		visible = false
		grid_line_count = 0
	else:
		# 因为不知道怎么触发重绘，索性就这样了
		visible = false
		visible = true
		grid_line_count += 1
