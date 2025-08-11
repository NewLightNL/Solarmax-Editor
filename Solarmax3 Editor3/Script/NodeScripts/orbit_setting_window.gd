extends ConfirmationDialog

var chosen_star : MapNodeStar

var initial_orbit_settings : Dictionary

@onready var orbit_param1_x_input = $Control/OrbitParam1Label/x/x_input
@onready var orbit_param1_y_input = $Control/OrbitParam1Label/y/y_input
@onready var orbit_param2_x_input = $Control/OrbitParam2Label/x/x_input
@onready var orbit_param2_y_input = $Control/OrbitParam2Label/y/y_input


func _ready() -> void:
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _on_global_data_updated(key : String):
	if key == "chosen_star":
		chosen_star = MapEditorSharedData.chosen_star
	update_star_position()


func update_star_position():
	if chosen_star == null:
		return
	
	$Control/StarPositionLabel.text = "天体坐标: (%s, %s)" % [chosen_star.star_position.x, chosen_star.star_position.y]


func _on_orbit_param1_x_input_value_changed(value: float) -> void:
	chosen_star.orbit_param1.x = value
	MapEditorSharedData.data_updated("chosen_star", chosen_star)


func _on_orbit_param1_y_input_value_changed(value: float) -> void:
	chosen_star.orbit_param1.y = value
	MapEditorSharedData.data_updated("chosen_star", chosen_star)


func _on_orbit_param2_x_input_value_changed(value: float) -> void:
	chosen_star.orbit_param2.x = value
	MapEditorSharedData.data_updated("chosen_star", chosen_star)


func _on_orbit_param2_y_input_value_changed(value: float) -> void:
	chosen_star.orbit_param2.y = value
	MapEditorSharedData.data_updated("chosen_star", chosen_star)


func _on_visibility_changed() -> void:
	if chosen_star != null:
		if self.visible == true:
			initial_orbit_settings = {"orbit_param1" : chosen_star.orbit_param1,
					"orbit_param2" : chosen_star.orbit_param2
			}
			orbit_param1_x_input.value = chosen_star.orbit_param1.x
			orbit_param1_y_input.value = chosen_star.orbit_param1.y
			orbit_param2_x_input.value = chosen_star.orbit_param2.x
			orbit_param2_y_input.value = chosen_star.orbit_param2.y


func _on_canceled() -> void:
	if (
			initial_orbit_settings.has("orbit_param1")
			and initial_orbit_settings.has("orbit_param1")
	):
		chosen_star.orbit_param1 = initial_orbit_settings["orbit_param1"]
		chosen_star.orbit_param2 = initial_orbit_settings["orbit_param2"]
		
