extends Node2D

@export var stars : Array
# 用于测试代码以及其它什么东西的

# Called when the node enters the scene tree for the first time.
func _ready():
	stars = Load.get_map_editor_basic_information("stars")
	print(Load.get_map_editor_basic_information("stars"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
