class_name Persistence


# TODO
static func saveProgress(slot : int) -> bool:
	return true


# TODO
static func loadProgress(slot : int) -> bool:
	return true


static func saveDTO(dto : DTO) -> String:
	var path = ''
	
	if dto is CharacterDTO:
		path = GamePaths.CHARACTER_DATA
	
	elif dto is VerdictDTO:
		path = GamePaths.VERDICT_DATA
	
	elif dto is FactDTO:
		path = GamePaths.FACT_DATA
	
	elif dto is InventoryDTO:
		path = GamePaths.INVENTORY_DATA
	
	elif dto is ItemDTO:
		path = GamePaths.ITEM_DATA
	
	elif dto is WeaponDTO:
		path = GamePaths.WEAPON_DATA
	
	elif dto is MoveDTO:
		path = GamePaths.MOVE_DATA
	
	elif dto is ArmorDTO:
		path = GamePaths.ARMOR_DATA
	
	elif dto is LocationDTO:
		path = GamePaths.LOCATION_DATA
	
	if path.empty():
		push_error(ErrorMessages.SAVE_ERR_UNK_TYPE)
		return ''
	
	path %= dto.shortName
	
	var file = File.new()
	file.open_compressed(path, File.WRITE, File.COMPRESSION_ZSTD)
	file.store_var(inst2dict(dto))
	file.close()
	
	return path


static func loadDTO(shortName : String, entityType : int) -> DTO:
	var path
	
	match entityType:
		Enums.EntityType.CHARACTER:
			path = GamePaths.CHARACTER_DATA
		
		Enums.EntityType.VERDICT:
			path = GamePaths.VERDICT_DATA
		
		Enums.EntityType.FACT:
			path = GamePaths.FACT_DATA
		
		Enums.EntityType.INVENTORY:
			path = GamePaths.INVENTORY_DATA
		
		Enums.EntityType.ITEM:
			path = GamePaths.ITEM_DATA
		
		Enums.EntityType.WEAPON:
			path = GamePaths.WEAPON_DATA
		
		Enums.EntityType.MOVE:
			path = GamePaths.MOVE_DATA
		
		Enums.EntityType.ARMOR:
			path = GamePaths.ARMOR_DATA
		
		Enums.EntityType.LOCATION:
			path = GamePaths.LOCATION_DATA
		
		_:
			push_error(ErrorMessages.LOAD_ERR_UNK_TYPE)
			return null
	
	path %= shortName
	
	var file = File.new()
	file.open_compressed(path, File.READ, File.COMPRESSION_ZSTD)
	var dto = dict2inst(file.get_var())
	file.close()
	
	return dto

