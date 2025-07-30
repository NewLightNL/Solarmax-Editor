extends Marker2D

var color : Color

func _draw() -> void:
	draw_arc(Vector2.ZERO, 100, 0, PI/2, 256, color, 3, true)


func _on_button_button_up() -> void:
	color = Color.RED
	queue_redraw()


func _on_button_2_button_up() -> void:
	color = Color.BLUE
	queue_redraw()


func _on_button_3_button_up() -> void:
	color = Color.WHITE
	queue_redraw()
