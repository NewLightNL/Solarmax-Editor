class_name FleetsInformationGetter extends Tool


static func get_camp_ship_number_from_fleets_dictionaries_array(
		camp_id : int,
		fleets_dictionaries_array : Array[Dictionary],
) -> int:
	var camp_fleet_ship_number : int = 0
	for fleet_dictionary in fleets_dictionaries_array:
		var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
		fleet_information_parser.parse_fleet_dicitionary(fleet_dictionary)
		if fleet_information_parser.camp_id == camp_id:
			camp_fleet_ship_number += fleet_information_parser.ship_number
		else:
			continue
	return camp_fleet_ship_number


static func get_camp_ship_number_from_fleets_arrarys_array():
	pass


static func get_star_fleets_dictionaries_campids(star_fleets_dictionaries : Array[Dictionary]) -> Array[int]:
	var fleets_camps = FleetsCampsGetter.get_star_fleets_dictionaries_campids(star_fleets_dictionaries)
	return fleets_camps


class FleetsCampsGetter:
	static func get_star_fleets_dictionaries_campids(star_fleets_dictionaries : Array[Dictionary]) -> Array[int]:
		var fleets_camps : Array[int]
		for star_fleets_dictionary in star_fleets_dictionaries:
			if star_fleets_dictionary.has("camp_id"):
				if fleets_camps.has(star_fleets_dictionary["camp_id"]):
					continue
				else:
					fleets_camps.append(star_fleets_dictionary["camp_id"])
			else:
				push_error("天体舰队缺少campid!")
				continue
		fleets_camps.sort()
		return fleets_camps
