extends EntityDatabase

# TODO remove
var locationSpawns : Array = [
	LocationSpawn.new(1, 1, 0, 1)
]

# TODO get from DB
func getEntityByLocationIdAndFromRoomId(locationId : int, fromRoomId : int) -> LocationSpawn:
	for locationSpawn in locationSpawns:
		if ((locationSpawn.locationId == locationId) && (locationSpawn.fromRoomId == fromRoomId)):
			return locationSpawn
	
	print('Location spawn not found (' + str(locationId) + ', ' + str(fromRoomId) + ')')
	return null
