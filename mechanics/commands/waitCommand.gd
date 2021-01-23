class_name WaitCommand
extends Command

var nextCommand : Command

func _init(ticks : int, nextCommand : Command) -> void:
	setTotalTicks(ticks)
	self.nextCommand = nextCommand
	self.executorCharSpawnId = nextCommand.executorCharSpawnId

func execute() -> void:
	CommandManager.publishCommand(nextCommand)

