class_name BarrierLines extends MapNodeStar

var start_map_node_star : MapNodeStar
var end_map_node_star : MapNodeStar
var star_pattern_dictionary : Dictionary[String, CompressedTexture2D]
var barrier_line_pattern : CompressedTexture2D

var is_dragging : bool = false
var mouse_position : Vector2


func _ready() -> void:
	if start_map_node_star != null:
		star_position = start_map_node_star.star_position
	else:
		star_position = Vector2.ZERO
		push_error("没有设置初始障碍点!")
	
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	
	if star_pattern_dictionary.has("barrier_line_new"):
		barrier_line_pattern = star_pattern_dictionary["barrier_line_new"]
	else:
		push_error("没有障碍线贴图!")
	
	
	var start_star_position : Vector2 = star_position
	var end_star_position : Vector2
	if end_map_node_star != null:
		end_star_position = end_map_node_star.star_position
	else:
		end_star_position = mouse_position
	
	
	create_barrier_lines(start_star_position, end_star_position)


func _pull_map_editor_shared_information() -> void:
	star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"star_pattern_dictionary":
			star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary


func create_barrier_lines(start_star_position : Vector2, end_star_position : Vector2):
	var relative_vector : Vector2 = end_star_position - start_star_position
	var dircetion_unit_vector : Vector2 = relative_vector.normalized()
	var barrier_lines_number : int = int(relative_vector.length()/0.1)
	var degree_to_x_axis : float = rad_to_deg(- dircetion_unit_vector.angle())
	
	for i in range(barrier_lines_number):
		
		var barrier_line : MapNodeStar = BarrierLineBuilder.create_barrier_line(
				dircetion_unit_vector * 0.1 * i,
				degree_to_x_axis,
				barrier_line_pattern
		)
		
		add_child(barrier_line, false, Node.INTERNAL_MODE_FRONT)


class BarrierLineBuilder:
	static func create_barrier_line(
			barrier_line_star_position : Vector2,
			barrier_line_f_angle : float,
			barrier_line_pattern : CompressedTexture2D,
	) -> MapNodeStar:
		var barrier_line : MapNodeStar = MapNodeStar.new()
		barrier_line.star_position = barrier_line_star_position
		barrier_line.fAngle = barrier_line_f_angle
		var sprite : Sprite2D = Sprite2D.new()
		barrier_line.add_child(sprite, false, Node.InternalMode.INTERNAL_MODE_FRONT)
		sprite.texture = barrier_line_pattern
		sprite.rotation_degrees = -barrier_line_f_angle 
		
		return barrier_line
