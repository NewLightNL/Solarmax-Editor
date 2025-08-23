extends Window

signal lasergun_information_changed(lasergun_information_sent : Dictionary[String, float])

var request_type : String = "LasergunInformationConfiguration"
var chosen_star : MapNodeStar
var initial_lasergun_information : Dictionary[String, float]
var is_setting_value : bool = false

var lasergun_information : Dictionary[String, float] = {
	"lasergunAngle" : 0.0,
	"lasergunRotateSkip" : 0.0,
	"lasergunRange" : 0.0,
}
# 这里拆分出来的变量以后可以封装
# 怎么从根本上解决这循环调用lasergun_angle→lasergun_anlge_setting_spin_box→lasergun_angle
var lasergun_angle : float:
	set(value):
		is_setting_value = true
		lasergun_angle = value
		lasergun_information["lasergunAngle"] = value
		lasergun_anlge_setting_spin_box.value = value
		is_setting_value = false

var lasergun_rotate_skip : float:
	set(value):
		is_setting_value = true
		lasergun_rotate_skip = value
		lasergun_information["lasergunRotateSkip"] = value
		lasergun_rotate_skip_spin_box.value = value
		is_setting_value = false

var lasergun_range : float:
	set(value):
		is_setting_value = true
		lasergun_range = value
		lasergun_information["lasergunRange"] = value
		lasergun_range_spin_box.value = value
		is_setting_value = false

@onready var lasergun_anlge_setting_spin_box : SpinBox = $ConfigureLasergunInformationUI/LasergunAngleSettingControl/LasergunAngleSettingSpinBox
@onready var lasergun_rotate_skip_spin_box : SpinBox = $ConfigureLasergunInformationUI/LasergunRotateSkipControl/LasergunRotateSkipSpinBox
@onready var lasergun_range_spin_box : SpinBox = $ConfigureLasergunInformationUI/LasergunRangeControl/LasergunRangeSpinBox


# lasergunAngle="" 表示射线炮的初始旋转角度。
# lasergunRotateSkip="" 表示射线炮的单次旋转角度。
# lasergunRange="" 表示射线炮的总旋转角度。
# 注意，如果想让射线炮不旋转，不可以在两个属性同时填0，因为0不能除以0。正确的填法是在lasergunRotateSkip=""中填写一个比lasergunRange=""中大的数字。


func _ready() -> void:
	position = Vector2(1200.0, 800.0)
	
	_pull_map_editor_shared_information()
	MapEditorSharedData.shared_data_updated.connect(_on_global_data_updated)
	
	_initialize_configure_lasergun_information_window_when_ready()


func _pull_map_editor_shared_information() -> void:
	chosen_star = MapEditorSharedData.chosen_star


func _on_global_data_updated(key : String):
	if key == "chosen_star":
		chosen_star = MapEditorSharedData.chosen_star


func _initialize_configure_lasergun_information_window_when_ready() -> void:
	if chosen_star != null:
		if chosen_star.special_star_type == "Lasergun":
			var is_having_lasergun_information : bool = false
			var chosen_star_information_got : Dictionary[String, float] = chosen_star.lasergun_information
			var required_keys : Array[String] = [
				"lasergunAngle",
				"lasergunRotateSkip",
				"lasergunRange",
			]
			for required_key in required_keys:
				if chosen_star_information_got.has(required_key):
					is_having_lasergun_information = true
				else:
					is_having_lasergun_information = false
			
			if is_having_lasergun_information:
				initial_lasergun_information = chosen_star.lasergun_information
				lasergun_angle = chosen_star.lasergun_information["lasergunAngle"]
				lasergun_rotate_skip = chosen_star.lasergun_information["lasergunRotateSkip"]
				lasergun_range = chosen_star.lasergun_information["lasergunRange"]


func initialize_configure_lasergun_information_window():
	initial_lasergun_information = {
		"lasergunAngle" : 0.0,
		"lasergunRotateSkip" : 0.0,
		"lasergunRange" : 0.0,
	}
	lasergun_information = {
		"lasergunAngle" : 0.0,
		"lasergunRotateSkip" : 0.0,
		"lasergunRange" : 0.0,
	}
	
	lasergun_angle = 0.0
	lasergun_rotate_skip = 0.0
	lasergun_range = 0.0


func update_configure_lasergun_information_window(map_node_star : MapNodeStar):
	initial_lasergun_information = {
		"lasergunAngle" : map_node_star.lasergun_information["lasergunAngle"],
		"lasergunRotateSkip" : map_node_star.lasergun_information["lasergunRotateSkip"],
		"lasergunRange" : map_node_star.lasergun_information["lasergunRange"],
	}
	lasergun_information = {
		"lasergunAngle" : map_node_star.lasergun_information["lasergunAngle"],
		"lasergunRotateSkip" : map_node_star.lasergun_information["lasergunRotateSkip"],
		"lasergunRange" : map_node_star.lasergun_information["lasergunRange"],
	}
	
	lasergun_angle = map_node_star.lasergun_information["lasergunAngle"]
	lasergun_rotate_skip = map_node_star.lasergun_information["lasergunRotateSkip"]
	lasergun_range = map_node_star.lasergun_information["lasergunRange"]
	emit_signal("lasergun_information_changed", lasergun_information)


func _on_lasergun_angle_setting_spin_box_value_changed(value: float) -> void:
	if not is_setting_value:
		lasergun_information["lasergunAngle"] = value
		lasergun_angle = value
		emit_signal("lasergun_information_changed", lasergun_information)


func _on_lasergun_rotate_skip_spin_box_value_changed(value: float) -> void:
	if not is_setting_value:
		lasergun_information["lasergunRotateSkip"] = value
		lasergun_rotate_skip = value
		emit_signal("lasergun_information_changed", lasergun_information)


func _on_lasergun_range_spin_box_value_changed(value: float) -> void:
	if not is_setting_value:
		lasergun_information["lasergunRange"] = value
		lasergun_range = value
		emit_signal("lasergun_information_changed", lasergun_information)


func _on_close_requested() -> void:
	queue_free()
