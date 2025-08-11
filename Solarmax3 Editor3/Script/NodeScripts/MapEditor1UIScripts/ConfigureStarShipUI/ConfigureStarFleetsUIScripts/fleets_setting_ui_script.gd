extends Control

signal fleet_information_changed(fleet_camp_info : int, ship_number_info : int)

@export var configure_camp_ship_unit : PackedScene
var star_fleets_arrays : Array[Array]
var camp_ids : Array[int]

@onready var v_box_container : VBoxContainer = $ScrollContainer/VBoxContainer

func _ready() -> void:
	if configure_camp_ship_unit == null:
		push_error("没有配置阵营飞船设置单位!")
	
	_pull_map_editor_shared_information()


func _pull_map_editor_shared_information():
	camp_ids = MapEditorSharedData.defined_camp_ids


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"defined_camp_ids":
			camp_ids = MapEditorSharedData.defined_camp_ids


func configure_fleets_setting_ui(star_fleet_dictionaries : Array[Dictionary]):
	star_fleet_dictionaries = FleetsInformationValidator.validate_star_fleets_dictionaries_array(
			star_fleet_dictionaries,
			FleetsInformationValidator.FilterFlags.NO_FILTER
	)
	
	for camp_id in camp_ids:
		var camp_ship_number : int = FleetsInformationGetter.get_camp_ship_number_from_fleets_dictionaries_array(
			camp_id,
			star_fleet_dictionaries
		)
		var configure_camp_ship_unit_node : Control = ConfigureCampShipUnitBuilder.create_configure_camp_ship_unit_node(
				camp_id,
				camp_ship_number,
				configure_camp_ship_unit
		)
		configure_camp_ship_unit_node.fleet_infomation_updated.connect(_on_fleet_ship_number_changed)
		v_box_container.add_child(configure_camp_ship_unit_node)


func _on_fleet_ship_number_changed(fleet_camp_info : int, ship_number_info : int):
	emit_signal("fleet_information_changed", fleet_camp_info, ship_number_info)


class ConfigureCampShipUnitBuilder:
	static func create_configure_camp_ship_unit_node(
			fleet_camp : int,
			ship_number : int,
			configure_camp_ship_unit_info : PackedScene
	) -> Control:
		var configure_camp_ship_unit_node : Control
		if configure_camp_ship_unit_info != null:
			configure_camp_ship_unit_node = configure_camp_ship_unit_info.instantiate()
			configure_camp_ship_unit_node.fleet_camp = fleet_camp
			configure_camp_ship_unit_node.ship_number = ship_number
		else:
			push_error("获取不到阵营飞船设置单位!")
			configure_camp_ship_unit_node = Control.new()

		return configure_camp_ship_unit_node
