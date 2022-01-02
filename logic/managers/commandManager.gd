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
	Signals.connect("battleStarted", self, "reset")
	
	add_child(timer)
	timer.connect("timeout", self, "tick")
	
	reset(null, null)


func tick() -> void:
	if !executingCommand:
		if !commandsQueue.empty():
			executingCommand = true
			
			for item in commandsQueue:
				item.tick()
			
			var command = commandsQueue.back()
			if command.toBeExecuted:
				command.run()
			
			if command.executed:
				commandsQueue.pop_back()
			
			executingCommand = false
		
		while !newCommands.empty():
			var command = newCommands.pop_front()
			
			if command is ExecuteMoveCommand:
				Signals.emit_signal("characterPreTimerSet", command.executorCharacter, command.totalTicks)
			else:
				Signals.emit_signal("characterPosTimerSet", command.executorCharacter, command.totalTicks)
			
			commandsQueue.append(command)
			commandsQueue.sort_custom(CommandArrayHelper, 'tickSortReverse')
			
			command.published()


func pause() -> void:
	timer.paused = true


func resume() -> void:
	timer.paused = false


func reset(players, enemies) -> void:
	timer.start(GameParameters.GCD)


func publishCommand(command : Command) -> void:
	if command.executorCharacter.currentHp <= 0:
		return
	
	newCommands.append(command)

