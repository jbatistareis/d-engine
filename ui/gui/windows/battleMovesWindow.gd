class_name BattleMovesWindow
extends GuiWindow

var character


func _init(character) -> void:
	self.character = character
	
	if character.inventory.weapon.move1 != null:
		widgets.append(GuiMoveButtonWidget.new(character.inventory.weapon.move1))
	
	if character.inventory.weapon.move2 != null:
		widgets.append(GuiMoveButtonWidget.new(character.inventory.weapon.move2))
	
	if character.inventory.weapon.move3 != null:
		widgets.append(GuiMoveButtonWidget.new(character.inventory.weapon.move3))
	
	if character.inventory.weapon.move4 != null:
		widgets.append(GuiMoveButtonWidget.new(character.inventory.weapon.move4))
	
	position = Vector2(
		560,
		GuiOverlayManager.windowSize().y - 157
	)
	
	lines = 3


# data == chosen move
func windowConfirmed() -> void:
	Signals.emit_signal("battleCursorOpen", character, data)

