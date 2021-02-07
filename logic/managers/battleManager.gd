extends Node

var players : Array = []
var enemies : Array = []
var inBattle : bool = false


func _ready():
	Signals.connect("battleStart", self, "start")
	Signals.connect("askedPlayerBattleInput", self, "pauseCommands")
	Signals.connect("playerConfirmedBattleInput", self, "confirmInput")


func start(players : Array, enemies : Array) -> void:
	if !inBattle:
		inBattle = true
		
		self.players = players
		self.enemies = enemies
		
		for enemy in enemies:
			var node = ScriptTool.getNode(enemy.characterAproachesScript)
			for player in players:
				node.execute(player)
			node.queue_free()
			
			if enemy.verdictActive:
				Signals.emit_signal("commandPublished", VerdictCommand.new(enemy, 1))


func _process(delta):
	if inBattle && (enemiesAlive() == 0):
		end()


func end() -> void:
	if inBattle:
		inBattle = false
		
		for enemy in enemies:
			if enemy.health.currentHp == 0:
				pass # TODO loot
			else:
				CharactersDatabase.deSpawnEntity(enemy.spawnId)
		
		enemies.clear()
		Signals.emit_signal("battleEnd", {}) # TODO loot


func pauseCommands(player : Character, enemies : Array) -> void:
	Signals.emit_signal("commandsPaused")


func confirmInput(command : Command) -> void:
	Signals.emit_signal("commandPublished", command)
	Signals.emit_signal("commandsResumed")


func enemiesAlive() -> int:
	var result = 0
	for enemy in enemies:
		if enemy.health.currentHp > 0:
			result += 1
	
	return result

