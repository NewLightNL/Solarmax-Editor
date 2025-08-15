@icon("res://Textures/IconTexture/planetRandom.png")
class_name MapNodeStar extends Star

const MAPUNITLENTH = 99.4


# 地图添加信息
## 天体标签
@export var tag : String = "":
	set(value):
		tag = value
		emit_signal("star_property_changed")
## 天体阵营
@export var star_camp : int = 0:
	set(value):
		star_camp = value
		emit_signal("star_property_changed")
## 天体舰队
@export var this_star_fleet_dictionaries_array : Array[Dictionary]:
	set(value):
		this_star_fleet_dictionaries_array = value
		emit_signal("star_property_changed")
# [{"camp_id" : ..., "ship_number" : ...}]
# this_star_fleet_dictionaries_array = [this_star_fleet1, this_star_fleet2]
# this_star_fleet = [阵营id(int), 舰队中的飞船数量(int)]
## 天体坐标
@export var star_position : Vector2 = Vector2.ZERO:
	set(value):
		star_position = value
		_update_map_node_star_position()
		emit_signal("star_property_changed")
## 轨道信息
@export var orbit_type : String = "no_orbit":
	set(value):
		orbit_type = value
		emit_signal("star_property_changed")
@export var orbit_param1 : Vector2 = Vector2.ZERO:
	set(value):
		orbit_param1 = value
		emit_signal("star_property_changed")
@export var orbit_param2 : Vector2 = Vector2.ZERO:
	set(value):
		orbit_param2 = value
		emit_signal("star_property_changed")
## 旋转角度
@export var fAngle : float = 0.0:
	set(value):
		fAngle = value
		emit_signal("star_property_changed")
# 特殊天体信息
## 变形装置变形的天体的id们
@export var transformBulidingID : Array = []:
	set(value):
		transformBulidingID = value
		emit_signal("star_property_changed")
## 射线炮数据(Array)
@export var lasergun_information : Array = []:
	set(value):
		lasergun_information = value
		emit_signal("star_property_changed")
# [lasergunAngle : int, lasergunRotateSkip : int, lasergunRange : int]
# lasergunAngle="" 表示射线炮的初始旋转角度。
# lasergunRotateSkip="" 表示射线炮的单次旋转角度。
# lasergunRange="" 表示射线炮的总旋转角度。
# 注意，如果想让射线炮不旋转，不可以在两个属性同时填0，因为0不能除以0。正确的填法是在lasergunRotateSkip=""中填写一个比lasergunRange=""中大的数字。
# 其它信息
## 是否为目标天体
@export var is_taget : bool = false:
	set(value):
		is_taget = value
		emit_signal("star_property_changed")


func _init() -> void:
	_update_map_node_star_position()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		_update_map_node_star_starposition()


func copy_information_from_star(base_star : Star) -> void:
	self.pattern_name = base_star.pattern_name
	self.star_scale = base_star.star_scale
	self.type = base_star.type
	self.size_type = base_star.size_type
	self.star_name = base_star.star_name
	self.special_star_type = base_star.special_star_type
	self.scale_fix = base_star.scale_fix
	self.offset_fix = base_star.offset_fix
	self.rotation_fix_degree = base_star.rotation_fix_degree


func duplicate_map_node_star() -> MapNodeStar:
	var rt_mapnodestar : MapNodeStar = MapNodeStar.new()
	
	rt_mapnodestar.pattern_name = self.pattern_name
	rt_mapnodestar.star_scale = self.star_scale
	rt_mapnodestar.type = self.type
	rt_mapnodestar.size_type = self.size_type
	rt_mapnodestar.star_name = self.star_name
	rt_mapnodestar.special_star_type = self.special_star_type
	rt_mapnodestar.scale_fix = self.scale_fix
	rt_mapnodestar.offset_fix = self.offset_fix
	rt_mapnodestar.rotation_fix_degree = self.rotation_fix_degree
	rt_mapnodestar.tag = self.tag
	rt_mapnodestar.star_camp = self.star_camp
	# 复合类型数组，需要拷贝
	var this_star_fleet_dictionaries_array_duplicated = self.this_star_fleet_dictionaries_array.duplicate(true)
	rt_mapnodestar.this_star_fleet_dictionaries_array = this_star_fleet_dictionaries_array_duplicated
	
	rt_mapnodestar.star_position = self.star_position
	rt_mapnodestar.orbit_type = self.orbit_type
	rt_mapnodestar.orbit_param1 = self.orbit_param1
	rt_mapnodestar.orbit_param2 = self.orbit_param2
	rt_mapnodestar.fAngle = self.fAngle
	
	var transformBulidingID_duplicated = self.transformBulidingID.duplicate(true)
	rt_mapnodestar.transformBulidingID = transformBulidingID_duplicated
	
	var lasergun_information_duplicated = self.lasergun_information.duplicate(true)
	rt_mapnodestar.lasergun_information = lasergun_information_duplicated
	
	rt_mapnodestar.is_taget = self.is_taget
	
	return rt_mapnodestar


func copy_map_node_star(map_node_star_copied : MapNodeStar) -> void:
	self.pattern_name = map_node_star_copied.pattern_name
	
	self.star_scale = map_node_star_copied.star_scale
	self.type = map_node_star_copied.type
	self.size_type = map_node_star_copied.size_type
	self.star_name = map_node_star_copied.star_name
	self.special_star_type = map_node_star_copied.special_star_type
	self.scale_fix = map_node_star_copied.scale_fix
	self.offset_fix = map_node_star_copied.offset_fix
	self.rotation_fix_degree = map_node_star_copied.rotation_fix_degree
	self.tag = map_node_star_copied.tag
	self.star_camp = map_node_star_copied.star_camp
	# 复合类型数组，需要拷贝
	var this_star_fleet_dictionaries_array_duplicated = map_node_star_copied.this_star_fleet_dictionaries_array.duplicate(true)
	self.this_star_fleet_dictionaries_array = this_star_fleet_dictionaries_array_duplicated
	
	self.star_position = map_node_star_copied.star_position
	self.orbit_type = map_node_star_copied.orbit_type
	self.orbit_param1 = map_node_star_copied.orbit_param1
	self.orbit_param2 = map_node_star_copied.orbit_param2
	self.fAngle = map_node_star_copied.fAngle
	
	var transformBulidingID_duplicated = map_node_star_copied.transformBulidingID.duplicate(true)
	self.transformBulidingID = transformBulidingID_duplicated
	
	var lasergun_information_duplicated = map_node_star_copied.lasergun_information.duplicate(true)
	self.lasergun_information = lasergun_information_duplicated
	self.is_taget = map_node_star_copied.is_taget


func _update_map_node_star_position():
	var x_axis_flip : Transform2D = Transform2D(Vector2(1, 0), Vector2(0, -1), Vector2.ZERO)
	var map_position = star_position * MAPUNITLENTH * x_axis_flip
	self.position = map_position


func _update_map_node_star_starposition():
	var x_axis_flip : Transform2D = Transform2D(Vector2(1, 0), Vector2(0, -1), Vector2.ZERO)
	var mapnodestar_position = (self.position * x_axis_flip) / MAPUNITLENTH 
	star_position = mapnodestar_position
