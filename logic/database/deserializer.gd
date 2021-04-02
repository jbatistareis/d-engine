class_name Deserializer


static func character(data : PoolByteArray) -> Character:
	var dict : Dictionary = bytes2var(data)
	var character : Character = dict2inst(dict)
	
	character.strength = dict2inst(dict.strength)
	character.dexterity = dict2inst(dict.dexterity)
	character.constitution = dict2inst(dict.constitution)
	character.intelligence = dict2inst(dict.intelligence)
	character.wisdom = dict2inst(dict.wisdom)
	character.charisma = dict2inst(dict.charisma)
	
	var index = 0
	for move in dict.moves:
		character.moves[index] = dict2inst(move)
		index += 1
	
	character.inventory = dict2inst(dict.inventory)
	
	index = 0
	for item in dict.inventory.items:
		character.inventory.items[index] = dict2inst(item)
		index += 1
	
	index = 0
	for weapon in dict.inventory.weapons:
		character.inventory.weapons[index] = dict2inst(weapon)
		index += 1
	
	character.verdict = dict2inst(dict.verdict)
	
	index = 0
	for concreteFact in dict.verdict.concreteFacts:
		character.verdict.concreteFacts[index] = [
			dict2inst(concreteFact[0]),
			dict2inst(concreteFact[1])
		]
		index += 1
	
	character.inventory.weapon = dict2inst(dict.inventory.weapon)
	character.inventory.armor = dict2inst(dict.inventory.armor)
	
	return character


static func item(data : PoolByteArray) -> Item:
	var dict : Dictionary = bytes2var(data)
	var item : Item = dict2inst(dict)
	
	return item


static func location(data : PoolByteArray) -> Location:
	var dict : Dictionary = bytes2var(data)
	var location : Location = dict2inst(dict)
	
	var index = 0
	for room in dict.rooms:
		location.rooms[index] = dict2inst(room)
		index += 1
	
	index = 0
	for portal in dict.portals:
		location.portals[index] = dict2inst(portal)
		index += 1
	
	index = 0
	for spawn in dict.spawns:
		location.spawns[index] = dict2inst(spawn)
		index += 1
	
	return location

