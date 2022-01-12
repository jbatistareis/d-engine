extends Node

var players : Array = []
var enemies : Array = []
var inBattle : bool = false


func _ready():
	Signals.connect("battleStarted", self, "start")
	Signals.connect("battleCursorConfirm", self, "confirmInput")


func start(players : Array, enemies : Array) -> void:
	if !inBattle:
		inBattle = true
		
		self.players = players
		self.enemies = enemies
		
		Signals.emit_signal("setupBattleScreen", players, enemies)
		yield(Signals, "battleScreenReady")
		
		# TODO pick order, ramdomize initial cd (or not)
		for player in players:
			if player.verdictActive:
				Signals.emit_signal("commandPublished", VerdictCommand.new(player, 10 * (Dice.rollNormal(Enums.DiceType.D100) / 100.0) + 2))
			else:
				Signals.emit_signal("commandPublished", AskPlayerBattleInputCommand.new(player, 10 * (Dice.rollNormal(Enums.DiceType.D100) / 100.0) + 2))
		
		for enemy in enemies:
			Signals.emit_signal("commandPublished", VerdictCommand.new(enemy, 10 * (Dice.rollNormal(Enums.DiceType.D100) / 100.0) + 2))


func _physics_process(delta) -> void:
	if inBattle && (enemiesAlive() == 0):
		end()


func end() -> void:
	if inBattle:
		inBattle = false
		var battleResult = BattleResult.new()
		
		for enemy in enemies:
			if enemy.currentHp == 0:
				battleResult.experience += enemy.experiencePoints
				pass # TODO loot
			else:
				#CharactersDatabase.deSpawnEntity(enemy.spawnId)
				pass
		
		Signals.emit_signal("showBattleResult", players, battleResult)
		
		players.clear()
		enemies.clear()


func confirmInput(player, targets : Array, move : Move) -> void:
	Signals.emit_signal("commandPublished", ExecuteMoveCommand.new(player, targets, move))
	Signals.emit_signal("commandsResumed")


func enemiesAlive() -> int:
	var result = 0
	for enemy in enemies:
		if (enemy != null) && (enemy.currentHp > 0):
			result += 1
	
	return result

