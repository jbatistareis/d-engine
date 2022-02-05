class_name VerdictCommand
extends Command


func _init(executorCharacter, ticks : int).(executorCharacter, ticks) -> void:
	pass


func execute() -> void:
	if !BattleManager.inBattle:
		toBeExecuted = false
		remainingTicks = 0
		return
	
	Signals.emit_signal("startedBattleAnimation", executorCharacter, 'idle')
	
	if executorCharacter.verdictActive:
		var suspects
		
		match executorCharacter.type:
			Enums.CharacterType.PC:
				suspects = BattleManager.enemies
			
			Enums.CharacterType.FOE:
				suspects = BattleManager.players
			
			_:
				suspects = []
		
		executorCharacter.verdict.decision(executorCharacter, suspects)

