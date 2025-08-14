extends Node

const MAX_RECENTLY_CHOSEN_STARS_NUMBER : int = 5

var recently_chosen_stars : Array[MapNodeStar]
var star_pattern_dictionary : Dictionary
var editor_type : EditorType

@onready var recently_chosen_star_slots : Control = $RecentlyChosenStarSlots


func _ready() -> void:
	_pull_map_editor_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	
	for recently_chosen_star_slot in recently_chosen_star_slots.get_children():
		var recently_chosen_star_button : Button = recently_chosen_star_slot.get_child(1).get_child(0)
		var slot_index : int = recently_chosen_star_slot.get_index()
		recently_chosen_star_button.button_up.connect(_on_recently_chosen_star_button_up.bind(slot_index))


func _pull_map_editor_information():
	star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
	editor_type = MapEditorSharedData.editor_type


func _on_global_data_updated(key : String):
	MapEditorSharedDataKeysChecker.check_key(key)
	
	match key:
		"star_pattern_dictionary":
			star_pattern_dictionary = MapEditorSharedData.star_pattern_dictionary
		"editor_type":
			editor_type = MapEditorSharedData.editor_type


func update_recently_chosen_stars(recently_chosen_star : MapNodeStar):
	_add_to_recently_chosen_star(recently_chosen_star)
	_update_recently_chosen_star_slots(recently_chosen_star)


func _add_to_recently_chosen_star(recently_chosen_star : MapNodeStar):
	recently_chosen_star = recently_chosen_star.duplicate()
	recently_chosen_stars.append(recently_chosen_star)
	
	if recently_chosen_stars.size() > MAX_RECENTLY_CHOSEN_STARS_NUMBER:
		recently_chosen_stars.remove_at(0)


func _update_recently_chosen_star_slots(recently_chosen_star : MapNodeStar):
	_clear_recently_chosen_star_slots()
	_set_recently_chosen_star_slots(recently_chosen_star)


func _clear_recently_chosen_star_slots():
	for recently_chosen_star_slot in recently_chosen_star_slots.get_children():
		var recently_chosen_star_piciture : TextureRect = recently_chosen_star_slot.get_child(0)
		if recently_chosen_star_piciture != null:
			recently_chosen_star_piciture.texture = null
		else:
			push_error("获取最近选择的天体栏的天体图片节点失败!")

# 设置最近选择的星球框(对recently_chosen_stars数组从右往左读取)
func _set_recently_chosen_star_slots(chosen_star : MapNodeStar):
	for slot_index in range(min(recently_chosen_stars.size(), MAX_RECENTLY_CHOSEN_STARS_NUMBER)):
		var recently_chosen_star_slot : Control = recently_chosen_star_slots.get_child(slot_index)
		var recently_chosen_star_piciture : TextureRect = recently_chosen_star_slot.get_child(0)
		var recently_chosen_star_index : int = recently_chosen_stars.size() - 1 - slot_index
		var recently_chosen_star : MapNodeStar = recently_chosen_stars[recently_chosen_star_index]
		var star_texture : CompressedTexture2D = star_pattern_dictionary[recently_chosen_star.pattern_name]
		if recently_chosen_star_piciture != null:
			recently_chosen_star_piciture.texture = star_texture
			if editor_type is NewExpedition:
				editor_type.obey_dirt_star_rotation_rule_ui(chosen_star, recently_chosen_star_piciture)
			else:
				pass
		else:
			push_error("获取最近选择的天体栏的天体图片节点失败!")


func _on_recently_chosen_star_button_up(slot_index : int):
	var old_recently_chosen_star_index =  recently_chosen_stars.size() - 1 - slot_index
	
