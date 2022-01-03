extends Spatial

const ENEMY_FRAME_RATIO : float = 1.875
const ENEMY_MAP : Array = [2, 3, 1, 4, 0]
const PREFIXES : Array = ["[A] ", "[B] ", "[C] ", "[D] ", "[E] "]

var enemyFrameSize : Vector2
onready var enemiesNode : Node = $ViewportContainer/Viewport/arena/enemies
onready var battleCamera : Camera = $ViewportContainer/Viewport/arena/Camera

var cursorOn : bool = false
var cursorPos : int = 0
var cursorPlayer : Character
var cursorMove : Move


func _ready() -> void:
	$ViewportContainer/Viewport.size = GuiOverlayManager.windowSize()
	
	Signals.connect("setupBattleScreen", self, "setup")
	Signals.connect("battleCursorOpen", self, "showCursor")
	Signals.connect("guiLeft", self, "moveCursor", [Enums.Direction.EAST])
	Signals.connect("guiRight", self, "moveCursor", [Enums.Direction.WEST])
	Signals.connect("guiSelect", self, "confirmCursor")
	Signals.connect("guiCancel", self, "cancelCursor")
	Signals.connect("battleEnded", self, "finish")
	Signals.connect("showBattleResult", self, "showBattleResult")


func setup(playerData : Array, enemyData : Array) -> void:
	for node in enemiesNode.get_children():
		for enemy in node.get_children():
			enemy.queue_free()
	
	var i = 0
	for enemy in enemyData:
		enemy.shortName = PREFIXES[i] + enemy.shortName
		enemy.name = PREFIXES[i] + enemy.name
		i += 1
	
	$AnimationPlayer.play("start")
	
	var enemiesTimerWindow = BattleTimerEnemiesWindow.new(enemyData)
	enemiesTimerWindow.position = Vector2(25, 25)
	Signals.emit_signal("guiOpenWindow", enemiesTimerWindow)
	
	var playersTimerWindow = BattleTimerPlayersWindow.new(playerData)
	playersTimerWindow.position = Vector2(25, GuiOverlayManager.windowSize().y - 157)
	Signals.emit_signal("guiOpenWindow", playersTimerWindow)
	
	var width = GuiOverlayManager.windowSize().x / 5
	var heigth = width * ENEMY_FRAME_RATIO
	enemyFrameSize = Vector2(width, heigth)
	
	for index in range(5):
		if enemyData[index] != null:
			var scene = SceneLoadManager.scenes[enemyData[index].shortName.substr(4)].instance()
			scene.character = enemyData[index]
			enemiesNode.get_child(ENEMY_MAP[index]).add_child(scene)
		
		index += 1
		if index > enemyData.size() - 1:
			break
	
	yield(get_tree(), "idle_frame")
	Signals.emit_signal("battleScreenReady")


func createCursor() -> BattleCursorWindow:
	var enemyNode = enemiesNode.get_child(ENEMY_MAP[cursorPos])
	
	return BattleCursorWindow.new(
		enemyNode.get_child(0).character.shortName,
		battleCamera.unproject_position(enemyNode.global_transform.origin) - (enemyFrameSize / 9.0))


func showCursor(player : Character, move : Move) -> void:
	if !cursorOn:
		# TODO error out if no one is alive
		for index in range(5):
			if enemiesNode.get_child(ENEMY_MAP[index]).get_child_count() == 0:
				break
			
			if enemiesNode.get_child(ENEMY_MAP[index]).get_child(0).character.currentHp > 0:
				cursorPos = index
				break
		
		cursorPlayer = player
		cursorMove = move
		cursorOn = true
		
		yield(get_tree(), "idle_frame")
		Signals.emit_signal("guiOpenWindow", createCursor())


# TODO fix this repetition
# TODO error out if no one is alive
func moveCursor(direction : int) -> void:
	if cursorOn:
		var newPos = cursorPos
		
		if direction == Enums.Direction.EAST: # left
			newPos = (newPos - 1) if newPos > 0 else 4
		elif direction == Enums.Direction.WEST: # right
			newPos = (newPos + 1) if newPos < 4 else 0
		
		while (enemiesNode.get_child(ENEMY_MAP[newPos]).get_child_count() == 0) || (enemiesNode.get_child(ENEMY_MAP[newPos]).get_child(0).character.currentHp == 0):
			if direction == Enums.Direction.EAST: # left
				newPos = (newPos - 1) if newPos > 0 else 4
			elif direction == Enums.Direction.WEST: # right
				newPos = (newPos + 1) if newPos < 4 else 0
		
		cursorPos = newPos
		
		Signals.emit_signal("guiCloseWindow")
		yield(get_tree(), "idle_frame")
		Signals.emit_signal("guiOpenWindow", createCursor())


func confirmCursor() -> void:
	if cursorOn:
		Signals.emit_signal("guiCloseWindow")
		yield(get_tree(), "idle_frame")
		Signals.emit_signal("battleCursorConfirm", cursorPlayer, [enemiesNode.get_child(ENEMY_MAP[cursorPos]).get_child(0).character], cursorMove)
		cursorOn = false


func cancelCursor(ignore) -> void:
	if cursorOn:
		cursorOn = false
		Signals.emit_signal("guiCloseWindow")
		yield(get_tree(), "idle_frame")
		Signals.emit_signal("askedPlayerBattleInput", cursorPlayer)


func finish() -> void:
	$AnimationPlayer.play("finish")


# TODO loot
func showBattleResult(players : Array, battleResult : BattleResult) -> void:
	for player in players:
		player.gainExperience(battleResult.experience)
	
	Signals.emit_signal("guiClearWindows")
	yield(get_tree(), "idle_frame")
	Signals.emit_signal("guiOpenWindow", BattleResultWindow.new(battleResult))

