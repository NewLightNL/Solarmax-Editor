extends ConfirmationDialog

var chosen_star : MapNodeStar


func _ready() -> void:
	Mapeditor1ShareData.editor_data_updated.connect(_on_global_data_updated)


func _on_global_data_updated(key : String):
	if key == "chosen_star":
		chosen_star = Mapeditor1ShareData.chosen_star
	update_star_position()


func update_star_position():
	if chosen_star == null:
		return
	
	$Control/StarPositionLabel.text = "天体坐标: (%s, %s)" % [chosen_star.star_position.x, chosen_star.star_position.y]
