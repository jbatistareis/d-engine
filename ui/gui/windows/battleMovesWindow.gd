class_name BattleMovesWindow
extends GuiWindow

var character


func _init(character) -> void:
	self.character = character
	
	for move in character.moves:
		widgets.append(GuiMoveButtonWidget.new(move))
	
	position = Vector2(
		560,
		GuiOverlayManager.windowSize().y - 157
	)
	
	lines = 3


# data == chosen move
func windowConfirmed() -> void:
	Signals.emit_signal("battleCursorOpen", character, data)

