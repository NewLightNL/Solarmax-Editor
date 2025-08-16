extends OptionButton


var orbit_types : Dictionary[int, String]


func _ready() -> void:
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_information() -> void:
	orbit_types = MapEditorSharedData.orbit_types


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"orbit_types":
			orbit_types = MapEditorSharedData.orbit_types


func initialize_orbit_type_option_button():
	clear()
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
		add_item(orbit_name, star_orbit_type_id)
	select(0)
