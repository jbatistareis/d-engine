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
	while index < character.moves.size():
		character.moves[index] = dict2inst(dict.moves[index])
		index += 1
	
	character.inventory = dict2inst(dict.inventory)
	
	index = 0
	while index < character.inventory.items.size():
		character.inventory.items[index] = dict2inst(dict.inventory.items[index])
		index += 1
	
	index = 0
	while index < character.inventory.weapons.size():
		character.inventory.weapons[index] = dict2inst(dict.inventory.weapons[index])
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
	while index < location.rooms.size():
		location.rooms[index] = dict2inst(dict.rooms[index])
		index += 1
	
	index = 0
	while index < location.portals.size():
		location.portals[index] = dict2inst(dict.portals[index])
		index += 1
	
	index = 0
	while index < location.spawns.size():
		location.spawns[index] = dict2inst(dict.spawns[index])
		index += 1
	
	return location

