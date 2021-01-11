class_name LocationSpawn
extends Entity

var locationId : int setget ,getLocationId
var portalId : int setget ,getPortalId
var roomId : int setget ,getRoomId

var entranceLogic : String

func _init(id : int, locationId : int, portalId : int, roomId : int).(id) -> void:
	self.locationId = locationId
	self.portalId = portalId
	self.roomId = roomId

func getLocationId() -> int:
	return locationId

func getPortalId() -> int:
	return portalId

func getRoomId() -> int:
	return roomId
