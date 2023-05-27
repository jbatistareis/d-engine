class_name ExploringState
extends State


func handleInput() -> void:
	if GameManager.canMove():
		if !GameManager.testing:
			if Input.is_action_pressed("ui_left"):
				GameManager.direction -= 1
				Signals.cameraRotatedLeft.emit()
			
			elif Input.is_action_pressed("ui_right"):
				GameManager.direction += 1
				Signals.cameraRotatedRight.emit()
			
			elif Input.is_action_pressed("ui_up"):
				LocationManager.moveCharacter(GameManager.player, GameManager.direction)
			
			elif Input.is_action_pressed("ui_down"):
				LocationManager.moveCharacter(GameManager.player, (GameManager.direction + 2) % 4)
			
			elif Input.is_action_just_pressed("ui_accept"):
				Signals.playerInteracted.emit(GameManager.direction)
			
			elif Input.is_action_just_pressed("ui_home"):
				next = GameManager.getState(Enums.States.EXPLORING_MENU)
			
		else:
			if Input.is_action_pressed("ui_up"):
				Signals.cameraMovedForward.emit()
			elif Input.is_action_pressed("ui_down"):
				Signals.cameraMovedBackward.emit()
			elif Input.is_action_pressed("ui_left"):
				GameManager.direction -= 1
				Signals.cameraRotatedLeft.emit()
			elif Input.is_action_pressed("ui_right"):
				GameManager.direction += 1
				Signals.cameraRotatedRight.emit()

