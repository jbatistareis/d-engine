extends Node3D


func _ready() -> void:
	Signals.connect("battleStarted",Callable(self,"reset"))
	Signals.connect("battleWon",Callable(self,"win"))
	Signals.connect("battleLost",Callable(self,"lose"))
	Signals.connect("battleEnded",Callable(self,"exit"))
	Signals.connect("commandsPaused",Callable(self,"pause"))
	Signals.connect("commandsResumed",Callable(self,"resume"))


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
	$Tween.remove_all()
	$Tween.interpolate_method(self, "enemyPlaybackSpeed", 1, 0, 0.25)
	$Tween.start()


func resume() -> void:
	$Tween.remove_all()
	$Tween.interpolate_method(self, "enemyPlaybackSpeed", 0, 1, 0.25)
	$Tween.start()


func enemyPlaybackSpeed(value : float) -> void:
	for enemyPos in $enemies.get_children():
		if enemyPos.get_child_count() > 0:
			enemyPos.get_child(0).get_node("AnimationPlayer").playback_speed = value
