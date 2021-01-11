extends EntityDatabase

# TODO remove
var items : Array = [
	Item.new(1, 'Cloth shirt', 'A comom shirt, offers environment protection', 1, Enums.ItemType.ARMOR),
	Item.new(2, 'Punch', 'Use your bare hands to hurt the enemy', 0, Enums.ItemType.WEAPON)
]

# TODO get from DB
func getEntity(id : int) -> Item:
	return items[id - 1]

func spawnEntity(id : int, useSameId : bool = false):
	var entity = .spawnEntity(id, useSameId)
	Signals.emit_signal("itemSpawned", entity.spawnId, entity.id)
	
	return entity as Item

func deSpawnEntity(id : int) -> void:
	var entity = .getEntitySpawn(id)
	Signals.emit_signal("itemDespawned", entity.spawnId, entity.id)
	.deSpawnEntity(id)

