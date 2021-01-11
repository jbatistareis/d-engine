extends EntityDatabase

# TODO remove
var locationSpawns : Array = [
	LocationSpawn.new(1, 1, 1, 1)
]

# TODO get from DB
func getEntityByLocationAndPortal(locationId : int, portalId : int) -> LocationSpawn:
	for locationSpawn in locationSpawns:
		if ((locationSpawn.getLocationId() == locationId) && (locationSpawn.getPortalId() == portalId)):
			return locationSpawn
	
	print('Location spawn not found (' + str(locationId) + ', ' + str(portalId) + ')')
	return null
