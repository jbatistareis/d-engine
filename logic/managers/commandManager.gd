extends Node

onready var timer : Timer = Timer.new()

var gcd : float = 0.25 # TODO make external
var elapsed : float = 0
var paused : bool = false

var commandsQueue : Array = []
var executedCommands : Array = []


func _ready():
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")
	Signals.connect("commandPublished", self, "publishCommand")
	Signals.connect("battleStarted", self, "reset")
	Signals.connect("battleEnded", self, "reset")
	
	add_child(timer)
	timer.connect("timeout", self, "tick")
	
	reset()


func tick() -> void:
	executedCommands.clear()
	
	for command in commandsQueue:
		command.tick()
		
		if command.toBeExecuted:
			command.run()
			if command.executed:
				# TODO pos cd
				executedCommands.append(command)
	
	for executedCommand in executedCommands:
		commandsQueue.erase(executedCommand)


func pause() -> void:
	timer.paused = true


func resume() -> void:
	timer.paused = false


func reset() -> void:
	timer.start(gcd)


func publishCommand(command : Command) -> void:
	Signals.emit_signal("characterPreTimerSet", command.executor, command.totalTicks)
	
	commandsQueue.append(command)
	commandsQueue.sort_custom(CommandArrayHelper, 'tickSort')
	
	command.published()

