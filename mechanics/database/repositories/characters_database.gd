extends EntityDatabase

var characters : Array = [
	Character.new(1, Enums.CharacterType.PC, 'Dummy 1'),
	Character.new(2, Enums.CharacterType.FOE_NPC, 'Dummy 2')
]

# TODO save on DB
func saveEntity(id : int) -> void:
	pass

# TODO get from DB
func getEntity(id : int) -> Character:
	return characters[id - 1]

func spawnEntity(id : int, useSameId : bool = false):
	var entity = .spawnEntity(id, useSameId)
	Signals.emit_signal("characterSpawned", entity.spawnId, entity.id)
	
	return entity as Character

func deSpawnEntity(id : int) -> void:
	var entity = .getEntitySpawn(id)
	Signals.emit_signal("characterDespawned", entity.spawnId, entity.id)
	.deSpawnEntity(id)

