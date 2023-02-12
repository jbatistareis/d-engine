class_name AskPlayerBattleInputCommand
extends Command


func _init(player, ticks : int):
	super(player, ticks)


func execute() -> void:
	if !BattleManager.inBattle:
		toBeExecuted = false
		remainingTicks = 0
		return
	
	Signals.commandsPaused.emit()
	Signals.battleShowCharacterMoves.emit(executorCharacter)

