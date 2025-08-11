extends Control

const UISTANDARDSIZE : Vector2 = Vector2(231.0, 231.0)
var camp_colors : Dictionary
@onready var star_fleet_labels_control : Control = $StarFleetLabels

func _ready() -> void:
	_pull_map_editor_shared_data()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_data():
	camp_colors = MapEditorSharedData.camp_colors


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"camp_colors":
			camp_colors = MapEditorSharedData.camp_colors


func update_star_ui(star_scale : float, this_star_fleets : Array[Dictionary]):
	_update_star_ui_rect(star_scale)
	_update_star_fleets_label(this_star_fleets, star_scale)


func _update_star_ui_rect(star_scale : float):
	self.position = -(UISTANDARDSIZE / 2) * star_scale
	self.size = UISTANDARDSIZE * star_scale

# 计算与生成应该分开
func _update_star_fleets_label(
		this_star_fleets_info : Array[Dictionary],
		star_scale : float,
):
	this_star_fleets_info = FleetsInformationValidator.validate_star_fleets_dictionaries_array(
			this_star_fleets_info,
			FleetsInformationValidator.FilterFlags.FILTER_CAMP_ZERO_AND_SHIP_NUMBER_ZERO
	)
	
	# 了解舰队信息
	var camp_ids : Array[int] = FleetsInformationGetter.get_star_fleets_dictionaries_campids(this_star_fleets_info)
	
	var relative_to_star_position : Vector2 = -self.position - star_fleet_labels_control.position
	# 计算飞船点位
	var ship_number_positions : Array[Vector2] = LabelPositionsCalculator.calculate_label_positions(
			camp_ids,
			star_scale,
			relative_to_star_position,
	)
	
	star_fleet_labels_control.add_ship_number_labels(
		ship_number_positions,
		this_star_fleets_info,
	)
	

class LabelPositionsCalculator:
	const ONE_CAMP_STANDARD_DISTANCE : float = 79.0
	const MULTI_CAMPS_STANDARD_DISTANCE : float = 150.0
	
	static func calculate_label_positions(
			camp_ids : Array[int],
			star_scale : float,
			origin_position : Vector2,
	) -> Array[Vector2]:
		var ship_number_positions : Array[Vector2] = []
		# 天体中心相对节点(ShipNumberLabels)的位置 = - ShipNumberLabels位置 - StarUI位置
		if camp_ids.size() <= 0:
			ship_number_positions = []
		elif camp_ids.size() == 1:
			var ship_number_position : Vector2 = origin_position + Vector2(0, ONE_CAMP_STANDARD_DISTANCE) * star_scale
			ship_number_positions.append(ship_number_position)
		elif camp_ids.size() == 2:
			var ship_number_position1 : Vector2 = origin_position + Vector2(0, MULTI_CAMPS_STANDARD_DISTANCE) * star_scale
			var ship_number_position2 : Vector2 = origin_position - Vector2(0, MULTI_CAMPS_STANDARD_DISTANCE) * star_scale
			ship_number_positions.append(ship_number_position1)
			ship_number_positions.append(ship_number_position2)
		else:
			var radian_divided = TAU / camp_ids.size()
			for i in range(camp_ids.size()):
				var ship_number_position : Vector2
				var relative_ship_number_position : Vector2 = Vector2(
						cos(PI/2 + radian_divided * i),
						-sin(PI/2 + radian_divided * i)
				) * MULTI_CAMPS_STANDARD_DISTANCE / star_scale
				ship_number_position = origin_position + relative_ship_number_position
				ship_number_positions.append(ship_number_position)
		return ship_number_positions
