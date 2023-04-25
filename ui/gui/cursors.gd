extends Container

var cursorPackedScene : PackedScene = preload("res://ui/gui/battle/moveCursor.tscn")
var character : Character


func _ready() -> void:
	Signals.battleSetCursorPosition.connect(setCursorPosition)
	Signals.battleCursorShow.connect(showCursors)
	Signals.guiCancel.connect(hideCursors)


func setCursorPosition(target : Character, pos : Vector2) -> void:
	var cursor = cursorPackedScene.instantiate()
	cursor.target = target
	
	add_child(cursor)
	cursor.position = pos
	
	cursor.confirmed.connect(func(): visible = false)


func showCursors(player : Character, move : Move) -> void:
	self.character = player
	
	# TODO adapt for ANY_ALL
	if (move.targetType == Enums.MoveTargetType.FRIENDLY) || (move.targetType == Enums.MoveTargetType.FRIENDLY_ALL):
		Signals.commandPublished.emit(createCommand(player, GameManager.party, move))
		return
	
	elif move.targetType == Enums.MoveTargetType.FOE_ALL:
		var targets = []
		for cursor in get_children():
			if cursor.target.currentHp > 0:
				targets.append(cursor.target)
		
		Signals.commandPublished.emit(createCommand(player, targets, move))
		return
	
	visible = true
	
	for cursor in get_children():
		cursor.executor = player
		cursor.move = move
	
	if get_child_count() == 3:
		get_child(1).get_child(1).grab_focus()
	else:
		get_child(0).get_child(1).grab_focus()


func hideCursors() -> void:
	if visible:
		visible = false
		Signals.battleAskedMove.emit(character)


func createCommand(player, targets, move) -> Command:
	match move.type:
		Enums.MoveType.ITEM:
			return UseItemCommand.new(player, targets, move)
		
		Enums.MoveType.SKILL:
			return ExecuteMoveCommand.new(player, targets, move)
		
		_:
			return null

