class_name AskPlayerBattleInputCommand
extends Command


func _init(player, ticks : int).(player, ticks) -> void:
	return


func execute() -> void:
	Signals.emit_signal("askedPlayerBattleInput", executorCharacter)

