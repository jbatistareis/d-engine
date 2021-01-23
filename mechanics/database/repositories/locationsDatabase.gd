extends EntityDatabase

# TODO remove
var locations : Array = [
	Location.new(1, 'Test Location', 'Testing', [1])
]

# TODO get from DB
func getEntity(id : int) -> Portal:
	return locations[id - 1]

