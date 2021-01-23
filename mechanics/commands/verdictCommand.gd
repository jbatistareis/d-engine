class_name VerdictCommand
extends Command

var _auditorSpawnId : int

func _init(auditorSpawnId : int) -> void:
	self._auditorSpawnId = auditorSpawnId

func execute() -> void:
	var auditor = CharactersDatabase.getEntitySpawn(_auditorSpawnId)
	var room = RoomsDatabase.getEntitySpawn(auditor.currentRoom)
	var suspectsSpawnIds
	
	# TODO get character verdict from database
	var verdict = load("res://mechanics/ai/verdict.gd")
	
	match auditor.getType():
		Enums.CharacterType.PC:
			suspectsSpawnIds = room.foeSpawns
		
		Enums.CharacterType.FOE_NPC:
			suspectsSpawnIds = room.characterSpawns
		
		_:
			suspectsSpawnIds = []
	
	verdict.decision(_auditorSpawnId, suspectsSpawnIds)

