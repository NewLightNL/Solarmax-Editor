extends Marker2D

const STAR_STANDARD_WIDTH : float = 231.0

var camp_colors : Dictionary
var _is_to_draw_halo : bool = false
var _halo_radius : float
var _halo_arguments : Array
# halo_argument = [起始弧度, 终止弧度, 颜色]
# 可能要改为{radian_info : [起始弧度, 终止弧度], arc_color : ...}?

# 要修改读取天体舰队方式 
func _ready() -> void:
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	_pull_map_editor_shared_data()


func _pull_map_editor_shared_data():
	camp_colors = MapEditorSharedData.camp_colors


# draw_arc(center: Vector2, radius: float, start_angle: float, end_angle: float, point_count: int, color: Color, width: float = -1.0, antialiased: bool = false)
func _draw():
	if _is_to_draw_halo == true:
		# draw_arc()函数是顺时针画弧的
		for halo_argument in _halo_arguments:
			draw_arc(Vector2(0, 0), _halo_radius, -halo_argument[0], -halo_argument[1], 128, halo_argument[2], 1, true)


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	match key:
		"camp_colors":
			camp_colors = MapEditorSharedData.camp_colors


func draw_halo(this_star_fleets_info : Array[Dictionary], star_scale_info : float) -> void:
	_halo_radius = (STAR_STANDARD_WIDTH - 3)/ 2 * star_scale_info
	_process_halo_arguments(this_star_fleets_info)
	self.queue_redraw()


func _process_halo_arguments(this_star_fleets_info : Array[Dictionary]) -> void:
	this_star_fleets_info = FleetsInformationValidator.validate_star_fleets_dictionaries_array(
			this_star_fleets_info,
			FleetsInformationValidator.FilterFlags.FILTER_CAMP_ZERO_AND_SHIP_NUMBER_ZERO
	)
	
	# 如果没有阵营有飞船或者只有一个阵营有飞船，就不画环
	if this_star_fleets_info.size() <= 1:
		_is_to_draw_halo = false
		return
	else:
		_is_to_draw_halo = true
	# 处理画环
	var halo_arguments : Array
	# 从PI/2开始先顺时针转半个步进角度，再逆时针开始画
	var total_ship_number = FleetsInformationGetter.get_total_ship_number_from_star_fleets_dictionaries_array(this_star_fleets_info)
	var radian_element = TAU / total_ship_number
	var last_end_radian : float = 0.0
	#var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
	var camp_ids : Array[int] = FleetsInformationGetter.get_star_fleets_dictionaries_campids(this_star_fleets_info)
	# 看该阵营在阵营id中的排序
	var index : int = 0
	for camp_id in camp_ids:
		index += 1
		var halo_argument : Array
		var halo_start_radian : float
		var ship_number : int = FleetsInformationGetter.get_camp_ship_number_from_fleets_dictionaries_array(
				camp_id,
				this_star_fleets_info,
		)
		var step_radian : float = ship_number * radian_element
		# 设置起始弧度
		if camp_ids.size() == 2:
			if index == 1:
				halo_start_radian = PI * 3/2 - step_radian/2
			elif index == 2:
				halo_start_radian = last_end_radian
			else:
				push_error("舰队阵营index出错!超出了范围!")
		elif camp_ids.size() >= 3:
			if index == 1:
				halo_start_radian = PI/2 - step_radian/2
			else:
				halo_start_radian = last_end_radian
		else:
			push_error("舰队阵营数量有问题!")
		var halo_end_radian : float = halo_start_radian + step_radian
		var halo_arc_color : Color = camp_colors[camp_id]
		halo_argument.append(halo_start_radian)
		halo_argument.append(halo_end_radian)
		halo_argument.append(halo_arc_color)
		last_end_radian = halo_end_radian
		halo_arguments.append(halo_argument)
	
	_halo_arguments = halo_arguments
