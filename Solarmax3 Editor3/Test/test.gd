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
	$OrbitDrawer.orbit_type = "ellipse"
	$OrbitDrawer.star_position = Vector2(-40, 80)
	$OrbitDrawer.orbit_param1 = Vector2(-60, 20)
	$OrbitDrawer.orbit_param2 = Vector2(80, 60)
	$OrbitDrawer.queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
