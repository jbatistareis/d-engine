extends EntityDatabase

# TODO remove
var weapons : Array = [Weapon.new(1, 2)]

# TODO get from DB
func getEntity(itemId : int) -> Weapon:
	return weapons[itemId - 1]

func spawnEntity(id : int, useSameId : bool = false):
	var entity = .spawnEntity(id, useSameId)
	Signals.emit_signal("weaponSpawned", entity.spawnId, entity.id)
	
	return entity as Weapon

func deSpawnEntity(id : int) -> void:
	var entity = .getEntitySpawn(id)
	Signals.emit_signal("weaponDespawned", entity.spawnId, entity.id)
	.deSpawnEntity(id)

