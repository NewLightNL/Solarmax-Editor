class_name IMapEditorInformationPuller extends MapEditorInformationSharedTool

func _pull_map_editor_information():
	pass


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		_:
			pass
