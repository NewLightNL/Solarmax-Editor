extends Control

signal change_object_visibility(object_name: String, visibile : bool)
signal switch_object_visibility(object_name: String)


@export var star_information_scene : PackedScene
@export var choose_star_ui : PackedScene
@export var map_node_star_scene : PackedScene

# 交流变量
var star_pattern_dictionary : Dictionary
var defined_camp_ids : Array
var camp_colors : Dictionary
var stars : Array[Star]
var orbit_types : Dictionary

# 天体编辑共享
var chosen_star : MapNodeStar

# 内部
var recently_chosen_stars : Array[Star]

const  MAX_RECENT_STARS_NUMBER = 5

# UI节点引用
@onready var choose_star = $ChooseStar
@onready var chosen_star_picture = $ChooseStar/ChosenStarPicture
@onready var chosen_star_name_label = $ChooseStar/Name_bg/Name
@onready var recently_chosen_stars_box = $RecentlyChosenStarBG
@onready var create_star_button = $CreateStarButton


@onready var map_node : Node2D = $"../../Map"
@onready var Main1_node : Node = $"../.."
@onready var ui_node : CanvasLayer = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	Mapeditor1ShareData.editor_data_updated.connect(_on_global_data_updated)
	$"../../Map"._on_create_star.connect(_create_star_feedback)
	$StarInformation.show_orbit_setting_window.connect(_on_change_object_visibility.bind("OrbitSettingWindow", true))
	$StarInformation.switch_star_preview_state.connect(_on_switch_object_visibility.bind("PreviewStar"))
	
	#$StarInformation.update_star_information_ui()
	#stars = Load.get_map_editor_basic_information("stars")
	#star_pattern_dictionary = Load.init_star_pattern_dictionary()
	#camp_colors = Load.get_map_editor_basic_information("camp_colors")
	_initialize_recently_chosen_star_button()


func _on_global_data_updated(key : String):
	match key:
		"defined_camp_ids":
			defined_camp_ids = Mapeditor1ShareData.defined_camp_ids
		"camp_colors":
			camp_colors = Mapeditor1ShareData.camp_colors
		"star_pattern_dictionary":
			star_pattern_dictionary = Mapeditor1ShareData.star_pattern_dictionary
		"stars":
			stars = Mapeditor1ShareData.stars
		"orbit_types":
			orbit_types = Mapeditor1ShareData.orbit_types
		"all_basic_information":
			defined_camp_ids = Mapeditor1ShareData.defined_camp_ids
			camp_colors = Mapeditor1ShareData.camp_colors
			star_pattern_dictionary = Mapeditor1ShareData.star_pattern_dictionary
			stars = Mapeditor1ShareData.stars
			orbit_types = Mapeditor1ShareData.orbit_types
		"chosen_star":
			chosen_star = Mapeditor1ShareData.chosen_star
		"stars_dictionary":
			pass
		_:
			push_error("数据更新出错，请检查要提交的内容名是否正确")


# 初始化最近选择的天体UI按钮
func _initialize_recently_chosen_star_button():
	for i in range(1, MAX_RECENT_STARS_NUMBER + 1):
		var slot = recently_chosen_stars_box.get_node("RecentlyChosenStarSlot%d"%i)
		var button : Button = slot.get_node("RecentlyChosenStarButtonBG/RecentlyChosenStarButton")
		if button != null:
			button.button_up.connect(_on_recently_chosen_star_button_up.bind(i))
		else:
			push_error("最近选择的天体按钮获取失败")

# 改成发射关闭UI信号更好
# 关闭UI
func _on_star_edit_ui_close_button_button_up():
	visible = false
	ui_node.show_star_edit_ui_open_button()


# 当按起选择天体按钮时
func _on_choose_star_button_up():
	var choose_star_ui_node = choose_star_ui.instantiate()
	choose_star_ui_node.star_pattern_dictionary = star_pattern_dictionary
	choose_star_ui_node.stars = stars
	var UI_node = $".."
	UI_node.add_child(choose_star_ui_node)


func _choose_star(star : Star):
	_update_star_display(star)
	_update_chosen_star(star)
	_add_to_recently_chosen_stars(chosen_star)
	_update_recently_chosen_stars_display()


func _add_to_recently_chosen_stars(recent_chosen_star : MapNodeStar) -> void:
	var chosen_star_duplicate = recent_chosen_star.duplicate_map_node_star()
	# 移除重复项
	# 降序检测，防止删了后超范围
	#for i in range(recently_chosen_stars.size() - 1, -1, -1):
		#var recently_chosen_star_info : Array = recently_chosen_stars[i].get_star_information()
		#var star_info : Array = chosen_star_duplicate.get_star_information()
		#if recently_chosen_star_info.size() == star_info.size():
			#if (
				#star_info[2] == recently_chosen_star_info[2]
				#and star_info[3] == recently_chosen_star_info[3]
			#):
				#recently_chosen_stars.remove_at(i)
		#else:
			#push_error("最近选择的天体信息或提交的天体信息残缺")
			#return
	
	recently_chosen_stars.append(chosen_star_duplicate)
	
	if recently_chosen_stars.size() > MAX_RECENT_STARS_NUMBER:
		recently_chosen_stars.remove_at(0)


func _update_recently_chosen_stars_display():
	for i in range(min(recently_chosen_stars.size(), MAX_RECENT_STARS_NUMBER)):
		var slot = recently_chosen_stars_box.get_child(i)
		var star_index = recently_chosen_stars.size() - i - 1
		var star_information : Array = recently_chosen_stars[star_index].get_star_information()
		slot.get_child(0).texture = star_pattern_dictionary[
				star_information[0]]
		var recently_chosen_star = recently_chosen_stars[star_index]
		if recently_chosen_star.special_star_type == "dirt":
			slot.get_child(0).flip_v = true
			slot.get_child(0).flip_h = true
		else:
			slot.get_child(0).flip_v = false
			slot.get_child(0).flip_h = false

# 最近选择的星球框显示(对lately_chosen_star数组从右往左读取)
func _update_star_display(star : Star):
	var star_infomation = star.get_star_information()
	if star.special_star_type == "dirt":
		chosen_star_picture.rotation = PI
	else:
		chosen_star_picture.rotation = 0
	chosen_star_picture.texture = star_pattern_dictionary[star_infomation[0]]
	chosen_star_name_label.text = star_infomation[4]


func _update_chosen_star(star : Star):
	chosen_star = MapNodeStar.new()
	
	# 赋予被选中的天体属性
	if star is MapNodeStar:
		chosen_star.copy_map_node_star(star)
		Mapeditor1ShareData.data_updated("chosen_star", chosen_star)
	else:
		chosen_star.copy_information_from_star(star)
		Mapeditor1ShareData.data_updated("chosen_star", chosen_star)
	
	$StarInformation.update_star_information_ui()
	$StarInformation.unlock_uis()


# 最近选择的天体按钮被按起
func _on_recently_chosen_star_button_up(button_index : int):
	var index = recently_chosen_stars.size() - button_index
	if index >= 0 and index < recently_chosen_stars.size():
		var star = recently_chosen_stars[index]
		_update_star_display(star)
		_update_chosen_star(star)

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
