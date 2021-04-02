class_name Serializer


static func character(character : Character) -> PoolByteArray:
	var data : Dictionary = inst2dict(character)
	
	data.strength = inst2dict(character.strength)
	data.dexterity = inst2dict(character.dexterity)
	data.constitution = inst2dict(character.constitution)
	data.intelligence = inst2dict(character.intelligence)
	data.wisdom = inst2dict(character.wisdom)
	data.charisma = inst2dict(character.charisma)
	
	var index = 0
	while index < data.moves.size():
		data.moves[index] = inst2dict(data.moves[index])
		index += 1
	
	data.inventory = inst2dict(character.inventory)
	
	index = 0
	while index < data.inventory.items.size():
		data.inventory.items[index] = inst2dict(data.inventory.items[index])
		index += 1
	
	index = 0
	while index < data.inventory.weapons.size():
		data.inventory.weapons[index] = inst2dict(data.inventory.weapons[index])
		index += 1
	
	data.inventory.weapon = inst2dict(data.inventory.weapon)
	data.inventory.armor = inst2dict(data.inventory.armor)
	
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

