class_name GuiWindowModel
extends PanelContainer

enum InputType {UP = 1, DOWN = -1}

var title : String = ''
var identifier : String = ''
var buttons : Array = []
var buttonIndex : int = 0
var data = null


func _init() -> void:
	Signals.connect("guiConfirm", self, "confirm")
	Signals.connect("guiUp", self, "action", [InputType.UP])
	Signals.connect("guiDown", self, "action", [InputType.DOWN])
	Signals.connect("guiSelect", self, "select")


func _ready() -> void:
	for button in buttons:
		pass


func action(inputAction : int) -> void:
	if isCurrentWindow():
		var newIndex = (buttonIndex + inputAction) % buttons.size()
		
		buttons[buttonIndex].hover = false
		buttonIndex = newIndex if (newIndex >= 0) else (buttons.size() - 1)
		buttons[buttonIndex].hover = true


func select() -> void:
	if isCurrentWindow():
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


# override
func windowConfirmed() -> void:
	pass

