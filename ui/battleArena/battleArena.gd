extends SubViewportContainer

const _ENEMY_FRAME_RATIO : float = 1.875
const _ENEMY_MAP : Array = [1, 2, 0]
const _PREFIXES : Array = ["[A] ", "[B] ", "[C] "]
const _ENEMIES_TRANSLATION : Array = [0.0, -1.25, 0.0]
const _ENEMY_ROTAION : Array = [[25, 0, -25], [25, 10, -10], [25, 0, -25]]

var enemyFrameSize : Vector2

var enemySize : int = 0
var cursorOn : bool = false
var cursorPos : int = 0
var cursorPlayer : Character
var cursorMove : Move


func _ready() -> void:
	Signals.setupBattleScreen.connect(setup)
	Signals.battleEnded.connect(finish)
	Signals.battleWon.connect(showBattleResult)
	Signals.battleLost.connect(lose)
	Signals.battleCursorShow.connect(setEnemyCursors)


func setup(playerData : Array, enemyData : Array) -> void:
	if playerData.is_empty() || enemyData.is_empty():
		push_error(ErrorMessages.BATTLE_CANT_START % [str(playerData), str(enemyData)])
		return
	
	var i = 0
	for enemy in $viewport/arena3d/enemies.get_children():
		for model in enemy.get_children():
			model.queue_free()
		
		enemy.rotation_degrees.y = _ENEMY_ROTAION[enemyData.size() - 1][i]
		i += 1
	$viewport/arena3d/enemies.transform.origin.x = _ENEMIES_TRANSLATION[enemyData.size() - 1]
	
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
			$viewport/arena3d/enemies.get_child(_ENEMY_MAP[index]).add_child(scene)
		
		index += 1
		if index > enemyData.size() - 1:
			break
	
	await get_tree().process_frame
	
	setEnemyCursors()
	
	Signals.battleScreenReady.emit()


func setEnemyCursors(character = null, move = null) -> void:
	for index in range(3):
		var enemy = $viewport/arena3d/enemies.get_child(index)
		
		if enemy.get_child_count() == 1:
			Signals.battleSetCursorPosition.emit(
				enemy.get_child(0).character,
				$viewport/arena3d/pivot/Camera3D.unproject_position(enemy.get_child(0).global_transform.origin) - (enemyFrameSize / 9.0))


func finish() -> void:
	$AnimationPlayer.play("finish")


# TODO loot
func showBattleResult(players : Array, battleResult : BattleResult) -> void:
	$AnimationPlayer.play("win")
	
	for player in players:
		player.gainExperience(battleResult.experience)
	
	await get_tree().create_timer(1.5).timeout
	Signals.battleShowResult.emit(battleResult)
	
	# should be a button on a window
	await get_tree().create_timer(2).timeout
	Signals.battleEnded.emit()


func lose() -> void:
	$AnimationPlayer.play("lose")
