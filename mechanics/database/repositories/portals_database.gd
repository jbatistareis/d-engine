extends EntityDatabase

# TODO remove
var portals : Array = [
	Portal.new(1, -1, -1),
	Portal.new(2, 1, 2)
]

# TODO get from DB
func getEntity(id : int) -> Portal:
	return portals[id - 1]

