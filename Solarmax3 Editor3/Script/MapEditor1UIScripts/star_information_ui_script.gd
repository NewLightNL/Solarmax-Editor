extends Control

@export_group("界面")
## 天体飞船设置UI
@export var configure_star_ship_ui : PackedScene

@export_group("", "")
## 天体大小输入
@export var star_size_input_option_button : OptionButton

@export_group("天体阵营输入")
@export var star_camp_input_spinbox : SpinBox
@export var star_camp_input_option_button : OptionButton

@export_group("", "")
## 天体飞船设置按钮
@export var configure_star_ship_button : Button
## 天体标签输入
@export var star_tag_input_line_edit : LineEdit

@export_group("天体坐标输入")
@export var star_position_input_x : SpinBox
@export var star_position_input_y : SpinBox

@export_group("", "")
## 天体轨道类型输入
@export var star_orbit_type_input_option_button : OptionButton
## 天体轨道设置按钮
@export var configure_star_orbit_button : Button
## 天体旋转角度输入
@export var star_fangle_input : SpinBox
## 是否为目标天体输入
@export var is_target_node_input : CheckButton
## 特殊类型天体设置按钮
@export var configure_special_star_button : Button

# 外部输入
var have_camps : Array
var campcolor : Dictionary
var chosen_star : MapNodeStar
var stars : Array[Star]

# 输出


# 内部
var star_size_types : Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	chosen_star = MapNodeStar.new()
	chosen_star.type = "star"
	chosen_star.pattern_name = "planet01"
	have_camps = Load.get_map_editor_basic_information("have_camps")
	campcolor = Load.get_map_editor_basic_information("campcolor")
	stars = Load.get_map_editor_basic_information("stars")
	star_size_types = get_star_size_types()
	configure_star_size_input_option_button()
	star_camp_input_option_button.clear()
	if have_camps.size() != 0:
		for i in have_camps:
			star_camp_input_option_button.add_item(str(i), i)
		star_camp_input_option_button.add_item("?", have_camps[-1]+1)
		star_camp_input_option_button.set_item_disabled(have_camps[-1]+1, true)
		star_camp_input_option_button.select(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 将天体阵营的两个输入方式绑定
func _on_star_camp_input_spin_box_changed():
	if int(star_camp_input_spinbox.value) in have_camps:
		star_camp_input_option_button.select(int(star_camp_input_spinbox.value))
	else:
		star_camp_input_option_button.select(have_camps[-1]+1)

func _on_star_camp_input_option_button_item_selected(index):
	star_camp_input_spinbox.value = int(star_camp_input_option_button.get_item_text(index))

func get_star_size_types() -> Array[int]:
	var star_size_types_process : Array[int]
	for star in stars:
		if star.type == chosen_star.type:
			star_size_types_process.append(star.size_type)
	star_size_types_process.sort()
	return star_size_types_process

func configure_star_size_input_option_button():
	if star_size_types.size() != 0:
		var index : int = -1
		for i in star_size_types:
			index += 1
			star_size_input_option_button.add_item(str(i), index)
		star_size_input_option_button.select(0)

# 召唤设置天体飞船UI
func _on_configure_star_ship_button_button_up():
	if chosen_star.pattern_name != "":
		var configure_star_ship_ui_node = configure_star_ship_ui.instantiate()
		# 输入信息
		# 输入基本信息
		configure_star_ship_ui_node.have_camps = have_camps
		configure_star_ship_ui_node.campcolor = campcolor
		# 输入天体信息
		configure_star_ship_ui_node.this_star_fleets = chosen_star.this_star_fleets
		$"../..".add_child(configure_star_ship_ui_node)
