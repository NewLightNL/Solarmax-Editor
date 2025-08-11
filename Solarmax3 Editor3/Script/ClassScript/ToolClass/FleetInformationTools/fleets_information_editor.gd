class_name FleetsInformationEditor extends FleetsInformationTool


static func change_camp_ship_number_in_fleet_dictionaries_array(
		camp_id : int,
		ship_number : int,
		fleet_dictionaries_array : Array[Dictionary],
) -> Array[Dictionary]:
	
	var new_fleet_information_dictionaries_array : Array[Dictionary] = []
	var new_fleet_information : Dictionary = {}
	var camp_ids = FleetsInformationGetter.get_star_fleets_dictionaries_campids(fleet_dictionaries_array)
	
	if camp_ids.size() == 0:
		new_fleet_information = FleetInformationCreator.create_fleet_dicitionary(
				camp_id,
				ship_number,
		)
		new_fleet_information_dictionaries_array.append(new_fleet_information)
	else:
		if not camp_ids.has(camp_id):
			camp_ids.append(camp_id)
			camp_ids.sort()
		
		for fcamp_id in camp_ids:
			if fcamp_id == camp_id:
				new_fleet_information = FleetInformationCreator.create_fleet_dicitionary(
						camp_id,
						ship_number,
				)
			else:
				var camp_ship_number : int = FleetsInformationGetter.get_camp_ship_number_from_fleets_dictionaries_array(
						fcamp_id,
						fleet_dictionaries_array
				)
				new_fleet_information = FleetInformationCreator.create_fleet_dicitionary(
						fcamp_id,
						camp_ship_number,
				)
			new_fleet_information_dictionaries_array.append(new_fleet_information)
				
	#print(new_fleet_information_dictionaries_array)
	return new_fleet_information_dictionaries_array


static func change_camp_ship_number_in_fleet_arrays_array(
		camp_id : int,
		ship_number : int,
		fleet_arrays_array : Array[Array],
) -> Array[Array]:
	return []
