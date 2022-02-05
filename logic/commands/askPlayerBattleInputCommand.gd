class_name AskPlayerBattleInputCommand
extends Command


func _init(player, ticks : int).(player, ticks) -> void:
	return


func execute() -> void:
	if !BattleManager.inBattle:
		toBeExecuted = false
		remainingTicks = 0
		return
	
	Signals.emit_signal("commandsPaused")
	Signals.emit_signal("guiOpenWindow", BattleMovesWindow.new(executorCharacter))

