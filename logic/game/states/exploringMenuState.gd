class_name ExploringMenuState
extends State


func _init() -> void:
	Signals.emit_signal("guiOpenExploringMenu")


func handleInput() -> void:
	if Input.is_action_just_pressed("ui_home"):
		Signals.emit_signal("guiCloseExploringMenu")

