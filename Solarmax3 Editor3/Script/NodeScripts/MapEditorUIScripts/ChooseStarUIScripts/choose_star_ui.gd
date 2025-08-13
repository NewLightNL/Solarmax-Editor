extends Control

@export var stars_slot : PackedScene

# 外部输入
var star_pattern_dictionary : Dictionary
var stars_dictionary : Dictionary[String, Dictionary]
var stars : Array[Star]
var editor_type : EditorType
# star_type_information = [天体图样名(pattern_name)(String), 天体缩放比例(scale)(float), 天体类型(type)(String), 大小类型(size_type)(int), 名称(String), 特殊天体类型(String)]

@onready var star_slots_container = $Control/PanelContainer/ScrollContainer/MarginContainer/GridContainer


func _ready():
	_pull_map_editor_information()
	
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	for type_stars_name in stars_dictionary:
		var stars_slot_node = stars_slot.instantiate()
		var size_types : Array[int] = stars_dictionary[type_stars_name].keys()
		size_types.sort()
		var first_size : int = size_types[0]
		var represent_star : Star = stars_dictionary[type_stars_name][first_size] # 避免了不同天体类型天体数不同的问题
		stars_slot_node.get_child(0).get_child(0).texture = star_pattern_dictionary[represent_star.pattern_name]
		stars_slot_node.get_child(0).get_child(1).text = str(stars_dictionary[type_stars_name].size())
		stars_slot_node.get_child(1).get_child(0).text = represent_star.star_name
		star_slots_container.add_child(stars_slot_node)
		stars_slot_node.get_child(2).button_up.connect(_star_chosen.bind(represent_star))
		if editor_type is NewExpedition:
			editor_type.obey_dirt_star_rotation_rule_ui(represent_star, stars_slot_node.get_child(0).get_child(0))
		else:
			pass


func _pull_map_editor_information():
	stars_dictionary = MapEditorSharedData.stars_dictionary
	editor_type = MapEditorSharedData.editor_type


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"stars_dictionary":
			stars_dictionary = MapEditorSharedData.stars_dictionary
		"editor_type":
			editor_type = MapEditorSharedData.editor_type


func _star_chosen(slot_star : Star):
	var star_edit_ui = $"../StarEditUI"
	star_edit_ui.call("_choose_star", slot_star)



func _on_close_choose_star_ui_button_button_up():
	queue_free()
