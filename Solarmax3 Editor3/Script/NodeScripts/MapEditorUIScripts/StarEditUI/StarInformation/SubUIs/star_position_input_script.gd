extends Control

signal star_position_changed(star_position : Vector2)

var chosen_star : MapNodeStar


@onready var x_input_spin_box : SpinBox = $XInputControl/XInputSpinBox
@onready var y_input_spin_box : SpinBox = $YInputControl/YInputSpinBox


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


func lock_ui():
	x_input_spin_box.editable = false
	y_input_spin_box.editable = false


func unlock_ui():
	x_input_spin_box.editable = true
	y_input_spin_box.editable = true


func initialize_map_node_star_position_input():
	x_input_spin_box.value = 0.0
	y_input_spin_box.value = 0.0
	chosen_star.star_position = Vector2(0.0, 0.0)


func update_map_node_star_position_input(map_node_star : MapNodeStar):
	var star_position : Vector2 = map_node_star.star_position
	x_input_spin_box.value = star_position.x
	y_input_spin_box.value = star_position.y


func _on_x_input_spin_box_value_changed(value: float) -> void:
	var star_position_x_coordinate : float = value
	var star_position_y_coordinate : float = y_input_spin_box.value
	var star_position : Vector2 = Vector2(star_position_x_coordinate, star_position_y_coordinate)
	emit_signal("star_position_changed", star_position)


func _on_y_input_spin_box_value_changed(value: float) -> void:
	var star_position_x_coordinate : float = x_input_spin_box.value
	var star_position_y_coordinate : float = value
	var star_position : Vector2 = Vector2(star_position_x_coordinate, star_position_y_coordinate)
	emit_signal("star_position_changed", star_position)
