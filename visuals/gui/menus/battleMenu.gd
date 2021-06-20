class_name BattleMenu
extends GuiWindowModel


func _init(character : Character) -> void:
	# TODO create real moves
	var attack = Move.new()
	var item = Move.new()
	var defend = Move.new()
	
	attack.name = 'Attack'
	attack.description = 'Use your primary weapon'
	
	item.name = 'Item'
	item.description = 'Use an item from your inventory'
	
	defend.name = 'Defend'
	defend.description =  'Protect yourself from coming attacks'
	
	buttons.append(GuiMoveButtonModel.new(attack))
	
	for move in character.moves:
		buttons.append(GuiMoveButtonModel.new(move))
	
	buttons.append(GuiMoveButtonModel.new(item))
	buttons.append(GuiMoveButtonModel.new(defend))
	
	position = Vector2(
		OverlayManager.windowSize().x * 0.18,
		OverlayManager.windowSize().y * 0.3
	)


func windowConfirmed() -> void:
	print(data)

