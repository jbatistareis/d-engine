class_name EntityArrayHelper


static func idSort(a, b) -> bool:
	return a.id < b.id


static func idFind(entity, id : int) -> bool:
	return entity.id < id


static func shortNameSort(a, b) -> bool:
	return a.shortName.nocasecmp_to(b.shortName) == -1


static func shortNameFind(entity, shortName : String) -> bool:
	return entity.shortName < shortName

