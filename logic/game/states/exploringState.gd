class_name ExploringState
extends State


func handleInput() -> void:
	if GameManager.canMove():
		if !GameManager.testing:
			if Input.is_action_pressed("ui_up"):
				LocationManager.moveCharacter(GameManager.player, GameManager.direction)
			
			elif Input.is_action_pressed("ui_down"):
				LocationManager.moveCharacter(GameManager.player, (GameManager.direction + 2) % 4)
			
			elif Input.is_action_pressed("ui_left"):
				Signals.emit_signal("cameraRotatedLeft")
				GameManager.direction -= 1
			
			elif Input.is_action_pressed("ui_right"):
				Signals.emit_signal("cameraRotatedRight")
				GameManager.direction += 1
			
			elif Input.is_action_just_pressed("ui_home"):
				next = GameManager.getState(Enums.States.EXPLORING_MENU)
		else:
			if Input.is_action_pressed("ui_up"):
				Signals.emit_signal("cameraMovedForward")
			elif Input.is_action_pressed("ui_down"):
				Signals.emit_signal("cameraMovedBackward")
			elif Input.is_action_pressed("ui_left"):
				Signals.emit_signal("cameraRotatedLeft")
			elif Input.is_action_pressed("ui_right"):
				Signals.emit_signal("cameraRotatedRight")

