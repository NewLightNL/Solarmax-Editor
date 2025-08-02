class_name MapCreator

extends Node2D

signal create_star
signal feedback(what_feedback : String, context : String)

@export var mapnodestar_scene : PackedScene

var mapnodestar : MapNodeStar
var previewstar : MapNodeStar

@onready var stars_container : Node2D = $Stars
@onready var previewstar_container : Node2D = $PreviewStar


var chosen_star : MapNodeStar:
	set(value):
		if value is MapNodeStar:
			chosen_star = value
			get_mapnodestar(value)
			if previewstar_container.get_child_count() == 1:
				update_star_preview()
			elif previewstar_container.get_child_count() == 0:
				pass
			else:
				push_error("有多个节点在预览节点下面！")
		else:
			push_error("提交了一个错误的类型!")


func _ready() -> void:
	initial_variants()
	

	Mapeditor1ShareData.connect("editor_data_updated", _on_global_data_updated)


func initial_variants():
	if mapnodestar_scene == null:
		push_error("天体场景加载失败!")
	
	previewstar = null
	code_and_emit_feedback("star_preview_state", "false")


func get_mapnodestar(mapnodestar_sent : MapNodeStar):
	mapnodestar = mapnodestar_sent.duplicate_map_node_star()


func create_mapnodestar() -> void:
	if mapnodestar == null:
		emit_signal("create_star", false, "要创建的天体为空")
		return
	
	if mapnodestar.tag == "":
		emit_signal("create_star", false, "要创建的天体没有标签")
		return
	
	# tag查重
	for star_in_map in $Stars.get_children():
		if star_in_map is MapNodeStar:
			if star_in_map.tag == mapnodestar.tag:
				emit_signal("create_star", false, "tag重复")
				return
	
	var mapnodestar_node = mapnodestar_scene.instantiate()
	mapnodestar_node.copy_map_node_star(mapnodestar)
	$Stars.add_child(mapnodestar_node)


func _on_global_data_updated(key : String):
	if key == "chosen_star":
		chosen_star = Mapeditor1ShareData.chosen_star


func change_star_preview_visibility(change_to_what_visibility : bool):
	if change_to_what_visibility == true:
		if previewstar == null:
			create_star_preview()
		else:
			update_star_preview()
	else:
		if previewstar_container.get_child_count() > 0:
			delete_star_preview()
		else:
			push_error("预览节点下面没有节点!")


func create_star_preview() -> void:
	if chosen_star == null or chosen_star is not MapNodeStar:
		push_error("chosen_star信息出错!")
		return
	
	if previewstar_container.get_child_count() == 0:
		var star_preview_node = mapnodestar_scene.instantiate()
		star_preview_node.copy_map_node_star(chosen_star)
		previewstar_container.add_child(star_preview_node)
		previewstar = star_preview_node
		previewstar.tree_exited.connect(_on_star_preview_queue_freed)
		code_and_emit_feedback("star_preview_state", "true")
	else:
		push_error("已有节点在预览天体容器节点下面!")


func update_star_preview():
	if previewstar == null:
		return
	
	if previewstar_container.get_child(0) is MapNodeStar:
		var star_preview = previewstar_container.get_child(0)
		star_preview.copy_map_node_star(chosen_star)
		star_preview.update_map_node_star()


func _on_star_preview_queue_freed():
	previewstar = null
	code_and_emit_feedback("star_preview_state", "false")


func delete_star_preview():
	if previewstar_container.get_child_count() > 0:
		previewstar_container.get_child(0).queue_free()
		previewstar = null
		code_and_emit_feedback("star_preview_state", "false")
	else:
		push_error("预览天体容器下面没有天体!")


func code_and_emit_feedback(what_feedback : String, context : String):
	match what_feedback:
		"star_preview_state":
			match context:
				"true", "false":
					pass
				_:
					push_error("发送了错误的反馈内容")
			
			emit_signal("feedback", "star_preview_state", context)
		_:
			push_error("未知反馈!")
