class_name Portal
extends Entity

var pointA : int
var pointB : int

var entranceLogic : String

func _init(id : int, pointA : int, pointB : int, entranceLogic : String = '').(id) -> void:
	self.pointA = pointA
	self.pointB = pointB
	
	self.entranceLogic = entranceLogic


func enter(characterSpawnId : int, fromLocationId, fromRoomId : int) -> bool:
	var result = true
	
	# TODO run entrance logic
	
	return result
