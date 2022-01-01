class_name RotateLeftState
extends State


func handleInput() -> void:
	if GameManager.canMove():
		Signals.emit_signal("playerRotatedLeft")
		
	next = GameManager.getState(Enums.States.IDLE)

