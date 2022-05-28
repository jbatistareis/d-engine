extends Node

var location : Location = null


func _ready():
	Signals.connect("playerTransferedLocation", self, "changeLocation")
	Signals.connect("playerMoved", self, "movePlayer")
	Signals.connect("characterMoved", self, "moveCharacter")


func changeLocation(locationShortName : String, toSpawnId : int) -> void:
	location = Location.new(locationShortName)
	
	SceneLoadManager.fromLocation(location)
	
	var spawn = location.findSpawn(toSpawnId)
	var room = location.findRoom(spawn.toRoomId)
	Signals.emit_signal("playerSpawned", location, room.x, room.y, spawn.direction)
	
	location.enter(GameManager.player, toSpawnId)


func movePlayer(direction : int) -> void:
	var result = location.move(GameManager.player, direction)
	
	match result:
		Enums.Direction.FORWARD:
			Signals.emit_signal("cameraMovedForward")
		
		Enums.Direction.BACKWARD:
			Signals.emit_signal("cameraMovedBackward")
	
	if result == Enums.Direction.NONE:
		Signals.emit_signal("playerRoomChangeDenied")
	else:
		Signals.emit_signal("playerChangedRoom", direction)


func moveCharacter(character, direction) -> void:
	location.move(character, direction)

