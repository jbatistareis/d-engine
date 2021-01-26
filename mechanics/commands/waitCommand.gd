class_name WaitCommand
extends Command

var nextCommand : Command


func _init(ticks : int, nextCommand : Command) -> void:
	setTotalTicks(ticks)
	self.nextCommand = nextCommand


func execute() -> void:
	Signals.emit_signal("publishedCommand", nextCommand)

