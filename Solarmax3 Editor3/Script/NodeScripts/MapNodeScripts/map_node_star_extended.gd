extends MapNodeStar

var _ui_last_position : Vector2
# 外部输入数据
var star_pattern_dictionary : Dictionary
var camp_colors : Dictionary

@onready var _halo_drawer : Marker2D = $HaloDrawingCenter
@onready var _map_node_star_sprite : Sprite2D = $MapNodeStarSprite
@onready var _star_ui : Control = $StarUI
@onready var _star_fleets_label : Control = $StarUI/StarFleetsLabel
@onready var _orbit_drawer : Node2D = $OrbitDrawer


func _ready():
	Mapeditor1ShareData.init_editor_data()
	star_pattern_dictionary = Mapeditor1ShareData.star_pattern_dictionary
	camp_colors = Mapeditor1ShareData.camp_colors
	
	update_map_node_star()
	#var stars = Mapeditor1ShareData.stars
	#_init_from_star(stars[0])


func _process(delta):
	if _star_ui.position != _ui_last_position:
		_update_ui_children()
	_ui_last_position = _star_ui.position


func _update_ui_children():
	_star_fleets_label.position = Vector2(0, 0)


func update_map_node_star():
	_update_map_node_star_showing_property()
	_call_draw_halo()
	_call_draw_orbit()
	_update_star_ui()


func _update_map_node_star_showing_property():
	_update_map_node_star_showing_picture()
	_update_map_node_star_showing_camp()


func _update_map_node_star_showing_picture():
	_map_node_star_sprite.texture = star_pattern_dictionary[pattern_name]
	var raw_scale = self.star_scale * Vector2.ONE
	var scale_processed = Vector2(raw_scale.x * scale_fix.x, raw_scale.y * scale_fix.y)
	_map_node_star_sprite.scale = scale_processed
	_map_node_star_sprite.offset = offset_fix
	
	if self.is_taget == true:
		# 对于可旋转天体，要用障碍点标记
		# 对于自带旋转的天体?
		self.fAngle = 90
		_map_node_star_sprite.rotation_degrees = self.rotation_fix_degree + self.fAngle
	else:
		# 对于不旋转天体，则恢复0度
		# 对于旋转天体，则去掉障碍点，保持其旋转角度
		self.fAngle = 0
		_map_node_star_sprite.rotation_degrees = self.rotation_fix_degree + self.fAngle


func _update_map_node_star_showing_camp():
	var camp_color : Color = camp_colors[star_camp]
	_map_node_star_sprite.modulate = camp_color


func _call_draw_orbit():
	if self.orbit_type != "":
		_orbit_drawer.orbit_type = self.orbit_type
		_orbit_drawer.star_position = self.star_position
		_orbit_drawer.orbit_param1 = self.orbit_param1
		_orbit_drawer.orbit_param2 = self.orbit_param2
		_orbit_drawer.queue_redraw()
	else:
		push_error("天体没有轨道类型!")


func _get_valid_camps_number() -> int:
	var valid_camps_number_process : int = 0
	for i in this_star_fleets:
		if i[0] != 0:
			if i[1] != 0:
				valid_camps_number_process += 1
	return valid_camps_number_process


func _call_draw_halo():
	if _halo_drawer != null:
		_halo_drawer.draw_halo(this_star_fleets, star_scale)
	else:
		push_error("天体缺少画环节点!")


func _update_star_ui():
	
	_configure_star_ship_number_labels()

# .............................



func _configure_star_ship_number_labels():
	var valid_camps_number = _get_valid_camps_number()
	var label_positions = calculate_ship_number_lable_positions(valid_camps_number)
	add_star_ship_labels(label_positions)


# 计算飞船数量点位位置
func calculate_ship_number_lable_positions(valid_camps_number : int) -> Array :
	var ship_number_positions : Array
	# 天体中心相对节点(ShipNumberLabels)的位置 = MapNodeStar位置 - ShipNumberLabels位置
	var relative_star_position = - _star_ui.position
	if valid_camps_number == 0:
		return ship_number_positions
	elif valid_camps_number == 1:
		var ship_number_position : Vector2
		ship_number_position = relative_star_position + Vector2(0, 79.0) * self.star_scale
		ship_number_positions.append(ship_number_position)
		return ship_number_positions
	elif valid_camps_number == 2:
		var ship_number_position1 : Vector2
		var ship_number_position2 : Vector2
		ship_number_position1 = relative_star_position + Vector2(0, 150.0) * self.star_scale
		ship_number_position2 = relative_star_position - Vector2(0, 150.0) * self.star_scale
		ship_number_positions.append(ship_number_position1)
		ship_number_positions.append(ship_number_position2)
		return ship_number_positions
	else:
		var radian_divided = TAU/valid_camps_number
		for i in range(valid_camps_number):
			var ship_number_position : Vector2
			var relative_ship_number_position : Vector2
			relative_ship_number_position = Vector2(cos(PI/2 + radian_divided * i), -sin(PI/2 + radian_divided * i)) * 150.0/2# /2要换成scale
			ship_number_position = relative_star_position + relative_ship_number_position
			ship_number_positions.append(ship_number_position)
		return ship_number_positions


func add_star_ship_labels(ship_number_positions):
	var index : int = -1
	for this_star_fleet in this_star_fleets:
		if this_star_fleet[0] != 0:
			index += 1
			var ship_number_label = Label.new()
			var camp_ship_number = this_star_fleet[1]
			var camp = this_star_fleet[0]
			var camp_ship_number_showed : String
			if camp_ship_number < 10000000:
				camp_ship_number_showed = str(camp_ship_number)# int
			else:
				camp_ship_number_showed = String.num_scientific(camp_ship_number)
			ship_number_label.text = camp_ship_number_showed
			ship_number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			ship_number_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			$StarUI/StarFleetsLabel.add_child(ship_number_label)
			ship_number_label.add_theme_color_override("font_color", camp_colors[camp])
			ship_number_label.position = ship_number_positions[index] - ship_number_label.size/2
# ......................

func _on_delete_button_button_up():
	queue_free()
