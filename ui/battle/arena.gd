extends Spatial


func _ready() -> void:
	Signals.connect("battleEnded", self, "exit")
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")


func exit() -> void:
	$AnimationPlayer.play("exit")


func pause() -> void:
	for enemyPos in $enemies.get_children():
		if enemyPos.get_child_count() > 0:
			enemyPos.get_child(0).get_node("AnimationPlayer").playback_speed = 0


func resume() -> void:
	for enemyPos in $enemies.get_children():
		if enemyPos.get_child_count() > 0:
			enemyPos.get_child(0).get_node("AnimationPlayer").playback_speed = 1
