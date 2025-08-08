class_name NumberLimiter extends Tool

# 待完善，要把下面这个类拆出来
class NumberProcessor:
	static func process_number(
			value : float,
			min_value : float,
			max_value : float,
			step : float,
	) -> Variant:
		# 判断step是不是整数
		# 建议拆分成两个函数
		if is_zero_approx(step - round(step)):
			# 是整数则返回整数
			var new_value : int = _clamp_int(
					value,
					min_value,
					max_value,
					round(step),
			)
			
			return new_value
		else:
			# 不是整数则返回浮点数
			var new_value : float = _clamp_float(
					value,
					min_value,
					max_value,
					step,
			)
			
			return new_value
	
	
	static func _process_blank(
			min_value : float,
			max_value : float,
			step : float,
	) -> Variant:
		# 判断step是不是整数
		if is_zero_approx(step - round(step)):
			var new_value : int = _clamp_int(
					0,
					min_value,
					max_value,
					round(step)
			)
			return new_value
		else:
			var new_value : float = _clamp_float(
					0,
					min_value,
					max_value,
					step
			)
			return new_value
	
	
	static func _clamp_int(
			value : float,
			min_value : float,
			max_value : float,
			step : int,
	) -> int:
		var min_value_ceiled = ceili(min_value)
		var max_value_floored = floori(max_value)
		if min_value_ceiled > max_value_floored:
			max_value_floored = min_value_ceiled
		
		var new_value : int = clampi(
				round(value),
				min_value_ceiled,
				max_value_floored,
		)
		new_value = snappedi(new_value, step)
		if new_value > max_value:
			if (max_value - min_value) < step:
				new_value = round(max_value)
			else:
				new_value -= step
		elif new_value < min_value:
			if (max_value - min_value) < step:
				new_value = round(min_value)
			else:
				new_value += step
		else:
			new_value = new_value
		
		return new_value
	
	
	static func _clamp_float(
			value : float,
			min_value : float,
			max_value : float,
			step : float,
	) -> float:
		if max_value < min_value:
			max_value = min_value
		
		var new_value : float = clampf(
				value,
				min_value,
				max_value
		)
		new_value = snappedf(new_value, step)
		if new_value > max_value:
			if (max_value - min_value) < step:
				new_value = max_value
			else:
				new_value -= step
		elif new_value < min_value:
			if (max_value - min_value) < step:
				new_value = min_value
			else:
				new_value += step
		else:
			new_value = new_value
		
		return new_value
