class_name EntityLoader


static func loadCharacter(shortName : String):
	var file = File.new()
	file.open_compressed(
		GamePaths.CHARACTER_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	
	var character : Character = Deserializer.character(file.get_var())
	file.close()
	
	return character


static func loadItem(shortName : String):
	var file = File.new()
	file.open_compressed(
		GamePaths.ITEM_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	var item : Item = Deserializer.item(file.get_var())
	file.close()
	
	return item


static func loadLocation(shortName : String):
	var file = File.new()
	print(GamePaths.LOCATION_DATA % shortName)
	file.open_compressed(
		GamePaths.LOCATION_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	var location = Deserializer.location(file.get_var())
	file.close()
	
	return location

