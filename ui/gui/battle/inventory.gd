extends MarginContainer

var character : Character


func _ready() -> void:
	Signals.connect("battleInventoryShow", self, "showWindow")
	Signals.connect("guiCancel", self, "hide")


func showWindow(character : Character) -> void:
	self.character = character
	visible = true
	
	


func hide() -> void:
	if visible:
		visible = false
		Signals.emit_signal("battleShowCharacterMoves", character)

