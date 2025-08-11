extends Control


@export var star_fleet_information_unit : PackedScene

# 存储画环的节点
@export var halo_drawer : Marker2D

# 基本信息
var star_pattern_dictionary : Dictionary
var defined_camp_ids : Array[int]
var camp_colors : Dictionary

var chosen_star : MapNodeStar

# 内部使用，并可以向外部输出
var this_star_fleets_ordered : Array # 整理过后的该天体舰队数据，省略了天体的tag
# this_star_fleet_ordered[阵营id(int), 舰队中的飞船数量(int)]

# 内部
var valid_camps_number : int
var this_star_fleets : Array #其元素相比于"star_fleets"的元素省略了天体的tag
# this_star_fleet = [阵营id(int), 舰队中的飞船数量(int)]

@onready var star_container : Node2D = $ConfigureStarShipUIRect/StarShipPreview/ContainStar

func _ready():
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	defined_camp_ids = MapEditorSharedData.defined_camp_ids
	camp_colors = MapEditorSharedData.camp_colors
	star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
	chosen_star = MapEditorSharedData.chosen_star
	this_star_fleets = chosen_star.this_star_fleets
	$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetShipNumberLabel/StarFleetShipNumberInput.text = "0"
	$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInput.text = "0"
	$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInputOptionButton.clear()
	if defined_camp_ids.size() != 0:
		for i in defined_camp_ids:
			$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInputOptionButton.add_item(str(i), i)
		$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInputOptionButton.add_item("?", defined_camp_ids[-1]+1)
		$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInputOptionButton.set_item_disabled(defined_camp_ids[-1]+1, true)
		$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInputOptionButton.select(0)
	if this_star_fleets.size() != 0:
		organize_star_fleets()
		update_valid_camps_number()
		update_star_preview()
		update_star_fleets_list()


func _on_global_data_updated(key : String):
	match key:
		"defined_camp_ids":
			defined_camp_ids = MapEditorSharedData.defined_camp_ids
		"camp_colors":
			camp_colors = MapEditorSharedData.camp_colors
		"star_pattern_dictionary":
			star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star
		"stars", "orbit_types", "all_basic_information", "stars_dictionary", "star_fleets":
			pass
		_:
			push_error("数据更新出错，请检查要提交的内容名是否正确")


# 整理star_fleets
func organize_star_fleets():
	this_star_fleets_ordered.clear()
	# 整理star_fleets(第一阶段)
	for camp in defined_camp_ids:
		var camp_ship_number : int = 0
		for this_star_fleet in this_star_fleets:
			if this_star_fleet["camp_id"] == camp and this_star_fleet["ship_number"] != 0:
				camp_ship_number += this_star_fleet["ship_number"]
		if camp_ship_number > 0:
			this_star_fleets_ordered.append([camp, camp_ship_number])
	# 检验star_fleets(第二阶段)
	#$WarningUI/ScrollContainer/WarningText.text = ""
	for i in range(this_star_fleets_ordered.size() - 1, -1, -1):
		if this_star_fleets_ordered[i][1] > 2147483647 or this_star_fleets_ordered[i][1] < 0:
			this_star_fleets_ordered.remove_at(i)

# 计算飞船数量点位位置
func calculate_positions() -> Array :
	var ship_number_positions : Array
	var relative_star_position = $ConfigureStarShipUIRect/StarShipPreview/ContainStar.position - $ConfigureStarShipUIRect/StarShipPreview/ShipNumberLabels.position
	if valid_camps_number == 0:
		return ship_number_positions
	elif valid_camps_number == 1:
		var ship_number_position : Vector2
		# 天体中心相对节点(ShipNumberLabels)的位置 = ContainStar位置 - ShipNumberLabels位置
		ship_number_position = relative_star_position + Vector2(0, 79.0/2.0)# /2要换成scale
		ship_number_positions.append(ship_number_position)
		return ship_number_positions
	elif valid_camps_number == 2:
		var ship_number_position1 : Vector2
		var ship_number_position2 : Vector2
		ship_number_position1 = relative_star_position + Vector2(0, 150.0/2)# /2要换成scale
		ship_number_position2 = relative_star_position - Vector2(0, 150.0/2)# /2要换成scale
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

# 生成飞船数量标签
func add_star_ship_labels(ship_number_positions):
	var index : int = -1
	for this_star_fleet_ordered in this_star_fleets_ordered:
		if this_star_fleet_ordered[0] != 0:
			index += 1
			var ship_number_label = Label.new()
			var camp_ship_number = this_star_fleet_ordered[1]
			var camp = this_star_fleet_ordered[0]
			var camp_ship_number_showed : String
			if camp_ship_number < 10000000:
				camp_ship_number_showed = str(camp_ship_number)# int
			else:
				camp_ship_number_showed = String.num_scientific(camp_ship_number)
			ship_number_label.text = camp_ship_number_showed
			ship_number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			ship_number_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			$ConfigureStarShipUIRect/StarShipPreview/ShipNumberLabels.add_child(ship_number_label)
			ship_number_label.add_theme_color_override("font_color", camp_colors[camp])
			ship_number_label.position = ship_number_positions[index] - ship_number_label.size/2

# 更新天体预览
func update_star_preview():
	var star_preview : Sprite2D = null
	if (
			star_container.get_child_count() == 1
			and star_container.get_child(0) is Sprite2D
	):
		star_preview = star_container.get_child(0)
	else:
		push_error("天体飞船配置界面的天体贴图配置有问题!")
		return
	star_preview.texture = star_pattern_dictionary[chosen_star.pattern_name]
	star_preview.offset = chosen_star.offset_fix
	
	# 获得飞船数量点位位置
	var ship_number_positions : Array = calculate_positions()
	# 清除已有的飞船数量标签
	if $ConfigureStarShipUIRect/StarShipPreview/ShipNumberLabels.get_child_count() != 0:
		for i in $ConfigureStarShipUIRect/StarShipPreview/ShipNumberLabels.get_children():
			i.queue_free()
	# 生成飞船数量标签
	add_star_ship_labels(ship_number_positions)
	# 画环
	var halo_arguments = calculate_halo_arguments()
	draw_halo(halo_arguments, valid_camps_number)

# 更新天体舰队列表
func update_star_fleets_list():
	# 清除已有的天体舰队标签
	for i in $StarFleetsUI/StarFleetsListScrollContainer/StarFleetsListVBoxContainer.get_children():
			i.queue_free()
	# 生成天体舰队列表
	for this_star_fleet in this_star_fleets:
		if this_star_fleet["ship_number"] >= 0:
			# 添加文字
			var star_fleet_text : String = " 飞船数: %s ; 阵营id: %s ; 阵营颜色:" % [this_star_fleet["ship_number"], this_star_fleet["camp_id"]]
			var star_fleet_information_unit_node = star_fleet_information_unit.instantiate()
			$StarFleetsUI/StarFleetsListScrollContainer/StarFleetsListVBoxContainer.add_child(star_fleet_information_unit_node)
			star_fleet_information_unit_node.get_child(1).text = star_fleet_text
			
			var star_fleet_camp_color_stylebox_d : StyleBoxFlat = load("res://Resources/StyleBoxes/show_camp_color_style_box_flat.tres")
			star_fleet_camp_color_stylebox_d = star_fleet_camp_color_stylebox_d.duplicate()
			# Stylebox设置
			var star_fleet_camp_color_stylebox = StyleBoxFlat.new()
			star_fleet_camp_color_stylebox.bg_color = camp_colors[this_star_fleet["camp_id"]]
			star_fleet_camp_color_stylebox.border_width_left = 2
			star_fleet_camp_color_stylebox.border_width_top = 2
			star_fleet_camp_color_stylebox.border_width_right = 2
			star_fleet_camp_color_stylebox.border_width_bottom = 2
			star_fleet_camp_color_stylebox.border_color = Color.WHITE
			star_fleet_camp_color_stylebox.corner_radius_top_left = 2
			star_fleet_camp_color_stylebox.corner_radius_top_right = 2
			star_fleet_camp_color_stylebox.corner_radius_bottom_left = 2
			star_fleet_camp_color_stylebox.corner_radius_bottom_right = 2
			star_fleet_information_unit_node.get_child(2).add_theme_stylebox_override("panel", star_fleet_camp_color_stylebox)
			
			star_fleet_information_unit_node.star_fleet_with_self = [this_star_fleet, star_fleet_information_unit_node]
			star_fleet_information_unit_node.delelte_star_fleet.connect(_delelte_star_fleet)

# 删除舰队
func _delelte_star_fleet(star_fleet_with_self):
	var star_fleet_index = star_fleet_with_self[1].get_index()
	this_star_fleets.remove_at(star_fleet_index)
	organize_star_fleets()
	update_valid_camps_number()
	update_star_preview()
	update_star_fleets_list()

# 按起添加天体舰队按钮
func _on_add_star_fleet_button_button_up():
	var ship_number : int = int($ConfigureStarShipUIRect/AddStarFleetUI/StarFleetShipNumberLabel/StarFleetShipNumberInput.text)
	var ships_camp : int = int($ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInput.text)
	this_star_fleets.append([ships_camp, ship_number])
	organize_star_fleets()
	update_valid_camps_number()
	update_star_preview()
	update_star_fleets_list()

# 将舰队阵营的两个输入方式绑定
# 舰队阵营输入框修正
func _on_star_fleet_ship_camp_input_text_changed(new_text):
	if int(new_text) >= 0 and int(new_text) in defined_camp_ids:
		$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInputOptionButton.select(int(new_text))
	elif int(new_text) >= 0 and int(new_text) not in defined_camp_ids:
		$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInputOptionButton.select(defined_camp_ids[-1]+1)
	else:
		$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInputOptionButton.select(0)
	if int(new_text) < 0 or int(new_text) > 2147483647:
		$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInput.text = "0"

func _on_star_fleet_ship_camp_input_option_button_item_selected(index):
	$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInput.text = $ConfigureStarShipUIRect/AddStarFleetUI/StarFleetCampLabel/StarFleetShipCampInputOptionButton.get_item_text(index)

# 舰队信息输入框内容修正
# 舰队飞船数量输入框修正
func _on_star_fleet_ship_number_input_text_changed(new_text):
	if int(new_text) < 0 or int(new_text) > 2147483647:
		$ConfigureStarShipUIRect/AddStarFleetUI/StarFleetShipNumberLabel/StarFleetShipNumberInput.text = "0"

# 按起离开编辑天体舰队界面按钮
func _on_leave_configure_star_ship_ui_button_button_up():
	chosen_star.this_star_fleets = this_star_fleets_ordered
	MapEditorSharedData.data_updated("chosen_star", chosen_star)
	queue_free()

# 计算环的参数
func calculate_halo_arguments() -> Array:
	var halo_arguments : Array
	# 从PI/2开始先顺时针转半个步进角度，再逆时针开始画
	var ship_number_summed : int = 0
	for this_star_fleet_ordered in this_star_fleets_ordered:
		if this_star_fleet_ordered[0] != 0:
			ship_number_summed += this_star_fleet_ordered[1]
	var radian_element = TAU/ship_number_summed
	var last_end_radian : float
	var times : int = 0
	for this_star_fleet_ordered in this_star_fleets_ordered:
		if this_star_fleet_ordered[0] != 0:
			times += 1
			var halo_argument : Array
			var step_radian : float = this_star_fleet_ordered[1] * radian_element
			var halo_start_radian : float
			if times == 1:
				if valid_camps_number == 2:
					halo_start_radian = PI * 3/2 - step_radian/2
				else:
					halo_start_radian = PI/2 - step_radian/2
			else:
				halo_start_radian = last_end_radian
			var halo_end_radian : float = halo_start_radian + step_radian
			var halo_arc_color : Color = camp_colors[this_star_fleet_ordered[0]]
			halo_argument.append(halo_start_radian)
			halo_argument.append(halo_end_radian)
			halo_argument.append(halo_arc_color)
			last_end_radian = halo_end_radian
			halo_arguments.append(halo_argument)
	return halo_arguments

# 画环
func draw_halo(halo_arguments : Array, camps_number : int):
	#if halo_drawer != null:
		#halo_drawer.queue_free()
	#var halo_drawing_center_node = halo_drawing_center.instantiate()
	#$ConfigureStarShipUIRect/StarShipPreview.add_child(halo_drawing_center_node)
	#halo_drawing_center_node.halo_arguments = halo_arguments
	#halo_drawing_center_node.camps_number = camps_number
	#halo_drawing_center_node.position = $ConfigureStarShipUIRect/StarShipPreview/ContainStar.position
	#halo_drawing_center_node.queue_redraw()
	#halo_drawer = halo_drawing_center_node
	halo_drawer.halo_arguments = halo_arguments
	halo_drawer.camps_number = camps_number
	halo_drawer.position = star_container.position
	halo_drawer.queue_redraw()


func update_valid_camps_number():
	var valid_camps_number_process : int = 0
	for i in this_star_fleets_ordered:
		if i[0] != 0:
			if i[1] != 0:
				valid_camps_number_process += 1
	valid_camps_number = valid_camps_number_process
