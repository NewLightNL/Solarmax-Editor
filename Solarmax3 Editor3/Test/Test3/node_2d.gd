extends Node2D

@export var osw : PackedScene

var c_list : Array[Callable]

func _ready() -> void:
	var text = "1234"
	text.left(-1)
	print(text)
