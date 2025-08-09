class_name FleetInformationCreator extends FleetsInformationTool

static func create_fleet_dicitionary(camp_id : int, ship_number : int) -> Dictionary:
	var fleet_dictionary : Dictionary
	if ship_number < 0:
		ship_number = 0
	fleet_dictionary["camp_id"] = camp_id
	fleet_dictionary["ship_number"] = ship_number
	return fleet_dictionary


static func create_fleet_array(camp_id : int, ship_number : int) -> Array[int]:
	var fleet_array : Array[int]
	if ship_number < 0:
		ship_number = 0
	fleet_array.append(camp_id)
	fleet_array.append(ship_number)
	return fleet_array
