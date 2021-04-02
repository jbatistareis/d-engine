class_name EntitySaver


static func saveCharacter(character : Character) -> String:
	var path = GamePaths.CHARACTER_DATA % character.shortName
	
	var file = File.new()
	file.open_compressed(
		path,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_var(Serializer.character(character))
	file.close()
	
	return path


static func saveItem(item : Item) -> String:
	var path = GamePaths.ITEM_DATA % item.shortName
	
	var file = File.new()
	file.open_compressed(
		path,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_var(Serializer.item(item))
	file.close()
	
	return path


static func saveLocation(location : Location) -> String:
	var path = GamePaths.LOCATION_DATA % location.shortName
	
	var file = File.new()
	file.open_compressed(
		path,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_var(Serializer.location(location))
	file.close()
	
	return path

