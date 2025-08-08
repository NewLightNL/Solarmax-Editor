extends Control

signal fleet_infomation_updated(fleet_camp_info : int, ship_number_info : int)

@export var fleet_camp : int
@export var ship_number : int
@onready var configure_camp_ship_ui : Control = $ConfigueCampShipUI


func _ready() -> void:
	configure_camp_ship_ui.ship_number_information_updated.connect(_on_receive_ship_number_infomation)
	initialize_ui()


func initialize_ui():
	configure_camp_ship_ui.fleet_camp = self.fleet_camp
	configure_camp_ship_ui.ship_number = self.ship_number
	configure_camp_ship_ui.initialize_ui()


func update_ui():
	configure_camp_ship_ui.ship_number = self.ship_number
	configure_camp_ship_ui.update_ui()


func _on_receive_ship_number_infomation(ship_number_info : int):
	ship_number = ship_number_info
	emit_signal("fleet_infomation_updated", fleet_camp, ship_number)
