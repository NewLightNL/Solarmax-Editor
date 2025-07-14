extends Control

@export var stars_slot : PackedScene

# 外部输入
var star_pattern_dictionary : Dictionary
var star_types_information : Array 
# star_type_information = [天体图样名(pattern_name)(String), 天体缩放比例(scale)(float), 天体类型(type)(String), 大小类型(size_type)(int), 名称(String), 特殊天体类型(String)]

func _ready():
	for star_type_information in star_types_information:
		var stars_slot_node = stars_slot.instantiate()
		stars_slot_node.get_child(0).get_child(0).texture = star_pattern_dictionary[star_type_information[0]]
		stars_slot_node.get_child(1).get_child(0).text = star_type_information[4]
		stars_slot_node.star_slot_information = star_type_information
		$Control/PanelContainer/ScrollContainer/MarginContainer/GridContainer.add_child(stars_slot_node)

func _on_close_choose_star_ui_button_button_up():
	queue_free()
