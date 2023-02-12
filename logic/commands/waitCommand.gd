class_name WaitCommand
extends Command

var nextCommand : Command


func _init(nextCommand : Command,ticks : int = GameParameters.WAIT_TICKS):
	super(nextCommand.executorCharacter, ticks)
	self.nextCommand = nextCommand


func execute() -> void:
	Signals.startedBattleAnimation.emit(executorCharacter, 'idle')
	Signals.commandPublished.emit(nextCommand)

