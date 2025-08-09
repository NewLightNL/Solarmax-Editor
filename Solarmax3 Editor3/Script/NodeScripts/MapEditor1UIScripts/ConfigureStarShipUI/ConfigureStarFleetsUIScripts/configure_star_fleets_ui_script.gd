extends Control


var chosen_star : MapNodeStar


@onready var star_preview_control : Control = $StarPreviewControl

func _ready() -> void:
	
	
	star_preview_control.initialize_preview()
	


func _pull_mapeditor_shared_data():
	chosen_star = Mapeditor1ShareData.chosen_star


func _on_leave_button_button_up() -> void:
	queue_free()
