extends MarginContainer

var enemyFrameSize : Vector2


func _ready() -> void:
	Signals.connect("battleCursorMove",Callable(self,"moveCursor"))
	Signals.connect("battleCursorHide",Callable(self,"hideCursor"))


func moveCursor(title : String, position : Vector2) -> void:
	visible = true
	$lblTgt.text = title
	
	position = position


func hideCursor() -> void:
	visible = false

