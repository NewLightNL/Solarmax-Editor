extends Control

signal star_orbit_type_changed(star_orbit_type : String)

var orbit_types : Dictionary[int, String]
var chosen_star : MapNodeStar


@onready var orbit_type_input_option_button : OptionButton = $OrbitTypeInputOptionButton


func _ready() -> void:
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_information() -> void:
	orbit_types = MapEditorSharedData.orbit_types
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"orbit_types":
			orbit_types = MapEditorSharedData.orbit_types
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star


func initialize_orbit_type_option_button():
	orbit_type_input_option_button.clear()
	for star_orbit_type_id in orbit_types:
		var orbit_type : String = orbit_types[star_orbit_type_id]
		var orbit_name : String = ""
		match orbit_type:
			"no_orbit":
				orbit_name = "无轨道"
			"circle":
				orbit_name = "圆形轨道"
			"triangle":
				orbit_name = "三角形轨道"
			"quadrilateral":
				orbit_name = "正方形轨道"
			"ellipse":
				orbit_name = "椭圆轨道"
			_:
				push_error("天体轨道类型信息出错!")
		orbit_type_input_option_button.add_item(orbit_name, star_orbit_type_id)
	orbit_type_input_option_button.select(0)
	chosen_star.orbit_type = "no_orbit"


func lock_ui():
	orbit_type_input_option_button.disabled = true


func unlock_ui():
	orbit_type_input_option_button.disabled = false


func update_orbit_type_option_button(map_node_star : MapNodeStar):
	var orbit_id : int = orbit_types.find_key(map_node_star.orbit_type)
	var index : int = orbit_type_input_option_button.get_item_index(orbit_id)
	orbit_type_input_option_button.select(index)


func _on_orbit_type_input_option_button_item_selected(index: int) -> void:
	var orbit_type : String = orbit_types[int(index)]
	emit_signal("star_orbit_type_changed", orbit_type)
