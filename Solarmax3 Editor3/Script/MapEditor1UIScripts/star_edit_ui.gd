extends Control

@export var star_information_scene : PackedScene
@export var choose_star_ui : PackedScene

# 外部输入
var star_pattern_dictionary : Dictionary
var have_camps : Array
var campcolor : Dictionary


# 共享
var chosen_star : MapNodeStar


# 内部
var recently_chosen_stars : Array[Star]
	# 天体
var stars : Array[Star]

const  MAX_RECENT_STARS_NUMBER = 6

# UI节点引用
@onready var choose_star = $ChooseStar
@onready var chosen_star_picture = $ChooseStar/ChosenStarPicture
@onready var chosen_star_name_label = $ChooseStar/Name_bg/Name
@onready var recently_chosen_star_bar = $RecentlyChosenStarBG/RecentlyChosenStarBar
@onready var create_star_button = $CreateStarButton
@onready var confirm_create_star_ui = $ConfirmCreateStarUI
@onready var star_editUI_open_button = $"../../StarEditUIOpenButton"


# Called when the node enters the scene tree for the first time.
func _ready():
	stars = Load.get_map_editor_basic_information("stars")
	_set_recently_chosen_star_button()


func _set_recently_chosen_star_button():
	for i in range(1, 7):
		var slot = recently_chosen_star_bar.get_node("RecentlyChosenStarSlot%d"%i)
		var button : Button = slot.get_node("RecentlyChosenStarButtonBG/RecentlyChosenStarButton")
		if button != null:
			button.button_up.connect(_on_recently_chosen_star_button_up.bind(i))
		else:
			push_error("最近选择的天体按钮获取失败")


func _on_star_edit_ui_close_button_button_up():
	visible = false
	star_editUI_open_button.visible = true


func _on_choose_star_button_up():
	var choose_star_ui_node = choose_star_ui.instantiate()
	choose_star_ui_node.star_pattern_dictionary = star_pattern_dictionary
	choose_star_ui_node.star_types_information = decode_stars()
	var UI_node = $".."
	UI_node.add_child(choose_star_ui_node)
	for starslot in choose_star_ui_node.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0).get_children():
		starslot.button_up.connect(_choose_star.bind())


func _choose_star(slot_star : Star):
	_update_star_display(slot_star)
	_update_chosen_star(slot_star)
	_add_to_recently_chosen_stars(slot_star)
	_update_recently_chosen_stars_display()


func _add_to_recently_chosen_stars(star : Star):
	# 移除重复项
	for i in range(0, recently_chosen_stars.size()):
		if recently_chosen_stars[i] == star:
			recently_chosen_stars.remove_at(i)
	
	recently_chosen_stars.append(star)
	
	while  recently_chosen_stars.size() > MAX_RECENT_STARS_NUMBER:
		recently_chosen_stars.remove_at(0)


func _update_recently_chosen_stars_display():
	for i in range(min(recently_chosen_stars.size(), MAX_RECENT_STARS_NUMBER)):
		var slot = recently_chosen_star_bar.get_child(i)
		var star_index = recently_chosen_stars.size() - i - 1
		var star_information : Array = recently_chosen_stars[star_index].get_star_information()
		slot.get_child(0).texture = star_pattern_dictionary[
				star_information[0]]

# 最近选择的星球框显示(对lately_chosen_star数组从右往左读取)
func _update_star_display(star : Star):
	var star_infomation = star.get_star_information()
	chosen_star_picture.texture = star_pattern_dictionary[star_infomation[0]]
	chosen_star_name_label.text = star_infomation[4]


func _update_chosen_star(star : Star):
	# 赋予被选中的天体属性
	# star_slot_information = [天体图样名(pattern_name)(String)(index = 0), 
	# 天体缩放比例(scale)(float)(index = 1), 天体类型(type)(String)(index = 2), 
	# 大小类型(size_type)(int)(index = 3),名称(String)(index = 4),
	# 特殊天体类型(String)(index = 5)]
	var star_information : Array = star.get_star_information()
	chosen_star.pattern_name = star_information[0]
	chosen_star.star_scale = star_information[1]
	chosen_star.type = star_information[2]
	chosen_star.size_type = star_information[3]
	chosen_star.name = star_information[4]
	chosen_star.special_star_type = star_information[5]


func _update_chosen_star_mapnode_information():
	pass


# 最近选择的天体按钮被按起
func _on_recently_chosen_star_button_up(button_index : int):
	var index = recently_chosen_stars.size() - button_index
	if index >= 0 and index < recently_chosen_stars.size():
		var star = recently_chosen_stars[index]
		_update_star_display(star)
		_update_chosen_star(star)


# 生成天体
func _on_create_star_button_button_up():
	$UI/CreateUI/CreateStarButton.visible = false
	$UI/CreateUI/ConfirmCreateStarUI.visible = true

# 确认生成天体
func _on_cancel_create_star_button_button_up():
	$UI/CreateUI/ConfirmCreateStarUI.visible = false
	$UI/CreateUI/CreateStarButton.visible = true

# 取消生成天体
func _on_confirm_create_star_button_2_button_up():
	$UI/CreateUI/ConfirmCreateStarUI.visible = false
	$UI/CreateUI/CreateStarButton.visible = true


# 获取天体飞船设置信息
func get_star_fleets():
	pass


# 可能会废弃
func decode_stars() -> Array:
	var star_types_information : Array
	for star in stars:
		#var star_type_information = [天体图样名(pattern_name)(String),
		#天体缩放比例(scale)(float), 天体类型(type)(String), 
		#大小类型(size_type)(int), 名称(String), 特殊天体类型(String),
		#缩放修正(scale_fix: scale_fix_x, scale_fix_y)
		#偏移修正(offset_fix: offset_fix_x, offset_fix_y)]
		var pattern_name = star.pattern_name
		var star_scale = star.star_scale
		var star_type = star.type
		var star_size_type = star.size_type
		var star_name = star.star_name
		var star_special_star_type = star.special_star_type
		var star_type_information : Array = [pattern_name, star_scale,
				star_type, star_size_type, star_name, star_special_star_type]
		star_types_information.append(star_type_information)
	return star_types_information
