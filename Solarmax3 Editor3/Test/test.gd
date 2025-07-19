extends Node2D

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

var all_shared_data : Dictionary = {
		"defined_camp_ids" : defined_camp_ids,
		"camp_colors" : camp_colors,
		"star_pattern_dictionary" : star_pattern_dictionary,
		"stars" : stars,
		"orbit_types" : orbit_types,
}
# 用于测试代码以及其它什么东西的

# Called when the node enters the scene tree for the first time.
func _ready():
	all_shared_data["defined_camp_ids"] = [1, 2, 3]
	print(defined_camp_ids)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
