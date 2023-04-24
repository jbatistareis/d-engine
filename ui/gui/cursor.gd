extends Container


func _ready() -> void:
	Signals.battleSetCursorPosition.connect(setCursorPosition)


func setCursorPosition(pos : Vector2) -> void:
	pass

