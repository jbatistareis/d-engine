extends Control

const _MOVE_DESC : String = '%s'
const _MODS : String = "[SLF] AT:%2d, DF:%2d, CD:%2d | [TGT] AT:%2d, DF:%2d, CD:%2d"

var moveCardPackedScene : PackedScene = preload("res://ui/gui/battle/moveCard.tscn")
var inventoryCardPackedScene : PackedScene = preload("res://ui/gui/battle/inventoryCard.tscn")


func _ready() -> void:
	Signals.battleStarted.connect(setup)
	Signals.battleWon.connect(victory)
	Signals.battleLost.connect(hideBattle)
	Signals.battleShowCharacterMoves.connect(showCharacterMoves)
	Signals.battleHideCharacterMoves.connect(hideCharacterMoves)


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
	$moves/decription/container/vBox/lblDescription.text = ''
	$moves.visible = true
	
	for child in $moves/cards/grid.get_children():
		child.queue_free()
	
#	await get_tree().create_timer(0.1).timeout
	
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


func hideCharacterMoves() -> void:
	$moves.visible = false


func showMoveDetails(move : Move) -> void:
	$moves/decription/container/vBox/lblDescription.text = _MOVE_DESC % move.description
	$moves/decription/container/vBox/lblMods.text = _MODS % [
		move.executorAtkModifier,
		move.executorDefModifier,
		move.executorCdModifier,
		move.targetAtkModifier,
		move.targetDefModifier,
		move.targetCdModifier]

