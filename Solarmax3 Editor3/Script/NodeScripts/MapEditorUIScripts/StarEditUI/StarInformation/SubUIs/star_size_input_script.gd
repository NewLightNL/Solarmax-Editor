extends Control

signal star_size_changed(star_size_type : int)

var stars_dictionary : Dictionary[String, Dictionary]
var chosen_star : MapNodeStar


@onready var star_size_input_option_button : OptionButton = $StarSizeInputOptionButton


func _ready() -> void:
	star_size_input_option_button.clear()
	
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_information() -> void:
	stars_dictionary = MapEditorSharedData.stars_dictionary
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"stars_dictionary":
			stars_dictionary = MapEditorSharedData.stars_dictionary
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star


func lock_ui():
	star_size_input_option_button.disabled = true


func unlock_ui():
	star_size_input_option_button.disabled = false


func initialize_size_input_option_button(star : Star):
	star_size_input_option_button.clear()
	
	var type_stars : Dictionary[int, Star] = stars_dictionary[star.type]
	if type_stars.size() != 0:
		for size_type in type_stars:
			star_size_input_option_button.add_item(str(size_type), size_type)
		var star_index = star_size_input_option_button.get_item_index(star.size_type)
		star_size_input_option_button.select(star_index)


func update_star_size_input_option_button(map_node_star : MapNodeStar):
	initialize_size_input_option_button(map_node_star)
	var map_node_star_index : int = star_size_input_option_button.get_item_index(map_node_star.size_type)
	star_size_input_option_button.select(map_node_star_index)


func _on_star_size_input_option_button_item_selected(index: int) -> void:
	var size_types : Array[int] = stars_dictionary[chosen_star.type].keys()
	var size_type_chosen : int = int(star_size_input_option_button.get_item_text(index))
	var size_type_index : int = size_types.find(size_type_chosen)
	var star_size_type : int = size_types[size_type_index]
	emit_signal("star_size_changed", star_size_type)
