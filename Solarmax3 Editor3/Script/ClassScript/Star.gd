@icon("res://Textures/IconTexture/planetRandom.png")
extends Node2D
class_name Star

# 天体类型信息
## 天体图样名
var pattern_name : String
## 天体缩放比例
var star_scale : float
## 天体类型
var type : String
## 大小类型
var size_type : int
## 名称
var star_name : String
## 特殊天体类型
var special_star_type : String
# 特殊天体类型(special_star_type): 
	# null(无)
	# dirt(焦土类)
	# Lasergun(射线炮)
	# UnknownStar(变形装置)
	# barrier(障碍点)
# 天体修正信息
## 缩放修正
var scale_fix : Vector2
## 位置修正
var offset_fix : Vector2
## 旋转修正
var rotation_fix_degree : float

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
