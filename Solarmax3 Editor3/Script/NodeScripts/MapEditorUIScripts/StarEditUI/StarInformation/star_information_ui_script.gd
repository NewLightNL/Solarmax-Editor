extends Control


signal star_size_changed(size_type : int)
signal star_information_changed
signal request_show_ui(ui : Node)

signal change_star_preview_state(object_name : String, change_to_what_visibility : bool)

## 天体飞船设置UI
@export var configure_star_ship_ui : PackedScene
@export var orbit_setting_window : PackedScene
@export var configure_lasergun_information_window_scene : PackedScene
@export var unknown_star_transformation_buildings_setting_window_scene : PackedScene

var editor_type : EditorType

var star_preview_state : bool = false :
	set(value):
		star_preview_state = value
		update_switch_star_preview_button()
var orbit_setting_window_showing : ConfirmationDialog
var configure_lasergun_information_window_showing : Window
var unknown_star_transformation_buildings_setting_window_showing : Window

# 基本信息
var defined_camp_ids : Array[int]
var camp_colors : Dictionary
var stars : Array[Star]
var orbit_types : Dictionary
var stars_dictionary : Dictionary[String, Dictionary]
var chosen_star : MapNodeStar

## 天体大小输入
@onready var star_size_input_control : Control = $SizeInputControl
## 天体阵营输入
@onready var star_camp_input_control : Control = $CampInputControl
## 天体飞船设置按钮
@onready var configure_star_ship_button : Button = $ConfigureStarShipButton
## 天体标签输入
@onready var star_tag_input_control : Control = $TagInputControl
## 天体坐标输入
@onready var star_position_input_control : Control = $MapNodeStarPositionInputControl
## 天体轨道类型输入
@onready var star_orbit_input_control : Control = $OrbitInputControl
## 天体轨道设置按钮
@onready var configure_star_orbit_button : Button = $OrbitInputControl/OrbitEditButton
## 天体旋转角度输入
@onready var star_f_angle_input_control : Control = $FAngleInputControl
## 是否为目标天体输入
@onready var star_is_target_control : Control = $IsTargetInputControl
## 特殊类型天体设置按钮
@onready var configure_special_star_button : Button = $ConfigureSpecialStarButton
## 天体预览开关
@onready var star_preview_switch_button : Button = $StarPreviewSwitchButton

@onready var ui_list : Array[Node] = [
	star_size_input_control,
	star_camp_input_control,
	configure_star_ship_button,
	star_tag_input_control,
	star_position_input_control,
	star_orbit_input_control,
	configure_star_orbit_button,
	star_f_angle_input_control,
	star_is_target_control,
	configure_special_star_button,
	star_preview_switch_button,
]


# Called when the node enters the scene tree for the first time.
func _ready():
	_pull_map_editor_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	
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
		if i is Control:
			if i.has_method("lock_ui"):
				i.lock_ui()
			else:
				if i is Button:
					i.disabled = true
				else:
					push_error("有UI没有lock_ui方法")


func unlock_uis():
	if chosen_star != null:
		for i in ui_list:
			if i is Control:
				if i.has_method("unlock_ui"):
					i.unlock_ui()
				else:
					if i is Button:
						i.disabled = false
					else:
						push_error("有UI没有unlock_ui方法")
		
		if editor_type is NewExpedition:
			editor_type.obey_dirt_star_rotation_rule(
					chosen_star,
					star_f_angle_input_control,
					editor_type.OperationType.PERMISSTION
			)
		else:
			pass
		
		if (
				chosen_star.special_star_type != "Lasergun" 
				and chosen_star.special_star_type != "UnknownStar"
		):
			configure_special_star_button.disabled = true
		
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
# 应该直接从这里获取信息，而不是用chosen_star来得到信息
func update_star_information_ui_on_choosing_star(star : Star):
	_initialize_star_size_input_option_button(star)
	_initialize_camp_input_label()
	_initialize_tag_input_label()
	_initialize_map_node_star_position_input()
	_initialize_orbit_type_option_button()
	_initialize_orbit_setting_window()
	_initialize_star_f_angle_input_spin_box(star)
	_initialize_is_target_node_check_button()
	_initialize_configure_lasergun_information_window()
	_initialize_unknown_star_transformation_buildings_setting_window()


func _initialize_star_size_input_option_button(star : Star):
	star_size_input_control.initialize_size_input_option_button(star)


func _initialize_camp_input_label():
	star_camp_input_control.initialize_camp_input_ui()


func _initialize_tag_input_label():
	star_tag_input_control.initialize_tag_input_line_edit()


func _initialize_map_node_star_position_input():
	star_position_input_control.initialize_map_node_star_position_input()


func _initialize_orbit_type_option_button():
	star_orbit_input_control.initialize_orbit_type_option_button()


func _initialize_orbit_setting_window():
	if orbit_setting_window_showing != null:
		orbit_setting_window_showing.initialize_orbit_setting_window()


func _initialize_star_f_angle_input_spin_box(star : Star):
	star_f_angle_input_control.initialize_star_f_angle_input_spin_box(star)


func _initialize_is_target_node_check_button() -> void:
	star_is_target_control.initialize_is_target_node_check_button()


func _initialize_configure_lasergun_information_window():
	if configure_lasergun_information_window_showing != null:
		configure_lasergun_information_window_showing.initialize_configure_lasergun_information_window()


func _initialize_unknown_star_transformation_buildings_setting_window() -> void:
	if unknown_star_transformation_buildings_setting_window_showing != null:
		unknown_star_transformation_buildings_setting_window_showing.initialize_unknown_star_transformation_buildings_setting_window()


func update_star_information_ui_on_switching_to_recently_chosen_star(map_node_star : MapNodeStar):
	_update_star_size_input_option_button(map_node_star)
	_update_star_camp_input(map_node_star)
	_update_star_position_input(map_node_star)
	_update_star_orbit_type_input_option_button(map_node_star)
	_update_orbit_setting_window(map_node_star)
	_update_f_angle_spin_box(map_node_star)
	_update_is_target_check_button(map_node_star)
	_update_configure_lasergun_information_window(map_node_star)
	_update_unknown_star_transformation_buildings_setting_window(map_node_star)


# 更新天体大小类型选择按钮
func _update_star_size_input_option_button(map_node_star : MapNodeStar):
	star_size_input_control.update_star_size_input_option_button(map_node_star)
	emit_signal("star_information_changed")


# 配置天体阵营输入按钮
func _update_star_camp_input(map_node_star : MapNodeStar):
	star_camp_input_control.uptdate_camp_input_ui(map_node_star)
	emit_signal("star_information_changed")


func _update_star_position_input(map_node_star : MapNodeStar):
	star_position_input_control.update_map_node_star_position_input(map_node_star)
	emit_signal("star_information_changed")


# 配置轨道选择按钮
func _update_star_orbit_type_input_option_button(map_node_star : MapNodeStar):
	star_orbit_input_control.update_orbit_type_option_button(map_node_star)
	emit_signal("star_information_changed")


func _update_orbit_setting_window(map_node_star : MapNodeStar):
	if orbit_setting_window_showing != null:
		orbit_setting_window_showing.update_orbit_setting_window(map_node_star)


func _update_f_angle_spin_box(map_node_star : MapNodeStar) -> void:
	star_f_angle_input_control.update_star_f_angle_input_spin_box(map_node_star)
	emit_signal("star_information_changed")


func _update_is_target_check_button(map_node_star : MapNodeStar):
	star_is_target_control.update_is_target_node_check_button(map_node_star)
	emit_signal("star_information_changed")


func _update_configure_lasergun_information_window(map_node_star : MapNodeStar):
	if configure_lasergun_information_window_showing != null:
		configure_lasergun_information_window_showing.update_configure_lasergun_information_window(map_node_star)


func _update_unknown_star_transformation_buildings_setting_window(map_node_star : MapNodeStar):
	if unknown_star_transformation_buildings_setting_window_showing != null:
		unknown_star_transformation_buildings_setting_window_showing.update_unknown_star_transformation_buildings_setting_window(map_node_star)


func _on_size_input_control_star_size_changed(star_size_type: int) -> void:
	emit_signal("star_size_changed", star_size_type)


func _on_camp_input_control_camp_id_changed(camp: int) -> void:
	chosen_star.star_camp = camp
	emit_signal("star_information_changed")


# 召唤设置天体飞船UI
func _on_configure_star_ship_button_button_up():
	if chosen_star.pattern_name != "":
		var configure_star_ship_ui_node = configure_star_ship_ui.instantiate()
		$"../..".add_child(configure_star_ship_ui_node)
		configure_star_ship_ui_node.star_fleets_information_changed.connect(_on_star_fleets_information_changed)


func _on_star_fleets_information_changed():
	emit_signal("star_information_changed")


func _on_tag_input_control_star_tag_changed(star_tag: String) -> void:
	chosen_star.tag = star_tag
	emit_signal("star_information_changed")


func _on_map_node_star_position_input_control_star_position_changed(star_position: Vector2) -> void:
	chosen_star.star_position = star_position
	emit_signal("star_information_changed")


func _on_orbit_input_control_star_orbit_type_changed(star_orbit_type: String) -> void:
	chosen_star.orbit_type = star_orbit_type
	emit_signal("star_information_changed")


func _on_orbit_setting_window_star_orbit_information_changed(orbit_parameter1 : Vector2, orbit_parameter2 : Vector2):
	chosen_star.orbit_param1 = orbit_parameter1
	chosen_star.orbit_param2 = orbit_parameter2
	emit_signal("star_information_changed")


func _on_orbit_input_control_request_show_orbit_setting_ui() -> void:
	var orbit_setting_window_instantiated : ConfirmationDialog = orbit_setting_window.instantiate()
	orbit_setting_window_instantiated.star_orbit_information_changed.connect(_on_orbit_setting_window_star_orbit_information_changed)
	orbit_setting_window_instantiated.position = Vector2(1500.0, 750.0)
	orbit_setting_window_showing = orbit_setting_window_instantiated
	emit_signal("request_show_ui", orbit_setting_window_instantiated)


func _on_f_angle_input_control_star_f_angle_changed(star_f_angle: float) -> void:
	chosen_star.fAngle = star_f_angle
	emit_signal("star_information_changed")


func _on_is_target_input_control_is_target_state_changed(is_target_state: bool) -> void:
	chosen_star.is_taget = is_target_state
	_update_f_angle_spin_box(chosen_star)
	emit_signal("star_information_changed")


func _on_configure_lasergun_information_window_lasergun_information_changed(lasergun_information : Dictionary[String, float]):
	chosen_star.lasergun_information = lasergun_information
	emit_signal("star_information_changed")


func _on_unknown_star_transformation_buildings_setting_window(unknown_star_transformation_buildings_ids : Array[int]):
	chosen_star.transformBuildingID = unknown_star_transformation_buildings_ids
	emit_signal("star_information_changed")


func _on_star_preview_switch_button_button_up() -> void:
	if star_preview_state == true:
		emit_signal("change_star_preview_state", "PreviewStar", false)
	else:
		emit_signal("change_star_preview_state", "PreviewStar", true)


func update_switch_star_preview_button():
	if star_preview_state == false:
		star_preview_switch_button.text = "启用天体预览"
	else:
		star_preview_switch_button.text = "关闭天体预览"


func _on_configure_special_star_button_button_up() -> void:
	match chosen_star.special_star_type:
		"Lasergun":
			var configure_lasergun_information_window : Window = configure_lasergun_information_window_scene.instantiate()
			configure_lasergun_information_window.lasergun_information_changed.connect(_on_configure_lasergun_information_window_lasergun_information_changed)
			configure_lasergun_information_window_showing = configure_lasergun_information_window
			emit_signal("request_show_ui", configure_lasergun_information_window)
		"UnknownStar":
			var unknown_star_transformation_buildings_setting_window : Window = unknown_star_transformation_buildings_setting_window_scene.instantiate()
			unknown_star_transformation_buildings_setting_window.unknown_star_transformBuildingID_information_changed.connect(_on_unknown_star_transformation_buildings_setting_window)
			unknown_star_transformation_buildings_setting_window_showing = unknown_star_transformation_buildings_setting_window
			emit_signal("request_show_ui", unknown_star_transformation_buildings_setting_window)
			
