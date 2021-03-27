class_name VerdictCommand
extends Command


func _init(executorCharacter, ticks : int).(executorCharacter, ticks) -> void:
	return


func execute() -> void:
	if (executorCharacter != null) && executorCharacter.verdictActive:
		var suspects
		
		match executorCharacter.getType():
			Enums.CharacterType.PC:
				suspects = BattleManager.enemies
			
			Enums.CharacterType.FOE_NPC:
				suspects = BattleManager.players
			
			_:
				suspects = []
		
		executorCharacter.verdict.decision(executorCharacter, suspects)

