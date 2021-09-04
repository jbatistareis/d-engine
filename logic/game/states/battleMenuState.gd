class_name BattleMenuState
extends State


func _init() -> void:
	Signals.connect("battleEnded", self, "exitState")


func handleInput() -> void:
	if Input.is_action_just_pressed("ui_up"):
		Signals.emit_signal("guiUp")
	elif Input.is_action_just_pressed("ui_down"):
		Signals.emit_signal("guiDown")
	elif Input.is_action_just_pressed("ui_left"):
		Signals.emit_signal("guiLeft")
	elif Input.is_action_just_pressed("ui_right"):
		Signals.emit_signal("guiRight")
	elif Input.is_action_just_pressed("ui_accept"):
		Signals.emit_signal("guiSelect")
	elif Input.is_action_just_pressed("ui_cancel"):
		Signals.emit_signal("guiCancel")


func exitState() -> void:
	next = GameManager.getState(Enums.States.IDLE)

