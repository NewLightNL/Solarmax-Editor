extends Control

signal request_delete
signal drag_state_changed(is_dragging : bool)

const  STANDARD_STAR_RADIUS : float = 231.0

var star_scale : float = 1.0:
	set(value):
		star_scale = value
		star_radius = STANDARD_STAR_RADIUS * star_scale

var star_radius : float = 231.0:
	set(value):
		star_radius = value/2
		origin_position = Vector2(star_radius, star_radius)

var origin_position : Vector2 = Vector2(115.5, 115.5)
var drag_state : bool = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.pressed and drag_state == true:
				drag_state = false
				emit_signal("drag_state_changed", drag_state)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var mouse_local_position : Vector2 = event.position
				var distance : float = origin_position.distance_to(mouse_local_position)
				if distance <= star_radius:
					drag_state = true
					emit_signal("drag_state_changed", drag_state)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed == false:
			emit_signal("request_delete")
