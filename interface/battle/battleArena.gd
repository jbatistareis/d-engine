extends Spatial

const ENEMY_FRAME_RATIO : float = 1.875
var enemyFrameSize : Vector2


func _ready() -> void:
	$ViewportContainer/Viewport.size = GuiOverlayManager.windowSize()
	
	Signals.connect("setupBattleScreen", self, "setup")
	Signals.connect("battleEnded", self, "finish")
	Signals.connect("showBattleResult", self, "showBattleResult")


func setup(playerData : Array, enemyData : Array) -> void:
	for node in $ViewportContainer/Viewport/arena/enemies.get_children():
		for enemy in node.get_children():
			enemy.queue_free()
	
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

	var index = 0
	for enemyNode in $ViewportContainer/Viewport/arena/enemies.get_children():
		if enemyData[index] != null:
			var scene = SceneLoadManager.scenes[enemyData[index].shortName].instance()
			scene.character = enemyData[index]
			enemyNode.add_child(scene)
		
		index += 1
		if index > enemyData.size() - 1:
			break
	
	yield(get_tree(), "idle_frame")
	Signals.emit_signal("battleScreenReady")


func finish() -> void:
	$AnimationPlayer.play("finish")


# TODO loot
func showBattleResult(players : Array, battleResult : BattleResult) -> void:
	for player in players:
		player.gainExperience(battleResult.experience)
	
	Signals.emit_signal("guiClearWindows")
	yield(get_tree(), "idle_frame")
	Signals.emit_signal("guiOpenWindow", BattleResultWindow.new(battleResult))

