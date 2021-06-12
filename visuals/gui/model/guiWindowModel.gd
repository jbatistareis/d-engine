class_name GuiWindowModel
extends Control

enum InputType {UP = 1, DOWN = -1}

var title : String = ''
var identifier : String = ''
var buttons : Array = []
var buttonIndex : int = 0
var data = null
var position : Vector2 = Vector2.ZERO setget setPostion

var vBox : VBoxContainer = VBoxContainer.new()
var bg : ColorRect = ColorRect.new()


func _init() -> void:
	Signals.connect("guiConfirm", self, "confirm")
	Signals.connect("guiUp", self, "action", [InputType.UP])
	Signals.connect("guiDown", self, "action", [InputType.DOWN])
	Signals.connect("guiSelect", self, "select")
	
	bg.color = GuiColors.BG_COLOR
	bg.anchor_bottom = 1
	bg.anchor_right = 1
	vBox.alignment = BoxContainer.ALIGN_CENTER


func _ready() -> void:
	for button in buttons:
		vBox.add_child(button)
	
	# TODO remove
	if !buttons.empty():
		buttons[buttonIndex].hover = true
	
	add_child(bg)
	add_child(vBox)
	
	yield(get_tree(),"idle_frame")
	rect_min_size = vBox.rect_size
	rect_position = position


func action(inputAction : int) -> void:
	if isCurrentWindow():
		var newIndex = (buttonIndex - inputAction) % buttons.size()
		
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

