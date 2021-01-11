extends EntityDatabase

# TODO remove
var armors : Array = [Armor.new(1, 1)]

# TODO save on DB
func saveEntity(id : int) -> void:
	pass

# TODO get from DB
func getEntity(itemId : int) -> Item:
	return armors[itemId - 1]

func spawnEntity(id : int, useSameId : bool = false):
	var entity = .spawnEntity(id, useSameId)
	Signals.emit_signal("armorSpawned", entity.spawnId, entity.id)
	
	return entity as Armor

func deSpawnEntity(id : int) -> void:
	var entity = .getEntitySpawn(id)
	Signals.emit_signal("armorDespawned", entity.spawnId, entity.id)
	.deSpawnEntity(id)

