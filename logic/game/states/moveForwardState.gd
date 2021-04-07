class_name MoveForwardState
extends State


func _init() -> void:
	Signals.connect("playerChangedRoom", self, "move")
	Signals.connect("playerRoomChangeDenied", self, "idle")


func handleInput(event : InputEvent) -> void:
	if GameManager.isCameraIdle:
		if GameManager.testing:
			move(0)
		else:
			Signals.emit_signal("playerMoved", GameManager.direction)
	
	if event.is_action_released("ui_up"):
		idle()


func move(ignore) -> void:
	Signals.emit_signal("playerMovedForward")


func idle() -> void:
	next = GameManager.getState(Enums.States.IDLE)

