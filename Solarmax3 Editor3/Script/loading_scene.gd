extends Node

var next_scene : String = "res://Scenes/MapEditor/MapEditor.tscn"
@onready var progress_bar : ProgressBar = $Control/ProgressBar


func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene)


func _process(delta: float) -> void:
	var progress : Array = []
	var load_status = ResourceLoader.load_threaded_get_status(next_scene, progress)
	var new_progress : float = progress[0] * 100.0
	# 可以使用插值
	progress_bar.value = new_progress
	
	if load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		var packed_next_scene : PackedScene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(packed_next_scene)
