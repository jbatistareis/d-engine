class_name MoveForwardState
extends State


func _init() -> void:
	Signals.connect("playerChangedRoom", self, "move")
	Signals.connect("playerRoomChangeDenied", self, "idle")


func handleInput() -> void:
	if GameManager.canMove():
		if GameManager.testing:
			move(GameManager.direction)
		else:
			Signals.emit_signal("playerMoved", GameManager.direction)
		
	idle()


func move(direction : int) -> void:
	Signals.emit_signal("playerMovedForward")


func idle() -> void:
	next = GameManager.getState(Enums.States.IDLE)

