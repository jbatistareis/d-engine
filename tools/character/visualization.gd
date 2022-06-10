extends TabContainer


func showData(type : int, shortName : String = '') -> void:
	match type:
		Enums.EntityType.VERDICT:
			current_tab = 1
			$Verdict/data.loadData(Persistence.loadDTO(shortName, type))
		
		Enums.EntityType.INVENTORY:
			current_tab = 2
			$Inventory/data.loadData(Persistence.loadDTO(shortName, type))
		
		Enums.EntityType.CHARACTER_MODEL:
			current_tab = 3
			$Model/data.loadData(load(GamePaths.CHARACTER_MODEL % shortName))
		
		-1:
			current_tab = 0
		
		_:
			current_tab = 0
			push_error(ErrorMessages.UNK_CHARACTER_DATA % [shortName, type])

