extends MapNodeStar

@export var is_star_preview : bool = false
@export var auto_initializable : bool = false

var is_dragging : bool = false
var star_pattern_dictionary : Dictionary
var camp_colors : Dictionary

@onready var _halo_drawer : Marker2D = $HaloDrawingCenter
@onready var _map_node_star_sprite : Sprite2D = $MapNodeStarSprite
@onready var _star_ui : Control = $StarUI
@onready var _orbit_drawer : Node2D = $OrbitDrawer
@onready var _lasergun_drawer : Marker2D = $LasergunLineDrawer


func _ready():
	MapEditorSharedData.shared_data_updated.connect( _on_global_data_updated)
	_pull_map_editor_shared_data()
	self.star_property_changed.connect(_update_map_node_star)
	if get_parent() == null or auto_initializable == true:
		_update_map_node_star()


func _process(delta: float) -> void:
	if is_dragging:
		star_position += get_local_mouse_position() * Transform2D(Vector2(1, 0), Vector2(0, -1), Vector2.ZERO) / MAPUNITLENTH


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"star_pattern_dictionary":
			star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
		"camp_colors":
			camp_colors = MapEditorSharedData.camp_colors


func _pull_map_editor_shared_data():
	star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
	camp_colors = MapEditorSharedData.camp_colors


func _update_map_node_star():
	_call_draw_lasergun_line()
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
		var is_lasergun = (
				true	 if special_star_type == "Lasergun"
				else false
		)
		var lasergun_angle : float = 0.0
		if lasergun_information.has("lasergunAngle"):
			lasergun_angle = lasergun_information["lasergunAngle"]
		_map_node_star_sprite.update_sprite(
				is_lasergun,
				star_pattern,
				star_scale,
				scale_fix,
				offset_fix,
				rotation_fix_degree,
				fAngle,
				lasergun_angle,
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
		_halo_drawer.draw_halo(self.this_star_fleet_dictionaries_array, star_scale, type)
	else:
		push_error("天体缺少画环节点!")


func _call_draw_lasergun_line() -> void:
	if self.special_star_type == "Lasergun":
		var is_having_lasergun_information : bool = false
		var required_keys : Array[String] = [
			"lasergunAngle",
			"lasergunRotateSkip",
			"lasergunRange",
		]
		for required_key in required_keys:
			if lasergun_information.has(required_key):
				is_having_lasergun_information = true
			else:
				is_having_lasergun_information = false
		if is_having_lasergun_information == false:
			_lasergun_drawer.is_lasergun = true
			_lasergun_drawer.lasergun_angle = 0.0
			_lasergun_drawer.lasergun_rotate_skip = 0.0
			_lasergun_drawer.lasergun_range = 0.0
		else:
			_lasergun_drawer.is_lasergun = true
			_lasergun_drawer.lasergun_angle = lasergun_information["lasergunAngle"]
			_lasergun_drawer.lasergun_rotate_skip = lasergun_information["lasergunRotateSkip"]
			_lasergun_drawer.lasergun_range = lasergun_information["lasergunRange"]
	else:
		_lasergun_drawer.is_lasergun = false
	
	_lasergun_drawer.queue_redraw()


func _update_star_ui():
	_star_ui.update_star_ui(star_scale, self.this_star_fleet_dictionaries_array)


func _on_star_ui_request_delete() -> void:
	if not is_star_preview:
		queue_free()


func _on_star_ui_update_drag_state(drag_state: bool) -> void:
	is_dragging = drag_state
