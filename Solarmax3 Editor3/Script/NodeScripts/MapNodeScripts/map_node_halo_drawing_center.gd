extends Marker2D

const STAR_STANDARD_WIDTH : float = 231.0

var camp_colors : Dictionary
var _is_to_draw_halo : bool = false
var _halo_radius : float
var _halo_arguments : Array
# halo_argument = [起始弧度, 终止弧度, 颜色]
# 可能要改为{radian_info : [起始弧度, 终止弧度], arc_color : ...}?


func _ready() -> void:
	Mapeditor1ShareData.editor_data_updated.connect(_on_global_data_updated)
	camp_colors = Mapeditor1ShareData.camp_colors


# draw_arc(center: Vector2, radius: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = -1.0, antialiased: bool = false)
func _draw():
	if _is_to_draw_halo == true:
		# draw_arc()函数是顺时针画弧的
		for halo_argument in _halo_arguments:
			draw_arc(Vector2(0, 0), _halo_radius, -halo_argument[0], -halo_argument[1], 128, halo_argument[2], 1, true)


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


func draw_halo(this_star_fleets_info : Array, star_scale_info : float) -> void:
	_halo_radius = (STAR_STANDARD_WIDTH - 3)/ 2 * star_scale_info
	_process_halo_arguments(this_star_fleets_info)
	self.queue_redraw()


func _process_halo_arguments(this_star_fleets_info : Array[Dictionary]) -> void:
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
	var ship_number_summed : int = 0
	var camps_having_ship_id_sorted : Array[int] = []
	for this_star_fleet in this_star_fleets_info:
		if (
				this_star_fleet["camp_id"] != 0
				and this_star_fleet["ship_number"] > 0
		):
			ship_number_summed += this_star_fleet["ship_number"]
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
	# 如果没有阵营有飞船或者只有一个阵营有飞船，就不画环
	if (
			camps_having_ship_id_sorted.size() <= 0
			or camps_having_ship_id_sorted.size() == 1
	):
		_is_to_draw_halo = false
		return
	else:
		_is_to_draw_halo = true
	# 处理画环
	var halo_arguments : Array
	# 从PI/2开始先顺时针转半个步进角度，再逆时针开始画
	var radian_element = TAU/ship_number_summed
	var last_end_radian : float = 0.0
	for this_star_fleet in this_star_fleets_info:
		if this_star_fleet["camp_id"] != 0:
			var halo_argument : Array
			var halo_start_radian : float
			var step_radian : float = this_star_fleet["ship_number"] * radian_element
			# 看该阵营在阵营id中的排序
			var index : int = 0
			for campid in camps_having_ship_id_sorted:
				index += 1
				if campid == this_star_fleet["camp_id"]:
					break
			# 设置起始弧度
			if camps_having_ship_id_sorted.size() == 2:
				if index == 1:
					halo_start_radian = PI * 3/2 - step_radian/2
				elif index == 2:
					halo_start_radian = last_end_radian
				else:
					push_error("舰队阵营index出错!超出了范围!")
			elif camps_having_ship_id_sorted.size() >= 3:
				if index == 1:
					halo_start_radian = PI/2 - step_radian/2
				else:
					halo_start_radian = last_end_radian
			else:
				push_error("舰队阵营数量有问题!")
			var halo_end_radian : float = halo_start_radian + step_radian
			var halo_arc_color : Color = camp_colors[this_star_fleet["camp_id"]]
			halo_argument.append(halo_start_radian)
			halo_argument.append(halo_end_radian)
			halo_argument.append(halo_arc_color)
			last_end_radian = halo_end_radian
			halo_arguments.append(halo_argument)
	_halo_arguments = halo_arguments
