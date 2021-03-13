class_name LocationSpawn
extends Entity

var locationId : int
var fromRoomId : int
var toRoomId : int


func _init(id : int, locationId : int, fromRoomId : int, toRoomId : int).(id) -> void:
	self.locationId = locationId
	self.fromRoomId = fromRoomId
	self.toRoomId = toRoomId

