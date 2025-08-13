extends Node

const LOADING_SCENE : PackedScene = preload("res://Scenes/MainMenu/loading_scene.tscn")

func _ready() -> void:
	var new_expedition : NewExpedition = NewExpedition.new()
	var new_main_line : NewMainLine = NewMainLine.new()
	$UI/NewExpeditionButton.button_up.connect(_on_enter_map_editor_button_up.bind(new_expedition))
	$UI/NewMainLineButton.button_up.connect(_on_enter_map_editor_button_up.bind(new_main_line))


func _on_enter_map_editor_button_up(editor_type : EditorType) -> void:
	MapEditorSharedData.data_updated("editor_type", editor_type)
	# 可以使用插值来平滑移动
	var loading_scene : Node = LOADING_SCENE.instantiate()
	loading_scene.next_scene = "res://Scenes/MapEditor/MapEditor.tscn"
	$UI.visible = false
	add_child(loading_scene)
