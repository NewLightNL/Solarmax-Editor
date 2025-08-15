extends Node2D

func _ready() -> void:
	var array : Array[int] = [1, 2, 3]
	var poped : int = array.pop_at(1)
	print(poped, array)
