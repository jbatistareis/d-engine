extends EntityDatabase

# TODO remove
var weapons : Array = [Weapon.new(1, 2)]


# TODO get from DB
func getEntity(itemId : int) -> Weapon:
	return weapons[itemId - 1]

