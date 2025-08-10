extends Sprite2D

@export var error_star_texture : CompressedTexture2D


var star_texture : CompressedTexture2D
var star_scale : float = 1.0
var scale_fix : Vector2 = Vector2.ONE
var offset_fix : Vector2
var rotation_fix_degree : float
var fAngle : float
var star_color : Color


func update_sprite(
		star_texture_info : CompressedTexture2D,
		star_scale_info : float,
		scale_fix_info : Vector2,
		offset_fix_info : Vector2,
		rotation_fix_degree_info : float,
		fAngle_info : float,
		star_color_info : Color,
):
	star_texture = star_texture_info
	star_scale = star_scale_info
	scale_fix = scale_fix_info
	offset_fix = offset_fix_info
	rotation_fix_degree = rotation_fix_degree_info
	fAngle = fAngle_info
	star_color = star_color_info
	
	update_sprite_texture()
	update_sprite_color()
	update_sprite_rotation()


func update_sprite_texture():
	if star_texture == null:
		texture = error_star_texture
		# star_scale问题
		#var star_scale_vector2 : Vector2 = self.star_scale * Vector2.ONE
		#var real_scale : Vector2 = star_scale_vector2 * scale_fix
		#self.scale = real_scale
		push_error("天体纹理为空！")
	else:
		self.texture = star_texture
		var star_scale_vector2 : Vector2 = self.star_scale * Vector2.ONE
		var real_scale : Vector2 = star_scale_vector2 * scale_fix
		self.scale = real_scale
		self.offset = offset_fix


func update_sprite_color():
	self.self_modulate = star_color


func update_sprite_rotation():
	self.rotation_degrees = rotation_fix_degree + fAngle
