extends OptionButton

var stars_dictionary : Dictionary[String, Dictionary]


func _ready() -> void:
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_information() -> void:
	stars_dictionary = MapEditorSharedData.stars_dictionary


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"stars_dictionary":
			stars_dictionary = MapEditorSharedData.stars_dictionary


func initialize_size_input_option_button(star : Star):
	clear()
	
	var type_stars : Dictionary[int, Star] = stars_dictionary[star.type]
	if type_stars.size() != 0:
		for size_type in type_stars:
			add_item(str(size_type), size_type)
		var star_index = get_item_index(star.size_type)
		select(star_index)


func update_star_size_input_option_button(map_node_star : MapNodeStar):
	var map_node_star_index : int = get_item_index(map_node_star.size_type)
	select(map_node_star_index)
