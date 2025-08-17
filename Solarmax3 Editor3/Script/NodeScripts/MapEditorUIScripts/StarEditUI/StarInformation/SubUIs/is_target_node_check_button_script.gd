extends CheckButton


var chosen_star : MapNodeStar


func _ready() -> void:
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_information() -> void:
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star


func initialize_is_target_node_check_button() -> void:
	button_pressed = false
	chosen_star.is_taget = false
