extends Control

const UISTANDARDSIZE : Vector2 = Vector2(231.0, 231.0)
var camp_colors : Dictionary

func _ready() -> void:
	Mapeditor1ShareData.editor_data_updated.connect(_on_global_data_updated)
	camp_colors = Mapeditor1ShareData.camp_colors


func _on_global_data_updated(key : String) -> void:
	var valid_keys : Array[String] = [
		"camp_colors",
		"star_fleets",
		"chosen_star",
		"is_star_chosen",
		"star_fleets",
		"stars_dictionary",
		"defined_camp_ids",
		"star_pattern_dictionary",
		"stars",
		"orbit_types",
		"all_basic_information",
	]
	var is_key_valid : bool = false
	for valid_key in valid_keys:
		if valid_key == key:
			is_key_valid = true
			break
	if is_key_valid == false:
		push_error("数据更新的键有问题!")
		return
	match key:
		"camp_colors":
			camp_colors = Mapeditor1ShareData.camp_colors


func update_star_ui(star_scale : float, this_star_fleets : Array[Dictionary]):
	_update_star_ui_rect(star_scale)
	_update_star_fleets_label(this_star_fleets)


func _update_star_ui_rect(star_scale : float):
	self.position = -(UISTANDARDSIZE / 2) * star_scale
	self.size = UISTANDARDSIZE * star_scale


func _update_star_fleets_label(this_star_fleets : Array[Dictionary]):
	for this_star_fleet in this_star_fleets:
		pass
