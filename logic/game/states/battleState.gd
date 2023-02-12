class_name BattleState
extends State


func _init():
	Signals.battleEnded.connect(exitState)


func handleInput() -> void:
	if Input.is_action_just_pressed("ui_left"):
		Signals.guiLeft.emit()
	elif Input.is_action_just_pressed("ui_right"):
		Signals.guiRight.emit()
	elif Input.is_action_just_pressed("ui_accept"):
		Signals.guiConfirm.emit()
	elif Input.is_action_just_pressed("ui_cancel"):
		Signals.guiCancel.emit()


func exitState() -> void:
	next = GameManager.getState(Enums.States.EXPLORING)

