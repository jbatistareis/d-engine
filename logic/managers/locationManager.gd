extends Node

var player : Character
var location : Location


func _ready():
	Signals.connect("playerStartedAtLocation", self, "instantiateLocation")
	Signals.connect("playerTransferLocation", self, "changeLocation")
	Signals.connect("playerMoved", self, "movePlayer")
	Signals.connect("characterMoved", self, "moveCharacter")


func instantiateLocation(player : Character, locationName : String, toSpawnId : int = 0) -> void:
	var file = File.new()
	file.open_compressed(
		"res://data/locations/" + str(locationName),
		File.READ,
		File.COMPRESSION_ZSTD
	)
	location = file.get_var()
	file.close()


func changeLocation(newLocationName : String, toSpawnId : int) -> void:
	instantiateLocation(player, newLocationName, toSpawnId)


func movePlayer(direction : int) -> void:
	location.move(player, direction)


func moveCharacter(character, direction) -> void:
	location.move(character, direction)

