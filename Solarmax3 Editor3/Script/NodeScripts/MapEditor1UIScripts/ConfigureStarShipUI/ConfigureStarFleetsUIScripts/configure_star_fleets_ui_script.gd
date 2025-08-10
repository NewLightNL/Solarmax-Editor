extends Control


var chosen_star : MapNodeStar


@onready var star_preview_control : Control = $StarPreviewControl

func _ready() -> void:
	_pull_mapeditor_shared_data()
	MapeditorShareData.shared_data_updated.connect(_on_global_data_updated)
	star_preview_control.initialize_preview()

func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"chosen_star":
			chosen_star = MapeditorShareData.chosen_star


func _pull_mapeditor_shared_data():
	chosen_star = MapeditorShareData.chosen_star


func _on_leave_button_button_up() -> void:
	queue_free()
