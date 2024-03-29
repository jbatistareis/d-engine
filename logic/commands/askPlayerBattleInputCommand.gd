class_name AskPlayerBattleInputCommand
extends Command


func _init(player : Character, ticks : int):
	super(player, ticks)


func execute() -> void:
	if !BattleManager.inBattle:
		toBeExecuted = false
		remainingTicks = 0
		return
	
	Signals.commandsPaused.emit()
	Signals.battleAskedMove.emit(executorCharacter)

