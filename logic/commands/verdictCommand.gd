class_name VerdictCommand
extends Command

var auditor : Character


func _init(ticks : int, auditor : Character) -> void:
	self.totalTicks = ticks
	self.auditor = auditor
	
	Signals.emit_signal("charaterTimerSet", self.auditor, self.totalTicks)


func execute() -> void:
	if (auditor != null) && auditor.verdictActive:
		var room = RoomsDatabase.getEntitySpawn(auditor.currentRoom)
		var suspects
		
		match auditor.getType():
			Enums.CharacterType.PC:
				suspects = BattleManager.enemies
			
			Enums.CharacterType.FOE_NPC:
				suspects = BattleManager.players
			
			_:
				suspects = []
		
		VerdictsDatabase.getEntity(auditor.verdictId).decision(auditor, suspects)

