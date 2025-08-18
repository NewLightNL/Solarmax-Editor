extends Control


signal star_tag_changed(star_tag : String)

var chosen_star : MapNodeStar


@onready var tag_input_line_edit : LineEdit = $TagInputLineEdit


func _ready() -> void:
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)


func _pull_map_editor_shared_information() -> void:
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star


func lock_ui():
	tag_input_line_edit.editable = false


func unlock_ui():
	tag_input_line_edit.editable = true


func initialize_tag_input_line_edit():
	tag_input_line_edit.text = ""
	chosen_star.tag = ""


func _on_tag_input_line_edit_text_changed(new_text: String) -> void:
	emit_signal("star_tag_changed", new_text)
