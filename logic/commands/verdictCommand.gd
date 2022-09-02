class_name VerdictCommand
extends Command

var auditor


func _init(auditor, ticks : int).(auditor, ticks) -> void:
	self.auditor = executorCharacter


func execute() -> void:
	if !BattleManager.inBattle:
		toBeExecuted = false
		remainingTicks = 0
		return
	
	if auditor.verdictActive:
		auditor.verdict.decision(auditor)

