class_name EntityArrayHelper


static func idSort(a : Entity, b : Entity) -> bool:
	if (a.id < b.id):
		return true
	return false


static func idFind(entity : Entity, id : int) -> bool:
	if (entity.id < id):
		return true
	return false


static func spawnSort(a : Entity, b : Entity) -> bool:
	if (a.spawnId < b.spawnId):
		return true
	return false


static func spawnFind(entity : Entity, spawnId : int) -> bool:
	if (entity.spawnId < spawnId):
		return true
	return false

