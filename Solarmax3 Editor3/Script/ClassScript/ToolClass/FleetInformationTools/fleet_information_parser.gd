class_name FleetInformationParser extends FleetsInformationTool

var camp_id : int
var ship_number : int


func parse_fleet_dicitionary(fleet_dicitionary : Dictionary) -> void:
	for info_key in fleet_dicitionary:
		if info_key == "camp_id":
			camp_id = fleet_dicitionary[info_key]
		elif info_key == "ship_number":
			ship_number = fleet_dicitionary[info_key]
		else:
			camp_id = 0
			ship_number = 0
			push_error("舰队字典的键错误！")


func parse_fleet_array(fleet_array : Array) -> void:
	if fleet_array.size() == 2:
		camp_id = fleet_array[0]
		ship_number = fleet_array[1]
	else:
		camp_id = 0
		ship_number = 0
		push_error("舰队数组大小有问题!")
