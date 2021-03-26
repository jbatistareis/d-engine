extends Node

var playerSpawnId : int
var location : Location


func _ready():
	Signals.connect("playerStartedAtLocation", self, "instantiateLocation")
	Signals.connect("playerTransferLocation", self, "changeLocation")
	Signals.connect("playerMoved", self, "movePlayer")
	Signals.connect("characterMoved", self, "moveCharacter")


func instantiateLocation(characterId : int, locationName : String, toSpawnId : int = 0) -> void:
	var file = File.new()
	file.open_compressed(
		"res://data/locations/" + str(locationName),
		File.READ,
		File.COMPRESSION_ZSTD
	)
	location = file.get_var()
	file.close()
	
	playerSpawnId = location.enter(characterId, toSpawnId)


func changeLocation(newLocationName : String, toSpawnId : int) -> void:
	instantiateLocation(CharactersDatabase.getEntitySpawn(playerSpawnId).id, newLocationName, toSpawnId)


func movePlayer(direction : int) -> void:
	location.move(CharactersDatabase.getEntitySpawn(playerSpawnId), direction)


func moveCharacter(character, direction) -> void:
	location.move(character, direction)

