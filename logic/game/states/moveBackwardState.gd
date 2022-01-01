class_name MoveBackwardState
extends State


func _init() -> void:
	Signals.connect("playerChangedRoom", self, "move")
	Signals.connect("playerRoomChangeDenied", self, "idle")


func handleInput() -> void:
	if GameManager.canMove():
		var direction = (GameManager.direction + 2) % 4
		
		if GameManager.testing:
			move(direction)
		else:
			Signals.emit_signal("playerMoved", direction)
		
	idle()


func move(direction : int) -> void:
	Signals.emit_signal("playerMovedBackward")


func idle() -> void:
	next = GameManager.getState(Enums.States.IDLE)

