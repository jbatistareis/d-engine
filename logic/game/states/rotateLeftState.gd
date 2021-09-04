class_name RotateLeftState
extends State


func handleInput() -> void:
	if (!GameManager.cameraMoving):
		Signals.emit_signal("playerRotatedLeft")
		
	if Input.is_action_just_released("ui_left"):
		next = GameManager.getState(Enums.States.IDLE)

