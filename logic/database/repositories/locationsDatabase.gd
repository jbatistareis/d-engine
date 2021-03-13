extends EntityDatabase


# TODO remove
var locations : Array = [
	Location.new(1, 'Test Location', 'Testing')
]


# TODO get from DB
func getEntity(id : int) -> Location:
	return locations[id - 1]


func spawnEntity(id : int) -> Location:
	return getEntity(id)


func deSpawnEntity(spawnId : int) -> void:
	return


func getEntitySpawn(spawnId : int) -> Location:
	return getEntity(spawnId)

