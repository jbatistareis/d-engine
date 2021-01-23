class_name LocationSpawn
extends Entity

var locationId : int
var portalId : int
var roomId : int

var entranceLogic : String

func _init(id : int, locationId : int, portalId : int, roomId : int).(id) -> void:
	self.locationId = locationId
	self.portalId = portalId
	self.roomId = roomId

