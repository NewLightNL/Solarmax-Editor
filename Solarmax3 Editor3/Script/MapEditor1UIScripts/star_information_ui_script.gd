extends Control

var shared_date : Resource

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

# 交流变量
# 基本信息
var defined_camp_ids : Array[int]
var camp_colors : Dictionary
var stars : Array[Star]
var orbit_types : Dictionary

# 天体编辑共享
var chosen_star : MapNodeStar

# 输出


# 内部
var star_size_types : Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	Mapeditor1ShareData.editor_data_updated.connect(_on_global_data_updated)
	star_position_input_x.value = 0.0
	star_position_input_y.value = 0.0
	$SizeInputLabel/StarSizeInputOptionButton.clear()

func _on_global_data_updated(key : String):
	match key:
		"defined_camp_ids":
			defined_camp_ids = Mapeditor1ShareData.defined_camp_ids
		"camp_colors":
			camp_colors = Mapeditor1ShareData.camp_colors
		"stars":
			stars = Mapeditor1ShareData.stars
		"orbit_types":
			orbit_types = Mapeditor1ShareData.orbit_types
		"all_basic_information":
			defined_camp_ids = Mapeditor1ShareData.defined_camp_ids
			camp_colors = Mapeditor1ShareData.camp_colors
			stars = Mapeditor1ShareData.stars
			orbit_types = Mapeditor1ShareData.orbit_types
		"chosen_star":
			chosen_star = Mapeditor1ShareData.chosen_star
		_:
			push_error("数据更新出错，请检查要提交的内容名是否正确")


func update_star_information_ui():
	get_star_size_types()
	configure_star_size_input_option_button()
	configure_star_camp_input()
	configure_star_orbit_type_input_option_button()

# 设置被选择天体属性
func set_chosen_star(chosen_star_import : MapNodeStar):
	chosen_star = chosen_star_import
	# 设置默认属性
	chosen_star.size_type = star_size_types[0]
	chosen_star.star_camp = defined_camp_ids[0]
	chosen_star.this_star_fleets = []
	chosen_star.tag = ""
	var star_position_x = star_position_input_x.value
	var star_potition_y = star_position_input_y.value
	chosen_star.star_position = Vector2(star_position_x, star_potition_y)
	Mapeditor1ShareData.data_updated("chosen_star", chosen_star)

# 获取天体类型
func get_star_size_types():
	var star_size_types_process : Array[int]
	for star in stars:
		if star.type == chosen_star.type:
			star_size_types_process.append(star.size_type)
	star_size_types_process.sort()
	star_size_types =  star_size_types_process

# 配置天体大小类型选择按钮
func configure_star_size_input_option_button():
	star_size_input_option_button.clear()
	if star_size_types.size() != 0:
		var index : int = -1
		for i in star_size_types:
			index += 1
			star_size_input_option_button.add_item(str(i), index)
		star_size_input_option_button.select(0)

# 配置天体阵营输入按钮
func configure_star_camp_input():
	star_camp_input_option_button.clear()
	if defined_camp_ids.size() != 0:
		for i in defined_camp_ids:
			star_camp_input_option_button.add_item(str(i), i)
		star_camp_input_option_button.add_item("?", defined_camp_ids[-1]+1)
		star_camp_input_option_button.set_item_disabled(defined_camp_ids[-1]+1, true)
		star_camp_input_option_button.select(0)
		star_camp_input_spinbox.value = 0

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


# 将天体阵营的两个输入方式绑定
func _on_star_camp_input_spin_box_changed():
	if int(star_camp_input_spinbox.value) in defined_camp_ids:
		star_camp_input_option_button.select(int(star_camp_input_spinbox.value))
	else:
		star_camp_input_option_button.select(defined_camp_ids[-1]+1)

func _on_star_camp_input_option_button_item_selected(index):
	star_camp_input_spinbox.value = int(star_camp_input_option_button.get_item_text(index))

# 召唤设置天体飞船UI
func _on_configure_star_ship_button_button_up():
	if chosen_star.pattern_name != "":
		var configure_star_ship_ui_node = configure_star_ship_ui.instantiate()
		# 输入信息
		# 输入基本信息
		configure_star_ship_ui_node.defined_camp_ids = defined_camp_ids
		configure_star_ship_ui_node.camp_colors = camp_colors
		# 输入天体
		configure_star_ship_ui_node.chosen_star = chosen_star
		$"../..".add_child(configure_star_ship_ui_node)


func _on_star_size_input_option_button_item_selected(index):
	chosen_star.size_type = int(star_size_input_option_button.get_item_text(index))
