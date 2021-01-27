extends EntityDatabase

# TODO remove
var armors : Array = [Armor.new(1, 1)]


# TODO save on DB
func saveEntity(id : int) -> void:
	pass


# TODO get from DB
func getEntity(itemId : int) -> Armor:
	return armors[itemId - 1]

