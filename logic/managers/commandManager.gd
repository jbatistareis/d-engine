extends Node

onready var timer : Timer = Timer.new()

var elapsed : float = 0
var paused : bool = false

var commandsQueue : Array = []
var executedCommands : Array = []


func _ready():
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")
	Signals.connect("commandPublished", self, "publishCommand")
	Signals.connect("battleStarted", self, "reset")
	Signals.connect("battleEnded", self, "reset", [true, true])
	
	add_child(timer)
	timer.connect("timeout", self, "tick")
	
	reset(null, null)


func tick() -> void:
	Signals.emit_signal("ticked")
	executedCommands.clear()
	
	for command in commandsQueue:
		command.tick()
		
		if command.toBeExecuted:
			command.run()
			
			if command.executed:
				executedCommands.append(command)
	
	for executedCommand in executedCommands:
		commandsQueue.erase(executedCommand)


func pause() -> void:
	timer.paused = true


func resume() -> void:
	timer.paused = false


func reset(players, enemies) -> void:
	timer.start(GameParameters.GCD)


func publishCommand(command : Command) -> void:
	yield(Signals, "ticked")
	
	if (command is AskPlayerBattleInputCommand) || (command is VerdictCommand):
		Signals.emit_signal("characterPosTimerSet", command.executorCharacter, command.totalTicks)
	else:
		Signals.emit_signal("characterPreTimerSet", command.executorCharacter, command.totalTicks)
	
	commandsQueue.append(command)
	commandsQueue.sort_custom(CommandArrayHelper, 'tickSort')
	
	command.published()

