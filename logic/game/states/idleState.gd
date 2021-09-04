class_name IdleState
extends State


func handleInput() -> void:
	if Input.is_action_just_pressed("ui_up"):
		next = GameManager.getState(Enums.States.MOVE_FORWARD)
	elif Input.is_action_just_pressed("ui_down"):
		next = GameManager.getState(Enums.States.MOVE_BACKWARD)
	elif Input.is_action_just_pressed("ui_left"):
		next = GameManager.getState(Enums.States.ROTATE_LEFT)
	elif Input.is_action_just_pressed("ui_right"):
		next = GameManager.getState(Enums.States.ROTATE_RIGHT)
	elif Input.is_action_just_pressed("ui_home"):
		next = GameManager.getState(Enums.States.GAME_MENU)

