class_name VerdictCommand
extends Command


func _init(executorCharacter, ticks : int).(executorCharacter, ticks) -> void:
	pass


func execute() -> void:
	if !BattleManager.inBattle:
		executed = true
		toBeExecuted = false
		return
	
	if executorCharacter.verdictActive:
		var suspects
		
		match executorCharacter.type:
			Enums.CharacterType.PC:
				suspects = BattleManager.enemies
			
			Enums.CharacterType.FOE_NPC:
				suspects = BattleManager.players
			
			_:
				suspects = []
		
		executorCharacter.verdict.decision(executorCharacter, suspects)

