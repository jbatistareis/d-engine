class_name VerdictCommand
extends Command

var auditor : Character


func _init(auditor, ticks : int).(auditor, ticks) -> void:
	self.auditor = executorCharacter


func execute() -> void:
	if !BattleManager.inBattle:
		toBeExecuted = false
		remainingTicks = 0
		return
	
	Signals.emit_signal("startedBattleAnimation", auditor, 'idle')
	
	if auditor.verdictActive:
		var suspects
		
		match auditor.type:
			Enums.CharacterType.PC:
				suspects = BattleManager.enemies
			
			Enums.CharacterType.FOE:
				suspects = BattleManager.players
			
			_:
				suspects = []
		
		auditor.verdict.decision(auditor, suspects)

