extends Node


# 编辑器基本信息
#阵营
var have_camps : Array[int]
var campcolor : Dictionary
# 天体贴图字典
var star_pattern_dictionary : Dictionary


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


func check_initalisation():
	if star_pattern_dictionary == {}:
		push_error("初始化天体贴图数据失败，请检查天体贴图文件夹是否存在")
	if have_camps == null:
		push_error("初始化天体阵营数据失败，
				请检查编辑器基本信息文件(res://GameInformation/MapEditor1BasicInformation.json)是否有问题")
	if campcolor == null:
		push_error("初始化阵营颜色数据失败，
				请检查编辑器基本信息文件(res://GameInformation/MapEditor1BasicInformation.json)是否有问题")
	#if stars == null:
		#assert(false, "初始化天体数据失败，
				#请检查编辑器基本信息文件(res://GameInformation/MapEditor1BasicInformation.json)是否有问题")
		# 应当弹出警告窗


func _on_star_edit_ui_open_button_button_up():
	$StarEditUIOpenButton.visible = false
	$UI/CreateUI.visible = true
