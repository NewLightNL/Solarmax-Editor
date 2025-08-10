class_name FleetsInformationValidator extends FleetsInformationTool

enum FilterFlags {
	NO_FILTER,
	FILTER_CAMP_ZERO,
	FILTER_SHIPNUMBER_ZERO,
	FILTER_CAMP_ZERO_AND_SHIP_NUMBER_ZERO
}


static func validate_star_fleets_dictionaries_array(
		star_fleets_dictionaries : Array[Dictionary],
		filterflag : FilterFlags,
) -> Array[Dictionary]:
	var fleets_camps : Array[int] = FleetsInformationGetter.get_star_fleets_dictionaries_campids(star_fleets_dictionaries)
	
	var star_fleets_dictionaries_validated : Array[Dictionary] = []
	for fleet_camp in fleets_camps:
		var camp_fleet_ship_number : int = FleetsInformationGetter.get_camp_ship_number_from_fleets_dictionaries_array(
				fleet_camp,
				star_fleets_dictionaries,
		)
		
		var star_fleet_dictionary : Dictionary = FleetInformationCreator.create_fleet_dicitionary(fleet_camp, camp_fleet_ship_number)
		if not _fleet_dictionary_should_filtered(
				star_fleet_dictionary,
				filterflag,
		):
			star_fleets_dictionaries_validated.append(star_fleet_dictionary)
	
	return star_fleets_dictionaries_validated


static func validate_star_fleet_arrays_array(
		star_fleets_arrarys : Array[Array],
		filter_flag : FilterFlags,
) -> Array[Array]:
	var fleet_camps : Array[int] = FleetsInformationGetter.get_star_fleets_arrays_array_campids(star_fleets_arrarys)
	
	var star_fleet_arrays_array_validated : Array[Array] = []
	for fleet_camp in fleet_camps:
		var fleet_ship_number : int = FleetsInformationGetter.get_camp_ship_number_from_fleets_arrarys_array(
			fleet_camp,
			star_fleets_arrarys
		)
		
		var star_fleet_array : Array = FleetInformationCreator.create_fleet_array(
				fleet_camp,
				fleet_ship_number,
		)
		
		if not _fleet_array_should_filter(
				star_fleet_array,
				filter_flag
		):
			star_fleet_arrays_array_validated.append(star_fleet_array)
	
	return star_fleet_arrays_array_validated


static func _fleet_dictionary_should_filtered(
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


static func _fleet_array_should_filter(
		fleet_array : Array,
		filter_flag : FilterFlags,
) -> bool:
	match filter_flag:
		FilterFlags.NO_FILTER:
			return true
		FilterFlags.FILTER_CAMP_ZERO:
			var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
			fleet_information_parser.parse_fleet_array(fleet_array)
			if fleet_information_parser.camp_id == 0:
				return false
			else:
				return true
		FilterFlags.FILTER_SHIPNUMBER_ZERO:
			var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
			fleet_information_parser.parse_fleet_array(fleet_array)
			if fleet_information_parser.ship_number == 0:
				return false
			else:
				return true
		FilterFlags.FILTER_CAMP_ZERO_AND_SHIP_NUMBER_ZERO:
			var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
			fleet_information_parser.parse_fleet_array(fleet_array)
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
