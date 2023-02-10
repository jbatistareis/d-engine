extends Node3D

var tween : Tween


func _ready() -> void:
	Signals.battleStarted.connect(reset)
	Signals.battleWon.connect(win)
	Signals.battleLost.connect(lose)
	Signals.battleEnded.connect(exit)
	Signals.commandsPaused.connect(pause)
	Signals.commandsResumed.connect(resume)
	
	tween = get_tree().create_tween()


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


func pause() -> void:
	tween.remove_all()
	tween.tween_method(enemyPlaybackSpeed, 1, 0, 0.25)
	tween.play()


func resume() -> void:
	tween.remove_all()
	tween.tween_method(enemyPlaybackSpeed, 0, 1, 0.25)
	tween.play()


func enemyPlaybackSpeed(value : float) -> void:
	for enemyPos in $enemies.get_children():
		if enemyPos.get_child_count() > 0:
			enemyPos.get_child(0).get_node("AnimationPlayer").playback_speed = value
