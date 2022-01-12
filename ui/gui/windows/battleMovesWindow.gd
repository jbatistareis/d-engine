class_name BattleMovesWindow
extends GuiWindow

var character
var item = Move.new()


func _init(character) -> void:
	Signals.emit_signal("commandsPaused")
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
		560,
		GuiOverlayManager.windowSize().y - 157
	)
	
	lines = 3


# data == chosen move
func windowConfirmed() -> void:
	if data == item:
		Signals.emit_signal("guiOpenWindow", ItemsWindow.new(character))
	else:
		Signals.emit_signal("battleCursorOpen", character, data)

