class_name AskPlayerInputCommand
extends Command

var player : Character


func _init(ticks : int, player : Character) -> void:
	self.totalTicks = ticks
	self.player = player
	
	Signals.emit_signal("charaterTimerSet", self.player, self.totalTicks)


func execute() -> void:
	Signals.emit_signal("askedPlayerInput", player)

