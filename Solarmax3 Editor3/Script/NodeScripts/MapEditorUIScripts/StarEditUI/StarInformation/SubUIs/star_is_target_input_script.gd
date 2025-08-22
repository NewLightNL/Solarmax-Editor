extends Control


signal is_target_state_changed(is_target_state : bool)


var chosen_star : MapNodeStar
var editor_type : EditorType


@onready var is_target_check_input_check_button : CheckButton = $IsTargetInputCheckButton


func _ready() -> void:
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_information() -> void:
	chosen_star = MapEditorSharedData.chosen_star
	editor_type = MapEditorSharedData.editor_type


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star
		"editor_type":
			editor_type = MapEditorSharedData.editor_type


func lock_ui():
	is_target_check_input_check_button.disabled = true


func unlock_ui():
	is_target_check_input_check_button.disabled = false


func initialize_is_target_node_check_button() -> void:
	is_target_check_input_check_button.button_pressed = false
	chosen_star.is_taget = false


func update_is_target_node_check_button(map_node_star : MapNodeStar):
	is_target_check_input_check_button.button_pressed = map_node_star.is_taget


func _on_is_target_input_check_button_button_up() -> void:
	if chosen_star.is_taget == true:
		is_target_check_input_check_button.button_pressed = false
		chosen_star.is_taget = false
		emit_signal("is_target_state_changed", false)
	else:
		is_target_check_input_check_button.button_pressed = true
		chosen_star.is_taget = true
		emit_signal("is_target_state_changed", true)
