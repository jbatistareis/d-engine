class_name RotateRightState
extends State


func handleInput(event : InputEvent) -> void:
	Signals.emit_signal("playerRotatedRight")
	
	if event.is_action_released("ui_right"):
		next = GameManager.getState(Enums.States.IDLE)

