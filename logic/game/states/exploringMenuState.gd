class_name ExploringMenuState
extends State


func _init():
	Signals.guiOpenExploringMenu.emit()
	Signals.guiCloseExploringMenu.connect(exit)


func handleInput() -> void:
	if Input.is_action_just_pressed("ui_home"):
		Signals.guiCloseExploringMenu.emit()
	elif Input.is_action_just_pressed("ui_accept"):
		Signals.guiConfirm.emit()
	elif Input.is_action_just_pressed("ui_cancel"):
		Signals.guiCancel.emit()


func exit() -> void:
	next = GameManager.getState(Enums.States.EXPLORING)

