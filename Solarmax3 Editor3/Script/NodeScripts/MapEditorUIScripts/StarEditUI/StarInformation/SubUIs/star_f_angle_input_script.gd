extends Control

signal star_f_angle_changed(star_f_angle : float)

var editor_type : EditorType
var chosen_star : MapNodeStar


@onready var star_f_angle_input : SpinBox = $StarFAngleInput


func _ready() -> void:
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_information() -> void:
	editor_type = MapEditorSharedData.editor_type
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"editor_type":
			editor_type = MapEditorSharedData.editor_type
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star


func lock_ui():
	star_f_angle_input.editable = false


func unlock_ui():
	star_f_angle_input.editable = true


func initialize_star_f_angle_input_spin_box(star : Star) -> void:
	if editor_type is NewExpedition:
		editor_type.obey_dirt_star_rotation_rule(star, star_f_angle_input, editor_type.OperationType.SET_VALUE)
	else:
		pass


func update_star_f_angle_input_spin_box(map_node_star : MapNodeStar):
	if editor_type is NewExpedition:
		editor_type.obey_dirt_star_rotation_rule(map_node_star, star_f_angle_input, editor_type.OperationType.SET_VALUE)
	else:
		pass


func _on_star_f_angle_input_value_changed(value: float) -> void:
	emit_signal("star_f_angle_changed", value)
