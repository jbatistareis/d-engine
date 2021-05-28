extends Spatial

func _ready() -> void:
	Signals.emit_signal("battleScreenSetUp")

