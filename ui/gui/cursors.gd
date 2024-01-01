extends Container

var cursorPackedScene : PackedScene = preload("res://ui/gui/battle/moveCursor.tscn")
var player : Character
var move : Move


func _ready() -> void:
	Signals.setupBattleScreen.connect(clearCursors)
	Signals.battleSetCursorPosition.connect(setCursorPosition)
	Signals.battleCursorShow.connect(showCursors)
	Signals.guiCancel.connect(hideCursors)


func setCursorPosition(target : Character, pos : Vector2) -> void:
	for cursor in $foes.get_children():
		if cursor.target == target:
			cursor.position = pos
			return
	
	var cursor = cursorPackedScene.instantiate()
	cursor.target = target
	$foes.add_child(cursor)
	
	await get_tree().process_frame
	cursor.position = pos
	
	cursor.confirmed.connect(func(): $foes.visible = false)


func showCursors(player : Character, move : Move) -> void:
	self.player = player
	self.move = move
	
	# TODO adapt for ANY_ALL
	if move.targetType == Enums.MoveTargetType.FRIENDLY:
		$party.clear()
		for friend in GameManager.party:
			$party.add_item(friend.name)
		
		$party.popup_centered()
		$party.set_focused_item(0)
		$party.grab_focus()
		return
	
	elif move.targetType == Enums.MoveTargetType.FRIENDLY_ALL:
		$allParty.popup_centered()
		$allParty.set_focused_item(0)
		$allParty.grab_focus()
		return
	
	elif move.targetType == Enums.MoveTargetType.FOE_ALL:
		$allEnemies.popup_centered()
		$allEnemies.set_focused_item(0)
		$allEnemies.grab_focus()
		return
	
	$foes.visible = true
	
	for cursor in $foes.get_children():
		cursor.executor = player
		cursor.move = move
	
	if $foes.get_child_count() == 3:
		$foes.get_child(1).focus()
	else:
		$foes.get_child(0).focus()


func hideCursors() -> void:
	if $foes.visible and (!$allEnemies.visible and !$party.visible):
		$foes.visible = false
		
		Signals.battleAskedMove.emit(player)


func clearCursors(playerData : Array[Character] = [], enemyData : Array[Character] = []) -> void:
	for cursor in $foes.get_children():
		cursor.queue_free()


func createCommand(player : Character, targets : Array[Character], move : Move) -> Command:
	match move.type:
		Enums.MoveType.ITEM:
			return UseItemCommand.new(player, targets, move)
		
		Enums.MoveType.SKILL:
			return ExecuteMoveCommand.new(player, targets, move)
		
		_:
			return null


func _on_all_enemies_index_pressed(index: int) -> void:
	var targets = []
	for cursor in get_children():
		if cursor.target.currentHp > 0:
			targets.append(cursor.target)
	
	Signals.commandPublished.emit(createCommand(player, targets, move))
	Signals.commandsResumed.emit()


func _on_party_id_pressed(id: int) -> void:
	Signals.commandPublished.emit(createCommand(player, [GameManager.party[id]], move))
	Signals.commandsResumed.emit()


func _on_all_party_id_pressed(id: int) -> void:
	Signals.commandPublished.emit(createCommand(player, GameManager.party, move))
	Signals.commandsResumed.emit()


func _on_menu_popup_hide() -> void:
	Signals.battleAskedMove.emit(player)

