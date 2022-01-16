extends Spatial


func _ready() -> void:
	Signals.connect("battleWon", self, "win")
	Signals.connect("battleLost", self, "lose")
	Signals.connect("battleEnded", self, "exit")
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")


func reset() -> void:
	$AnimationPlayer.play("RESET")


func win(ignore1, ignore2) -> void:
	$AnimationPlayer.play("win")


func lose() -> void:
	$AnimationPlayer.play("lose")


func exit() -> void:
	$AnimationPlayer.play("exit")


func pause() -> void:
	$Tween.remove_all()
	$Tween.interpolate_method(self, "enemyPlaybackSpeed", 1, 0, 0.3)
	$Tween.start()


func resume() -> void:
	$Tween.remove_all()
	$Tween.interpolate_method(self, "enemyPlaybackSpeed", 0, 1, 0.3)
	$Tween.start()


func enemyPlaybackSpeed(value : float) -> void:
	for enemyPos in $enemies.get_children():
		if enemyPos.get_child_count() > 0:
			enemyPos.get_child(0).get_node("AnimationPlayer").playback_speed = value
