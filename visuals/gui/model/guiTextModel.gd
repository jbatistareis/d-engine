class_name GuiTextModel
extends Control

var text : String
var vBox = VBoxContainer.new()


func _init(text : String) -> void:
	self.text = text
	add_child(vBox)


func _enter_tree() -> void:
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
	
	yield(get_tree(), "idle_frame")
	rect_min_size = vBox.rect_size

