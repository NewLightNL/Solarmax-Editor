class_name IMapEditorInformationPuller extends MapEditorInformationSharedTool


func _pull_map_editor_shared_information() -> void:
	pass


func _on_global_data_updated(key : String) -> void:
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		_:
			pass

# "defined_camp_ids",
# "camp_colors",
# "star_pattern_dictionary",
# "stars",
# "stars_dictionary",
# "orbit_types",
# "chosen_star",
# "star_fleets"
