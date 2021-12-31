class_name BattleMenu
extends GuiWindow

var character : Character
var item = Move.new()
var defend = Move.new()


func _init(character : Character) -> void:
	self.character = character
	
	item.name = 'Item'
	item.description = 'Use an item from your inventory'
	
	defend.name = 'Defend'
	defend.description =  'Protect yourself from coming attacks'
	
	for move in character.moves:
		widgets.append(GuiMoveButtonWidget.new(move))
	
	var itemButton = GuiMoveButtonWidget.new(item)
	itemButton.closeOnConfirm = false
	
	widgets.append(itemButton)
	widgets.append(GuiMoveButtonWidget.new(defend))
	
	position = Vector2(
		GuiOverlayManager.windowSize().x * 0.18,
		GuiOverlayManager.windowSize().y * 0.3
	)


# data == chosen move
func windowConfirmed() -> void:
	match data:
		item:
			Signals.emit_signal("guiOpenWindow", ItemsWindow.new(character))
		
		defend:
			pass #TODO
		
		_: # normal move
			Signals.emit_signal("battleCursorOpen", character, data)

