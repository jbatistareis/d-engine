class_name VerdictCommand
extends Command


func _init(auditor : Character, ticks : int):
	super(auditor, ticks)


func execute() -> void:
	if !BattleManager.inBattle:
		toBeExecuted = false
		remainingTicks = 0
		return
	
	if executorCharacter.verdictActive:
		executorCharacter.verdict.decision(executorCharacter)

