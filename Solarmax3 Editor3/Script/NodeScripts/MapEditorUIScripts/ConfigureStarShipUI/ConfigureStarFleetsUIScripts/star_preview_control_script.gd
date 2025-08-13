extends Control

@onready var star_preview_bg : Panel = $StarShipPreviewBG
@onready var map_node_star : MapNodeStar = $MapNodeStar


func update_preview(chosen_star : MapNodeStar):
	_update_map_node_star(chosen_star)

# 天体要是太大了要改小
func _update_map_node_star(chosen_star : MapNodeStar):
	map_node_star.copy_map_node_star(chosen_star)
	
	var star_preview_bg_center_position : Vector2 = star_preview_bg.position + star_preview_bg.size/2
	map_node_star.position = star_preview_bg_center_position
	map_node_star.orbit_type = "no_orbit"
	map_node_star.star_scale = 0.5
	map_node_star.is_star_preview = true
