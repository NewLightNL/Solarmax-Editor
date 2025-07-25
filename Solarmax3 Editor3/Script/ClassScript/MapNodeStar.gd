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
var orbit_information : Array
# [轨道类型(int), 轨道参数1(Vector2)， 轨道参数2(Vector2)]
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


func duplicate_map_node_star(map_node_star : MapNodeStar):
	self.pattern_name = map_node_star.pattern_name
	self.star_scale = map_node_star.star_scale
	self.type = map_node_star.type
	self.size_type = map_node_star.size_type
	self.star_name = map_node_star.star_name
	self.special_star_type = map_node_star.special_star_type
	self.scale_fix = map_node_star.scale_fix
	self.offset_fix = map_node_star.offset_fix
	self.tag = map_node_star.tag
	self.star_camp = map_node_star.star_camp
	# 复合类型数组，需要拷贝
	var this_star_fleets_duplicated = map_node_star.this_star_fleets.duplicate(true)
	self.this_star_fleets = this_star_fleets_duplicated
	
	self.star_position = map_node_star.star_position
	
	var orbit_information_duplicated = map_node_star.orbit_information.duplicate(true)
	self.orbit_information = orbit_information_duplicated
	
	self.fAngle = map_node_star.fAngle
	
	var transformBulidingID_duplicated = map_node_star.transformBulidingID.duplicate(true)
	self.transformBulidingID = transformBulidingID_duplicated
	
	var lasergun_information_duplicated = map_node_star.lasergun_information.duplicate(true)
	self.lasergun_information = lasergun_information_duplicated
	
	self.is_taget = map_node_star.is_taget
