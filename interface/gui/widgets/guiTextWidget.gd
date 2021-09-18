class_name GuiTextWidget
extends GuiWidget

var vBox = VBoxContainer.new()


func _init(text : String) -> void:
	var strLine = text.split(">")
	
	for line in strLine:
		var hBox = HBoxContainer.new()
		
		var strArr = line.split("|")
		for i in strArr.size():
			var label = Label.new()
			label.set("custom_colors/font_color", GuiTheme.TEXT_COLOR)
			label.add_font_override('font', GuiTheme.font)
			label.size_flags_horizontal = SIZE_EXPAND_FILL
			label.text = strArr[i]
			
			if (i > 0) && (i < (strArr.size() - 1)):
				label.align = Label.ALIGN_CENTER
			elif (strArr.size() > 1) && (i == (strArr.size() - 1)):
				label.align = Label.ALIGN_RIGHT
			
			hBox.add_child(label)
		
		vBox.add_child(hBox)
	
	add_child(vBox)


func _ready() -> void:
	rect_min_size = vBox.rect_size

