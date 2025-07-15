extends Control

# 写入/输出这个框的信息
var star_slot_information : Array
# star_slot_information = [天体图样名(pattern_name)(String), 天体缩放比例(scale)(float), 天体类型(type)(String), 大小类型(size_type)(int), 名称(String), 特殊天体类型(String)]

signal deliver_star_slot_information(star_slot_information)

func _on_choose_star_button_button_up():
	deliver_star_slot_information.emit(star_slot_information)
