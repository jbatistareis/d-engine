extends Node

var scenes : Dictionary = {}


func fromLocation(location : Location) -> void:
	scenes.clear()
	
	var directory = Directory.new()
	var path = GamePaths.MAP_DATA % location.shortName
	
	directory.open(GamePaths.MAP_DATA % location.shortName)
	directory.list_dir_begin(true, true)
	
	var filename = directory.get_next()
	while !filename.empty():
		if filename.ends_with('.tscn'):
			scenes[filename.substr(0, filename.find_last('.'))] = load(path + '/' + filename)
		filename = directory.get_next()
	
	for room in location.rooms:
		for foeGroup in room.foeShortNameGroups:
			if !scenes.has_all(foeGroup):
				for foe in foeGroup:
					scenes[foe] = load(GamePaths.CHARACTER_MODEL % foe)

