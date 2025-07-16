extends Control

@export var star_information_scene : PackedScene

# 外部输入
var star_pattern_dictionary : Dictionary
var have_camps : Array
var campcolor : Dictionary
var chosen_star : MapNodeStar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 将天体阵营的两个输入方式绑定
func _on_star_camp_input_text_changed(new_text):
	if int(new_text) >= 0 and int(new_text) in have_camps:
		$UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInputOptionButton.select(int(new_text))
	elif int(new_text) >= 0 and int(new_text) not in have_camps:
		$UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInputOptionButton.select(have_camps[-1]+1)
	else:
		$UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInputOptionButton.select(0)

func _on_star_camp_input_option_button_item_selected(index):
	$UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInput.text = $UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInputOptionButton.get_item_text(index)

# 天体阵营信息输入框内容修正
func _on_star_camp_input_focus_exited():
	if int($UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInput.text) < 0 or int($UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInput.text) > 2147483647:
		$UI/CreateUI/StarInformation/CamptionInputLabel/StarCampInput.text = "0"
