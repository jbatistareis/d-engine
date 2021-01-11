class_name Portal
extends Entity

var pointA : int setget ,getPointA
var pointB : int setget ,getPointB

var entranceLogic : String

func _init(id : int, pointA : int, pointB : int, entranceLogic : String = '').(id) -> void:
	self.pointA = pointA
	self.pointB = pointB
	
	self.entranceLogic = entranceLogic

func getPointA() -> int:
	return pointA

func getPointB() -> int:
	return pointB

func enter(characterSpawnId : int, fromLocationId, fromRoomId : int) -> bool:
	var result = true
	
	# TODO run entrance logic
	
	return result
