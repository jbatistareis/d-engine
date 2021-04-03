extends Node

var player : Character = null
var location : Location = null


func _ready():
	Signals.connect("playerStartedAtLocation", self, "instantiateLocation")
	Signals.connect("playerTransferedLocation", self, "changeLocation")
	Signals.connect("playerMoved", self, "movePlayer")
	Signals.connect("characterMoved", self, "moveCharacter")


func instantiateLocation(player : Character, shortName : String, toSpawnId : int) -> void:
	location = EntityLoader.loadLocation(shortName)
	
	var room = location.findRoom(location.findSpawn(toSpawnId).toRoomId)
	Signals.emit_signal("playerSpawned", location, room.x, room.y, room.orientation)
	
	location.enter(player, toSpawnId)


func changeLocation(newLocationName : String, toSpawnId : int) -> void:
	instantiateLocation(player, newLocationName, toSpawnId)


func movePlayer(direction : int) -> void:
	if (player != null) && (location != null):
		location.move(player, direction)


func moveCharacter(character, direction) -> void:
	if location != null:
		location.move(character, direction)

