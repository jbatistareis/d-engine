class_name Deserializer


static func character(data : PoolByteArray) -> Character:
	var character : Character = Character.new()
	var dict : Dictionary = bytes2var(data)
	
	return character


static func item(data : PoolByteArray) -> Item:
	var item : Item = Item.new()
	var dict : Dictionary = bytes2var(data)
	
	return item


static func location(data : PoolByteArray) -> Location:
	var dict : Dictionary = bytes2var(data)
	var location : Location = dict2inst(dict)
	
	var index = 0
	while index < location.rooms.size():
		location.rooms[index] = dict2inst(location.rooms[index])
		index += 1
	
	index = 0
	while index < location.portals.size():
		location.portals[index] = dict2inst(location.portals[index])
		index += 1
	
	index = 0
	while index < location.spawns.size():
		location.spawns[index] = dict2inst(location.spawns[index])
		index += 1
	
	return location

