extends MapNodeStar

# 外部输入数据
var star_pattern_dictionary : Dictionary
var camp_colors : Dictionary

@onready var _halo_drawer : Marker2D = $HaloDrawingCenter
@onready var _map_node_star_sprite : Sprite2D = $MapNodeStarSprite
@onready var _star_ui : Control = $StarUI
@onready var _star_fleets_label : Control = $StarUI/StarFleetsLabel
@onready var _orbit_drawer : Node2D = $OrbitDrawer


func _ready():
	_pull_map_editor_shared_data()
	update_map_node_star()


func _pull_map_editor_shared_data():
	star_pattern_dictionary = Mapeditor1ShareData.star_pattern_dictionary
	camp_colors = Mapeditor1ShareData.camp_colors


func _update_ui_children():
	_star_fleets_label.position = Vector2(0, 0)


func update_map_node_star():
	_update_map_node_star_sprite()
	_call_draw_halo()
	_call_draw_orbit()
	_update_star_ui()


func _update_map_node_star_sprite():
	if _map_node_star_sprite != null:
		var star_pattern : CompressedTexture2D
		if star_pattern_dictionary.has(pattern_name):
			star_pattern = star_pattern_dictionary[pattern_name]
		else:
			push_error("天体图案字典里找不到该天体图案！")
			star_pattern = null
		_map_node_star_sprite.update_sprite(
				star_pattern,
				star_scale,
				scale_fix,
				offset_fix,
				rotation_fix_degree,
				fAngle,
				camp_colors[star_camp],
		)
	else:
		push_error("缺少天体精灵!")


func _call_draw_orbit():
	if self.orbit_type != "":
		_orbit_drawer.orbit_type = self.orbit_type
		_orbit_drawer.star_position = self.star_position
		_orbit_drawer.orbit_param1 = self.orbit_param1
		_orbit_drawer.orbit_param2 = self.orbit_param2
		_orbit_drawer.queue_redraw()
	else:
		push_error("天体没有轨道类型!")


func _call_draw_halo():
	if _halo_drawer != null:
		_halo_drawer.draw_halo(this_star_fleets, star_scale)
	else:
		push_error("天体缺少画环节点!")


func _update_star_ui():
	_star_ui.update_star_ui(star_scale, this_star_fleets)

# 不应该直接获取删除按钮发出的信息
func _on_delete_button_button_up():
	queue_free()
