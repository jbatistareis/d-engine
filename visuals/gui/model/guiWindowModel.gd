class_name GuiWindowModel
extends Control

enum InputType {UP = 1, DOWN = -1}

var text : GuiTextModel = null
var buttons : Array = []

var buttonIndex : int = 0
var data = null
var position : Vector2 = Vector2.INF setget setPostion
var type : int = Enums.GuiWindowType.FOREGROUND

var vBox : VBoxContainer = VBoxContainer.new()
var bg : ColorRect = ColorRect.new()
var shadow : ColorRect = ColorRect.new()


# override
func _init(pos : Vector2 = Vector2.INF) -> void:
	position = pos


func _ready() -> void:
	Signals.connect("guiConfirm", self, "confirm")
	Signals.connect("guiUp", self, "action", [InputType.UP])
	Signals.connect("guiDown", self, "action", [InputType.DOWN])
	Signals.connect("guiSelect", self, "select")
	
	bg.color = GuiTheme.BG_COLOR
	shadow.color = Color.black
	shadow.color.a = 0.5
	shadow.rect_position = Vector2(4, 4)
	
	if text != null:
		vBox.add_child(text)
	
	for button in buttons:
		vBox.add_child(button)
	
	if !buttons.empty():
		buttons[buttonIndex].hover = true
	
	add_child(shadow)
	add_child(bg)
	add_child(vBox)


func _enter_tree() -> void:
	yield(get_tree(), "idle_frame")
	
	rect_min_size = vBox.rect_size
	
	if position == Vector2.INF:
		position = OverlayManager.windowSize() * 0.5 - (rect_min_size * 0.5)
	
	rect_position = position
	
	bg.rect_min_size = rect_min_size
	shadow.rect_min_size = rect_min_size
	
	for button in buttons:
		button.fitWidth(rect_min_size.x)


func action(inputAction : int) -> void:
	if OverlayManager.isCurrentWindow(self):
		var newIndex = (buttonIndex - inputAction) % buttons.size()
		
		if buttons[newIndex] is GuiButtonModel:
			buttons[buttonIndex].hover = false
			buttonIndex = newIndex if (newIndex >= 0) else (buttons.size() - 1)
			buttons[buttonIndex].hover = true


func select() -> void:
	if OverlayManager.isCurrentWindow(self):
		yield(get_tree(), "idle_frame")
		buttons[buttonIndex].action()


func confirm(source : GuiButtonModel) -> void:
	if OverlayManager.isCurrentWindow(self) && buttons.has(source):
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


func setPostion(value : Vector2) -> void:
	position = value
	rect_position = value


# override
func windowConfirmed() -> void:
	pass

