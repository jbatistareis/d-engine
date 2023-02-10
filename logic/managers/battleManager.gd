extends Node

var players : Array = []
var enemies : Array = []
var inBattle : bool = false


func _ready():
	Signals.connect("battleStarted",Callable(self,"start"))


func start(players : Array, enemies : Array) -> void:
	if !inBattle:
		Signals.emit_signal("hideToast")
		inBattle = true
		
		self.players = players
		self.enemies = enemies
		
		Signals.emit_signal("setupBattleScreen", players, enemies)
		await Signals.battleScreenReady
		
		# TODO pick order, ramdomize initial cd (or not)
		for player in players:
			if player.verdictActive:
				Signals.emit_signal("commandPublished", VerdictCommand.new(player, int(30 * randf())))
			else:
				Signals.emit_signal("commandPublished", AskPlayerBattleInputCommand.new(player, int(30 * randf())))
		
		for enemy in enemies:
			Signals.emit_signal("commandPublished", VerdictCommand.new(enemy, int(30 * randf())))


func _process(_delta) -> void:
	if inBattle:
		if playersAlive() == 0: # TODO game over
			inBattle = false
			Signals.emit_signal("commandsPaused")
			Signals.emit_signal("commandsCleared")
			Signals.emit_signal("battleLost")
			
		elif enemiesAlive() == 0: # TODO loot
			inBattle = false
			Signals.emit_signal("commandsCleared")
			
			var battleResult = BattleResult.new()
			for enemy in enemies:
				if enemy.currentHp == 0:
					battleResult.experience += enemy.experiencePoints
			
			Signals.emit_signal("battleWon", players, battleResult)
			
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

