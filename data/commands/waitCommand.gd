class_name WaitCommand
extends Command

var nextCommand : Command


func _init(nextCommand : Command, ticks : int).(nextCommand.executor, ticks) -> void:
	self.nextCommand = nextCommand


func execute() -> void:
	Signals.emit_signal("commandPublished", nextCommand)

