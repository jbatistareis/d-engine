class_name EntityLoader


static func loadCharacter(shortName : String) -> Character:
	var file = File.new()
	file.open_compressed(
		GamePaths.CHARACTER_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	var character : Character = bytes2var(file.get_buffer(file.get_len()))
	file.close()
	
	return character


static func loadItem(shortName : String) -> Item:
	var file = File.new()
	file.open_compressed(
		GamePaths.ITEM_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	var item : Item = bytes2var(file.get_buffer(file.get_len()))
	file.close()
	
	return item


static func loadLocation(shortName : String) -> Location:
	var file = File.new()
	file.open_compressed(
		GamePaths.LOCATION_DATA % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	var location : Location = bytes2var(file.get_buffer(file.get_len()))
	file.close()
	
	return location

