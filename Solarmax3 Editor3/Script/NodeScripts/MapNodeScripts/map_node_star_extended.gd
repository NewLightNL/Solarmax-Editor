extends MapNodeStar

var _ui_last_position : Vector2
# 外部输入数据
var star_pattern_dictionary : Dictionary
var camp_colors : Dictionary

@onready var _halo_drawer : Marker2D = $HaloDrawingCenter
@onready var _map_node_star_sprite : Sprite2D = $MapNodeStarSprite
@onready var _star_ui : Control = $StarUI
@onready var _star_fleets_label : Control = $StarUI/StarFleetsLabel
@onready var _orbit_drawer : Node2D = $OrbitDrawer


func _ready():
	Mapeditor1ShareData.init_editor_data()
	star_pattern_dictionary = Mapeditor1ShareData.star_pattern_dictionary
	camp_colors = Mapeditor1ShareData.camp_colors
	
	update_map_node_star()
	#var stars = Mapeditor1ShareData.stars
	#_init_from_star(stars[0])


func _process(delta):
	if _star_ui.position != _ui_last_position:
		_update_ui_children()
	_ui_last_position = _star_ui.position


func _update_ui_children():
	_star_fleets_label.position = Vector2(0, 0)


func update_map_node_star():
	_update_map_node_star_showing_property()
	_call_draw_halo()
	_call_draw_orbit()
	_update_star_ui()


func _update_map_node_star_showing_property():
	_update_map_node_star_showing_picture()
	_update_map_node_star_showing_camp()


func _update_map_node_star_showing_picture():
	_map_node_star_sprite.texture = star_pattern_dictionary[pattern_name]
	var raw_scale = self.star_scale * Vector2.ONE
	var scale_processed = Vector2(raw_scale.x * scale_fix.x, raw_scale.y * scale_fix.y)
	_map_node_star_sprite.scale = scale_processed
	_map_node_star_sprite.offset = offset_fix
	
	if self.is_taget == true:
		# 对于可旋转天体，要用障碍点标记
		# 对于自带旋转的天体?
		self.fAngle = 90
		_map_node_star_sprite.rotation_degrees = self.rotation_fix_degree + self.fAngle
	else:
		# 对于不旋转天体，则恢复0度
		# 对于旋转天体，则去掉障碍点，保持其旋转角度
		self.fAngle = 0
		_map_node_star_sprite.rotation_degrees = self.rotation_fix_degree + self.fAngle


func _update_map_node_star_showing_camp():
	var camp_color : Color = camp_colors[star_camp]
	_map_node_star_sprite.modulate = camp_color


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


func _on_delete_button_button_up():
	queue_free()
