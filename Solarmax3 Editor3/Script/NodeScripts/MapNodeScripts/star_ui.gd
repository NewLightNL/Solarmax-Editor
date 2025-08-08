extends Control

const UISTANDARDSIZE : Vector2 = Vector2(231.0, 231.0)
var camp_colors : Dictionary

func _ready() -> void:
	_pull_map_editor_shared_data()
	Mapeditor1ShareData.editor_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_data():
	camp_colors = Mapeditor1ShareData.camp_colors


func _on_global_data_updated(key : String) -> void:
	var valid_keys : Array[String] = [
		"camp_colors",
		"star_fleets",
		"chosen_star",
		"is_star_chosen",
		"star_fleets",
		"stars_dictionary",
		"defined_camp_ids",
		"star_pattern_dictionary",
		"stars",
		"orbit_types",
		"all_basic_information",
	]
	var is_key_valid : bool = false
	for valid_key in valid_keys:
		if valid_key == key:
			is_key_valid = true
			break
	if is_key_valid == false:
		push_error("数据更新的键有问题!")
		return
	match key:
		"camp_colors":
			camp_colors = Mapeditor1ShareData.camp_colors


func update_star_ui(star_scale : float, this_star_fleets : Array[Dictionary]):
	_update_star_ui_rect(star_scale)
	_update_star_fleets_label(this_star_fleets)


func _update_star_ui_rect(star_scale : float):
	self.position = -(UISTANDARDSIZE / 2) * star_scale
	self.size = UISTANDARDSIZE * star_scale

# 计算与生成应该分开
func _update_star_fleets_label(this_star_fleets_info : Array[Dictionary]):
	# 检验传入参数
	for this_star_fleet in this_star_fleets_info:
		if (
				not this_star_fleet.has("camp_id")
				or not this_star_fleet.has("ship_number")
		):
			push_error("环参数缺键!")
			return
		else:
			if (
					this_star_fleet["camp_id"] is not int
					or this_star_fleet["ship_number"] is not int
			):
				push_error("环参数内容有问题!")
				return
			else:
				if (
						this_star_fleet["ship_number"] > 2147483647
						or this_star_fleet["ship_number"] < 0
				):
					push_error("campid为%sd的舰队数量有问题!" % this_star_fleet["camp_id"])
					return
	
	
	# 了解舰队信息
	var camps_having_ship_id_sorted : Array[int] = []
	for this_star_fleet in this_star_fleets_info:
		if (
				this_star_fleet["camp_id"] != 0
				and this_star_fleet["ship_number"] > 0
		):
			camps_having_ship_id_sorted.append(this_star_fleet["ship_number"])
			camps_having_ship_id_sorted.sort()
	
	# 整理舰队信息(只会得到阵营id不为0且有飞船的舰队)
	var this_star_fleets_sorted : Array[Dictionary]
	for index in camps_having_ship_id_sorted:
		var this_star_fleet : Dictionary
		this_star_fleet["camp_id"] = index
		for this_star_fleet_info in this_star_fleets_info:
			if this_star_fleet_info["camp_id"] == index:
				if not this_star_fleet.has("ship_number"):
					this_star_fleet["ship_number"] = this_star_fleet_info["camp_id"]
				else:
					this_star_fleet["ship_number"] += this_star_fleet_info["camp_id"]
		this_star_fleets_sorted.append(this_star_fleet)
	# 获取有多少非id为0且有飞船的阵营
	var camps_having_ship_number : int = camps_having_ship_id_sorted.size()
	
	# 计算飞船点位
	var ship_number_positions : Array = []
	# 天体中心相对节点(ShipNumberLabels)的位置 = MapNodeStar位置 - ShipNumberLabels位置
	var relative_star_position = Vector2(0, 0) - self.position
	if camps_having_ship_number == 0:
		ship_number_positions = []
	elif camps_having_ship_number == 1:
		var ship_number_position : Vector2
		ship_number_position = relative_star_position + Vector2(0, 79.0) * self.star_scale
		ship_number_positions.append(ship_number_position)
	elif camps_having_ship_number == 2:
		var ship_number_position1 : Vector2
		var ship_number_position2 : Vector2
		ship_number_position1 = relative_star_position + Vector2(0, 150.0) * self.star_scale
		ship_number_position2 = relative_star_position - Vector2(0, 150.0) * self.star_scale
		ship_number_positions.append(ship_number_position1)
		ship_number_positions.append(ship_number_position2)
	else:
		var radian_divided = TAU / camps_having_ship_number
		for i in range(camps_having_ship_number):
			var ship_number_position : Vector2
			var relative_ship_number_position : Vector2
			relative_ship_number_position = Vector2(cos(PI/2 + radian_divided * i), -sin(PI/2 + radian_divided * i)) * 150.0/2# /2要换成scale
			ship_number_position = relative_star_position + relative_ship_number_position
			ship_number_positions.append(ship_number_position)
	
	var index : int = -1
	for this_star_fleet in this_star_fleets_sorted:
		if this_star_fleet["camp_id"] != 0:
			index += 1
			var ship_number_label = Label.new()
			var camp_ship_number = this_star_fleet["ship_number"]
			var camp = this_star_fleet["camp_id"]
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
	
