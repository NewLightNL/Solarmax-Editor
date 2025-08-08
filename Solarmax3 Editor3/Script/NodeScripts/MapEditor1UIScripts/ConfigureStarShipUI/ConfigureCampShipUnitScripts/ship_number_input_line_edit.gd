extends LineEdit

signal value_changed(value : float)

@export var min_value : float = 0.0
@export var max_value : float = 100.0
@export var step : float = 1.0
var text_processor : TextProcessor


func _ready() -> void:
	text_processor = TextProcessor.new(
			min_value,
			max_value,
			step,
			self.text,
			self.caret_column,
	)
	
	text_processor.update_text_info(self.text, self.caret_column)
	self.text = text_processor.showed_text
	self.caret_column = text_processor.caret_colomn


func _on_text_changed(new_text: String) -> void:
	text_processor.update_text_info(new_text, self.caret_column)
	self.text = text_processor.showed_text
	self.caret_column = text_processor.caret_colomn
	emit_signal("value_changed", float(self.text))


func update_ship_number(ship_number_info : int):
	text_processor.update_text_info(str(ship_number_info), self.caret_column)
	self.text = text_processor.showed_text
	self.caret_column = text_processor.caret_colomn
	emit_signal("value_changed", float(self.text))


class TextProcessor:
	var showed_text : String
	var caret_colomn : int
	
	var min_value : float
	var max_value : float
	var step : float
	var new_text : String
	var old_text : String
	var now_caret_column : int
	var old_caret_column : int
	
	
	func _init(
			min_value_info : float,
			max_value_info : float,
			step_info : float,
			new_text_info : String,
			now_caret_column_info : int,
	) -> void:
		if max_value_info < min_value_info:
			push_warning("最大值小于最小值")
		if (max_value_info - min_value_info) < step:
			push_warning("step大于取值区间")
		self.min_value = min_value_info
		self.max_value = max_value_info
		self.step = step_info
		var old_text_value = NumberProcessor._process_blank(
				min_value,
				max_value,
				step,
		)
		self.old_text = str(old_text_value)
		self.old_caret_column = 1
		self.new_text = new_text_info
		self.now_caret_column = now_caret_column_info
	
	
	func update_limit_info(
			min_value_info : float,
			max_value_info : float,
			step_info : float
	) -> void:
		self.min_value = min_value_info
		self.max_value = max_value_info
		self.step = step_info
	
	
	func update_text_info(
			new_text_info : String,
			now_caret_column_info : int,
	) -> void:
		self.new_text = new_text_info
		self.now_caret_column = now_caret_column_info
		
		self.showed_text = _get_showed_text()
		self.caret_colomn = _get_caret_colomn()
	
	
	func _get_showed_text() -> String:
		var return_showed_text : String = ""
		# 判断新文本是不是数字
		if new_text.is_valid_float() == true:
			var new_text_to_float : float = float(new_text)
			var new_text_to_float_processed : Variant = NumberProcessor.process_number(
					new_text_to_float,
					min_value,
					max_value,
					step,
			)
			return_showed_text = str(new_text_to_float_processed)
		else:
			# 如果不是数字的原因是空格的话
			if new_text == "":
				var new_text_processed : Variant = NumberProcessor._process_blank(
						min_value,
						max_value,
						step,
				)
				return_showed_text = str(new_text_processed)
			else:
				return_showed_text = old_text
		
		old_text = return_showed_text
		return return_showed_text
	
	
	func _get_caret_colomn() -> int:
		var return_caret_colomn : int = 0
		# 判断新文本是不是数字
		if new_text.is_valid_float() == true:
			return_caret_colomn = now_caret_column
		else:
			if new_text == "":
				return_caret_colomn = 1
			else:
				return_caret_colomn = old_caret_column
		
		old_caret_column = return_caret_colomn
		return return_caret_colomn


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
