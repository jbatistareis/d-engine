class_name Portal
extends Entity

const _NOOP : String = 'extends Node\nfunc execute(character : Character, fromRoom : Room, toRoom : Room) -> bool:\n\treturn true'

var pointA : int
var pointB : int

var entranceLogic : String


func _init(id : int, pointA : int, pointB : int, entranceLogic : String = '').(id) -> void:
	self.pointA = pointA
	self.pointB = pointB
	
	self.entranceLogic = entranceLogic if !entranceLogic.empty() else _NOOP


func enter(characterSpawnId : int, fromRoomId : int) -> bool:
	var node = ScriptTool.getNode(entranceLogic)
	var result = node.execute(
			CharactersDatabase.getEntitySpawn(characterSpawnId),
			RoomsDatabase.getEntitySpawn(fromRoomId),
			RoomsDatabase.getEntitySpawn(pointA if fromRoomId == pointB else pointB)
	)
	node.queue_free()
	
	return result

