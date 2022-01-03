class_name AskPlayerBattleInputCommand
extends Command


func _init(player, ticks : int).(player, ticks) -> void:
	return


func execute() -> void:
	if !BattleManager.inBattle:
		executed = true
		toBeExecuted = false
		return
	
	Signals.emit_signal("commandsPaused")
	Signals.emit_signal("askedPlayerBattleInput", executorCharacter)

