extends EntityDatabase

# TODO remove
var inventories : Array = [Inventory.new(1, false)]


# TODO save on DB
func saveEntity(id : int) -> void:
	pass


# TODO get from DB
func getEntity(id : int) -> Inventory:
	return inventories[id - 1]

