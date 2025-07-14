extends Control

var star_slot_information : Array

signal deliver_star_slot_information(star_slot_information)

func _on_choose_star_button_button_up():
	deliver_star_slot_information.emit(star_slot_information)
