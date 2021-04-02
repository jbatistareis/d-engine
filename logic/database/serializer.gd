class_name Serializer


static func character(character : Character) -> PoolByteArray:
	var data : Dictionary = inst2dict(character)
	
	return var2bytes(data)


static func item(item : Item) -> PoolByteArray:
	var data : Dictionary = inst2dict(item)
	
	return var2bytes(data)


static func location(location : Location) -> PoolByteArray:
	location.rooms.sort_custom(EntityArrayHelper, 'idSort')
	location.portals.sort_custom(EntityArrayHelper, 'idSort')
	location.spawns.sort_custom(EntityArrayHelper, 'idSort')
	
	var data : Dictionary = inst2dict(location)
	
	var index = 0
	while index < data.rooms.size():
		data.rooms[index] = inst2dict(data.rooms[index])
		index += 1
	
	index = 0
	while index < data.portals.size():
		data.portals[index] = inst2dict(data.portals[index])
		index += 1
	
	index = 0
	while index < data.spawns.size():
		data.spawns[index] = inst2dict(data.spawns[index])
		index += 1
	
	return var2bytes(data)

