extends Node

var players : Array = []
var enemies : Array = []
var inBattle : bool = false


func _ready():
	Signals.battleStarted.connect(start)


func start(players : Array, enemies : Array) -> void:
	if !inBattle:
		Signals.hideToast.emit()
		inBattle = true
		
		self.players = players
		self.enemies = enemies
		
		Signals.setupBattleScreen.emit(players, enemies)
		await Signals.battleScreenReady
		
		# TODO pick order, ramdomize initial cd (or not)
		for player in players:
			if player.verdictActive:
				Signals.commandPublished.emit(VerdictCommand.new(player, 30))
			else:
				Signals.commandPublished.emit(AskPlayerBattleInputCommand.new(player, 30))

		for enemy in enemies:
			Signals.commandPublished.emit(VerdictCommand.new(enemy, int(randf_range(0.5, 0.8) * 30)))


func _process(_delta) -> void:
	if inBattle:
		if playersAlive() == 0: # TODO game over
			inBattle = false
			Signals.commandsPaused.emit()
			Signals.commandsCleared.emit()
			Signals.battleLost.emit()
			
		elif enemiesAlive() == 0: # TODO loot
			inBattle = false
			Signals.commandsCleared.emit()
			
			var battleResult = BattleResult.new()
			for enemy in enemies:
				if enemy.currentHp == 0:
					battleResult.experience += enemy.experiencePoints
			
			Signals.battleWon.emit(players, battleResult)
			
			players.clear()
			enemies.clear()


func enemiesAlive() -> int:
	var result = 0
	for enemy in enemies:
		if (enemy != null) && (enemy.currentHp > 0):
			result += 1
	
	return result


func playersAlive() -> int:
	var result = 0
	for player in players:
		if (player != null) && (player.currentHp > 0):
			result += 1
	
	return result

