extends Node

var player : Character
var enemies : Array

func _ready():
	Signals.connect("battleStart", self, "start")
	Signals.connect("askedPlayerInput", self, "pauseCommands")
	Signals.connect("playerConfirmedInput", self, "confirmInput")


func start(player : Character, enemies : Array) -> void:
	self.player = player
	self.enemies = enemies
	
	for enemy in enemies:
		var node = ScriptTool.getNode(enemy.characterAproachesScript)
		node.execute(player)
		node.queue_free()


func end() -> void:
	for enemy in enemies:
		CharactersDatabase.deSpawnEntity(enemy.spawnId)
	
	Signals.emit_signal("commandsResumed")


func pauseCommands(player : Character, enemies : Array) -> void:
	Signals.emit_signal("commandsPaused")


func confirmInput(command : Command) -> void:
	Signals.emit_signal("publishedCommand", command)
	Signals.emit_signal("commandsResumed")

