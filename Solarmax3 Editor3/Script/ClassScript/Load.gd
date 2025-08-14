class_name Load
## 加载地图编辑器的资源和信息的类

const INFO_STARS = "stars"
const INFO_DEFINED_CAMP_IDS = "defined_camp_ids"
const INFO_CAMP_COLORS = "camp_colors"
const INFO_ORBIT_TYPES = "orbit_types"

# 建议预加载项与主体分离
# UI，天体，各种控件也尽量都与主编辑器分离，MapEditor只作为启动以及管理中心

# 应注意: res:// 只在开发/运行时有效
const _STARTEXTUREPATH : String = "res://Textures/StarTexture"
const _MAPEDITOR1_BASIC_INFORMATION : String = "res://GameInformation/mapeditor1_basic_data.json"
const _STARS_INFORMATION_PATH : String = "res://GameInformation/stars_data.json"

# 未来要修改文件夹, 增加在Texture增加文件夹BetaVersion1、3(测试版1、3)
# 现在的纹理会被放入BetaVersion1(测试版1)
## 初始化天体贴图字典
static func init_star_pattern_dictionary(path:String = _STARTEXTUREPATH) -> Dictionary[String, CompressedTexture2D]:
	var dictionary_result : Dictionary[String, CompressedTexture2D] = {}
	var directory = DirAccess.open(path) # 新建 DirAccess 对象并打开文件系统中的某个现存目录
	
	# directory如果返回的是null, 也就是打开失败了
	if directory == null:
		# 正式上来时，要告知用户缺少文件
		assert(false, "无法打开目录: %s, 因为%s"% [path, DirAccess.get_open_error()])# 如果无法打开，强制停止项目
		return dictionary_result# 要返回错误原因
	
	# 初始化用于通过get_next()函数
	# “流”是什么: 把读一点处理一点(以及相反的生成一点, 写入一点)的数据类型(或曰操作)抽象出来, 就是流
	# 流就是读一点数据, 处理一点点数据
	directory.list_dir_begin()# 开始访问文件夹的流
	var file_name : String = directory.get_next()# 获得文件名
	while file_name != "":
		# 跳过 "."(当前目录) 和 ".."(上级目录) 目录(虽然好像没遇到)
		# 另外，该判断可以实现隐藏文件
		if file_name == "." or file_name == "..":
			file_name = directory.get_next()
			continue
		# 访问非星球纹理和星球文件夹
		var full_path = path.path_join(file_name) # 获得完整路径
		if directory.current_is_dir(): # 判断正在访问的这个东西是不是文件夹
			var get_planets : Dictionary = init_star_pattern_dictionary(full_path) # 递归子文件夹
			dictionary_result.merge(get_planets) # 添加星球
		else:
			if full_path.right(4) == ".png":# 当加载的是.png时
				var star_texture_name = file_name.left(-4) # 获得天体贴图名称
				if not dictionary_result.has(star_texture_name):
					var star_texture = ResourceLoader.load(full_path)# 获得天体纹理
					if star_texture != null : # ResourceLoader.load()方法访问失败会返回null
						dictionary_result[star_texture_name] = star_texture
					else:
						push_error("天体贴图访问失败! 访问路径: %s" % full_path)
				#else:
					#print("字典中已含这个键%s" % star_texture_name)
			elif full_path.right(7) == ".import":# 当加载的是.import时(导出后的文件名)
				# 截断.import
				full_path = full_path.left(-7)
				file_name = file_name.left(-7)
				
				var star_texture_name = file_name.left(-4) # 获得天体贴图名称
				if not dictionary_result.has(star_texture_name):
					var star_texture = ResourceLoader.load(full_path)# 获得天体纹理
					if star_texture != null : # ResourceLoader.load()方法访问失败会返回null
						dictionary_result[star_texture_name] = star_texture
					else:
						push_error("天体贴图访问失败! 访问路径: %s" % full_path)
				#else:
					#print("字典中已含这个键%s" % star_texture_name)
			else:
				push_error("有未知类型的文件进入图片文件夹! 文件路径: %s" % full_path)
		file_name = directory.get_next()
	directory.list_dir_end()# 结束访问文件夹的流
	
	return dictionary_result

## 获取地图编辑器基本信息
static func get_map_editor_basic_information(get_what_information : String) -> Variant:
	match get_what_information:
		"stars":
			return _load_stars()
		"stars_dictionary":
			return _load_stars_dictionary()
		"defined_camp_ids", "camp_colors", "orbit_types":
			return _load_mapeditor_basic_information(get_what_information)
		_:
			push_error("未知信息类型: " + get_what_information)
			return null
	

static func _load_stars() -> Array[Star]:
	var stars_data =  _parse_json_data(_STARS_INFORMATION_PATH)
	# 验证JSON数据结构
	if stars_data == null:
		return[]
	
	if not stars_data.has("stars_data"):
		push_error("JSON字段缺少\"stars_data\"字段")
		return []
	
	var stars : Array[Star] = []
	
	# 在stars_information里遍历
	for star_type in stars_data["stars_data"]:
		var type_data : Dictionary = stars_data["stars_data"][star_type]
		# 在对应的天体类型(star_type)里遍历
		for star_key in type_data:
			var star_data = type_data[star_key]
			var star = _parse_star_data(star_data)
			if star != null:
				stars.append(star)
	
	return stars


static func _load_stars_dictionary() -> Dictionary[String, Dictionary]:
	var stars_data =  _parse_json_data(_STARS_INFORMATION_PATH)
	# 验证JSON数据结构
	if stars_data == null:
		return{}
	
	if not stars_data.has("stars_data"):
		push_error("JSON字段缺少\"stars_data\"字段")
		return {}
	
	var stars_dictionary : Dictionary[String, Dictionary] = {}
	
	# 在stars_data里遍历
	for star_type in stars_data["stars_data"]:
		var type_data : Dictionary = stars_data["stars_data"][star_type]
		var type_stars : Dictionary[int, Star] = {}
		# 在对应的天体类型(star_type)里遍历
		for star_key in type_data:
			var star_data = type_data[star_key]
			var star = _parse_star_data(star_data)
			if star != null:
				if star_key as int:
					type_stars[int(star_key)] = star
				else:
					push_error("天体大小类型应当是整数!")
					continue
		stars_dictionary[star_type] = type_stars
	
	return stars_dictionary


static func _parse_star_data(star_data: Dictionary) -> Star:
	# 检验必要字段
	var required_keys = ["pattern_name", "star_scale", "type", "size_type",
			"star_name", "special_star_type", "scale_fix", "offset_fix", "rotation_fix_degree"]
	
	for key in required_keys:
		if not star_data.has(key):
			push_error("天体数据缺少字段" + key)
			return null
	
	# 登记信息
	# star_data = [天体图样名(pattern_name)(String),
	# 天体缩放比例(scale)(float), 天体类型(type)(String), 
	# 大小类型(size_type)(int), 名称(String), 特殊天体类型(String),
	# 缩放修正(scale_fix: scale_fix_x, scale_fix_y)
	# 偏移修正(offset_fix: offset_fix_x, offset_fix_y)]
	var star = Star.new()
	star.pattern_name = star_data["pattern_name"]
	star.star_scale = star_data["star_scale"]
	star.type = star_data["type"]
	star.size_type = star_data["size_type"]
	star.star_name = star_data["star_name"]
	star.special_star_type = star_data["special_star_type"]
	
	if star_data["scale_fix"] is Array and star_data["scale_fix"].size() == 2:
		star.scale_fix = Vector2(star_data["scale_fix"][0], star_data["scale_fix"][1])
	else:
		push_error("天体数据中scale_fix格式出错!")
		return null
	
	if star_data["offset_fix"] is Array and star_data["offset_fix"].size() == 2:
		star.offset_fix = Vector2(star_data["offset_fix"][0], star_data["offset_fix"][1])
	else:
		push_error("天体数据中offset_fix格式出错!")
		return null
	
	if star_data["rotation_fix_degree"] is float:
		star.rotation_fix_degree = star_data["rotation_fix_degree"]
	else:
		push_error("天体数据中rotation_fix_degree格式出错!")
		return null
	
	return star


static func _load_mapeditor_basic_information(information_type : String) -> Variant:
	var mapeditor_basic_data = _parse_json_data(_MAPEDITOR1_BASIC_INFORMATION)
	if mapeditor_basic_data == null:
		push_error("地图编辑器基本信息获取失败!")
		return null
	match information_type:
		"defined_camp_ids":
			if not mapeditor_basic_data.has("defined_camp_ids"):
				push_error("JSON缺少\"defined_camp_ids\"字段!")
				return []
			
			if mapeditor_basic_data["defined_camp_ids"] is not Array:
				push_error("阵营id数据格式出错!")
				return []
			
			# camps_difined里的数字应全是整数
			var camps_defined : Array[int] = []
			for i in mapeditor_basic_data["defined_camp_ids"]:
				if int(i) not in camps_defined:
					camps_defined.append(int(i))
			
			# 对数组进行排序，防止出现保存的阵营数据不是按从小到大的顺序
			camps_defined.sort()
			return camps_defined
		
		"camp_colors":
			if not mapeditor_basic_data.has("camp_colors"):
				push_error("JSON缺少\"camp_colors\"字段!")
				return {}
			
			if mapeditor_basic_data["camp_colors"] is not Dictionary:
				push_error("阵营颜色数据格式出错!")
				return {}
			
			var camp_colors : Dictionary
			for campid in mapeditor_basic_data["camp_colors"]:
				var campcolor_string = mapeditor_basic_data["camp_colors"][campid]
				camp_colors[int(campid)] = Color(campcolor_string)
			return camp_colors
		
		"orbit_types":
			if not mapeditor_basic_data.has("orbit_types"):
				push_error("JSON缺少\"orbit_types\"字段!")
				return {}
			
			if mapeditor_basic_data["orbit_types"] is not Dictionary:
				push_error("轨道数据格式出错!")
				return {}
			
			var orbit_types : Dictionary
			for orbit_id in mapeditor_basic_data["orbit_types"]:
				orbit_types[int(orbit_id)] = mapeditor_basic_data["orbit_types"][orbit_id]
			return orbit_types
	
	push_error("加载编辑器基本信息失败!")
	return null


static func _parse_json_data(json_information_path : String) -> Dictionary:
	# 检验路径上有没有这个文件
	if not FileAccess.file_exists(json_information_path):
		push_error("在文件路径:%s上的保存文件不存在!" %json_information_path)
		return {}
	var information_file = FileAccess.open(json_information_path, FileAccess.READ)
	# 获得json文件里的信息
	var information_json_string : String = information_file.get_as_text()
	# 使用JSON类辅助解析
	var json = JSON.new()
	# 是否成功解析
	var parse_result = json.parse(information_json_string)
	if not parse_result == OK:
		push_error("解析文件信息失败！JSON Parse: Error: %s at line %s"%[json.get_error_message(), json.get_error_line()])
		return {}
	return json.data
