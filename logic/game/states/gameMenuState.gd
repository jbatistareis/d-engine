class_name GameMenuState
extends State


func _init() -> void:
	Signals.emit_signal("guiOpenWindow", StatusWindow.new())
	Signals.emit_signal("guiOpenWindow", GameMenu.new())


func handleInput(event : InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		Signals.emit_signal("guiUp")
	elif event.is_action_pressed("ui_down"):
		Signals.emit_signal("guiDown")
	elif event.is_action_pressed("ui_left"):
		Signals.emit_signal("guiLeft")
	elif event.is_action_pressed("ui_right"):
		Signals.emit_signal("guiRight")
	elif event.is_action_pressed("ui_accept"):
		Signals.emit_signal("guiSelect")
	elif event.is_action_pressed("ui_cancel"):
		Signals.emit_signal("guiCancel")
	elif event.is_action_pressed("ui_home"):
		Signals.emit_signal("guiCloseWindow")
	
	if OverlayManager.windowQueue.empty():
		next = GameManager.getState(Enums.States.IDLE)

