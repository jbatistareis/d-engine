extends Node

var player : Character
var location : Location


func _ready():
	Signals.connect("playerStartedAtLocation", self, "instantiateLocation")
	Signals.connect("playerTransferedLocation", self, "changeLocation")
	Signals.connect("playerMoved", self, "movePlayer")
	Signals.connect("characterMoved", self, "moveCharacter")


func instantiateLocation(player : Character, shortName : String, toSpawnId : int = 0) -> void:
	location = EntityLoader.loadLocation(shortName)
	location.enter(player, toSpawnId)


func changeLocation(newLocationName : String, toSpawnId : int) -> void:
	instantiateLocation(player, newLocationName, toSpawnId)


func movePlayer(direction : int) -> void:
	location.move(player, direction)


func moveCharacter(character, direction) -> void:
	location.move(character, direction)
