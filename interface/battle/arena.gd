extends Spatial


func _ready() -> void:
	Signals.connect("battleEnded", self, "exit")


func exit() -> void:
	$AnimationPlayer.play("exit")

