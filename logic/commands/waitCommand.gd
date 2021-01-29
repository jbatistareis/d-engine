class_name WaitCommand
extends Command

var nextCommand : Command


func _init(ticks : int, nextCommand : Command) -> void:
	self.totalTicks = ticks
	self.nextCommand = nextCommand


func execute() -> void:
	Signals.emit_signal("publishedCommand", nextCommand)

