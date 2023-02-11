extends Node

var scenes : Dictionary = {}


func fromLocation(location : Location) -> void:
	scenes.clear()
	
	var locationModels = Persistence.listEntities(Enums.EntityType.LOCATION_MODELS, location.shortName)
	var locationModelPath = GamePaths.LOCATION_MODELS + '/%s.tscn'
	
	for model in locationModels:
		if !scenes.has(model):
			scenes[model] = load(locationModelPath % [location.shortName, model])
	
	for room in location.rooms:
		for foeGroup in room.foeShortNameGroups:
			for foe in foeGroup:
				if !scenes.has(foe):
					scenes[foe] = load(GamePaths.CHARACTER_MODEL % foe)

