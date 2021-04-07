class_name RotateLeftState
extends State


func handleInput(event : InputEvent) -> void:
	if GameManager.isCameraIdle:
		GameManager.direction -= 1
		Signals.emit_signal("playerRotatedLeft")
	
	if event.is_action_released("ui_left"):
		next = GameManager.getState(Enums.States.IDLE)

