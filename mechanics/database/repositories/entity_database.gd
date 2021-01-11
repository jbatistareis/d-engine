class_name EntityDatabase
extends Node

var spawnedEntities : Array = []
var spawnCount : int = 1

# TODO save on DB
func saveEntity(id : int) -> void:
	pass

# TODO get from DB
func getEntity(id : int):
	return null

func spawnEntity(id : int, useSameId : bool = false):
	var entity = getEntity(id)
	entity.setSpawnId(spawnCount if !useSameId else id)
	
	if (!useSameId): spawnCount += 1
	
	spawnedEntities.append(entity)
	spawnedEntities.sort_custom(EntityArrayHelper, 'spawnSort')
	
	return entity

func deSpawnEntity(id : int) -> void:
	var index = spawnedEntities.bsearch_custom(id, EntityArrayHelper, 'spawnFind')
	
	if (index < spawnedEntities.size()):
		spawnedEntities.remove(index)
		spawnedEntities.sort_custom(EntityArrayHelper, 'spawnSort')

func getEntitySpawn(id : int):
	var index = spawnedEntities.bsearch_custom(id, EntityArrayHelper, 'spawnFind')
	
	if (index < spawnedEntities.size()):
		return spawnedEntities[index]
	else:
		return null

func clearEntitySpawns() -> void:
	spawnedEntities.clear()
	spawnCount = 1

