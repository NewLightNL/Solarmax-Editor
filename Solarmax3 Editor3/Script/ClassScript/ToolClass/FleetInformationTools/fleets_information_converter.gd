class_name FleetsInformationConverter extends FleetsInformationTool


static func get_star_fleets_arrays(star_fleets_dictionaries : Array[Dictionary]) -> Array[Array]:
	star_fleets_dictionaries = FleetsInformationValidator.validate_star_fleets_dictionaries(
			star_fleets_dictionaries,
			FleetsInformationValidator.FilterFlags.NO_FILTER
	)
	
	var star_fleets_arrays : Array[Array]
	for star_fleets_dictionary in star_fleets_dictionaries:
		var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
		fleet_information_parser.parse_fleet_dicitionary(star_fleets_dictionary)
		
		var fleet_camp_id = fleet_information_parser.camp_id
		var fleet_ship_number = fleet_information_parser.ship_number
		
		var star_fleet_array : Array = FleetInformationCreator.create_fleet_array(fleet_camp_id, fleet_ship_number)
		star_fleets_arrays.append(star_fleet_array)
	
	return star_fleets_arrays


static func get_star_fleets_dictionaries_array() -> Array[Array]:
	return []
