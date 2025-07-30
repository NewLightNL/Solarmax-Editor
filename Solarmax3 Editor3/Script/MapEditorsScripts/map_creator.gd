class_name MapCreator

extends Node2D

signal create_star

@export var mapnodestar_scene : PackedScene

var mapnodestar : MapNodeStar


func _ready() -> void:
	if mapnodestar_scene == null:
		push_error("天体场景加载失败!")


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
