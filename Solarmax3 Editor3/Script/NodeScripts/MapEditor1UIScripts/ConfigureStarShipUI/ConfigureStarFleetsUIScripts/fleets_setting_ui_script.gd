extends Control

@export var configure_camp_ship_unit : PackedScene
var star_fleets_arrays : Array[Array]
var camp_ids : Array[int]

@onready var v_box_container : VBoxContainer = $ScrollContainer/VBoxContainer

func _ready() -> void:
	if configure_camp_ship_unit == null:
		push_error("没有配置阵营飞船设置单位!")
	
	_pull_map_editor_shared_information()


func _pull_map_editor_shared_information():
	camp_ids = MapeditorShareData.defined_camp_ids





func configure_fleets_setting_ui(star_fleet_dictionaries : Array[Dictionary]):
	star_fleet_dictionaries = FleetsInformationValidator.validate_star_fleets_dictionaries_array(
			star_fleet_dictionaries,
			FleetsInformationValidator.FilterFlags.NO_FILTER
	)
	
	var fleet_information_parser : FleetInformationParser = FleetInformationParser.new()
	for star_fleet_dictionary in star_fleet_dictionaries:
		fleet_information_parser.parse_fleet_dicitionary(star_fleet_dictionary)
		var configure_camp_ship_unit_node : Control = ConfigureCampShipUnitBuilder.create_configure_camp_ship_unit_node(
				fleet_information_parser.camp_id,
				fleet_information_parser.ship_number,
				configure_camp_ship_unit
		)
		
		v_box_container.add_child(configure_camp_ship_unit_node)


class ConfigureCampShipUnitBuilder:
	static func create_configure_camp_ship_unit_node(
			fleet_camp : int,
			ship_number : int,
			configure_camp_ship_unit_info : PackedScene
	) -> Control:
		var configure_camp_ship_unit_node : Control
		if configure_camp_ship_unit_info != null:
			configure_camp_ship_unit_node = configure_camp_ship_unit_info.instatiate()
			configure_camp_ship_unit_node.fleet_camp = fleet_camp
			configure_camp_ship_unit_node.ship_number = ship_number
		else:
			push_error("获取不到阵营飞船设置单位!")
			configure_camp_ship_unit_node = Control.new()

		return configure_camp_ship_unit_node
