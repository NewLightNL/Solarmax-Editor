extends ConfirmationDialog

signal star_orbit_information_changed(orbit_param1 : Vector2, orbit_param2 : Vector2)

var request_type : String = "OrbitSetting"

var chosen_star : MapNodeStar

var initial_orbit_settings : Dictionary[String, Vector2]

var star_position : Vector2 = Vector2.ZERO:
	set(value):
		star_position = value
		star_position_label.text = "天体坐标: (%s, %s)" % [star_position.x, star_position.y]
var orbit_parameter1 : Vector2 = Vector2.ZERO:
	set(value):
		orbit_parameter1 = value
		orbit_param1_x_input.value = value.x
		orbit_param1_y_input.value = value.y
var orbit_parameter2 : Vector2 = Vector2.ZERO:
	set(value):
		orbit_parameter2 = value
		orbit_param2_x_input.value = value.x
		orbit_param2_y_input.value = value.y

@onready var star_position_label : Label = $Control/StarPositionLabel
@onready var orbit_param1_x_input : SpinBox = $Control/OrbitParam1Label/x/x_input
@onready var orbit_param1_y_input : SpinBox= $Control/OrbitParam1Label/y/y_input
@onready var orbit_param2_x_input : SpinBox = $Control/OrbitParam2Label/x/x_input
@onready var orbit_param2_y_input : SpinBox= $Control/OrbitParam2Label/y/y_input


func _ready() -> void:
	get_cancel_button().button_up.connect(_on_canceled)
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	_initialize_orbit_settings_when_ready()


func _pull_map_editor_shared_information() -> void:
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String):
	if key == "chosen_star":
		chosen_star = MapEditorSharedData.chosen_star


func _initialize_orbit_settings_when_ready() -> void:
	if chosen_star != null:
		if self.visible == true:
			initial_orbit_settings = {
					"star_position" : chosen_star.star_position,
					"orbit_param1" : chosen_star.orbit_param1,
					"orbit_param2" : chosen_star.orbit_param2,
			}
			star_position = chosen_star.star_position
			orbit_parameter1 = chosen_star.orbit_param1
			orbit_parameter2 = chosen_star.orbit_param2


func initialize_orbit_setting_window():
	initial_orbit_settings = {
			"star_position" : Vector2.ZERO,
			"orbit_param1" : Vector2.ZERO,
			"orbit_param2" : Vector2.ZERO,
	}
	star_position = Vector2.ZERO
	orbit_parameter1 = Vector2.ZERO
	orbit_parameter2 = Vector2.ZERO


func update_orbit_setting_window(map_node_star : MapNodeStar):
	initial_orbit_settings = {
			"star_position" : map_node_star.star_position,
			"orbit_param1" : map_node_star.orbit_param1,
			"orbit_param2" : map_node_star.orbit_param2,
	}
	star_position = map_node_star.star_position
	orbit_parameter1 = map_node_star.orbit_param1
	orbit_parameter2 = map_node_star.orbit_param2
	emit_signal("star_orbit_information_changed", orbit_parameter1, orbit_parameter2)


func _on_orbit_param1_x_input_value_changed(value: float) -> void:
	orbit_parameter1.x = value
	emit_signal("star_orbit_information_changed", orbit_parameter1, orbit_parameter2)


func _on_orbit_param1_y_input_value_changed(value: float) -> void:
	orbit_parameter1.y = value
	emit_signal("star_orbit_information_changed", orbit_parameter1, orbit_parameter2)


func _on_orbit_param2_x_input_value_changed(value: float) -> void:
	orbit_parameter2.x = value
	emit_signal("star_orbit_information_changed", orbit_parameter1, orbit_parameter2)


func _on_orbit_param2_y_input_value_changed(value: float) -> void:
	orbit_parameter2.y = value
	emit_signal("star_orbit_information_changed", orbit_parameter1, orbit_parameter2)


func _on_canceled() -> void:
	if (
			initial_orbit_settings.has("orbit_param1")
			and initial_orbit_settings.has("orbit_param1")
	):
		orbit_parameter1 = initial_orbit_settings["orbit_param1"]
		orbit_parameter2 = initial_orbit_settings["orbit_param2"]
		emit_signal("star_orbit_information_changed", orbit_parameter1, orbit_parameter2)
		queue_free()


func _on_confirmed() -> void:
	queue_free()
