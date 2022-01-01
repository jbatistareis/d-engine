class_name BattleMenu
extends GuiWindow

var character : Character
var item = Move.new()


func _init(character : Character) -> void:
	self.character = character
	
	item.name = 'Item'
	item.description = 'Use an item from your inventory'
	
	# TODO remove
	var moveBtn = GuiMoveButtonWidget.new(Move.new())
	widgets.append(moveBtn)
	
	for move in character.moves:
		var btn = GuiMoveButtonWidget.new(move)
		widgets.append(btn)
	
	var itemButton = GuiMoveButtonWidget.new(item)
	itemButton.closeOnConfirm = false
	
	position = Vector2(
		GuiOverlayManager.windowSize().x * 0.18,
		GuiOverlayManager.windowSize().y * 0.3
	)


# data == chosen move
func windowConfirmed() -> void:
	if data == item:
		Signals.emit_signal("guiOpenWindow", ItemsWindow.new(character))
	else:
		Signals.emit_signal("battleCursorOpen", character, data)

