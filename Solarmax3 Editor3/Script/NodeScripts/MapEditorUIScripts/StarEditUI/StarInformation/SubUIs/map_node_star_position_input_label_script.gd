extends Label

@onready var x_spin_box : SpinBox = $x/SpinBox
@onready var y_spin_box : SpinBox = $y/SpinBox


func initialize_map_node_star_position_input():
	x_spin_box.value = 0.0
	y_spin_box.value = 0.0
