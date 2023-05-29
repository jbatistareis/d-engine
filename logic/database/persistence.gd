class_name Persistence


static func saveDTO(dto : DTO) -> String:
	var path = ''
	
	if dto is CharacterDTO:
		path = GamePaths.CHARACTER_DATA
	
	elif dto is VerdictDTO:
		path = GamePaths.VERDICT_DATA
	
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
	
	elif dto is SaveDTO:
		path = GamePaths.SAVE_DATA
	
	if path.is_empty():
		push_error(ErrorMessages.FILE_SAVE_ERR_UNK_TYPE % dto.shortName)
		return ''
	
	path %= dto.shortName
	
	var file = FileAccess.open_compressed(path, FileAccess.WRITE, FileAccess.COMPRESSION_ZSTD)
	file.store_var(inst_to_dict(dto))
	file.flush()
	
	return path


static func loadDTO(shortName : String, entityType : int) -> DTO:
	var path
	
	match entityType:
		Enums.EntityType.CHARACTER:
			path = GamePaths.CHARACTER_DATA
		
		Enums.EntityType.VERDICT:
			path = GamePaths.VERDICT_DATA
		
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
		
		Enums.EntityType.SAVE_DATA:
			path = GamePaths.SAVE_DATA
		
		_:
			push_error(ErrorMessages.FILE_LOAD_ERR_UNK_TYPE % shortName)
			return null
	
	path %= shortName
	
	var file = FileAccess.open_compressed(path, FileAccess.READ, FileAccess.COMPRESSION_ZSTD)
	
	if file == null:
		push_error(ErrorMessages.FILE_NOT_FOUND % path)
		return null
	
	var dto = dict_to_inst(file.get_var())
	
	return dto


# TODO
static func deleteDTO(dto : DTO) -> String:
	var path = ''
	
	if dto is CharacterDTO:
		path = GamePaths.CHARACTER_DATA
	
	elif dto is VerdictDTO:
		path = GamePaths.VERDICT_DATA
	
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
	
	elif dto is SaveDTO:
		path = GamePaths.SAVE_DATA
	
	if path.is_empty():
		push_error(ErrorMessages.FILE_DELETE_ERR_UNK_TYPE % dto.shortName)
		return ''
	
	path %= dto.shortName
	
	push_error(ErrorMessages.FILE_DELETE_NO_IMPL)
	
	return path


static func listEntities(entityType : int, subpath : String = '') -> Array:
	var extensionRegex : RegEx = RegEx.new()
	extensionRegex.compile(GamePaths.EXTENSION_REGEX)
	
	var result = []
	var path
	
	match entityType:
		Enums.EntityType.CHARACTER:
			path = GamePaths.CHARACTER_PATH
		
		Enums.EntityType.CHARACTER_MODEL:
			path = GamePaths.CHARACTER_PATH
		
		Enums.EntityType.VERDICT:
			path = GamePaths.VERDICT_PATH
		
		Enums.EntityType.INVENTORY:
			path = GamePaths.INVENTORY_PATH
		
		Enums.EntityType.ITEM:
			path = GamePaths.ITEM_PATH
		
		Enums.EntityType.WEAPON:
			path = GamePaths.WEAPON_PATH
		
		Enums.EntityType.MOVE:
			path = GamePaths.MOVE_PATH
		
		Enums.EntityType.ARMOR:
			path = GamePaths.ARMOR_PATH
		
		Enums.EntityType.LOCATION:
			path = GamePaths.LOCATION_PATH
		
		Enums.EntityType.LOCATION_MODELS:
			path = GamePaths.LOCATION_MODELS % subpath
		
		Enums.EntityType.SAVE_DATA:
			path = GamePaths.SAVE_DATA
	
	var dir = DirAccess.open(path)
	if dir != null:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		
		var file = dir.get_next()
		while !file.is_empty():
			if (entityType != Enums.EntityType.CHARACTER_MODEL) && !dir.current_is_dir():
				result.append(extensionRegex.sub(file, ''))
			elif (entityType == Enums.EntityType.CHARACTER_MODEL) && dir.current_is_dir():
				result.append(extensionRegex.sub(file, ''))
			
			file = dir.get_next()
		
		dir.list_dir_end()
	else:
		push_error(ErrorMessages.DIR_NOT_FOUND % path)
	
	result.sort()
	return result

