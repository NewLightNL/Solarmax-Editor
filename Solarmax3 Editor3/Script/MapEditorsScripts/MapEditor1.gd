extends Node

@export var choose_star_ui : PackedScene
@export var set_star_ship_ui : PackedScene

# 编辑器基本信息
#阵营
var have_camps : Array = [0, 1, 2, 3, 4, 5, 6, 7, 8]
var campcolor : Dictionary = {0 : Color("CCCCCC"), 1 : Color("5FB6FF"),
2 : Color("FF5D93"), 3 : Color("FE8B59"), 4 : Color("C6FA6C"),
5 : Color("CCCCCC"), 6 : Color("CCCCCC"), 7 : Color("000000"),
8 : Color("1B924B")}
# 天体
var star_pattern_dictionary : Dictionary = Load.init_star_pattern_dictionary()

var star_types_information : Array = [["planet01", 0.4, "star", 1, "30人口星球", "null"],
["starbase", 1, "castle", 1, "太空堡垒", "null"]]
# StarTypeElement = [天体图样名(pattern_name)(String), 天体缩放比例(scale)(float), 天体类型(type)(String), 大小类型(size_type)(int), 名称(String), 特殊天体类型(String)]

var lately_chosen_stars : Array
var chosen_star : Array
# mapnode基本内容: [
# 天体自身信息: 天体图样名(pattern_name)(String), 天体缩放比例(scale)(float), 天体类型(type)(String), 大小类型(size_type)(int), 名称(String), 特殊天体类型(String),
# 地图添加信息: 大小类型(size)(int)( = size_type), 天体标签(tag)(String), 天体阵营(camption), 天体舰队(Array),天体坐标(Vector2), 轨道信息(Array), 旋转角度(float), 
# 特殊天体信息: 变形装置变形的天体的id们(Array), 射线炮数据(Array),
# 其它信息: 是否为目标天体(bool)
# ]

var star_fleets : Array

var editing_star_information : Array 

# Called when the node enters the scene tree for the first time.
func _ready():
	# 初始化创建天体UI
	$CreateUI_openButton.visible = false
	$UI/CreateUI.visible = true
	editing_star_information = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("up"):
		$Camera.position -= Vector2(0, 100) * delta
	if Input.is_action_pressed("down"):
		$Camera.position += Vector2(0, 100) * delta
	if Input.is_action_pressed("left"):
		$Camera.position -= Vector2(100, 0) * delta
	if Input.is_action_pressed("right"):
		$Camera.position += Vector2(100, 0) * delta


func _on_create_ui_close_button_button_up():
	$CreateUI.visible = false
	$UI/CreateUI_openButton.visible = true


func _on_create_ui_open_button_button_up():
	$CreateUI_openButton.visible = false
	$UI/CreateUI.visible = true


func _on_choose_star_button_up():
	var choose_star_ui_node = choose_star_ui.instantiate()
	choose_star_ui_node.star_pattern_dictionary = star_pattern_dictionary
	choose_star_ui_node.star_types_information = star_types_information
	$UI.add_child(choose_star_ui_node)
	for starslot in choose_star_ui_node.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0).get_children():
		starslot.deliver_star_slot_information.connect(_choose_star)

func _choose_star(star_slot_information):
	# 选择星球框显示
	$UI/CreateUI/ChooseStar/ChoosedStarPicture.texture = star_pattern_dictionary[star_slot_information[0]]
	$UI/CreateUI/ChooseStar/Name_bg/Name.text = star_slot_information[4]
	
	
	if lately_chosen_stars.size() < 5:
		# 要修改的点: 在除了information的内容，还需要...也就是lately_chosen_star装的应该是mapnode基本内容
		lately_chosen_stars.append(star_slot_information)
	else:
		lately_chosen_stars.append(star_slot_information)
		lately_chosen_stars.remove_at(0)
	
	
	# 最近选择的星球框显示(对lately_chosen_star数组从右往左读取)
	for i in range(lately_chosen_stars.size()):
		var slot = $UI/CreateUI/LatelyChosenStarBG/LatelyChosenStarBar.get_child(i)
		slot.get_child(0).texture = star_pattern_dictionary[lately_chosen_stars[-i-1][0]]



# 最近选择的天体按钮被按起
func _on_lately_chosen_star_button_button_up1():
	if lately_chosen_stars.size() >= 1:
		$UI/CreateUI/ChooseStar/ChoosedStarPicture.texture = star_pattern_dictionary[lately_chosen_stars[-1][0]]
		$UI/CreateUI/ChooseStar/Name_bg/Name.text = lately_chosen_stars[-1][4]

func _on_lately_chosen_star_button_button_up2():
	if lately_chosen_stars.size() >= 2:
		$UI/CreateUI/ChooseStar/ChoosedStarPicture.texture = star_pattern_dictionary[lately_chosen_stars[-2][0]]
		$UI/CreateUI/ChooseStar/Name_bg/Name.text = lately_chosen_stars[-2][4]

func _on_lately_chosen_star_button_button_up3():
	if lately_chosen_stars.size() >= 3:
		$UI/CreateUI/ChooseStar/ChoosedStarPicture.texture = star_pattern_dictionary[lately_chosen_stars[-3][0]]
		$UI/CreateUI/ChooseStar/Name_bg/Name.text = lately_chosen_stars[-3][4]

func _on_lately_chosen_star_button_button_up4():
	if lately_chosen_stars.size() >= 4:
		$UI/CreateUI/ChooseStar/ChoosedStarPicture.texture = star_pattern_dictionary[lately_chosen_stars[-4][0]]
		$UI/CreateUI/ChooseStar/Name_bg/Name.text = lately_chosen_stars[-4][4]

func _on_lately_chosen_star_button_button_up5():
	if lately_chosen_stars.size() >= 5:
		$UI/CreateUI/ChooseStar/ChoosedStarPicture.texture = load(lately_chosen_stars[-5][0])
		$UI/CreateUI/ChooseStar/Name_bg/Name.text = lately_chosen_stars[-5][4]


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

# 召唤设置天体飞船UI
func _on_set_star_ship_button_button_up():
	var set_star_ship_ui_node = set_star_ship_ui.instantiate()
	$UI.add_child(set_star_ship_ui_node)
	# 输入信息
	set_star_ship_ui_node.have_camps = have_camps
	set_star_ship_ui_node.campcolor = campcolor
	set_star_ship_ui_node.star_fleets = star_fleets


# 获取天体飞船设置信息
func get_star_fleets():
	pass
