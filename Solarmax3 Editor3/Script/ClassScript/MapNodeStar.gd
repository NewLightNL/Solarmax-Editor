extends Star
class_name MapNodeStar

# 地图添加信息
## 大小类型(不应修改)
var size : int = size_type
## 天体标签
var tag : String
## 天体阵营
var star_camp : int
## 天体舰队
var this_star_fleets : Array
# this_star_fleets = [this_star_fleet1, this_star_fleet2]
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
