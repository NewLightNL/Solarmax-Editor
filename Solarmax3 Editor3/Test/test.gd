extends Node2D

@export var map_node_star_node : MapNodeStar

@export var nodes : Array[Sprite2D]



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
@export var render_texture : ViewportTexture
@onready var render_target : ColorRect = $ColorRect
@onready var viewport : SubViewport = $SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	viewport.size = get_viewport().size
	$ColorRect.size = get_viewport().size
	$SubViewport/ColorRect.size = get_viewport().size
	render_texture = viewport.get_texture()
	$Sprite2D.texture = render_texture

# 差一个粘度
func _process(delta: float) -> void:
	_on_node_changed()
	render_target.material.set_shader_parameter("render_texture", render_texture)
	render_target.material.set_shader_parameter("threshold", 0.8)
	render_target.material.set_shader_parameter("influence_color", Color.BLUE)


func _on_node_changed():
	var node_number : int = nodes.size()
	var node_positions : PackedVector2Array = []
	var node_camps : PackedInt32Array = []
	for node in nodes:
		node_positions.append(node.position)
		node_camps.append(node.camp)
	var node_radii : PackedFloat32Array = [90.0, 90.0, 90.0, 90.0]
	$SubViewport/ColorRect.material.set_shader_parameter("node_number", node_number)
	$SubViewport/ColorRect.material.set_shader_parameter("node_positions", node_positions)
	$SubViewport/ColorRect.material.set_shader_parameter("node_camps", node_camps)
	$SubViewport/ColorRect.material.set_shader_parameter("node_radii", node_radii)
	
