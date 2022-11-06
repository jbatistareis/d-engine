extends Spatial

const _ENEMY_FRAME_RATIO : float = 1.875
const _ENEMY_MAP : Array = [1, 2, 0]
const _PREFIXES : Array = ["[A] ", "[B] ", "[C] "]

var enemyFrameSize : Vector2
onready var enemiesNode : Node = $ViewportContainer/Viewport/arena/enemies
onready var battleCamera : Camera = $ViewportContainer/Viewport/arena/pivot/Camera

var cursorOn : bool = false
var cursorPos : int = 0
var cursorPlayer : Character
var cursorMove : Move


func _ready() -> void:
	Signals.connect("setupBattleScreen", self, "setup")
	Signals.connect("battleCursorShow", self, "showCursor")
	Signals.connect("guiLeft", self, "moveCursor", [Enums.Direction.EAST])
	Signals.connect("guiRight", self, "moveCursor", [Enums.Direction.WEST])
	Signals.connect("guiConfirm", self, "confirmCursor")
	Signals.connect("guiCancel", self, "cancelCursor")
	Signals.connect("battleEnded", self, "finish")
	Signals.connect("battleWon", self, "showBattleResult")
	
	get_viewport().connect("size_changed", self, "updateSize")
	updateSize()


func updateSize() -> void:
	$ViewportContainer/Viewport.size = GuiOverlayManager.currentSize


func setup(playerData : Array, enemyData : Array) -> void:
	if playerData.empty() || enemyData.empty():
		push_error(ErrorMessages.BATTLE_CANT_START % [str(playerData), str(enemyData)])
		return
	
	for node in enemiesNode.get_children():
		for enemy in node.get_children():
			enemy.queue_free()
	
	var i = 0
	for enemy in enemyData:
		enemy.shortName = _PREFIXES[i] + enemy.shortName
		enemy.name = _PREFIXES[i] + enemy.name
		i += 1
	
	$AnimationPlayer.play("start")
	
	var width = GuiOverlayManager.currentSize.x / 5
	var heigth = width * _ENEMY_FRAME_RATIO
	enemyFrameSize = Vector2(width, heigth)
	
	for index in range(5):
		if enemyData[index] != null:
			var scene = SceneLoadManager.scenes[enemyData[index].shortName.substr(4)].instance()
			scene.character = enemyData[index]
			enemiesNode.get_child(_ENEMY_MAP[index]).add_child(scene)
		
		index += 1
		if index > enemyData.size() - 1:
			break
	
	yield(get_tree().create_timer(0.1), "timeout")
	Signals.emit_signal("battleScreenReady")


func createCursor() -> void:
	var enemyNode = enemiesNode.get_child(_ENEMY_MAP[cursorPos])

	Signals.emit_signal(
		"battleCursorMove",
		enemyNode.get_child(0).character.name,
		battleCamera.unproject_position(enemyNode.global_transform.origin) - (enemyFrameSize / 9.0)
	)
	
	yield(get_tree().create_timer(0.1), "timeout")
	cursorOn = true


# TODO pick from the players group
func showCursor(player : Character, move : Move) -> void:
	if !cursorOn:
		# TODO adapt for ANY_ALL
		if (move.targetType == Enums.MoveTargetType.FRIENDLY) || (move.targetType == Enums.MoveTargetType.FRIENDLY_ALL):
			publishCommand(player, [player], move)
			return
		elif move.targetType == Enums.MoveTargetType.FOE_ALL:
			var targets = []
			for index in range(3):
				var character = enemiesNode.get_child(_ENEMY_MAP[index]).get_child(0).character
				
				if character.currentHp > 0:
					targets.append(character)
			
			publishCommand(player, targets, move)
			return
		
		# TODO error out if no one is alive
		if enemiesNode.get_child(_ENEMY_MAP[cursorPos]).get_child(0).character.currentHp <= 0:
			for index in range(3):
				if enemiesNode.get_child(_ENEMY_MAP[index]).get_child(0).character.currentHp > 0:
					cursorPos = index
					break
				elif enemiesNode.get_child(_ENEMY_MAP[index]).get_child_count() == 0:
					return
		
		cursorPlayer = player
		cursorMove = move
		
		createCursor()


# TODO fix this repetition
# TODO error out if no one is alive
func moveCursor(direction : int) -> void:
	if cursorOn:
		var newPos = cursorPos
		
		if direction == Enums.Direction.EAST: # left
			newPos = (newPos - 1) if newPos > 0 else 2
		elif direction == Enums.Direction.WEST: # right
			newPos = (newPos + 1) if newPos < 2 else 0
		
		while (enemiesNode.get_child(_ENEMY_MAP[newPos]).get_child_count() == 0) || (enemiesNode.get_child(_ENEMY_MAP[newPos]).get_child(0).character.currentHp == 0):
			if direction == Enums.Direction.EAST: # left
				newPos = (newPos - 1) if newPos > 0 else 2
			elif direction == Enums.Direction.WEST: # right
				newPos = (newPos + 1) if newPos < 2 else 0
		
		cursorPos = newPos
		
		createCursor()


func confirmCursor() -> void:
	if cursorOn:
		publishCommand(
			cursorPlayer,
			[enemiesNode.get_child(_ENEMY_MAP[cursorPos]).get_child(0).character],
			cursorMove)


func publishCommand(player, targets : Array, move : Move) -> void:
	var command
	match move.type:
		Enums.MoveType.ITEM:
			command = UseItemCommand.new(player, targets, move)
		
		Enums.MoveType.SKILL:
			command = ExecuteMoveCommand.new(player, targets, move)
	
	Signals.emit_signal("battleCursorHide")
	Signals.emit_signal("commandPublished", command)
	Signals.emit_signal("commandsResumed")
	cursorOn = false


func cancelCursor() -> void:
	if cursorOn:
		cursorOn = false
		Signals.emit_signal("battleCursorHide")
		Signals.emit_signal("battleShowCharacterMoves", cursorPlayer)


func finish() -> void:
	$AnimationPlayer.play("finish")


# TODO loot
func showBattleResult(players : Array, battleResult : BattleResult) -> void:
	for player in players:
		player.gainExperience(battleResult.experience)
	
	yield(get_tree().create_timer(1.5), "timeout")
	Signals.emit_signal("battleShowResult", battleResult)
	
	# should be on the window
	yield(get_tree().create_timer(2), "timeout")
	Signals.emit_signal("battleEnded")

