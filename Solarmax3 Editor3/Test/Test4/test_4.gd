extends Node2D

var sampling_image : Image

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	sampling_image = Image.create_empty(
			viewport_size.x,
			viewport_size.y,
			false,
			Image.FORMAT_RGBAF
	)
	
	var star_radius : float = 32.0
	
	var texture : ImageTexture = ImageTexture.create_from_image(sampling_image)
	
	$Sprite2D.texture = texture
