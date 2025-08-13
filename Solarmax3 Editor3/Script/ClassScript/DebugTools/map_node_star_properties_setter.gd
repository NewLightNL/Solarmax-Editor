class_name MapNodeStarPropertiesSetter extends DebugTool

@export var map_node_star : MapNodeStar
@export var star_type : String = ""
@export var size_type : int = 0

# 被定义的阵营
var defined_camp_ids : Array[int]
# 阵营颜色
var camp_colors : Dictionary
# 天体贴图字典
var star_pattern_dictionary : Dictionary
# 天体们
var stars : Array[Star]
var stars_dictionary : Dictionary[String, Dictionary]
# 轨道类型
var orbit_types : Dictionary
var chosen_star : MapNodeStar
var star_fleets : Array


func _ready() -> void:
	_pull_map_editor_information()


func _pull_map_editor_information():
	defined_camp_ids = MapEditorSharedData.defined_camp_ids
	camp_colors = MapEditorSharedData.camp_colors
	star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
	stars = MapEditorSharedData.stars
	stars_dictionary = Load.get_map_editor_basic_information("stars_dictionary")
	orbit_types = MapEditorSharedData.orbit_types
	chosen_star = MapEditorSharedData.chosen_star
	star_fleets = MapEditorSharedData.star_fleets


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"defined_camp_ids":
			defined_camp_ids = MapEditorSharedData.defined_camp_ids
		"camp_colors":
			camp_colors = MapEditorSharedData.camp_colors
		"star_pattern_dictionary":
			star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
		"stars":
			stars = MapEditorSharedData.stars
		"stars_dictionary":
			stars_dictionary = MapEditorSharedData.stars_dictionary
		"orbit_types":
			orbit_types = MapEditorSharedData.orbit_types
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star
		"star_fleets":
			star_fleets = MapEditorSharedData.star_fleets


func set_inherit_star():
	if stars_dictionary.has(star_type):
		if (
				stars_dictionary[star_type].has(size_type)
		):
			map_node_star.inherit_star = stars_dictionary[star_type][size_type]
		else:
			var error_str1 : String = "size_type出错!\n"
			var error_str2 : String = "该天体有大小类型为: "
			var error_str3 : String = ""
			var index : int = 0
			for i in stars_dictionary[star_type]:
				index += 1
				if index == stars_dictionary[star_type].size():
					error_str3 += "%s" % i
				else:
					error_str3 += "%s, " % i 
			var error_str : String = error_str1 + error_str2 + error_str3
			push_error(error_str)
			
