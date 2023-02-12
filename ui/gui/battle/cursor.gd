extends MarginContainer

var enemyFrameSize : Vector2


func _ready() -> void:
	Signals.battleCursorMove.connect(moveCursor)
	Signals.battleCursorHide.connect(hideCursor)


func moveCursor(title : String, position : Vector2) -> void:
	visible = true
	$lblTgt.text = title
	
	position = position


func hideCursor() -> void:
	visible = false

