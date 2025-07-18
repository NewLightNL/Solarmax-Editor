extends Node

@export var choose_star_ui : PackedScene


# 编辑器基本信息
#阵营
var have_camps : Array[int]
var campcolor : Dictionary
# 天体贴图字典
var star_pattern_dictionary : Dictionary
# 天体
var stars : Array[Star]

var lately_chosen_stars : Array
var chosen_star : MapNodeStar = MapNodeStar.new()
var is_star_chosen : bool = false# 用于未来判断是否有天体被选择

var star_fleets : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	# 初始化变量
	# 加载编辑器基本信息
	star_pattern_dictionary = Load.init_star_pattern_dictionary()
	have_camps = Load.get_map_editor_basic_information("defined_camp_ids")
	campcolor = Load.get_map_editor_basic_information("camp_colors")
	stars = Load.get_map_editor_basic_information("stars")
	check_initalisation()
	
	# 处理变量
	
	
	# 初始化创建天体UI
	$StarEditUIOpenButton.visible = false
	$UI/CreateUI.visible = true
	#if is_star_chosen == false:
		#$UI/CreateUI/StarInformation/SetStarShipButton.disabled = true
	#$UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInput.text = "0"
	#$UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInputOptionButton.clear()



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




func _on_choose_star_button_up():
	var choose_star_ui_node = choose_star_ui.instantiate()
	choose_star_ui_node.star_pattern_dictionary = star_pattern_dictionary
	choose_star_ui_node.star_types_information = decode_stars()
	$UI.add_child(choose_star_ui_node)
	for starslot in choose_star_ui_node.get_child(0).get_child(0).get_child(0).get_child(0).get_child(0).get_children():
		starslot.deliver_star_slot_information.connect(_choose_star)

func _choose_star(star_slot_information):
	# 选择星球框显示
	$UI/CreateUI/ChooseStar/ChoosedStarPicture.texture = star_pattern_dictionary[star_slot_information[0]]
	$UI/CreateUI/ChooseStar/Name_bg/Name.text = star_slot_information[4]
	
	# 赋予被选中的天体属性
	# star_slot_information = [天体图样名(pattern_name)(String)(index = 0), 
	# 天体缩放比例(scale)(float)(index = 1), 天体类型(type)(String)(index = 2), 
	# 大小类型(size_type)(int)(index = 3),名称(String)(index = 4),
	# 特殊天体类型(String)(index = 5)]
	chosen_star.pattern_name = star_slot_information[0]
	chosen_star.star_scale = star_slot_information[1]
	chosen_star.type = star_slot_information[2]
	chosen_star.size_type = star_slot_information[3]
	chosen_star.name = star_slot_information[4]
	chosen_star.special_star_type = star_slot_information[5]
	
	# 添加选择的天体进入最近选择的天体
	if lately_chosen_stars.size() < 6: # 6应改为最近选择的星球栏的格子数
		# 要修改的点: 在除了information的内容，还需要...也就是lately_chosen_star装的应该是mapnode基本内容
		lately_chosen_stars.append(star_slot_information)
	else:
		lately_chosen_stars.append(star_slot_information)
		lately_chosen_stars.remove_at(0)
	
	# 最近选择的星球框显示(对lately_chosen_star数组从右往左读取)
	# 可能要做清除?
	for i in range(lately_chosen_stars.size()):
		var slot = $UI/CreateUI/LatelyChosenStarBG/LatelyChosenStarBar.get_child(i)
		slot.get_child(0).texture = star_pattern_dictionary[lately_chosen_stars[-i-1][0]]
	
	is_star_chosen = true
	if is_star_chosen == true:
		$UI/CreateUI/StarInformation/SetStarShipButton.disabled = false


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

func _on_lately_chosen_star_button_button_up6():
	if lately_chosen_stars.size() >= 6:
		$UI/CreateUI/ChooseStar/ChoosedStarPicture.texture = load(lately_chosen_stars[-6][0])
		$UI/CreateUI/ChooseStar/Name_bg/Name.text = lately_chosen_stars[-6][4]






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

func check_initalisation():
	if star_pattern_dictionary == {}:
		assert(false, "初始化天体贴图数据失败，请检查天体贴图文件夹是否存在")
	if have_camps == null:
		assert(false, "初始化天体阵营数据失败，
				请检查编辑器基本信息文件(res://GameInformation/MapEditor1BasicInformation.json)是否有问题")
	if campcolor == null:
		assert(false, "初始化阵营颜色数据失败，
				请检查编辑器基本信息文件(res://GameInformation/MapEditor1BasicInformation.json)是否有问题")
	if stars == null:
		assert(false, "初始化天体数据失败，
				请检查编辑器基本信息文件(res://GameInformation/MapEditor1BasicInformation.json)是否有问题")
		# 应当弹出警告窗

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


func _on_star_edit_ui_open_button_button_up():
	$StarEditUIOpenButton.visible = false
	$UI/CreateUI.visible = true
