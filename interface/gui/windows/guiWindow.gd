class_name GuiWindow
extends Control

enum InputType {UP = 1, DOWN = -1, LEFT = 2, RIGHT = -2}

var widgets : Array = []

var buttonIndex : int = 0
var data = null
var position : Vector2 = Vector2.INF setget setPostion
var type : int = Enums.GuiWindowType.FOREGROUND

var lines : int = 0
var columns : int

var bg : ColorRect = ColorRect.new()
var shadow : ColorRect = ColorRect.new()
var hBox : HBoxContainer = HBoxContainer.new()


# override
func _init(pos : Vector2 = Vector2.INF) -> void:
	position = pos


func setContent() -> void:
	if type == Enums.GuiWindowType.FOREGROUND:
		Signals.connect("guiConfirm", self, "confirm")
		Signals.connect("guiUp", self, "action", [InputType.UP])
		Signals.connect("guiDown", self, "action", [InputType.DOWN])
		Signals.connect("guiLeft", self, "action", [InputType.LEFT])
		Signals.connect("guiRight", self, "action", [InputType.RIGHT])
		Signals.connect("guiSelect", self, "select")
		Signals.connect("guiCancel", self, "cancel")
	
	bg.color = GuiTheme.BG_COLOR
	
	shadow.color = Color.black
	shadow.color.a = 0.5
	shadow.rect_position = Vector2(4, 4)
	
	if lines == 0:
		lines = widgets.size()
	columns = ceil(widgets.size() / float(lines))
	
	for i in range(columns):
		hBox.add_child(VBoxContainer.new())
	
	var lineCount = 0
	var columnCount = 0
	for widget in widgets:
		hBox.get_child(columnCount).add_child(widget)
		lineCount += 1
		
		if lineCount == lines:
			columnCount += 1
			lineCount = 0
	
	var index = 0
	for widget in widgets:
		if widget is GuiButtonWidget:
			buttonIndex = index
			widget.hover = true
			break
		index += 1
	
	if position == Vector2.INF:
		position = GuiOverlayManager.windowSize() / 2
	
	rect_position = position
	
	add_child(shadow)
	add_child(bg)
	add_child(hBox)


func fit() -> void:
	var columnWidth = hBox.rect_size.x / float(columns)
	for widget in widgets:
		widget.fitWidth(columnWidth)
		
	yield(get_tree(), "idle_frame")
	
	bg.rect_min_size =  hBox.rect_size
	shadow.rect_min_size =  hBox.rect_size


func action(inputAction : int) -> void:
	if GuiOverlayManager.isCurrentWindow(self):
		if (inputAction == InputType.UP) || (inputAction == InputType.DOWN):
			hoverButton(buttonIndex - inputAction)
		else:
			var newIndex = int(buttonIndex - (sign(inputAction) * lines))
			if (newIndex % lines) != (buttonIndex % lines):
				return
			
			hoverButton(newIndex)


func hoverButton(newIndex : int) -> void:
	if (newIndex < 0) || (newIndex >= widgets.size()):
		return
	
	if widgets[newIndex] is GuiButtonWidget:
		widgets[buttonIndex].hover = false
		buttonIndex = newIndex
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

