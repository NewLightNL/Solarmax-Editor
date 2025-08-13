extends Control

var chosen_star : MapNodeStar


@onready var star_preview_control : Control = $StarPreviewControl
@onready var fleets_setting_ui_control : Control = $FleetsSettingUI

func _ready() -> void:
	_pull_mapeditor_shared_data()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	if chosen_star == null:
		chosen_star = MapNodeStar.new()
		chosen_star.pattern_name = "planet09"
	
	star_preview_control.update_preview(chosen_star)
	fleets_setting_ui_control.configure_fleets_setting_ui(chosen_star.this_star_fleet_dictionaries_array)


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"chosen_star":
			chosen_star = MapEditorSharedData.chosen_star


func _pull_mapeditor_shared_data():
	chosen_star = MapEditorSharedData.chosen_star


func _on_fleet_information_changed(
	fleet_camp_info : int,
	ship_number_info : int
):
	chosen_star.this_star_fleet_dictionaries_array = FleetsInformationEditor.change_camp_ship_number_in_fleet_dictionaries_array(
		fleet_camp_info,
		ship_number_info,
		chosen_star.this_star_fleet_dictionaries_array
	)
	
	MapEditorSharedData.data_updated("chosen_star", chosen_star)
	star_preview_control.update_preview(chosen_star)


func _on_leave_button_button_up() -> void:
	queue_free()
