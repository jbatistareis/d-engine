extends Node

var gcd : float = 1 # TODO make external
var elapsed : float = 0

var commandsQueue : Array = []
var executedCommands : Array = []

func _process(delta : float) -> void:
	elapsed += delta
	
	if (elapsed >= gcd):
		elapsed = 0
		tick()

func tick() -> void:
	executedCommands.clear()
	
	for command in commandsQueue:
		command.tick()
		if (command.wasExecuted()): executedCommands.append(command)
	
	for executedCommand in executedCommands:
		commandsQueue.erase(executedCommand)

func publishCommand(command : Command) -> void:
	commandsQueue.append(command)
	commandsQueue.sort_custom(CommandArrayHelper, 'tickSort')

