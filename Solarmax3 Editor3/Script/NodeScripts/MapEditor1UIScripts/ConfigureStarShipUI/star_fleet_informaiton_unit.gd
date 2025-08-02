extends Control

signal delelte_star_fleet(star_fleet_with_self)

var star_fleet_with_self : Array
# star_fleet_with_self = [[star_fleet], self]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_star_fleet_informaiton_label_resized():
	$StarFleetInformaitonLabel.position = Vector2(0, 0)
	custom_minimum_size.x = $StarFleetInformaitonLabel.size.x + 80
	$StarFleetInformaitonBG.size.x = $StarFleetInformaitonLabel.size.x + 40
	$StarFleetCampColor.position = Vector2($StarFleetInformaitonLabel.size.x + 6.4, 8)
	$StarFleetDeleteButton.position = Vector2($StarFleetInformaitonLabel.size.x + 40, 0)



func _on_star_fleet_delete_button_button_up():
	emit_signal("delelte_star_fleet", star_fleet_with_self)
	queue_free()
