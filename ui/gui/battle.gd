extends Control

const _MOVE_DESC : String = ' %s '

var moveCardPackedScene : PackedScene = preload("res://ui/gui/battle/moveCard.tscn")
var inventoryCardPackedScene : PackedScene = preload("res://ui/gui/battle/inventoryCard.tscn")


func _ready() -> void:
	Signals.connect("battleStarted",Callable(self,"setup"))
	Signals.connect("battleWon",Callable(self,"victory"))
	Signals.connect("battleLost",Callable(self,"hide"))
	Signals.connect("battleShowCharacterMoves",Callable(self,"showCharacterMoves"))
	Signals.connect("battleHideCharacterMoves",Callable(self,"hideCharacterMoves"))


func setup(players : Array, enemies : Array) -> void:
	visible = true
	
	$enemyStats.characters = enemies
	$playerStats.characters = players


# TODO
func victory(players : Array, battleResult : BattleResult) -> void:
	hide()


func hide() -> void:
	visible = false
	
	$enemyStats.clear()
	$playerStats.clear()


func showCharacterMoves(character : Character) -> void:
	$moves/decription/container/lblDescription.text = ''
	$moves.visible = true
	
	for child in $moves/cards/grid.get_children():
		child.queue_free()
	
	await get_tree().create_timer(0.1).timeout
	
	if character.inventory.weapon.move1 != null:
		var card = moveCardPackedScene.instantiate()
		card.character = character
		card.move = character.inventory.weapon.move1
		card.connect("hovered",Callable(self,"showMoveDetails"))
		$moves/cards/grid.add_child(card)
	
	if character.inventory.weapon.move2 != null:
		var card = moveCardPackedScene.instantiate()
		card.character = character
		card.move = character.inventory.weapon.move2
		card.connect("hovered",Callable(self,"showMoveDetails"))
		$moves/cards/grid.add_child(card)
	
	if character.inventory.weapon.move3 != null:
		var card = moveCardPackedScene.instantiate()
		card.character = character
		card.move = character.inventory.weapon.move3
		card.connect("hovered",Callable(self,"showMoveDetails"))
		$moves/cards/grid.add_child(card)
	
	var inventoryCard = inventoryCardPackedScene.instantiate()
	inventoryCard.character = character
	inventoryCard.connect("hovered",Callable(self,"showMoveDetails"))
	$moves/cards/grid.add_child(inventoryCard)
	
	$moves/cards/grid.get_child(0).button.grab_focus()


func hideCharacterMoves() -> void:
	$moves.visible = false


func showMoveDetails(move : Move) -> void:
	$moves/mods/data/self.visible = !move.executorModifiers.is_empty()
	$moves/mods/data/target.visible = !move.targetModifiers.is_empty()
	
	$moves/decription/container/lblDescription.text = _MOVE_DESC % move.description
	
	if $moves/mods/data/self.visible:
		$moves/mods/data/self/fields/lblAtkMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.ATK, move.executorModifiers)
		$moves/mods/data/self/fields/lblDefMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.DEF, move.executorModifiers)
		$moves/mods/data/self/fields/lblCdMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.CD, move.executorModifiers)
	
	if $moves/mods/data/target.visible:
		$moves/mods/data/target/fields/lblAtkMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.ATK, move.targetModifiers)
		$moves/mods/data/target/fields/lblDefMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.DEF, move.targetModifiers)
		$moves/mods/data/target/fields/lblCdMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.CD, move.targetModifiers)

