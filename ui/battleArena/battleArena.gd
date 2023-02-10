extends Node3D

const _ENEMY_FRAME_RATIO : float = 1.875
const _ENEMY_MAP : Array = [1, 2, 0]
const _PREFIXES : Array = ["[A] ", "[B] ", "[C] "]
const _ENEMIES_TRANSLATION : Array = [0.0, -1.25, 0.0]
const _ENEMY_ROTAION : Array = [[25, 0, -25], [25, 10, -10], [25, 0, -25]]

var enemyFrameSize : Vector2
@onready var enemiesNode : Node = $SubViewportContainer/SubViewport/arena/enemies
@onready var battleCamera : Camera3D = $SubViewportContainer/SubViewport/arena/pivot/Camera3D

var enemySize : int = 0
var cursorOn : bool = false
var cursorPos : int = 0
var cursorPlayer : Character
var cursorMove : Move


func _ready() -> void:
	Signals.connect("setupBattleScreen",Callable(self,"setup"))
	Signals.connect("battleCursorShow",Callable(self,"showCursor"))
	Signals.connect("guiLeft",Callable(self,"moveCursor").bind(Enums.Direction.EAST))
	Signals.connect("guiRight",Callable(self,"moveCursor").bind(Enums.Direction.WEST))
	Signals.connect("guiConfirm",Callable(self,"confirmCursor"))
	Signals.connect("guiCancel",Callable(self,"cancelCursor"))
	Signals.connect("battleEnded",Callable(self,"finish"))
	Signals.connect("battleWon",Callable(self,"showBattleResult"))
	
	get_viewport().connect("size_changed",Callable(self,"updateSize"))
	updateSize()


func updateSize() -> void:
	$SubViewportContainer/SubViewport.size = GuiOverlayManager.currentSize


func setup(playerData : Array, enemyData : Array) -> void:
	var cursorPos = 0
	var enemySize = enemyData.size()
	
	if playerData.is_empty() || enemyData.is_empty():
		push_error(ErrorMessages.BATTLE_CANT_START % [str(playerData), str(enemyData)])
		return
	
	var i = 0
	for enemy in enemiesNode.get_children():
		for model in enemy.get_children():
			model.queue_free()
		
		enemy.rotation_degrees.y = _ENEMY_ROTAION[enemyData.size() - 1][i]
		i += 1
	enemiesNode.transform.origin.x = _ENEMIES_TRANSLATION[enemyData.size() - 1]
	
	i = 0
	for enemy in enemyData:
		enemy.shortName = _PREFIXES[i] + enemy.shortName
		enemy.name = _PREFIXES[i] + enemy.name
		i += 1
	
	$AnimationPlayer.play("start")
	
	var width = GuiOverlayManager.currentSize.x / 5
	var heigth = width * _ENEMY_FRAME_RATIO
	enemyFrameSize = Vector2(width, heigth)
	
	for index in range(3):
		if enemyData[index] != null:
			var scene = SceneLoadManager.scenes[enemyData[index].shortName.substr(4)].instantiate()
			scene.character = enemyData[index]
			enemiesNode.get_child(_ENEMY_MAP[index]).add_child(scene)
		
		index += 1
		if index > enemyData.size() - 1:
			break
	
	await get_tree().create_timer(0.1).timeout
	Signals.emit_signal("battleScreenReady")


func createCursor() -> void:
	cursorOn = true
	var enemyNode = enemiesNode.get_child(_ENEMY_MAP[cursorPos])

	Signals.emit_signal(
		"battleCursorMove",
		enemyNode.get_child(0).character.name,
		battleCamera.unproject_position(enemyNode.global_transform.origin) - (enemyFrameSize / 9.0)
	)


# TODO pick from the players group
func showCursor(player : Character, move : Move) -> void:
	if !cursorOn:
		# TODO adapt for ANY_ALL
		if (move.targetType == Enums.MoveTargetType.FRIENDLY) || (move.targetType == Enums.MoveTargetType.FRIENDLY_ALL):
			publishCommand(player, [player], move)
			return
		# FIXME this will crash for sure
		elif move.targetType == Enums.MoveTargetType.FOE_ALL:
			var targets = []
			for index in range(3):
				var character = enemiesNode.get_child(_ENEMY_MAP[index]).get_child(0).character
				
				if character.currentHp > 0:
					targets.append(character)
			
			publishCommand(player, targets, move)
			return
		
		# TODO error out if no one is alive
		cursorPos = cursorPos % (enemySize - 1)
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


# FIXME repetition
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
	
	await get_tree().create_timer(1.5).timeout
	Signals.emit_signal("battleShowResult", battleResult)
	
	# should be checked the window
	await get_tree().create_timer(2).timeout
	Signals.emit_signal("battleEnded")

