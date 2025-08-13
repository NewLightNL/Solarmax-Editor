extends Sprite2D


@export var camp : int = 0
@export var radius : float = 32.0

var is_dragging : bool = false
var click_range : float = 32.0
var mouse_offset : Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if is_dragging:
		position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# position? pressed?
		if (event.position - self.position).length() <= click_range:
			if not is_dragging and event.pressed:
				is_dragging = true
				mouse_offset = self.position - event.position
				#print(mouse_offset)
		if is_dragging and not event.pressed:
			is_dragging = false
		
		if event is InputEventMouseMotion and is_dragging:
			self.position = event.position + mouse_offset
