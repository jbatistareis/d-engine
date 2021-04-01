class_name EntitySaver


static func saveCharacter(character : Character) -> void:
	var file = File.new()
	file.open_compressed(
		GamePaths.CHARACTER_DATA % character.shortName,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_buffer(character.serialize())
	file.close()


static func saveItem(item : Item) -> void:
	var file = File.new()
	file.open_compressed(
		GamePaths.ITEM_DATA % item.shortName,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_buffer(item.serialize())
	file.close()


static func saveLocation(location : Location) -> void:
	location.rooms.sort_custom(EntityArrayHelper, 'idSort')
	location.portals.sort_custom(EntityArrayHelper, 'idSort')
	location.spawns.sort_custom(EntityArrayHelper, 'idSort')
	
	var file = File.new()
	file.open_compressed(
		GamePaths.LOCATION_DATA % location.shortName,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_buffer(location.serialize())
	file.close()


static func saveLocationOnPath(location : Location, path : String) -> void:
	location.rooms.sort_custom(EntityArrayHelper, 'idSort')
	location.portals.sort_custom(EntityArrayHelper, 'idSort')
	location.spawns.sort_custom(EntityArrayHelper, 'idSort')
	
	var file = File.new()
	file.open_compressed(
		path,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_buffer(location.serialize())
	file.close()

