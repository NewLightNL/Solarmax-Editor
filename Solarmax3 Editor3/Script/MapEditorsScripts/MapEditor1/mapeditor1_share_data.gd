extends Node

signal editor_data_updated(key)

# 被定义的阵营
var defined_camp_ids : Array[int]
# 阵营颜色
var camp_colors : Dictionary
# 天体贴图字典
var star_pattern_dictionary : Dictionary
# 天体们
var stars : Array[Star]
var stars_dictionary : Dictionary
# 轨道类型
var orbit_types : Dictionary
var chosen_star : MapNodeStar
var star_fleets : Array


func init_editor_data():
	star_pattern_dictionary = Load.init_star_pattern_dictionary()
	defined_camp_ids = Load.get_map_editor_basic_information("defined_camp_ids")
	camp_colors = Load.get_map_editor_basic_information("camp_colors")
	stars = Load.get_map_editor_basic_information("stars")
	stars_dictionary = Load.get_map_editor_basic_information("stars_dictionary")
	orbit_types = Load.get_map_editor_basic_information("orbit_types")
	
	emit_signal("editor_data_updated", "all_basic_information")


func data_updated(key : String, value):
	match key:
		"defined_camp_ids":
			defined_camp_ids = value
		"camp_colors":
			camp_colors = value
		"star_pattern_dictionary":
			star_pattern_dictionary = value
		"stars":
			stars = value
		"stars_dictionary":
			stars_dictionary = value
		"orbit_types":
			orbit_types = value
		"chosen_star":
			chosen_star = value
		"star_fleets":
			star_fleets = value
		_:
			push_error("数据更新出错，请检查要提交的内容名是否正确")
	emit_signal("editor_data_updated", key)
