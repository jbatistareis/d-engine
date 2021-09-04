class_name GuiTextModel
extends MarginContainer

var vBox = VBoxContainer.new()


func _init(text : String) -> void:
	var strLine = text.split(">")
	
	for line in strLine:
		var hBox = HBoxContainer.new()
		vBox.add_child(hBox)
		
		var strArr = line.split("|")
		for i in strArr.size():
			var label = Label.new()
			label.size_flags_horizontal = SIZE_EXPAND_FILL
			label.text = strArr[i]
			
			if (i > 0) && (i < (strArr.size() - 1)):
				label.align = Label.ALIGN_CENTER
			elif (strArr.size() > 1) && (i == (strArr.size() - 1)):
				label.align = Label.ALIGN_RIGHT
			
			hBox.add_child(label)
	
	add_constant_override("margin_top", GuiTheme.MARGIN_SIZE)
	add_constant_override("margin_left", GuiTheme.MARGIN_SIZE)
	add_constant_override("margin_bottom", GuiTheme.MARGIN_SIZE)
	add_constant_override("margin_right", GuiTheme.MARGIN_SIZE)
	
	add_child(vBox)


func _ready() -> void:
	rect_min_size = vBox.rect_size
