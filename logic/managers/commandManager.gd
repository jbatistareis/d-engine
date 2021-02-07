extends Node

var gcd : float = 1 # TODO make external
var elapsed : float = 0
var paused : bool = false

var commandsQueue : Array = []
var executedCommands : Array = []


func _ready():
	Signals.connect("commandsPaused", self, 'pause')
	Signals.connect("commandsResumed", self, 'resume')
	Signals.connect("commandPublished", self, 'publishCommand')


func _process(delta : float) -> void:
	if !paused:
		elapsed += delta
		
		if elapsed >= gcd:
			elapsed = 0
			tick()


func tick() -> void:
	executedCommands.clear()
	
	for command in commandsQueue:
		command.tick()
		if command.executed:
			executedCommands.append(command)
	
	for executedCommand in executedCommands:
		commandsQueue.erase(executedCommand)


func pause() -> void:
	paused = true


func resume() -> void:
	paused = true


func publishCommand(command : Command) -> void:
	Signals.emit_signal("charaterTimerSet", command.executor, command.totalTicks)
	
	commandsQueue.append(command)
	commandsQueue.sort_custom(CommandArrayHelper, 'tickSort')

