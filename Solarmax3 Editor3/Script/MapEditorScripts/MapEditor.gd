extends Node

@export var map_node_star_list_unit : PackedScene

# 编辑器基本信息
# 交流变量
# 阵营
var defined_camp_ids : Array[int]
var camp_colors : Dictionary
# 天体贴图字典
var star_pattern_dictionary : Dictionary
var stars : Array[Star]
# 轨道类型
var orbit_types : Dictionary
var chosen_star : MapNodeStar
var editor_type : EditorType

@onready var star_edit_ui_open_button : Button = $UI/EditorUI/StarEditUIOpenButton


# Called when the node enters the scene tree for the first time.
func _ready():
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	
	# 初始化界面
	$UI/SaveWindow.set_ok_button_text("保存")


func _pull_map_editor_information():
	defined_camp_ids = MapEditorSharedData.defined_camp_ids
	camp_colors = MapEditorSharedData.camp_colors
	star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
	stars = MapEditorSharedData.stars
	orbit_types = MapEditorSharedData.orbit_types
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"defined_camp_ids":
			defined_camp_ids = MapEditorSharedData.defined_camp_ids
		"camp_colors":
			camp_colors = MapEditorSharedData.camp_colors
		"star_pattern_dictionary":
			star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
		"stars":
			stars = MapEditorSharedData.stars
		"orbit_types":
			orbit_types = MapEditorSharedData.orbit_types
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star
		"editor_type":
			editor_type = MapEditorSharedData.editor_type


func check_initalisation():
	if star_pattern_dictionary == {}:
		push_error("初始化天体贴图数据失败，请检查天体贴图文件夹是否存在")
	if defined_camp_ids == null:
		push_error("初始化天体阵营数据失败，
				请检查编辑器基本信息文件(res://GameInformation/MapEditor1BasicInformation.json)是否有问题")
	if camp_colors == null:
		push_error("初始化阵营颜色数据失败，
				请检查编辑器基本信息文件(res://GameInformation/MapEditor1BasicInformation.json)是否有问题")
	#if stars == null:
		#assert(false, "初始化天体数据失败，
				#请检查编辑器基本信息文件(res://GameInformation/MapEditor1BasicInformation.json)是否有问题")
		# 应当弹出警告窗
