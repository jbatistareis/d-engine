extends Node

var id : int = 0 setget ,getId


func adjustId(location : Location) -> void:
	id = 0
	
	for room in location.rooms:
		if room.id > id:
			id = room.id
	
	for portal in location.portals:
		if portal.id > id:
			id = portal.id
	
	for spawn in location.spawns:
		if spawn.id > id:
			id = spawn.id


func resetId() -> void:
	id = 0


func getId() -> int:
	id += 1
	return id
