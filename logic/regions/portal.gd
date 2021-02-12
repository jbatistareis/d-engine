class_name Portal
extends Entity

const _NOOP : String = 'func execute(character : Character, fromRoom : Room, toRoom : Room) -> bool:\n\treturn true'

var pointA : int
var pointB : int

var entranceLogic : String


func _init(id : int, pointA : int, pointB : int, entranceLogic : String = '').(id) -> void:
	self.pointA = pointA
	self.pointB = pointB
	
	self.entranceLogic = entranceLogic if !entranceLogic.empty() else _NOOP


func enter(character : Character, fromRoom : Room) -> bool:
	return ScriptTool.getReference(entranceLogic).execute(
			character,
			fromRoom,
			RoomsDatabase.getEntitySpawn(pointA if fromRoom.id == pointB else pointB)
	)

