class_name EntityArrayHelper


static func idSort(a, b) -> bool:
	if (a.id < b.id):
		return true
	return false


static func idFind(entity, id : int) -> bool:
	if entity.id < id:
		return true
	return false


static func shortNameSort(a, b) -> bool:
	return a.shortName.nocasecmp_to(b.shortName) == -1


# TODO not working as intended
static func shortNameFind(entity, shortName : String) -> bool:
	return entity.shortName == shortName

