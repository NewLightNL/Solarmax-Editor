class_name NewExpedition extends EditorType


enum OperationType {
	ROTATION,
	PERMISSTION,
	SET_VALUE,
}


func obey_rotation_rule(star : Star, operation_object : Node, operation_type : OperationType):
	match operation_type:
		OperationType.ROTATION:
			rotation_rule_apparitor.obey_dirt_star_rotation_rule(star, operation_object)
		OperationType.PERMISSTION:
			rotation_rule_apparitor.obey_rotation_permission(star, operation_object)
		OperationType.SET_VALUE:
			rotation_rule_apparitor.obey_rotation_value_setting_rule(star, operation_object)


class rotation_rule_apparitor:
	# 焦土类要在UI上显示旋转，但目标不用，
	# 因为焦土类是天体属性，而目标是天体节点属性
	static func obey_dirt_star_rotation_rule(star : Star, operation_object : Node):
		if operation_object is Node2D or operation_object is Control:
			if star.special_star_type == "dirt":
				operation_object.rotation = PI
			else:
				operation_object.rotation = 0.0
		else:
			push_error("要旋转的东西没有旋转功能!")
	
	
	static func obey_rotation_permission(star : Star, operation_object : Control):
		if operation_object is SpinBox:
			if star.type == "Gunturret" or star.type == "Mirror":
				operation_object.editable = true
			else:
				operation_object.editable = false
	
	
	static func obey_rotation_value_setting_rule(star : Star, operation_object : Control):
		if operation_object is SpinBox:
			if star.special_star_type == "dirt":
				operation_object.value = 180.0
			else:
				if star is MapNodeStar:
					if star.is_taget == true:
						operation_object.value = 90.0
				else:
					operation_object.value = 0.0


# 旋转规则:
# 1. 焦土星球旋转180度
# 2. 目标天体旋转90度
# 3. 反射镜、追踪炮自由旋转
# 4. 射线炮和粒子炮绝对不能旋转
# 5. 其它天体默认不能转，除非有允许旋转的情况

# 允许任意椭圆
