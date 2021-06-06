class_name MoveForwardState
extends State


func _init() -> void:
	Signals.connect("playerChangedRoom", self, "move")
	Signals.connect("playerRoomChangeDenied", self, "idle")


func handleInput(event : InputEvent) -> void:
	if GameManager.testing:
		Signals.emit_signal("playerMovedForward")
	else:
		Signals.emit_signal("playerMoved", GameManager.direction)
	
	if event.is_action_released("ui_up"):
		next = GameManager.getState(Enums.States.IDLE)

