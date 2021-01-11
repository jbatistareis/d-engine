class_name VerdictCommand
extends Command

var auditorSpawnId : int

func _init(auditorSpawnId : int) -> void:
	self.auditorSpawnId = auditorSpawnId

func execute() -> void:
	# TODO get verdict from database
	var verdict = load("res://ai/verdict.gd")
	var auditor = CharactersDatabase.getEntitySpawn(auditorSpawnId)
	var room = RoomsDatabase.getEntitySpawn(auditor.currentRoom)
	var suspectsSpawnIds
	
	match auditor.getType():
		Enums.CharacterType.PC:
			suspectsSpawnIds = room.foeSpawns
		
		Enums.CharacterType.FOE_NPC:
			suspectsSpawnIds = room.characterSpawns
		
		_:
			suspectsSpawnIds = []
	
	verdict.decision(auditorSpawnId, suspectsSpawnIds)

