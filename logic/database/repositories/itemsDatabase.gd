extends EntityDatabase

# TODO remove
var items : Array = []


# TODO get from DB
func getEntity(id : int) -> Item:
	return items[id - 1]

