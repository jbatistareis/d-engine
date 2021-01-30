class_name AskPlayerBattleInputCommand
extends Command


func _init(player : Character, ticks : int).(player, ticks) -> void:
	return


func execute() -> void:
	Signals.emit_signal("askedPlayerBattleInput", executor)

