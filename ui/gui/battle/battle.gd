extends Control

const _MOVE_DESC : String = '%s\n[SLF] AT:%2d, DF:%2d, CD:%2d | [TGT] AT:%2d, DF:%2d, CD:%2d'

var moveCardPackedScene : PackedScene = preload("res://ui/gui/battle/moveCard.tscn")
var inventoryCardPackedScene : PackedScene = preload("res://ui/gui/battle/inventoryCard.tscn")


func _ready() -> void:
	Signals.battleStarted.connect(setup)
	Signals.battleWon.connect(victory)
	Signals.battleLost.connect(hideBattle)
	Signals.battleAskedMove.connect(showCharacterMoves)
	Signals.battlePickedMove.connect(hideCharacterMoves)


func setup(players : Array, enemies : Array) -> void:
	visible = true
	
	$enemyStats.characters = enemies
	$playerStats.characters = players


# TODO
func victory(_players : Array, _battleResult : BattleResult) -> void:
	hide()


func hideBattle() -> void:
	visible = false
	
	$enemyStats.clear()
	$playerStats.clear()


func showCharacterMoves(character : Character) -> void:
	$moves.visible = true
	
	for child in $moves/cards/grid.get_children():
		child.queue_free()
	
	for move in [character.inventory.weapon.move1, character.inventory.weapon.move2, character.inventory.weapon.move3]:
		if move != null:
			var card = moveCardPackedScene.instantiate()
			card.character = character
			card.move = move
			card.hovered.connect(showMoveDetails)
			$moves/cards/grid.add_child(card)
	
	var inventoryCard = inventoryCardPackedScene.instantiate()
	inventoryCard.character = character
	inventoryCard.hovered.connect(showMoveDetails)
	$moves/cards/grid.add_child(inventoryCard)
	
	$moves/cards/grid.get_child(0).button.grab_focus()


func hideCharacterMoves(character : Character, move : Move) -> void:
	$moves.visible = false


func showMoveDetails(move : Move) -> void:
	var text = _MOVE_DESC % [
		move.description,
		move.executorAtkModifier,
		move.executorDefModifier,
		move.executorCdModifier,
		move.targetAtkModifier,
		move.targetDefModifier,
		move.targetCdModifier
	]
	
	Signals.battleMoveDescription.emit(text)

