extends Node

var playerSpawnId : int
var location : Location


func _ready():
	Signals.connect("playerStartedAtLocation", self, "instantiateLocation")
	Signals.connect("playerLeftLocation", self, "changeLocation")
	Signals.connect("playerMoved", self, "movePlayer")
	Signals.connect("characterMoved", self, "moveCharacter")


func instantiateLocation(characterId : int, locationId : int, fromPortalId : int) -> void:
	location = LocationsDatabase.getEntity(locationId)
	playerSpawnId = location.enter(characterId, fromPortalId)


func changeLocation(oldLocation : Location, newLocation : Location, fromPortal : Portal) -> void:
	instantiateLocation(CharactersDatabase.getEntitySpawn(playerSpawnId).id, newLocation.id, fromPortal.id)


func movePlayer(direction : int) -> void:
	location.move(CharactersDatabase.getEntitySpawn(playerSpawnId), direction)


func moveCharacter(character, direction) -> void:
	location.move(character, direction)

