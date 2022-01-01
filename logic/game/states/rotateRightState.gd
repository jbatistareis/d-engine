class_name RotateRightState
extends State


func handleInput() -> void:
	if GameManager.canMove():
		Signals.emit_signal("playerRotatedRight")
		
	next = GameManager.getState(Enums.States.IDLE)

