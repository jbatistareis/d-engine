class_name VerdictCommand
extends Command


func _init(executor : Character, ticks : int).(executor, ticks) -> void:
	return


func execute() -> void:
	if (executor != null) && executor.verdictActive:
		var room = RoomsDatabase.getEntitySpawn(executor.currentRoom)
		var suspects
		
		match executor.getType():
			Enums.CharacterType.PC:
				suspects = BattleManager.enemies
			
			Enums.CharacterType.FOE_NPC:
				suspects = BattleManager.players
			
			_:
				suspects = []
		
		VerdictsDatabase.getEntity(executor.verdictId).decision(executor, suspects)

