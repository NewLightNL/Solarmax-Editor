extends Label

var chosen_star : MapNodeStar


@onready var x_spin_box : SpinBox = $x/SpinBox
@onready var y_spin_box : SpinBox = $y/SpinBox


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


func initialize_map_node_star_position_input():
	x_spin_box.value = 0.0
	y_spin_box.value = 0.0
	chosen_star.star_position = Vector2(0.0, 0.0)


func update_map_node_star_position_input(map_node_star : MapNodeStar):
	var star_position : Vector2 = map_node_star.star_position
	x_spin_box.value = star_position.x
	y_spin_box.value = star_position.y
