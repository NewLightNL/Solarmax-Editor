extends SpinBox

var editor_type : EditorType


func _ready() -> void:
	_pull_map_editor_shared_information()


func _pull_map_editor_shared_information() -> void:
	editor_type = MapEditorSharedData.editor_type


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"editor_type":
			editor_type = MapEditorSharedData.editor_type


func initialize_star_f_angle_input_spin_box(star : Star) -> void:
	if editor_type is NewExpedition:
		editor_type.obey_rotation_rule(star, self, editor_type.OperationType.SET_VALUE)
	else:
		pass
