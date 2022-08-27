extends MarginContainer

var enemyFrameSize : Vector2


func _ready() -> void:
	Signals.connect("battleCursorMove", self, "moveCursor")
	Signals.connect("battleCursorHide", self, "hideCursor")


func moveCursor(title : String, position : Vector2) -> void:
	visible = true
	$lblTgt.text = title
	
	rect_position = position


func hideCursor() -> void:
	visible = false

