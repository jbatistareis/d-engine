class_name MoveBackwardState
extends State


func _init() -> void:
	Signals.connect("playerChangedRoom", self, "move")
	Signals.connect("playerRoomChangeDenied", self, "idle")


func handleInput(event : InputEvent) -> void:
	if GameManager.isCameraIdle:
		if GameManager.testing:
			move(0)
		else:
			Signals.emit_signal("playerMoved", (GameManager.direction + 2) % 4)
	
	if event.is_action_released("ui_down"):
		idle()


func move(ignore) -> void:
	Signals.emit_signal("playerMovedBackward")


func idle() -> void:
	next = GameManager.getState(Enums.States.IDLE)

