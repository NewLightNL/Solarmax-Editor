extends Node

signal request_choose_star

var editor_type : EditorType
var star_pattern_dictionary : Dictionary[String, CompressedTexture2D]

@onready var chosen_star_picture : TextureRect = $ChosenStarPicture
@onready var chosen_star_name_label : Label = $Name_bg/Name


func _pull_map_editor_shared_information():
	editor_type = MapEditorSharedData.editor_type
	star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"editor_type":
			editor_type = MapEditorSharedData.editor_type
		"star_pattern_dictionary":
			star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary


func update_choosing_star_display(star : Star):
	if editor_type is NewExpedition:
		editor_type.obey_dirt_star_rotation_rule_ui(star, chosen_star_picture)
	else:
		pass
	chosen_star_picture.texture = star_pattern_dictionary[star.pattern_name]
	chosen_star_name_label.text = star.star_name


func _on_choose_star_button_up() -> void:
	emit_signal("request_choose_star")
