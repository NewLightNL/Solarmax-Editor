@icon("res://Textures/IconTexture/planetRandom.png")
class_name Star extends Node2D

signal star_property_changed()

# 天体类型信息
## 天体图样名
@export var pattern_name : String:
	set(value):
		pattern_name = value
		emit_signal("star_property_changed")
## 天体缩放比例
@export var star_scale : float = 1.0:
	set(value):
		star_scale = value
		emit_signal("star_property_changed")
## 天体类型
@export var type : String:
	set(value):
		type = value
		emit_signal("star_property_changed")
## 大小类型
@export var size_type : int:
	set(value):
		size_type = value
		emit_signal("star_property_changed")
## 名称
@export var star_name : String:
	set(value):
		star_name = value
		emit_signal("star_property_changed")
## 特殊天体类型
@export var special_star_type : String = "null":
	set(value):
		special_star_type = value
		emit_signal("star_property_changed")
# 特殊天体类型(special_star_type): 
	# null(无)
	# dirt(焦土类)
	# Lasergun(射线炮)
	# UnknownStar(变形装置)
	# barrier(障碍点)
# 天体修正信息
## 缩放修正
@export var scale_fix : Vector2 = Vector2.ONE:
	set(value):
		scale_fix = value
		emit_signal("star_property_changed")
## 位置修正
@export var offset_fix : Vector2 = Vector2.ZERO:
	set(value):
		offset_fix = value
		emit_signal("star_property_changed")
## 旋转修正
@export var rotation_fix_degree : float:
	set(value):
		rotation_fix_degree = value
		emit_signal("star_property_changed")

func _init(
		pattern_name_info : String = "",
		star_scale_info : float = 0.0,
		type_info : String = "",
		size_type_info : int = 0,
		star_name_info : String = "",
		special_star_type_info : String = "",
		scale_fix_info : Vector2 = Vector2.ZERO,
		offset_fix_info : Vector2 = Vector2.ZERO,
		rotation_fix_degree_info : float = 0,
):
	pattern_name = pattern_name_info
	star_scale = star_scale_info
	type = type_info
	size_type = size_type_info
	star_name = star_name_info
	special_star_type = special_star_type_info
	scale_fix = scale_fix_info
	offset_fix = offset_fix_info
	rotation_fix_degree = rotation_fix_degree_info


func get_star_information() -> Array:
	var pattern_name_info = pattern_name
	var star_scale_info = star_scale
	var star_type_info = type
	var star_size_type_info = size_type
	var star_name_info = star_name
	var star_special_star_type_info = special_star_type
	var scale_fix_info = scale_fix
	var offset_fix_info = offset_fix
	var rotation_fix_degree_info = rotation_fix_degree
	var star_information : Array = [
			pattern_name_info,
			star_scale_info,
			star_type_info,
			star_size_type_info,
			star_name_info,
			star_special_star_type_info,
			scale_fix_info,
			offset_fix_info,
			rotation_fix_degree_info,
	]
	return star_information
