class_name MoveBackwardState
extends State


func _init() -> void:
	Signals.connect("playerChangedRoom", self, "move")
	Signals.connect("playerRoomChangeDenied", self, "idle")


func handleInput(event : InputEvent) -> void:
	if GameManager.testing:
		Signals.emit_signal("playerMovedBackward")
	else:
		Signals.emit_signal("playerMoved", (GameManager.direction + 2) % 4)
	
	if event.is_action_released("ui_down"):
		next = GameManager.getState(Enums.States.IDLE)

