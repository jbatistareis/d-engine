class_name EntityArrayHelper


static func idSort(a : Entity, b : Entity) -> bool:
	if (a.id < b.id):
		return true
	return false


static func idFind(entity : Entity, id : int) -> bool:
	if (entity.id < id):
		return true
	return false

