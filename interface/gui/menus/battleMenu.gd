class_name BattleMenu
extends GuiWindow

var character : Character


func _init(character : Character) -> void:
	self.character = character
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
	
	widgets.append(GuiMoveButtonWidget.new(attack))
	
	for move in character.moves:
		widgets.append(GuiMoveButtonWidget.new(move))
	
	widgets.append(GuiMoveButtonWidget.new(item))
	widgets.append(GuiMoveButtonWidget.new(defend))
	
	position = Vector2(
		OverlayManager.windowSize().x * 0.18,
		OverlayManager.windowSize().y * 0.3
	)


func windowConfirmed() -> void:
#	CommandManager.publishCommand()
	# TODO ask which target
	pass

