extends Node

var players : Array = []
var enemies : Array = []
var inBattle : bool = false


func _ready():
	Signals.connect("battleStart", self, "start")
	Signals.connect("askedPlayerInput", self, "pauseCommands")
	Signals.connect("playerConfirmedInput", self, "confirmInput")


func start(players : Array, enemies : Array) -> void:
	self.players = players
	self.enemies = enemies
	self.inBattle = true
	
	for enemy in enemies:
		var node = ScriptTool.getNode(enemy.characterAproachesScript)
		for player in players:
			node.execute(player)
		node.queue_free()


func _process(delta):
	if inBattle && (enemiesAlive() == 0):
		end()


func end() -> void:
	for enemy in enemies:
		CharactersDatabase.deSpawnEntity(enemy.spawnId)
	
	inBattle = false
	enemies.clear()
	Signals.emit_signal("battleEnd", {}) # TODO loot


func pauseCommands(player : Character, enemies : Array) -> void:
	Signals.emit_signal("commandsPaused")


func confirmInput(command : Command) -> void:
	Signals.emit_signal("publishedCommand", command)
	Signals.emit_signal("commandsResumed")


func enemiesAlive() -> int:
	var result = 0
	for enemy in enemies:
		if enemy.health.currentHp == 0:
			result += 1
	
	return result

