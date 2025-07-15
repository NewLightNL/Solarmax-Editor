extends Node2D

# 用于测试代码以及其它什么东西的

# Called when the node enters the scene tree for the first time.
func _ready():
	print(init_star_pattern_dictionary())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const starTexturePath : String = "res://Textures/StarTextures"

# 未来要修改文件夹, 增加BetaVersion1、3
static func init_star_pattern_dictionary(path:String = starTexturePath) -> Dictionary:
	var dictionary_result : Dictionary = {}
	var directory = DirAccess.open(path)
	
	# directory如果返回的是null, 也就是打开失败了
	# 要测试能否使godot停止编译
	if directory == null:
		# 正式上来时，要告知用户缺少文件
		assert(false, "无法打开目录: " + path)# 如果无法打开，强制停止项目
		
		return dictionary_result
	
	# 初始化用于通过get_next()函数
	# “流”是什么: 把读一点处理一点(以及相反的生成一点, 写入一点)的数据类型(或曰操作)抽象出来, 就是流
	# 流就是读一点数据, 处理一点点数据
	directory.list_dir_begin()
	var file_name : String = directory.get_next()# 获得文件名
	while file_name != "":
		# 跳过 "."(当前目录) 和 ".."(上级目录) 目录，另外，该判断可以实现隐藏文件
		if file_name == "." or file_name == "..":
			file_name = directory.get_next()
			continue
		# 访问非星球纹理和星球文件夹
		var full_path = path.path_join(file_name) # 获得完整路径
		if directory.current_is_dir(): # 判断正在访问的这个东西是不是文件夹
			var get_planets : Dictionary =init_star_pattern_dictionary(full_path) # 递归子文件夹
			dictionary_result.merge(get_planets) # 添加星球
		else:
			if full_path.right(7) != ".import":# 不加载引擎内自己添加的.import文件
				var star_texture = ResourceLoader.load(full_path)# 获得天体纹理
				if star_texture != null : # ResourceLoader.load()方法访问失败会返回null
					var star_texture_name = file_name.left(-4) # 获得天体贴图名称
					dictionary_result[star_texture_name] = star_texture
		file_name = directory.get_next()
	directory.list_dir_end()
	return dictionary_result
