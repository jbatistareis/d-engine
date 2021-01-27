extends EntityDatabase

# TODO remove
var items : Array = [
	Item.new(1, 'Cloth shirt', 'A comom shirt, offers environment protection', 1, Enums.ItemType.ARMOR),
	Item.new(2, 'Punch', 'Use your bare hands to hurt the enemy', 0, Enums.ItemType.WEAPON)
]


# TODO get from DB
func getEntity(id : int) -> Item:
	return items[id - 1]

