extends Control

signal show_orbit_setting_window
signal change_star_preview_state(object_name : String, change_to_what_visibility : bool)

var editor_type : EditorType

var star_preview_state : bool = false :
	set(value):
		star_preview_state = value
		update_switch_star_preview_button()

## 天体飞船设置UI
@export var configure_star_ship_ui : PackedScene

## 天体大小输入
@onready var star_size_input_option_button : OptionButton = $SizeInputLabel/StarSizeInputOptionButton
## 天体阵营输入
@onready var star_camp_input_spinbox : SpinBox = $CampInputLabel/StarCampInputSpinBox
@onready var star_camp_input_option_button : OptionButton = $CampInputLabel/StarCampInputOptionButton
## 天体飞船设置按钮
@onready var configure_star_ship_button : Button = $ConfigureStarShipButton
## 天体标签输入
@onready var star_tag_input_line_edit : LineEdit = $TagInputLabel/LineEdit
## 天体坐标输入
@onready var star_position_input_x : SpinBox = $MapNodeStarPositionInputLabel2/x/SpinBox
@onready var star_position_input_y : SpinBox = $MapNodeStarPositionInputLabel2/y/SpinBox
## 天体轨道类型输入
@onready var star_orbit_type_input_option_button : OptionButton = $OrbitType/OptionButton
## 天体轨道设置按钮
@onready var configure_star_orbit_button : Button = $OrbitEditButton
## 天体旋转角度输入
@onready var star_fangle_input : SpinBox = $FAngle/StarFAngleInput
## 是否为目标天体输入
@onready var is_target_check_Button : CheckButton = $IsTagetNode/CheckButton
## 特殊类型天体设置按钮
@onready var configure_special_star_button : Button = $ConfigureSpecialStarButton
## 天体预览开关
@onready var star_preview_switch_button : Button = $StarPreviewSwitchButton

@onready var ui_list : Array[Node] = [
	star_size_input_option_button,
	star_size_input_option_button,
	star_camp_input_spinbox,
	star_camp_input_option_button,
	configure_star_ship_button,
	star_tag_input_line_edit,
	star_position_input_x,
	star_position_input_y,
	star_orbit_type_input_option_button,
	configure_star_orbit_button,
	star_fangle_input,
	is_target_check_Button,
	configure_special_star_button,
	star_preview_switch_button,
]

# 基本信息
var defined_camp_ids : Array[int]
var camp_colors : Dictionary
var stars : Array[Star]
var orbit_types : Dictionary
var stars_dictionary : Dictionary[String, Dictionary]

# 天体编辑共享
var chosen_star : MapNodeStar:
	set(value):
		chosen_star = value
		if chosen_star != null:
			unlock_uis()
			update_star_information_ui()
			


# Called when the node enters the scene tree for the first time.
func _ready():
	_pull_map_editor_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	
	star_position_input_x.value = 0.0
	star_position_input_y.value = 0.0
	$SizeInputLabel/StarSizeInputOptionButton.clear()
	
	lock_uis()


func _pull_map_editor_information():
	defined_camp_ids = MapEditorSharedData.defined_camp_ids
	camp_colors = MapEditorSharedData.camp_colors
	stars = MapEditorSharedData.stars
	orbit_types = MapEditorSharedData.orbit_types
	stars_dictionary = MapEditorSharedData.stars_dictionary
	chosen_star = MapEditorSharedData.chosen_star
	editor_type = MapEditorSharedData.editor_type


func lock_uis():
	for i in ui_list:
		if i is SpinBox or i is LineEdit:
			i.editable = false
		else:
			i.disabled = true


func unlock_uis():
	if chosen_star != null:
		for i in ui_list:
			if i is SpinBox or i is LineEdit:
				i.editable = true
			else:
				i.disabled = false
		if editor_type is NewExpedition:
			editor_type.obey_rotation_permission_spin_box(chosen_star, star_fangle_input)
		else:
			pass
	else:
		push_error("天体信息界面没有被选择的天体信息!")


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"defined_camp_ids":
			defined_camp_ids = MapEditorSharedData.defined_camp_ids
		"camp_colors":
			camp_colors = MapEditorSharedData.camp_colors
		"stars":
			stars = MapEditorSharedData.stars
		"orbit_types":
			orbit_types = MapEditorSharedData.orbit_types
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star
		"editor_type":
			editor_type = MapEditorSharedData.editor_type


# 不仅应该在更改选择天体时被召唤，还应该在生成后被召唤
func update_star_information_ui():
	configure_star_size_input_option_button()
	configure_star_camp_input()
	# 位置也应该修改
	configure_star_orbit_type_input_option_button()
	_update_f_angle_spin_box()
	update_is_target_check_button()
	update_switch_star_preview_button()


func initialize_ui():
	pass


# 配置天体大小类型选择按钮
func configure_star_size_input_option_button():
	star_size_input_option_button.clear()
	var type_stars : Dictionary[int, Star] = stars_dictionary[chosen_star.type]
	if type_stars.size() != 0:
		for size_type in type_stars:
			star_size_input_option_button.add_item(str(size_type), size_type)
		var chosen_star_index = star_size_input_option_button.get_item_index(chosen_star.size_type)
		star_size_input_option_button.select(chosen_star_index)


# 配置天体阵营输入按钮
func configure_star_camp_input():
	star_camp_input_option_button.clear()
	if defined_camp_ids.size() != 0:
		for i in defined_camp_ids:
			star_camp_input_option_button.add_item(str(i), i)
		star_camp_input_option_button.add_item("?", defined_camp_ids[-1]+1)
		star_camp_input_option_button.set_item_disabled(defined_camp_ids[-1]+1, true)
		if chosen_star.star_camp in defined_camp_ids:
			star_camp_input_option_button.select(chosen_star.star_camp)
		else:
			star_camp_input_option_button.select(defined_camp_ids[-1]+1)
		star_camp_input_spinbox.value = chosen_star.star_camp

# 配置轨道选择按钮
func configure_star_orbit_type_input_option_button():
	star_orbit_type_input_option_button.clear()
	for star_orbit_type_id in orbit_types:
		var orbit_type : String = orbit_types[star_orbit_type_id]
		var orbit_name : String = ""
		match orbit_type:
			"no_orbit":
				orbit_name = "无轨道"
			"circle":
				orbit_name = "圆形轨道"
			"triangle":
				orbit_name = "三角形轨道"
			"quadrilateral":
				orbit_name = "正方形轨道"
			"ellipse":
				orbit_name = "椭圆轨道"
			_:
				push_error("天体轨道类型信息出错!")
		star_orbit_type_input_option_button.add_item(orbit_name, star_orbit_type_id)
	star_orbit_type_input_option_button.select(0)


func update_is_target_check_button():
	is_target_check_Button.button_pressed = chosen_star.is_taget


func update_switch_star_preview_button():
	if star_preview_state == false:
		star_preview_switch_button.text = "启用天体预览"
	else:
		star_preview_switch_button.text = "关闭天体预览"


# 天体阵营输入方式1
func _on_star_camp_input_spin_box_value_changed(value):
	if int(value) in defined_camp_ids:
		star_camp_input_option_button.select(int(value))
	else:
		star_camp_input_option_button.select(defined_camp_ids[-1]+1)
	chosen_star.star_camp = int(value)


# 天体阵营输入方式2
func _on_star_camp_input_option_button_item_selected(index):
	star_camp_input_spinbox.value = int(star_camp_input_option_button.get_item_text(index))
	chosen_star.star_camp = int(star_camp_input_spinbox.value)

# 召唤设置天体飞船UI
func _on_configure_star_ship_button_button_up():
	if chosen_star.pattern_name != "":
		var configure_star_ship_ui_node = configure_star_ship_ui.instantiate()
		$"../..".add_child(configure_star_ship_ui_node)

# 输入天体标签
func _on_line_edit_text_changed(new_text):
	chosen_star.tag = new_text


func _star_position_x_input(value):
	chosen_star.star_position.x = value


func _star_position_y_input(value):
	chosen_star.star_position.y = value


func _on_star_size_input_option_button_item_selected(index):
	# 需要研究代码逻辑
	var new_type_chosen_star : MapNodeStar = MapNodeStar.new()
	var size_types : Array[int] = stars_dictionary[chosen_star.type].keys()
	var size_type : int = size_types[index]
	new_type_chosen_star.inherit_star = stars_dictionary[chosen_star.type][size_type]
	var star_edit_ui = $".."
	star_edit_ui.call("_choose_star", new_type_chosen_star)


func _on_orbit_type_option_button_item_selected(index: int) -> void:
	var orbit_type = orbit_types[int(index)]
	chosen_star.orbit_type = orbit_type


func _on_orbit_edit_button_button_up() -> void:
	emit_signal("show_orbit_setting_window", "OrbitSettingWindow", true)


func _update_f_angle_spin_box() -> void:
	star_fangle_input.value = chosen_star.fAngle


func _on_f_angle_spin_box_value_changed(value: float) -> void:
	chosen_star.fAngle = value


func _on_is_target_check_button_button_up() -> void:
	if chosen_star.is_taget == true:
		chosen_star.is_taget = false
		is_target_check_Button.button_pressed = false
	else:
		chosen_star.is_taget = true
		is_target_check_Button.button_pressed = true


func _on_star_preview_switch_button_button_up() -> void:
	if star_preview_state == true:
		emit_signal("change_star_preview_state", "PreviewStar", false)
	else:
		emit_signal("change_star_preview_state", "PreviewStar", true)
	
