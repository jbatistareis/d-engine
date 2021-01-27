extends EntityDatabase

# TODO remove
var locationSpawns : Array = [
	LocationSpawn.new(1, 1, 1, 1)
]

# TODO get from DB
func getEntityByLocationAndPortal(locationId : int, portalId : int) -> LocationSpawn:
	for locationSpawn in locationSpawns:
		if ((locationSpawn.locationId == locationId) && (locationSpawn.portalId == portalId)):
			return locationSpawn
	
	print('Location spawn not found (' + str(locationId) + ', ' + str(portalId) + ')')
	return null
