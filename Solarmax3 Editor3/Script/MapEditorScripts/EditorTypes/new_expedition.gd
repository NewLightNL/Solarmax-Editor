class_name NewExpedition extends EditorType

# 允许任意椭圆
func obey_dirt_star_rotation_rule_ui(star : Star, operation_object : Control):
	if star.special_star_type == "dirt":
		operation_object.rotation = PI
	else:
		operation_object.rotation = 0


func obey_rotation_permission_spin_box(star : Star, operation_object : SpinBox):
	if star.type == "Gunturret" or star.type == "Mirror":
		operation_object.editable = true
	else:
		operation_object.editable = false

# 旋转规则:
# 1. 焦土星球旋转180度
# 2. 目标天体旋转90度
# 3. 反射镜、追踪炮自由旋转
# 4. 射线炮和粒子炮绝对不能旋转
# 5. 其它天体默认不能转，除非有允许旋转的情况
