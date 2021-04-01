class_name EntitySaver


static func saveCharacter(character : Character) -> void:
	var file = File.new()
	file.open_compressed(
		GamePaths.CHARACTER_DATA % character.shortName,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_var(Serializer.character(character))
	file.close()


static func saveItem(item : Item) -> void:
	var file = File.new()
	file.open_compressed(
		GamePaths.ITEM_DATA % item.shortName,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_var(Serializer.item(item))
	file.close()


static func saveLocation(location : Location) -> void:
	saveLocationOnPath(location, GamePaths.LOCATION_DATA % location.shortName)


static func saveLocationOnPath(location : Location, path : String) -> void:
	location.rooms.sort_custom(EntityArrayHelper, 'idSort')
	location.portals.sort_custom(EntityArrayHelper, 'idSort')
	location.spawns.sort_custom(EntityArrayHelper, 'idSort')
	
	var file = File.new()
	file.open_compressed(
		path,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_var(Serializer.location(location))
	file.close()

