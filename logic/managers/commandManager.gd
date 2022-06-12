extends Node

onready var timer : Timer = Timer.new()

var paused : bool = false
var executingCommand : bool = false
var commandsQueue : Array = []
var newCommands : Array = []


func _ready():
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")
	Signals.connect("commandPublished", self, "publishCommand")
	Signals.connect("battleScreenReady", self, "reset")
	Signals.connect("commandsCleared", self, "clearCommands")
	
	add_child(timer)
	timer.connect("timeout", self, "tick")
	
	reset()


func tick() -> void:
	if timer.paused:
		return
	
	if !executingCommand:
		for command in commandsQueue:
			executingCommand=true
			command.tick()
			
			if command.toBeExecuted:
				command.execute()
				commandsQueue.erase(command)
			elif command.canceled:
				commandsQueue.erase(command)
		
		executingCommand = false
	
	while !newCommands.empty():
		var command = newCommands.pop_front()
		commandsQueue.append(command)
		command.published()
		
		Signals.emit_signal("commandOnQueue", command)
	
	commandsQueue.sort_custom(CommandArrayHelper, 'tickSortReverse')


func pause() -> void:
	timer.paused = true


func resume() -> void:
	timer.paused = false


func reset() -> void:
	timer.start(GameParameters.GCD)


func clearCommands() -> void:
	commandsQueue.clear()
	newCommands.clear()


func publishCommand(command : Command) -> void:
	if command.executorCharacter.currentHp <= 0:
		return
	
	newCommands.append(command)

