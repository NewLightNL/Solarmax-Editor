extends CanvasLayer

signal feedback(method : String, context : String)

@export var map_node_star_list_unit : PackedScene
@export var choose_star_ui_scene : PackedScene

var star_information_uis_showing : Array[Node] = []

@onready var star_edit_ui : Control = $StarEditUI

@onready var star_edit_ui_open_button : Button = $EditorUI/StarEditUIOpenButton
@onready var show_star_list_button : Button = $EditorUI/ShowStarListButton
@onready var change_view_button : Button = $EditorUI/ChangeViewButton
@onready var map_setting_button : Button = $EditorUI/MapSettingButton
@onready var add_info_button : Button = $EditorUI/AddInfoButton
@onready var show_grid_button : Button = $EditorUI/ShowGridButton
@onready var barrier_line_connect_button : Button = $EditorUI/BarrierLineConnectButton
@onready var export_button : Button = $EditorUI/ExportButton
@onready var import_button : Button = $EditorUI/ImportButton
@onready var editor_setting_button : Button = $EditorUI/EditorSettingButton
@onready var map_info_edit_buttons : Array[Button] = [
	show_star_list_button,
	change_view_button,
	map_setting_button,
	add_info_button,
	show_grid_button,
	barrier_line_connect_button,
]


func _ready() -> void:
	$StarEditUI.change_object_visibility.connect(change_object_visbile)
	$"../Map".feedback.connect(_on_get_feedback)


func change_object_visbile( 
		object_name : String,
		object_visible: bool 
):
	match object_name:
		"PreviewStar":
			$"../Map".change_star_preview_visibility(object_visible)
		_:
			pass


func code_and_emit_feedback(what_feedback : String, context : String):
	match what_feedback:
		"star_preview_state":
			match context:
				"true", "false":
					emit_signal("feedback", "star_preview_state", context)
				_:
					push_error("发送了错误的反馈内容")
			


func _on_get_feedback(get_feedback : String, context : String):
	match get_feedback:
		"star_preview_state":
			code_and_emit_feedback(get_feedback, context)
		_:
			push_error("获得了未知反馈")


# 展开天体编辑UI
func _on_star_edit_ui_open_button_button_up():
	star_edit_ui_open_button.visible = false
	$StarEditUI.visible = true
	for i in map_info_edit_buttons:
		i.position.x = $StarEditUI.position.x - 128


# 折叠天体编辑UI第2步
func show_star_edit_ui_open_button():
	star_edit_ui_open_button.visible = true
	for i in map_info_edit_buttons:
		i.position.x = $EditorUI.size.x - 128


func _on_export_button_button_up():
	$SaveWindow.show()


func _on_show_star_list_button_button_up():
	$MapNodeStarListWindow.show()
	var map_node_stars = $"../Map/Stars".get_children()
	var map_node_star_list = $MapNodeStarListWindow/Control/ScrollContainer/MapNodeStarListVBoxContainer
	for i in map_node_star_list.get_children():
		i.queue_free()
	for map_node_star in map_node_stars:
		var context_format : String = "  天体名: %s ; 天体类型: %s ; 大小类型: %s ; 天体标签: %s ; 坐标: (%s, %s) ; 阵营: %s  "
		var context = context_format % [
			map_node_star.star_name,
			map_node_star.type,
			map_node_star.size_type,
			map_node_star.tag,
			map_node_star.star_position.x,
			map_node_star.star_position.y,
			map_node_star.star_camp,
		]
		var map_node_star_list_unit_node = map_node_star_list_unit.instantiate()
		map_node_star_list_unit_node.text = context
		map_node_star_list.add_child(map_node_star_list_unit_node)


func _on_map_node_star_list_window_close_requested():
	$MapNodeStarListWindow.hide()


func _on_save_window_confirmed():
	var saved_path : String = $SaveWindow.current_path
	
	if saved_path != "":
		var stars_should_be_saved : Array[MapNodeStar]
		for star in $"../Map/Stars".get_children():
			stars_should_be_saved.append(star)
		Save.save_map_node_stars(stars_should_be_saved, saved_path)


func _on_show_grid_button_button_up() -> void:
	$"../Map/Coordinates".update_grid()


func _on_save_window_close_requested() -> void:
	$MapNodeStarListWindow.hide()


func _on_star_edit_ui_request_choose_star() -> void:
	if choose_star_ui_scene != null:
		var choose_star_ui_node : Control = choose_star_ui_scene.instantiate()
		add_child(choose_star_ui_node)
		choose_star_ui_node.choose_star.connect(_on_choose_star_ui_choose_star)
	else:
		push_error("choose_star_ui_scene为空!")


func _on_choose_star_ui_choose_star(star : Star):
	star_edit_ui.update_star_edit_ui_on_choosing_star(star)


func _on_star_edit_ui_request_show_ui(ui: Node) -> void:
	var ui_children : Array[Node] = get_children()
	
	if ui.get("request_type") == null:
		push_error("要求显示的ui没有request_type!")
		return
	
	for ui_child in ui_children:
		if ui_child.get("request_type") == null:
			continue
		else: 
			if ui_child.request_type == ui.request_type:
				ui_child.queue_free()
	
	ui.tree_exited.connect(lift_star_edit_ui_is_starinformaiton_ui_showing_state.bind(ui))
	star_information_uis_showing.append(ui)
	add_child(ui)


func lift_star_edit_ui_is_starinformaiton_ui_showing_state(ui : Node):
	var ui_index : int = star_information_uis_showing.find(ui)
	star_information_uis_showing.remove_at(ui_index)
	if star_information_uis_showing.size() <= 0:
		star_edit_ui.is_star_information_ui_showing = false
