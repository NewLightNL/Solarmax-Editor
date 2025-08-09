class_name FleetsInformationValidator extends FleetsInformationTool

enum FilterFlags {
	NO_FILTER,
	FILTER_CAMP_ZERO,
	FILTER_SHIPNUMBER_ZERO,
	FILTER_CAMP_ZERO_AND_SHIP_NUMBER_ZERO
}


static func validate_star_fleets_dictionaries(
		star_fleets_dictionaries : Array[Dictionary],
		filterflag : FilterFlags
) -> Array[Dictionary]:
	var fleets_camps : Array[int] = FleetsInformationGetter.get_star_fleets_dictionaries_campids(star_fleets_dictionaries)
	
	var star_fleets_dictionaries_validated : Array[Dictionary]
	for fleet_camp in fleets_camps:
		var camp_fleet_ship_number : int = FleetsInformationGetter.get_camp_ship_number_from_fleets_dictionaries_array(
				fleet_camp,
				star_fleets_dictionaries,
		)
		
		var star_fleets_dictionary_validated : Dictionary = FleetInformationCreator.create_fleet_dicitionary(fleet_camp, camp_fleet_ship_number)
		if not _should_filtered(
				star_fleets_dictionary_validated,
				filterflag,
		):
			star_fleets_dictionaries_validated.append(star_fleets_dictionary_validated)
	
	return star_fleets_dictionaries_validated


static func validate_star_fleets_arrays(star_fleets_arrarys : Array[Array]) -> Array[Array]:
	return []


static func _should_filtered(
		fleet_dictionary : Dictionary,
		filter_flag : FilterFlags,
) -> bool:
		match filter_flag:
			FilterFlags.NO_FILTER:
				return true
			FilterFlags.FILTER_CAMP_ZERO:
				var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
				fleet_information_parser.parse_fleet_dicitionary(fleet_dictionary)
				if fleet_information_parser.camp_id == 0:
					return false
				else:
					return true
			FilterFlags.FILTER_SHIPNUMBER_ZERO:
				var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
				fleet_information_parser.parse_fleet_dicitionary(fleet_dictionary)
				if fleet_information_parser.ship_number == 0:
					return false
				else:
					return true
			FilterFlags.FILTER_CAMP_ZERO_AND_SHIP_NUMBER_ZERO:
				var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
				fleet_information_parser.parse_fleet_dicitionary(fleet_dictionary)
				if (
						fleet_information_parser.camp_id == 0
						or fleet_information_parser.ship_number == 0
				):
					return false
				else:
					return true
			_:
				push_error("未知的过滤标志: " + str(filter_flag))
				return false
