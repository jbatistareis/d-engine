class_name GuiWindow
extends Control

enum InputType {UP = 1, DOWN = -1}

var widgets : Array = []

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
	if type == Enums.GuiWindowType.FOREGROUND:
		Signals.connect("guiConfirm", self, "confirm")
		Signals.connect("guiUp", self, "action", [InputType.UP])
		Signals.connect("guiDown", self, "action", [InputType.DOWN])
		Signals.connect("guiSelect", self, "select")
		Signals.connect("guiCancel", self, "cancel")
	
	bg.color = GuiTheme.BG_COLOR
	
	shadow.color = Color.black
	shadow.color.a = 0.5
	shadow.rect_position = Vector2(4, 4)
	
	for widget in widgets:
		vBox.add_child(widget)
	
	var index = 0
	for widget in widgets:
		if widget is GuiButtonWidget:
			buttonIndex = index
			widget.hover = true
			break
		index += 1
	
	if position == Vector2.INF:
		position = GuiOverlayManager.windowSize() * 0.5 - (rect_min_size * 0.5)
	
	rect_position = position
	
	add_child(shadow)
	add_child(bg)
	add_child(vBox)


func _enter_tree() -> void:
	yield(get_tree(), "idle_frame")
	
	rect_min_size = vBox.rect_size
	
	bg.rect_min_size = rect_min_size
	shadow.rect_min_size = rect_min_size
	
	for widget in widgets:
		widget.fitWidth(rect_min_size.x)


func action(inputAction : int) -> void:
	if GuiOverlayManager.isCurrentWindow(self):
		var newIndex = (buttonIndex - inputAction) % widgets.size()
		
		if widgets[newIndex] is GuiButtonWidget:
			widgets[buttonIndex].hover = false
			buttonIndex = newIndex if (newIndex >= 0) else (widgets.size() - 1)
			widgets[buttonIndex].hover = true
			Signals.emit_signal("guiHover", widgets[buttonIndex].data)


func select() -> void:
	if GuiOverlayManager.isCurrentWindow(self):
		yield(get_tree(), "idle_frame")
		widgets[buttonIndex].action()


func confirm(source : GuiButtonWidget) -> void:
	if GuiOverlayManager.isCurrentWindow(self) && widgets.has(source):
		data = null
		
		if source.data != null:
			data = source.data
		else:
			data = {}
			for widget in widgets:
				if (widget is GuiButtonWidget) && (widget.identifier != null) && !widget.identifier.empty():
					data[widget.identifier] = widget.data
		
		windowConfirmed()
		
		if source.closeOnConfirm:
			Signals.emit_signal("guiCloseWindow")


func cancel(source : GuiButtonWidget) -> void:
	if GuiOverlayManager.isCurrentWindow(self) && widgets.has(source):
		windowClosed()
		Signals.emit_signal("guiCloseWindow")


func setPostion(value : Vector2) -> void:
	position = value
	rect_position = value


# override
func windowConfirmed() -> void:
	pass



# override
func windowClosed() -> void:
	pass

