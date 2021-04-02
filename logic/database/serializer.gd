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
	for move in character.moves:
		data.moves[index] = inst2dict(move)
		index += 1
	
	data.inventory = inst2dict(character.inventory)
	
	index = 0
	for item in character.inventory.items:
		data.inventory.items[index] = inst2dict(item)
		index += 1
	
	index = 0
	for weapon in character.inventory.weapons:
		data.inventory.weapons[index] = inst2dict(weapon)
		index += 1
	
	data.verdict = inst2dict(character.verdict)
	
	index = 0
	for concreteFact in character.verdict.concreteFacts:
		data.verdict.concreteFacts[index] = [
			inst2dict(concreteFact[0]),
			inst2dict(concreteFact[1])
		]
		index += 1
	
	data.inventory.weapon = inst2dict(character.inventory.weapon)
	data.inventory.armor = inst2dict(character.inventory.armor)
	
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
	for room in location.rooms:
		data.rooms[index] = inst2dict(room)
		index += 1
	
	index = 0
	for portal in location.portals:
		data.portals[index] = inst2dict(portal)
		index += 1
	
	index = 0
	for spawn in location.spawns:
		data.spawns[index] = inst2dict(spawn)
		index += 1
	
	return var2bytes(data)
