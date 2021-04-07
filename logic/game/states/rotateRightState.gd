class_name RotateRightState
extends State


func handleInput(event : InputEvent) -> void:
	if GameManager.isCameraIdle:
		GameManager.direction += 1
		Signals.emit_signal("playerRotatedRight")
	
	if event.is_action_released("ui_right"):
		next = GameManager.getState(Enums.States.IDLE)

