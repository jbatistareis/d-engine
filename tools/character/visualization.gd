extends VBoxContainer


func showData(shortName : String, type : int) -> void:
	$dummyContainer.visible = false
	$inventory.visible = false
	$verdict.visible = false
	$model.visible = false
	
	match type:
		Enums.EntityType.INVENTORY:
			$inventory.visible = true
			$inventory.loadData(Persistence.loadDTO(shortName, type))
		
		Enums.EntityType.VERDICT:
			$verdict.visible = true
			$verdict.loadData(Persistence.loadDTO(shortName, type))
		
		Enums.EntityType.CHARACTER_MODEL:
			$model.visible = true
			$model.loadData(load(GamePaths.CHARACTER_MODEL % shortName))
		
		_:
			$dummyContainer.visible = true
			push_error(ErrorMessages.UNK_CHARACTER_DATA % [shortName, type])

