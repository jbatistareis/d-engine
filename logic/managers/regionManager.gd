extends Node

var playerSpawnId : int
var location : Location


func _ready():
	Signals.connect("playerStartedAtLocation", self, "instantiateLocation")
	Signals.connect("playerTransferLocation", self, "changeLocation")
	Signals.connect("playerMoved", self, "movePlayer")
	Signals.connect("characterMoved", self, "moveCharacter")


func instantiateLocation(characterId : int, locationId : int, fromRoomId : int) -> void:
	location = LocationsDatabase.getEntity(locationId)
	playerSpawnId = location.enter(characterId, fromRoomId)


func changeLocation(oldLocationId : int, newLocationId : int, fromRoomId : int) -> void:
	LocationsDatabase.deSpawnEntity(oldLocationId)
	instantiateLocation(CharactersDatabase.getEntitySpawn(playerSpawnId).id, newLocationId, fromRoomId)


func movePlayer(direction : int) -> void:
	location.move(CharactersDatabase.getEntitySpawn(playerSpawnId), direction)


func moveCharacter(character, direction) -> void:
	location.move(character, direction)

