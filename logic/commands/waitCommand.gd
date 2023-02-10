class_name WaitCommand
extends Command

var nextCommand : Command


func _init(nextCommand : Command,ticks : int = GameParameters.WAIT_TICKS,nextCommand.executorCharacter,ticks):
	self.nextCommand = nextCommand


func execute() -> void:
	Signals.emit_signal("startedBattleAnimation", executorCharacter, 'idle')
	Signals.emit_signal("commandPublished", nextCommand)

