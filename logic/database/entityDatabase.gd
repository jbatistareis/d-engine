class_name EntityDatabase
extends Node

var spawnedEntities : Array = []
var useSameId : bool = false


# TODO save on DB
func saveEntity(id : int) -> void:
	pass


# TODO get from DB
func getEntity(id : int):
	return null


func spawnEntity(id : int):
	var lastSpanwId = 0
	for entity in spawnedEntities:
		if entity.spanwId > lastSpanwId:
			lastSpanwId = entity.spanwId
	
	var entity = getEntity(id)
	entity.spawnId = (lastSpanwId + 1) if !useSameId else id
	
	spawnedEntities.append(entity)
	spawnedEntities.sort_custom(EntityArrayHelper, 'spawnSort')
	
	return entity


func deSpawnEntity(spawnId : int) -> void:
	var index = spawnedEntities.bsearch_custom(spawnId, EntityArrayHelper, 'spawnFind')
	
	if (index < spawnedEntities.size()):
		spawnedEntities.remove(index)
		spawnedEntities.sort_custom(EntityArrayHelper, 'spawnSort')


func getEntitySpawn(spawnId : int):
	var index = spawnedEntities.bsearch_custom(spawnId, EntityArrayHelper, 'spawnFind')
	
	if (index < spawnedEntities.size()):
		return spawnedEntities[index]
	else:
		return null


func clearEntitySpawns() -> void:
	spawnedEntities.clear()

