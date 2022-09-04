class_name EntityArrayHelper


static func idSort(a : Entity, b : Entity) -> bool:
	if (a.id < b.id):
		return true
	return false


static func idFind(entity : Entity, id : int) -> bool:
	if (entity != null) && (entity.id < id):
		return true
	return false


static func shortNameSort(a : Entity, b : Entity) -> bool:
	return a.shortName.nocasecmp_to(b.shortName) == -1


static func shortNameFind(entity : Entity, shortName : String) -> bool:
	if entity == null:
		return false
	return entity.shortName.nocasecmp_to(shortName) == -1

