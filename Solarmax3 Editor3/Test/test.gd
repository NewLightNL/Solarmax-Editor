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
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# 废弃代码
#var format = "<mapbuilding type=\"%s\" size=\"7\" tag=\"A\" x=\"-5\" y=\"-2\" camption=\"1\" fAngle=\"0\" orbit=\"0\" revospeed=\"10\" orbitParam1=\"0,0\" orbitParam2=\"0\" rbitClockWise=\"False\" />"\
			#%"star"
	#stars = Mapeditor1ShareData.stars
	#Mapeditor1ShareData.init_editor_data()
	#stars = Mapeditor1ShareData.stars
	#var star : MapNodeStar = MapNodeStar.new()
	#star._init_from_star(stars[0])
	#Save.save_map_node_stars([star])
	#var mapnode_scene : PackedScene = load("res://MapNode/map_node_star.tscn")
	#map_node_star_node = mapnode_scene.instantiate()
	#map_node_star_node._init_from_star(stars[0])
	#add_child(map_node_star_node)
	#map_node_star_node._update_map_node_star()
	#$MapNodeStar._init_from_star(stars[0])


func _on_window_close_requested():
	$Window.hide()


func _on_button_button_up():
	$Window.show()
