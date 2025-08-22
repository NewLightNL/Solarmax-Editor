extends Control

signal change_object_visibility(object_name: String, visibile : bool)
signal request_choose_star
signal request_show_ui(ui : Node)

@export var star_information_scene : PackedScene

@export var map_node_star_scene : PackedScene

var stars_dictionary : Dictionary[String, Dictionary]
var defined_camp_ids : Array
var camp_colors : Dictionary
var stars : Array[Star]
var orbit_types : Dictionary
var editor_type : EditorType

var chosen_star : MapNodeStar

var is_star_information_ui_showing : bool = false:
	set(value):
		is_star_information_ui_showing = value
		if value == true:
			lock_choose_star_buttoN_and_recently_chosne_star_bar()
		else:
			unlock_choose_star_buttoN_and_recently_chosne_star_bar()

# UI节点引用
@onready var choose_star_button : Button = $ChooseStar
@onready var chosen_star_picture = $ChooseStar/ChosenStarPicture
@onready var chosen_star_name_label = $ChooseStar/Name_bg/Name
@onready var recently_chosen_stars_bar = $RecentlyChosenStarBar
@onready var star_information = $StarInformation
@onready var create_star_button = $CreateStarButton


@onready var map_node : Node2D = $"../../Map"
@onready var Main1_node : Node = $"../.."
@onready var ui_node : CanvasLayer = $".."


# Called when the node enters the scene tree for the first time.
func _ready():
	_pull_map_editor_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	map_node.create_star.connect(_create_star_feedback)
	ui_node.feedback.connect(_on_get_feedback)
	$StarInformation.change_star_preview_state.connect(_on_change_object_visibility)


func _pull_map_editor_information():
	defined_camp_ids = MapEditorSharedData.defined_camp_ids
	camp_colors = MapEditorSharedData.camp_colors
	stars_dictionary = MapEditorSharedData.stars_dictionary
	stars = MapEditorSharedData.stars
	orbit_types = MapEditorSharedData.orbit_types
	editor_type = MapEditorSharedData.editor_type


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"defined_camp_ids":
			defined_camp_ids = MapEditorSharedData.defined_camp_ids
		"camp_colors":
			camp_colors = MapEditorSharedData.camp_colors
		"stars_dictionary":
			stars_dictionary = MapEditorSharedData.stars_dictionary
		"stars":
			stars = MapEditorSharedData.stars
		"orbit_types":
			orbit_types = MapEditorSharedData.orbit_types
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star


func lock_choose_star_buttoN_and_recently_chosne_star_bar() -> void:
	choose_star_button.disabled = true
	recently_chosen_stars_bar.lock_slots()


func unlock_choose_star_buttoN_and_recently_chosne_star_bar() -> void:
	choose_star_button.disabled = false
	recently_chosen_stars_bar.unlock_slots()


func update_star_edit_ui_on_choosing_star(star : Star):
	_update_star_display(star)
	_update_chosen_star(star)
	_add_recently_chosen_star(star)
	_initialize_star_information(star)


func _on_recently_chosen_star_bar_switch_chosen_star(star_switch_to : MapNodeStar) -> void:
	_update_star_display(star_switch_to)
	_update_star_information(star_switch_to)


# 改成发射关闭UI信号更好
# 关闭UI
func _on_star_edit_ui_close_button_button_up():
	visible = false
	ui_node.show_star_edit_ui_open_button()


func _update_star_display(star : Star):
	choose_star_button.update_choosing_star_display(star)


func _update_chosen_star(star : Star):
	# chosen_star应该全局唯一
	if chosen_star == null:
		chosen_star = MapNodeStar.new()
	
	# 赋予被选中的天体属性
	# 应该为最近选择的天体栏单独做一个上传被选择的天体方法
	
	chosen_star.copy_information_from_star(star)
	MapEditorSharedData.data_updated("chosen_star", chosen_star)


func _add_recently_chosen_star(star : Star):
	recently_chosen_stars_bar.add_recently_chosen_star(star)


func _initialize_star_information(star):
	star_information.lock_uis()
	star_information.unlock_uis()
	
	star_information.update_star_information_ui_on_choosing_star(star)


func _update_star_information(map_node_star : MapNodeStar):
	star_information.lock_uis()
	star_information.unlock_uis()
	
	star_information.update_star_information_ui_on_switching_to_recently_chosen_star(map_node_star)


func _on_choose_star_request_choose_star() -> void:
	emit_signal("request_choose_star")


# 应移到MapEditor1里
# 生成天体
func _on_create_star_button_button_up() -> void:
	map_node.create_mapnodestar()


func _create_star_feedback(is_success : bool, context : String):
	if is_success == true:
		pass
	else:
		# 呼出警告界面
		push_error("创建天体失败！原因：" + context)


func _on_change_object_visibility(object_name : String, visibility : bool):
	emit_signal("change_object_visibility", object_name, visibility)


func _on_switch_object_visibility(object_name : String):
	emit_signal("switch_object_visibility", object_name)


func _on_get_feedback(what_feedback : String, context : String):
	match what_feedback:
		"star_preview_state":
			match context:
				"true", "false":
					parse_feedback(what_feedback, context)
				_:
					push_error("发送了错误的反馈内容!")


func parse_feedback(what_feedback : String, context : String) -> void:
	match what_feedback:
		"star_preview_state":
			var star_preview_state : bool
			if context == "true":
				star_preview_state = true
			elif context == "false":
				star_preview_state = false
			else:
				push_error("反馈内容有问题!无法转换反馈内容!")
				return
			
			$StarInformation.star_preview_state = star_preview_state
		_:
			push_error("未知反馈内容!")


func _on_star_information_star_size_changed(size_type: int) -> void:
	var type_stars_dictionary : Dictionary[int, Star] = stars_dictionary[chosen_star.type]
	var type_star : Star = type_stars_dictionary[size_type]
	chosen_star.copy_information_from_star(type_star)
	_update_star_display(type_star)
	_update_recently_chosen_stars_bar()


func _on_star_information_star_information_changed() -> void:
	_update_recently_chosen_stars_bar()


func _update_recently_chosen_stars_bar():
	recently_chosen_stars_bar.update_recently_chosen_stars()


func _on_star_information_request_show_ui(ui: Node) -> void:
	is_star_information_ui_showing = true
	emit_signal("request_show_ui", ui)
