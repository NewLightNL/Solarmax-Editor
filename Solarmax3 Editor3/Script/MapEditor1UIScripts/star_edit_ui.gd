extends Control

@export var star_information_scene : PackedScene

# 外部输入
var star_pattern_dictionary : Dictionary
var have_camps : Array
var campcolor : Dictionary
var chosen_star : MapNodeStar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_star_edit_ui_close_button_button_up():
	visible = false
	$"../../StarEditUIOpenButton".visible = true
