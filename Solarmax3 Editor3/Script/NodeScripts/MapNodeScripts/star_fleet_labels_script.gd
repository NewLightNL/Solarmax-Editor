extends Control

var camp_colors : Dictionary


func _ready() -> void:
	_pull_map_editor_shared_information()


func _pull_map_editor_shared_information():
	camp_colors = MapeditorShareData.camp_colors

func add_ship_number_labels(
		label_positions : Array[Vector2],
		star_fleet_dictionaries_array : Array[Dictionary],
	) -> void:
		var camp_ids = FleetsInformationGetter.get_star_fleets_dictionaries_campids(star_fleet_dictionaries_array)
		var index : int = -1
		for camp_id in camp_ids:
			index += 1
			var ship_number : int = FleetsInformationGetter.get_camp_ship_number_from_fleets_dictionaries_array(
				camp_id,
				star_fleet_dictionaries_array
			)
			var ship_number_label = Label.new()
			var camp_ship_number_showed : String
			if ship_number < 10000000:
				camp_ship_number_showed = str(ship_number)# int
			else:
				camp_ship_number_showed = String.num_scientific(ship_number)
			ship_number_label.text = camp_ship_number_showed
			ship_number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			ship_number_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			add_child(ship_number_label)
			
			ship_number_label.add_theme_color_override("font_color", camp_colors[camp_id])
			ship_number_label.position = label_positions[index] - ship_number_label.size/2
