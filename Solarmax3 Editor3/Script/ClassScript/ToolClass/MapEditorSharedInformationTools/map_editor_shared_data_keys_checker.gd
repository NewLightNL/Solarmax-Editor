class_name MapEditorSharedDataKeysChecker extends Tool

const keys : Array[String] = [
	"defined_camp_ids",
	"camp_colors",
	"star_pattern_dictionary",
	"stars",
	"stars_dictionary",
	"orbit_types",
	"chosen_star",
	"star_fleets",
	"editor_type",
]


static func check_key(key : String) -> void:
	if not keys.has(key):
		push_error("上传的key有问题!")
