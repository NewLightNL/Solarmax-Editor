extends Control

signal ship_number_information_updated(ship_number : int)

const CAMP_COLOR_PANEL_STYLE_BOX_PATH : String = "res://Resources/StyleBoxes/show_camp_color_style_box_flat.tres"

var camp_colors : Dictionary

var fleet_camp : int
var ship_number : int
@onready var camp_color_panel : Panel = $CampColorLabel/CampColorPanel
@onready var camp_id_label : Label = $CampIDLabel
@onready var ship_number_line_edit : LineEdit = $ShipNumberLabel/ShipNumberLineEdit
@onready var ship_number_difference_control : Control = $ShipNumberDifference


func _ready() -> void:
	Mapeditor1ShareData.editor_data_updated.connect(_on_mapeditor1_shared_data_updated)
	ship_number_line_edit.value_changed.connect(_on_ship_number_line_edit_value_changed)
	ship_number_difference_control.ship_number_added_to_difference.connect(_on_ship_number_added_to_difference)
	_pull_mapeditor_shared_data()


func _pull_mapeditor_shared_data():
	camp_colors = Mapeditor1ShareData.camp_colors


func _on_mapeditor1_shared_data_updated(key : String, value):
	match key:
		"camp_colors":
			camp_colors = value
		"defined_camp_ids",\
		"star_pattern_dictionary",\
		"stars",\
		"stars_dictionary",\
		"orbit_types",\
		"chosen_star",\
		"star_fleets",\
		"all_basic_information":
			pass
		_:
			push_error("数据更新出错，请检查要提交的内容名是否正确")


# 实际数字与显示的数字会相同, LineEdit起到了限制器的作用
func _on_ship_number_line_edit_value_changed(value : float):
	ship_number = roundi(value)
	emit_signal("ship_number_information_updated", ship_number)


func _on_ship_number_added_to_difference(ship_number_difference : int):
	ship_number += ship_number_difference
	update_ui()

# 需要修改一下更改天体阵营显示的方法，把它封装成函数或者下放
func initialize_ui():
	if camp_colors != {}:
		var camp_color_panel_style_box : StyleBoxFlat = load(CAMP_COLOR_PANEL_STYLE_BOX_PATH)
		camp_color_panel_style_box = camp_color_panel_style_box.duplicate()
		camp_color_panel_style_box.bg_color = camp_colors[fleet_camp]
		camp_color_panel.add_theme_stylebox_override("panel", camp_color_panel_style_box)
	else:
		push_error("阵营颜色信息为空！")
		camp_colors = Mapeditor1ShareData.camp_colors
		if camp_colors == {}:
			push_error("获取不到阵营颜色信息！")
		else:
			var camp_color_panel_style_box : StyleBoxFlat = load(CAMP_COLOR_PANEL_STYLE_BOX_PATH)
			camp_color_panel_style_box = camp_color_panel_style_box.duplicate()
			camp_color_panel_style_box.bg_color = camp_colors[fleet_camp]
			camp_color_panel.add_theme_stylebox_override("panel", camp_color_panel_style_box)
	
	camp_id_label.text = "阵营ID: %s" % fleet_camp
	ship_number_line_edit.update_ship_number(ship_number)


func update_ui():
	ship_number_line_edit.update_ship_number(ship_number)
