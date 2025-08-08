extends Node2D

@export var map_node_star_node : MapNodeStar


# 被定义的阵营
var defined_camp_ids : Array[int]
# 阵营颜色
var camp_colors : Dictionary
# 天体贴图字典
var star_pattern_dictionary : Dictionary
# 天体们
var stars : Array[Star]
# 轨道类型
var orbit_types : Dictionary
# 用于测试代码以及其它什么东西的

# Called when the node enters the scene tree for the first time.
func _ready():
	var a : Vector2 = Vector2(1, 2)
	var b : Vector2 = Vector2(3, 4)
	var c = a * b
	print(c)
