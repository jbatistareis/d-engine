class_name EntityLoader


static func loadCharacter(shortName : String) -> Character:
	var character : Character
	var file = File.new()
	file.open_compressed(
		GamePaths.CHARACTER_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	character = bytes2var(file.get_buffer(file.get_len()))
	file.close()
	
	return character


static func loadItem(shortName : String) -> Item:
	var item : Item
	var file = File.new()
	file.open_compressed(
		GamePaths.ITEM_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	item = bytes2var(file.get_buffer(file.get_len()))
	file.close()
	
	return item


static func loadLocation(shortName : String) -> Location:
	var location : Location
	var file = File.new()
	file.open_compressed(
		GamePaths.LOCATION_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	location = bytes2var(file.get_buffer(file.get_len()))
	file.close()
	
	return location

