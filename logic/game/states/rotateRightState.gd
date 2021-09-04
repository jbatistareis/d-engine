class_name RotateRightState
extends State


func handleInput() -> void:
	if (!GameManager.cameraMoving):
		Signals.emit_signal("playerRotatedRight")
		
	if Input.is_action_just_released("ui_right"):
		next = GameManager.getState(Enums.States.IDLE)

