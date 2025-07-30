extends Star
class_name MapNodeStar

# 地图添加信息
## 大小类型
#var size : int = size_type
## 天体标签
var tag : String
## 天体阵营
var star_camp : int
## 天体舰队
var this_star_fleets : Array
# this_star_fleets = [this_star_fleet1, this_star_fleet2]
# this_star_fleet = [阵营id(int), 舰队中的飞船数量(int)]
## 天体坐标
var star_position : Vector2
## 轨道信息
var orbit_type : int
var orbit_param1 : Vector2
var orbit_param2 : Vector2
## 旋转角度
var fAngle : float
# 特殊天体信息
## 变形装置变形的天体的id们
var transformBulidingID : Array
## 射线炮数据(Array)
var lasergun_information : Array
# [lasergunAngle : int, lasergunRotateSkip : int, lasergunRange : int]
# lasergunAngle="" 表示射线炮的初始旋转角度。
# lasergunRotateSkip="" 表示射线炮的单次旋转角度。
# lasergunRange="" 表示射线炮的总旋转角度。
# 注意，如果想让射线炮不旋转，不可以在两个属性同时填0，因为0不能除以0。正确的填法是在lasergunRotateSkip=""中填写一个比lasergunRange=""中大的数字。
# 其它信息
## 是否为目标天体
var is_taget : bool


func copy_information_from_star(base_star : Star):
	self.pattern_name = base_star.pattern_name
	self.star_scale = base_star.star_scale
	self.type = base_star.type
	self.size_type = base_star.size_type
	self.star_name = base_star.star_name
	self.special_star_type = base_star.special_star_type
	self.scale_fix = base_star.scale_fix
	self.offset_fix = base_star.offset_fix


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
	rt_mapnodestar.tag = self.tag
	rt_mapnodestar.star_camp = self.star_camp
	# 复合类型数组，需要拷贝
	var this_star_fleets_duplicated = self.this_star_fleets.duplicate(true)
	rt_mapnodestar.this_star_fleets = this_star_fleets_duplicated
	
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


func copy_map_node_star(map_node_star_copied) -> void:
	self.pattern_name = map_node_star_copied.pattern_name
	self.star_scale = map_node_star_copied.star_scale
	self.type = map_node_star_copied.type
	self.size_type = map_node_star_copied.size_type
	self.star_name = map_node_star_copied.star_name
	self.special_star_type = map_node_star_copied.special_star_type
	self.scale_fix = map_node_star_copied.scale_fix
	self.offset_fix = map_node_star_copied.offset_fix
	self.tag = map_node_star_copied.tag
	self.star_camp = map_node_star_copied.star_camp
	# 复合类型数组，需要拷贝
	var this_star_fleets_duplicated = map_node_star_copied.this_star_fleets.duplicate(true)
	self.this_star_fleets = this_star_fleets_duplicated
	
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
	
