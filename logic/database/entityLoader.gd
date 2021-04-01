class_name EntityLoader


static func loadCharacter(shortName : String) -> Character:
	var file = File.new()
	file.open_compressed(
		GamePaths.CHARACTER_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	var character : Character = Deserializer.character(file.get_var())
	file.close()
	
	return character


static func loadItem(shortName : String) -> Item:
	var file = File.new()
	file.open_compressed(
		GamePaths.ITEM_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	var item : Item = Deserializer.item(file.get_var())
	file.close()
	
	return item


static func loadLocation(shortName : String) -> Location:
	return loadLocationFromPath(GamePaths.LOCATION_DATA % shortName)


static func loadLocationFromPath(path : String) -> Location:
	var file = File.new()
	file.open_compressed(
		path,
		File.READ,
		File.COMPRESSION_ZSTD)
	var location : Location = Deserializer.location(file.get_var())
	file.close()
	
	return location

