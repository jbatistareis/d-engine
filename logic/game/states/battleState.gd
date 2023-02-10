class_name BattleState
extends State


func _init():
	Signals.connect("battleEnded",Callable(self,"exitState"))


func handleInput() -> void:
	if Input.is_action_just_pressed("ui_left"):
		Signals.emit_signal("guiLeft")
	elif Input.is_action_just_pressed("ui_right"):
		Signals.emit_signal("guiRight")
	elif Input.is_action_just_pressed("ui_accept"):
		Signals.emit_signal("guiConfirm")
	elif Input.is_action_just_pressed("ui_cancel"):
		Signals.emit_signal("guiCancel")


func exitState() -> void:
	next = GameManager.getState(Enums.States.EXPLORING)

