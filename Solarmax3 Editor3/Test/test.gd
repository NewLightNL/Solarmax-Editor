extends Node2D

# 用于测试代码以及其它什么东西的

const MAPEDITOR1_BASIC_INFORMATION : String = "res://GameInformation/MapEditor1BasicInformation.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_map_editor_basic_information("campcolor"))

func get_map_editor_basic_information(get_what_informtion : String):
	# 检验路径上有没有这个文件
	if not FileAccess.file_exists(MAPEDITOR1_BASIC_INFORMATION):
		assert(false, "在文件路径:%s上的保存文件不存在!" %MAPEDITOR1_BASIC_INFORMATION)
		return "在文件路径:%s上的保存文件不存在!" %MAPEDITOR1_BASIC_INFORMATION
	var information_file = FileAccess.open(MAPEDITOR1_BASIC_INFORMATION, FileAccess.READ)

	# 获得json文件里的信息
	var information_json_string : String = information_file.get_as_text()
	# 使用JSON类辅助解析
	var json = JSON.new()
	# 是否成功解析
	var parse_result = json.parse(information_json_string)
	if not parse_result == OK:
		assert(false, "解析文件信息失败！JSON Parse: Error: %s at line %s"%[json.get_error_message(), json.get_error_line()])
		return
	var information_data = json.data
	match get_what_informtion:
		"have_camps":
			# int化
			var have_camps : Array
			for i in information_data["have_camps"]:
				if i not in have_camps:
					have_camps.append(int(i))
			# 对数组进行排序，防止出现保存的阵营数据不是按从小到大的顺序
			have_camps.sort()# 功能可能冗余，到时候可能要删
			return have_camps
		"campcolor":
			var campcolor : Dictionary
			for key in information_data["campcolor"]:
				campcolor[int(key)] = Color(information_data["campcolor"][key])
			return campcolor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
