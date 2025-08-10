class_name FleetsInformationGetter extends Tool


static func get_camp_ship_number_from_fleets_dictionaries_array(
		camp_id : int,
		fleets_dictionaries_array : Array[Dictionary],
) -> int:
	var camp_fleet_ship_number : int = FleetShipNumberGetter.get_camp_ship_number_from_fleets_dictionaries_array(
			camp_id,
			fleets_dictionaries_array,
	)
	return camp_fleet_ship_number


static func get_camp_ship_number_from_fleets_arrarys_array(
		camp_id : int,
		fleets_arrays_array : Array[Array],
):
	var camp_fleet_ship_number : int = FleetShipNumberGetter.get_camp_ship_number_from_fleets_arrarys_array(
			camp_id,
			fleets_arrays_array
	)
	return camp_fleet_ship_number


static func get_star_fleets_dictionaries_campids(star_fleets_dictionaries : Array[Dictionary]) -> Array[int]:
	var fleets_camps = FleetCampsGetter.get_star_fleets_dictionaries_campids(star_fleets_dictionaries)
	return fleets_camps


static func get_star_fleets_arrays_array_campids(star_fleets_arrays_array : Array[Array]) -> Array[int]:
	var fleets_camps = FleetCampsGetter.get_star_fleets_arrays_campids(star_fleets_arrays_array)
	return fleets_camps


static func get_total_ship_number_from_star_fleets_dictionaries_array(star_fleets_dictionaries_array : Array[Dictionary]) -> int:
	var total_ship_number : int = TotalShipNumberGetter.get_total_ship_number_from_star_fleets_dictionaries_array(star_fleets_dictionaries_array)
	return total_ship_number


static func get_total_ship_number_from_star_fleets_arrays_array(star_fleets_arrays_array : Array[Array]) -> int:
	var total_ship_number : int = TotalShipNumberGetter.get_total_ship_number_from_star_fleets_arrays_array(star_fleets_arrays_array,)
	return total_ship_number


class FleetShipNumberGetter:
	static func get_camp_ship_number_from_fleets_dictionaries_array(
			camp_id : int,
			fleets_dictionaries_array : Array[Dictionary],
	) -> int:
		var camp_fleet_ship_number : int = 0
		var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
		for fleet_dictionary in fleets_dictionaries_array:
			fleet_information_parser.parse_fleet_dicitionary(fleet_dictionary)
			if fleet_information_parser.camp_id == camp_id:
				camp_fleet_ship_number += fleet_information_parser.ship_number
			else:
				continue
		return camp_fleet_ship_number


	static func get_camp_ship_number_from_fleets_arrarys_array(
			camp_id : int,
			fleets_arrays_array : Array[Array],
	):
		var camp_fleet_ship_number : int = 0
		var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
		for fleet_array in fleets_arrays_array:
			fleet_information_parser.parse_fleet_array(fleet_array)
			if fleet_information_parser.camp_id == camp_id:
				camp_fleet_ship_number += fleet_information_parser.ship_number
			else:
				continue
		return camp_fleet_ship_number


class FleetCampsGetter:
	static func get_star_fleets_dictionaries_campids(star_fleet_dictionaries : Array[Dictionary]) -> Array[int]:
		var fleets_camps : Array[int]
		var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
		for star_fleet_dictionary in star_fleet_dictionaries:
			fleet_information_parser.parse_fleet_dicitionary(star_fleet_dictionary)
			var fleet_camp_id = fleet_information_parser.camp_id
			if not fleets_camps.has(fleet_camp_id):
				fleets_camps.append(fleet_camp_id)

		fleets_camps.sort()
		return fleets_camps
	
	
	static func get_star_fleets_arrays_campids(star_fleet_arrays : Array[Array]) -> Array[int]:
		var fleet_camps : Array[int]
		var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
		for star_fleet_array in star_fleet_arrays:
			fleet_information_parser.parse_fleet_array(star_fleet_array)
			var fleet_camp_id = fleet_information_parser.camp_id
			if not fleet_camps.has(fleet_camp_id):
				fleet_camps.append(fleet_camp_id)
		
		fleet_camps.sort()
		return fleet_camps


class TotalShipNumberGetter:
	static func get_total_ship_number_from_star_fleets_dictionaries_array(star_fleets_dictionaries_array : Array[Dictionary]) -> int:
		var total_ship_number : int = 0
		var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
		for fleet_dictionary in star_fleets_dictionaries_array:
			fleet_information_parser.parse_fleet_dicitionary(fleet_dictionary)
			var fleet_ship_number : int = fleet_information_parser.ship_number
			total_ship_number += fleet_ship_number
		
		return total_ship_number


	static func get_total_ship_number_from_star_fleets_arrays_array(star_fleets_arrays_array : Array[Array]) -> int:
		var total_ship_number : int = 0
		var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
		for fleet_array in star_fleets_arrays_array:
			fleet_information_parser.parse_fleet_array(fleet_array)
			var fleet_ship_number : int = fleet_information_parser.ship_number
			total_ship_number += fleet_ship_number
		
		return total_ship_number
