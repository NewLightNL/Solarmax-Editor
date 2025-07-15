class_name Load
# 建议预加载项与主体分离
# UI，天体，各种控件也尽量都与主编辑器分离，MapEditor只作为启动以及管理中心
const starTexturePath : String = "res://Textures/StarTexture"

static func init_star_pattern_dictionary(path:String = starTexturePath) -> Dictionary:
	var resDic:Dictionary = {}
	var dir = DirAccess.open(path)

	if !dir:
		push_error("无法打开目录: " + path)
		return resDic
	
	dir.list_dir_begin()
	var file_name:String = dir.get_next()
	while file_name != "":
		# 跳过 "." 和 ".." 目录
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue
			
		var full_path = path.path_join(file_name)
		if dir.current_is_dir():
			resDic.merge(init_star_pattern_dictionary(full_path)) # 递归子文件夹
		else:
			var res = ResourceLoader.load(full_path)
			if res:
				resDic[file_name.left(-4)] = res
		file_name = dir.get_next()

	return resDic
