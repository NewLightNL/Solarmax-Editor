extends Node

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

signal editor_data_updated(key)

func init_editor_data():
	star_pattern_dictionary = Load.init_star_pattern_dictionary()
	defined_camp_ids = Load.get_map_editor_basic_information("defined_camp_ids")
	camp_colors = Load.get_map_editor_basic_information("camp_colors")
	stars = Load.get_map_editor_basic_information("stars")
	orbit_types = Load.get_map_editor_basic_information("orbit_types")
	
	emit_signal("editor_data_updated", "all_basic_information")


var chosen_star : MapNodeStar = MapNodeStar.new()
var is_star_chosen : bool = false# 用于未来判断是否有天体被选择
var star_fleets : Array

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
		"orbit_types":
			orbit_types = value
		"chosen_star":
			chosen_star = value
		"is_star_chosen":
			is_star_chosen = value
		"star_fleets":
			star_fleets = value
		_:
			push_error("数据更新出错，请检查要提交的内容名是否正确")
	emit_signal("editor_data_updated", key)
