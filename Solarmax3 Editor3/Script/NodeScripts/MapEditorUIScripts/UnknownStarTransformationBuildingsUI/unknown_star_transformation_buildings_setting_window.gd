extends Window

signal unknown_star_transformBuildingID_information_changed(unknown_star_transformBuildingID_information_sent : Array[int])

var request_type : String = "UnknownStarTransformationBuildingsSetting"

var chosen_star : MapNodeStar

var initial_unknown_star_transformBuildingID_information : Array[int]

# 怎么解决这循环调用lasergun_angle→lasergun_anlge_setting_spin_box→lasergun_angle
var unknown_star_transformBuildingID_information : Array[int]:
	set(value):
		unknown_star_transformBuildingID_information = value
		var unknown_star_transformBuildingID_information_text : String = UnknownStarInformationTransformer.transform_unknown_star_information_from_array_to_text(unknown_star_transformBuildingID_information)
		unknown_star_transformBuildingID_setting_line_edit.text = unknown_star_transformBuildingID_information_text

@onready var unknown_star_transformBuildingID_setting_line_edit : LineEdit = $UnknownStarTransformationBuildingsSettingUI/UnknownStarTransformationBuildingsSettingControl/UnknownStarTransformationBuildingsSettingLineEdit

# lasergunAngle="" 表示射线炮的初始旋转角度。
# lasergunRotateSkip="" 表示射线炮的单次旋转角度。
# lasergunRange="" 表示射线炮的总旋转角度。
# 注意，如果想让射线炮不旋转，不可以在两个属性同时填0，因为0不能除以0。正确的填法是在lasergunRotateSkip=""中填写一个比lasergunRange=""中大的数字。


func _ready() -> void:
	position = Vector2(1200.0, 800.0)
	
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	
	_initialize_configure_lasergun_information_window_when_ready()


func _pull_map_editor_shared_information() -> void:
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String):
	if key == "chosen_star":
		chosen_star = MapEditorSharedData.chosen_star


func _initialize_configure_lasergun_information_window_when_ready() -> void:
	if chosen_star != null:
		if chosen_star.special_star_type == "UnknownStar":
			initial_unknown_star_transformBuildingID_information = chosen_star.transformBuildingID


func _on_unknown_star_transformation_buildings_setting_line_edit_text_changed(new_text: String) -> void:
	unknown_star_transformBuildingID_information = UnknownStarInformationGetter.get_unknown_star_information_from_text(new_text)
	emit_signal("unknown_star_transformBuildingID_information_changed", unknown_star_transformBuildingID_information)


func initialize_unknown_star_transformation_buildings_setting_window():
	initial_unknown_star_transformBuildingID_information = []


func update_unknown_star_transformation_buildings_setting_window(map_node_star : MapNodeStar):
	unknown_star_transformBuildingID_information = map_node_star.transformBuildingID
	emit_signal("unknown_star_transformBuildingID_information_changed", unknown_star_transformBuildingID_information)


class UnknownStarInformationGetter:
	static func get_unknown_star_information_from_text(text : String) -> Array[int]:
		var unknown_star_transform_building_id : Array[int] = []
		var text_split : Array[String] = text.split(",")
		for text_unit in text_split:
			if text_unit.is_valid_int():
				var id : int = int(text_unit)
				unknown_star_transform_building_id.append(id)
		return unknown_star_transform_building_id


class UnknownStarInformationTransformer:
	static func transform_unknown_star_information_from_array_to_text(unknown_star_information_array : Array[int]) -> String:
		var text : String = ""
		for id in unknown_star_information_array:
			text += str(id)
			text += ","
		text = text.left(-1)
		
		return text


func _on_close_requested() -> void:
	queue_free()
