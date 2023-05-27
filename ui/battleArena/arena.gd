extends Node


func _ready() -> void:
	Signals.battleStarted.connect(reset)
	Signals.battleWon.connect(win)
	Signals.battleLost.connect(lose)
	Signals.battleEnded.connect(exit)


func reset(_ignore1, _ignore2) -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET", 0)


func win(_ignore1, _ignore2) -> void:
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("win")


func lose() -> void:
	$AnimationPlayer.play("lose")


func exit() -> void:
	$AnimationPlayer.play("exit")

