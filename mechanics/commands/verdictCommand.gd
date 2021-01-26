class_name VerdictCommand
extends Command

var auditor : Character

func _init(auditor : Character) -> void:
	self.auditor = auditor

func execute() -> void:
	if (auditor != null) && auditor.verdictActive:
		var room = RoomsDatabase.getEntitySpawn(auditor.currentRoom)
		var suspects
		
		match auditor.getType():
			Enums.CharacterType.PC:
				suspects = room.foeSpawns
			
			Enums.CharacterType.FOE_NPC:
				suspects = room.characterSpawns
			
			_:
				suspects = []
		
		VerdictsDatabase.getEntity(auditor.verdictId).decision(auditor, suspects)

