class_name EntityArrayHelper


static func idSort(a, b) -> bool:
	if (a.id < b.id):
		return true
	return false


static func idFind(entity, id : int) -> bool:
	if (entity.id < id):
		return true
	return false

