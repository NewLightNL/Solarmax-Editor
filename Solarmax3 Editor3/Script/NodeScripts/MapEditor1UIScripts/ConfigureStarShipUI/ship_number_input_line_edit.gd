extends LineEdit

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


# 可能不需要外界提供old_text, old_caret_column
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
		self.min_value = min_value_info
		self.max_value = max_value_info
		self.step = step_info
		# 判断step是否为整数
		# 要考虑最小值的问题
		if is_zero_approx(step - round(step)):
			old_text = "0"
		else:
			old_text = "0.0"
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
			# 判断step是不是整数
			if is_zero_approx(step - round(step)):
				var new_text_to_float_rounded : int = snappedi(new_text_to_float, round(step))
				print(max_value)
				print(round(max_value))
				new_text_to_float_rounded = clampi(new_text_to_float_rounded, round(min_value), round(max_value))
				return_showed_text = str(new_text_to_float_rounded)
			else:
				var new_text_to_float_snapped : float = snappedf(new_text_to_float, step)
				new_text_to_float_snapped = clampf(new_text_to_float_snapped, round(min_value), round(max_value))
				return_showed_text = str(new_text_to_float_snapped)
		else:
			# 如果不是数字的原因是空格的话
			if new_text == "":
				# 判断step是不是整数
				if is_zero_approx(step - round(step)):
					return_showed_text = "0"
				else:
					return_showed_text = "0.0"
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
