class_name Deserializer


static func character(dict : Dictionary):
	var index = 0
	var data = dict2inst(dict)
	
	data.strength = dict2inst(dict.strength)
	data.dexterity = dict2inst(dict.dexterity)
	data.constitution = dict2inst(dict.constitution)
	data.intelligence = dict2inst(dict.intelligence)
	data.wisdom = dict2inst(dict.wisdom)
	data.charisma = dict2inst(dict.charisma)
	
	data.inventory = dict2inst(dict.inventory)
	index = 0
	for item in dict.inventory.items:
		data.inventory.items[index] = dict2inst(item)
		index += 1
	index = 0
	for weapon in dict.inventory.weapons:
		data.inventory.weapons[index] = dict2inst(weapon)
		index += 1
	
	data.verdict = dict2inst(dict.verdict)
	index = 0
	for action in dict.verdict.actions:
		var actionInst = dict2inst(action)
		actionInst.fact = dict2inst(action.fact)
		actionInst.move = dict2inst(action.move)
		
		data.verdict.actions[index] = actionInst
		index += 1
	
	data.inventory.weapon = null if (dict.inventory.weapon == null) else dict2inst(dict.inventory.weapon)
	index = 0
	for move in dict.inventory.weapon.moves:
		data.inventory.weapon.moves[index] = dict2inst(move)
		index += 1
	
	data.inventory.armor = null if (dict.inventory.armor == null) else dict2inst(dict.inventory.armor)
	
	return data


static func item(dict : Dictionary):
	var data = dict2inst(dict)
	
	return data


static func location(dict : Dictionary):
	var data = dict2inst(dict)
	
	var index = 0
	for room in dict.rooms:
		data.rooms[index] = dict2inst(room)
		index += 1
	
	index = 0
	for portal in dict.portals:
		data.portals[index] = dict2inst(portal)
		index += 1
	
	index = 0
	for spawn in dict.spawns:
		data.spawns[index] = dict2inst(spawn)
		index += 1
	
	return data

