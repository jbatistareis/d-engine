class_name IdleState
extends State


func handleInput(event : InputEvent) -> void:
	if BattleManager.inBattle:
		pass
	else:
		if event.is_action_pressed("ui_up"):
			next = GameManager.getState(Enums.States.MOVE_FORWARD)
		elif event.is_action_pressed("ui_down"):
			next = GameManager.getState(Enums.States.MOVE_BACKWARD)
		elif event.is_action_pressed("ui_left"):
			next = GameManager.getState(Enums.States.ROTATE_LEFT)
		elif event.is_action_pressed("ui_right"):
			next = GameManager.getState(Enums.States.ROTATE_RIGHT)

