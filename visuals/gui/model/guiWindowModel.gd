class_name GuiWindowModel
extends Control

enum InputType {UP = 1, DOWN = -1}

var text : GuiTextModel = null
var buttons : Array = []

var buttonIndex : int = 0
var data = null
var position : Vector2 = Vector2.ZERO setget setPostion


func _init() -> void:
	Signals.connect("guiConfirm", self, "confirm")
	Signals.connect("guiUp", self, "action", [InputType.UP])
	Signals.connect("guiDown", self, "action", [InputType.DOWN])
	Signals.connect("guiSelect", self, "select")


func _ready() -> void:
	var vBox : VBoxContainer = VBoxContainer.new()
	var bg : ColorRect = ColorRect.new()
	var shadow : ColorRect = ColorRect.new()
	
	bg.color = GuiColors.BG_COLOR
	bg.anchor_bottom = 1
	bg.anchor_right = 1
	shadow.color = Color.black
	shadow.color.a = 0.5
	shadow.anchor_bottom = 1
	shadow.anchor_right = 1
	vBox.alignment = BoxContainer.ALIGN_CENTER
	
	if text != null:
		vBox.add_child(text)
	
	for button in buttons:
		vBox.add_child(button)
	
	buttons[buttonIndex].hover = true
	
	add_child(shadow)
	add_child(bg)
	add_child(vBox)
	
	for i in range(2):
		yield(get_tree(),"idle_frame")
	
	rect_min_size = vBox.rect_size
	rect_position = position
	shadow.rect_position += Vector2(4, 4)


func action(inputAction : int) -> void:
	if isCurrentWindow():
		var newIndex = (buttonIndex - inputAction) % buttons.size()
		
		if buttons[newIndex] is GuiButtonModel:
			buttons[buttonIndex].hover = false
			buttonIndex = newIndex if (newIndex >= 0) else (buttons.size() - 1)
			buttons[buttonIndex].hover = true


func select() -> void:
	if isCurrentWindow():
		yield(get_tree(), "idle_frame")
		buttons[buttonIndex].action()


func confirm(source : GuiButtonModel) -> void:
	if isCurrentWindow() && buttons.has(source):
		data = null
		
		if source.data != null:
			data = source.data
		else:
			data = {}
			for button in buttons:
				if (button.identifier != null) && !button.identifier.empty():
					data[button.identifier] = button.data
		
		windowConfirmed()
		Signals.emit_signal("guiCloseWindow")


func isCurrentWindow() -> bool:
	return WindowManager.windowQueue.front() == self


func setPostion(value : Vector2) -> void:
	position = value
	rect_position = value


# override
func windowConfirmed() -> void:
	pass

