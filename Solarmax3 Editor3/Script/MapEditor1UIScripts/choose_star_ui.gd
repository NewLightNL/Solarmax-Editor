extends Control

@export var stars_slot : PackedScene

# 外部输入
var star_pattern_dictionary : Dictionary
var stars : Array[Star]
# star_type_information = [天体图样名(pattern_name)(String), 天体缩放比例(scale)(float), 天体类型(type)(String), 大小类型(size_type)(int), 名称(String), 特殊天体类型(String)]

# 内部
@onready var star_slots_container = $Control/PanelContainer/ScrollContainer/MarginContainer/GridContainer

func _ready():
	for star in stars:
		var stars_slot_node = stars_slot.instantiate()
		var star_information : Array = star.get_star_information()
		stars_slot_node.get_child(0).get_child(0).texture = star_pattern_dictionary[star_information[0]]
		stars_slot_node.get_child(1).get_child(0).text = star_information[4]
		stars_slot_node.slot_star = star
		
		star_slots_container.add_child(stars_slot_node)


func get_star_slots() -> Array[Node]:
	return star_slots_container.get_children()


func _on_close_choose_star_ui_button_button_up():
	queue_free()
