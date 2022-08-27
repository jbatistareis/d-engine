extends Control

const _MOVE_DESC : String = ' %s '

var moveCardPackedScene : PackedScene = preload("res://ui/gui/battle/moveCard.tscn")


func _ready() -> void:
	Signals.connect("battleStarted", self, "setup")
	Signals.connect("battleWon", self, "victory")
	Signals.connect("battleLost", self, "hide")
	Signals.connect("battleShowCharacterMoves", self, "showCharacterMoves")
	Signals.connect("battleHideCharacterMoves", self, "hideCharacterMoves")


func setup(players : Array, enemies : Array) -> void:
	visible = true
	
	$enemyStats.characters = enemies
	$playerStats.characters = players


func victory(players : Array, battleResult : BattleResult) -> void:
	hide()


func hide() -> void:
	visible = false
	
	$enemyStats.clear()
	$playerStats.clear()


func showCharacterMoves(character : Character) -> void:
	$moves.visible = true
	
	for child in $moves/cards/grid.get_children():
		child.queue_free()
	
	yield(get_tree(), "idle_frame")
	
	if character.inventory.weapon.move1 != null:
		var card = moveCardPackedScene.instance()
		card.character = character
		card.move = character.inventory.weapon.move1
		card.connect("hovered", self, "showMoveDetails")
		
		$moves/cards/grid.add_child(card)
	
	if character.inventory.weapon.move2 != null:
		var card = moveCardPackedScene.instance()
		card.character = character
		card.move = character.inventory.weapon.move2
		card.connect("hovered", self, "showMoveDetails")
		
		$moves/cards/grid.add_child(card)
	
	if character.inventory.weapon.move3 != null:
		var card = moveCardPackedScene.instance()
		card.character = character
		card.move = character.inventory.weapon.move3
		card.connect("hovered", self, "showMoveDetails")
		
		$moves/cards/grid.add_child(card)
	
	if character.inventory.weapon.move4 != null:
		var card = moveCardPackedScene.instance()
		card.character = character
		card.move = character.inventory.weapon.move4
		card.connect("hovered", self, "showMoveDetails")
		
		$moves/cards/grid.add_child(card)
	
	$moves/cards/grid.get_child(0).button.grab_focus()


func hideCharacterMoves() -> void:
	$moves.visible = false


func showMoveDetails(move : Move) -> void:
	$moves/mods/data/self.visible = !move.executorModifiers.empty()
	$moves/mods/data/target.visible = !move.targetModifiers.empty()
	
	$moves/decription/container/lblDescription.text = _MOVE_DESC % move.description
	
	if $moves/mods/data/self.visible:
		$moves/mods/data/self/fields/lblAtkMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.ATK, move.executorModifiers)
		$moves/mods/data/self/fields/lblDefMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.DEF, move.executorModifiers)
		$moves/mods/data/self/fields/lblCdMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.CD, move.executorModifiers)
	
	if $moves/mods/data/target.visible:
		$moves/mods/data/target/fields/lblAtkMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.ATK, move.targetModifiers)
		$moves/mods/data/target/fields/lblDefMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.DEF, move.targetModifiers)
		$moves/mods/data/target/fields/lblCdMod.text = Util.countAbsoluteModType(Enums.MoveModifierType.CD, move.targetModifiers)

