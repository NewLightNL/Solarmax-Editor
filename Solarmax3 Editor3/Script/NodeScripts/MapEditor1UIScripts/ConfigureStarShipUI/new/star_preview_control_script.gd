extends Control

@onready var star_preview_bg : Panel = $StarShipPreviewBG
@onready var map_node_star : MapNodeStar = $MapNodeStar


func initialize_preview():
	_initialize_map_node_star()


func _initialize_map_node_star():
	var star_preview_bg_center_position : Vector2 = star_preview_bg.position + star_preview_bg.size/2
	map_node_star.position = star_preview_bg_center_position


func update_mapnodestar():
	pass
