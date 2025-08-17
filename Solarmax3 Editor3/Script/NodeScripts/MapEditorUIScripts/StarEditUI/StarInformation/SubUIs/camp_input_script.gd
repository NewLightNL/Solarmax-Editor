extends Label

var defined_camp_ids : Array[int]
var chosen_star : MapNodeStar


@onready var star_camp_input_spin_box : SpinBox = $StarCampInputSpinBox
@onready var star_camp_input_option_button : OptionButton = $StarCampInputOptionButton


func _ready() -> void:
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_information() -> void:
	defined_camp_ids = MapEditorSharedData.defined_camp_ids
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"defined_camp_ids":
			defined_camp_ids = MapEditorSharedData.defined_camp_ids
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star


func initialize_camp_input_ui():
	star_camp_input_option_button.clear()
	if defined_camp_ids.size() != 0:
		for i in defined_camp_ids:
			star_camp_input_option_button.add_item(str(i), i)
		star_camp_input_option_button.add_item("?", defined_camp_ids[-1]+1)
		star_camp_input_option_button.set_item_disabled(defined_camp_ids[-1]+1, true)
		
		star_camp_input_option_button.select(0)
		star_camp_input_spin_box.value = 0
		chosen_star.star_camp = 0


func uptdate_camp_input_ui(map_node_star : MapNodeStar):
	star_camp_input_option_button.select(map_node_star.star_camp)
	star_camp_input_spin_box.value = map_node_star.star_camp


		#if chosen_star.star_camp in defined_camp_ids:
			#star_camp_input_option_button.select(chosen_star.star_camp)
		#else:
			#star_camp_input_option_button.select(defined_camp_ids[-1]+1)
		#star_camp_input_spinbox.value = chosen_star.star_camp
