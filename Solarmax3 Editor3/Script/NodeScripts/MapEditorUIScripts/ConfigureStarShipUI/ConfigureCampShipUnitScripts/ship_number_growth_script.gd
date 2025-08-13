extends Control

signal ship_number_added_to_difference(ship_number_difference_info : int)

var absolute_ship_number_difference : int

@onready var ship_number_difference_label : Label = $ShipNumberDifferenceLabel
@onready var ship_number_difference_h_slider : HSlider = $ShipNumberDifferenceHSlider

func _ready() -> void:
	_initialize()


func _initialize():
	var ship_number_difference_h_slider_value = ship_number_difference_h_slider.value
	absolute_ship_number_difference = roundi(ship_number_difference_h_slider_value)


func _on_ship_number_difference_h_slider_value_changed(value: float) -> void:
	absolute_ship_number_difference = roundi(value)
	var absolute_ship_number_text : String = "-/+\n%s" % absolute_ship_number_difference
	ship_number_difference_label.text = absolute_ship_number_text


func _on_add_button_button_up() -> void:
	emit_signal("ship_number_added_to_difference", absolute_ship_number_difference)


func _on_decrease_button_button_up() -> void:
	emit_signal("ship_number_added_to_difference", -absolute_ship_number_difference)
