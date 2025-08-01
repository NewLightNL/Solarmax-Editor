class_name MapCreator

extends Node2D

signal _on_create_star

@export var mapnodestar_scene : PackedScene

var mapnodestar : MapNodeStar

var chosen_star : MapNodeStar:
	set(value):
		if value is MapNodeStar:
			chosen_star = value
			get_mapnodestar(value)
			if $PreviewStar.get_child_count() == 1:
				update_star_preview()
			elif $PreviewStar.get_child_count() == 0:
				pass
			else:
				push_error("有多个节点在预览节点下面！")
		else:
			push_error("提交了一个错误的类型!")


func _ready() -> void:
	if mapnodestar_scene == null:
		push_error("天体场景加载失败!")
	Mapeditor1ShareData.connect("editor_data_updated", _on_global_data_updated)


func get_mapnodestar(mapnodestar_sent : MapNodeStar):
	mapnodestar = mapnodestar_sent.duplicate_map_node_star()


func create_mapnodestar() -> void:
	if mapnodestar == null:
		emit_signal("_on_create_star", false, "要创建的天体为空")
		return
	
	if mapnodestar.tag == "":
		emit_signal("_on_create_star", false, "要创建的天体没有标签")
		return
	
	# tag查重
	for star_in_map in $Stars.get_children():
		if star_in_map is MapNodeStar:
			if star_in_map.tag == mapnodestar.tag:
				emit_signal("_on_create_star", false, "tag重复")
				return
	
	var mapnodestar_node = mapnodestar_scene.instantiate()
	mapnodestar_node.copy_map_node_star(mapnodestar)
	$Stars.add_child(mapnodestar_node)


func _on_global_data_updated(key : String):
	if key == "chosen_star":
		chosen_star = Mapeditor1ShareData.chosen_star


func change_star_preview_visibility():
	if $PreviewStar.get_child_count() == 0:
		create_star_preview()
	elif $PreviewStar.get_child_count() == 1:
		delete_star_preview()
	else:
		push_error("有多个节点在预览节点下面！")


func create_star_preview() -> void:
	if chosen_star == null or chosen_star is not MapNodeStar:
		push_error("chosen_star信息出错!")
		return
	
	if $PreviewStar.get_child_count() == 0:
		var star_preview_node = mapnodestar_scene.instantiate()
		star_preview_node.copy_map_node_star(chosen_star)
		$PreviewStar.add_child(star_preview_node)
	elif $PreviewStar.get_child_count() == 1:
		update_star_preview()
	else:
		push_error("有多个节点在预览节点下面！")


func delete_star_preview():
	if $PreviewStar.get_child_count() == 1:
		$PreviewStar.get_child(0).queue_free()
	elif $PreviewStar.get_child_count() == 0:
		push_error("预览节点下面没有天体!")
	else:
		push_error("有多个节点在预览节点下面！")


func update_star_preview():
	if $PreviewStar.get_child(0) is MapNodeStar:
		var star_preview = $PreviewStar.get_child(0)
		star_preview.copy_map_node_star(chosen_star)
		star_preview.update_map_node_star()
