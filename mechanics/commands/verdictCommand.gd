class_name VerdictCommand
extends Command

var _auditorSpawnId : int

func _init(auditorSpawnId : int) -> void:
	self._auditorSpawnId = auditorSpawnId

func execute() -> void:
	var auditor = CharactersDatabase.getEntitySpawn(_auditorSpawnId)
	
	if (auditor != null) && auditor.verdictActive:
		var room = RoomsDatabase.getEntitySpawn(auditor.currentRoom)
		var suspectsSpawnIds
		
		match auditor.getType():
			Enums.CharacterType.PC:
				suspectsSpawnIds = room.foeSpawns
			
			Enums.CharacterType.FOE_NPC:
				suspectsSpawnIds = room.characterSpawns
			
			_:
				suspectsSpawnIds = []
		
		VerdictsDatabase.getEntity(auditor.verdictId).decision(auditor.spawnId, suspectsSpawnIds)

