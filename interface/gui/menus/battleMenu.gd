class_name BattleMenu
extends GuiWindow

var character : Character


func _init(character : Character) -> void:
	self.character = character
	# TODO create real moves
	var item = Move.new()
	var defend = Move.new()
	
	item.name = 'Item'
	item.description = 'Use an item from your inventory'
	
	defend.name = 'Defend'
	defend.description =  'Protect yourself from coming attacks'
	
	for move in character.moves:
		widgets.append(GuiMoveButtonWidget.new(move))
	
	widgets.append(GuiMoveButtonWidget.new(item))
	widgets.append(GuiMoveButtonWidget.new(defend))
	
	position = Vector2(
		GuiOverlayManager.windowSize().x * 0.18,
		GuiOverlayManager.windowSize().y * 0.3
	)


func windowConfirmed() -> void:
#	playerConfirmedBattleInput
	# TODO ask which target
	pass

