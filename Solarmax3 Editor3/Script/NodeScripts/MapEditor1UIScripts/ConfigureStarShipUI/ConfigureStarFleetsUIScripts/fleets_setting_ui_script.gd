extends Control

@export var configure_camp_ship_unit : PackedScene
var star_fleets_arrays : Array[Array]

func _ready() -> void:
	if configure_camp_ship_unit == null:
		push_error("没有配置阵营飞船设置单位!")


func configure_fleets_setting_ui(star_fleets_dictionaries : Array[Dictionary]):
	pass


class ConfigureCampShipUnitBuilder:
	var configure_camp_ship_unit : PackedScene
	
	func _init(
		 configure_camp_ship_unit_info : PackedScene
	) -> void:
		if configure_camp_ship_unit_info != null:
			configure_camp_ship_unit = configure_camp_ship_unit_info
		else:
			push_error("获取不到阵营飞船设置单位!")
			configure_camp_ship_unit = PackedScene.new()
	
	func create_configure_camp_ship_unit_node(
			fleet_camp : int,
			ship_number : int,
	) -> PackedScene:
		var configure_camp_ship_unit_node = configure_camp_ship_unit.instatiate()
		configure_camp_ship_unit_node.fleet_camp = fleet_camp
		configure_camp_ship_unit_node.ship_number = ship_number
		return configure_camp_ship_unit_node
