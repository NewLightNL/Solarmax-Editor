class_name Save


const FILE_PATH = "user://saved_map_information.xml"


static func save_map_node_stars(map_node_stars_should_be_saved : Array[MapNodeStar]):
	var star_info = _convert_map_node_stars_to_string(map_node_stars_should_be_saved)
	#print(star_info)
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_string(star_info)
	file.close()


static func _convert_map_node_stars_to_string(map_node_stars_should_be_saved : Array[MapNodeStar]) -> String:
	var xml_content : String = ""
	xml_content += "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
	xml_content += "<map player_count=\"1\" vertical=\"False\" defaultAIStrategy=\"-1\" teamJiemeng=\"\">\n"
	xml_content += "\t<mapbuildings>\n"
	for map_node_star in map_node_stars_should_be_saved:
		var star_format = "<mapbuilding type=\"%s\" size=\"%s\" tag=\"%s\" x=\"%s\" y=\"%s\" camption=\"%s\"/>"
		var type_info = map_node_star.type
		var size_info = map_node_star.size_type
		var tag_info = map_node_star.tag
		var position_x_info = map_node_star.star_position.x
		var position_y_info = map_node_star.star_position.y
		var camp_info = map_node_star.star_camp
		var star_info_string = star_format % [type_info, size_info, tag_info, position_x_info, position_y_info, camp_info]
		xml_content += "\t\t" + star_info_string + "\n"
	xml_content += "\t</mapbuildings>\n"
	xml_content += "\t<mapplayers>\n"
	for map_node_star in map_node_stars_should_be_saved:
		var ship_format = "<mapplayer tag=\"%s\" ship=\"%s\" camption=\"%s\" />"
		var this_star_fleets : Array = map_node_star.this_star_fleets
		for this_star_fleet in this_star_fleets:
			var fleet_tag : String = map_node_star.tag
			var ship_number : int = this_star_fleet[1]
			var fleet_camp : int = this_star_fleet[0]
			var ship_info_string : String = ship_format % [fleet_tag, ship_number, fleet_camp]
			xml_content += "\t\t" + ship_info_string + "\n"
	xml_content += "\t</mapplayers>\n"
	xml_content += "</map>"
	return xml_content

#<?xml version="1.0" encoding="utf-8"?>
#<map player_count="1" vertical="False" defaultAIStrategy="-1" teamAITypes="-1,-1,-1,-1,-1,-1,-1,-1,-1" teamJiemeng="">
  #<mapbuildings>
	#<mapbuilding type="star" size="7" tag="A" x="-5" y="-2" camption="1" fAngle="0" orbit="0" revospeed="10" orbitParam1="0,0" orbitParam2="0" orbitClockWise="False" />
	#<mapbuilding type="star" size="6" tag="B" x="-1" y="0" camption="0" fAngle="0" orbit="0" revospeed="10" orbitParam1="0,0" orbitParam2="0" orbitClockWise="False" />
	#<mapbuilding type="star" size="4" tag="1" x="2" y="3" camption="0" fAngle="0" orbit="0" revospeed="10" orbitParam1="0,0" orbitParam2="0" orbitClockWise="False" />
	#<mapbuilding type="star" size="2" tag="2" x="4" y="-2" camption="0" fAngle="0" orbit="0" revospeed="10" orbitParam1="0,0" orbitParam2="0" orbitClockWise="False" />
  #</mapbuildings>
  #<mapplayers>
	#<mapplayer tag="A" ship="60" camption="1" />
  #</mapplayers>
  #<candidates>
	#<candidate transformBulidingID="" />
	#<candidate lasergunAngle="" lasergunRotateSkip="" lasergunRange="" />
	#<candidate orbit="0" orbitParam1="" orbitParam2="" />
	#<candidate revospeed="10" />
  #</candidates>
#</map>
