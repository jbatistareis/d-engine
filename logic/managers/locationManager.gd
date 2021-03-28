extends Node

const _LOCATION_BIN_PATH = 'res://data/locations/%s.zst'

var player : Character
var location : Location


func _ready():
	Signals.connect("playerStartedAtLocation", self, "instantiateLocation")
	Signals.connect("playerTransferedLocation", self, "changeLocation")
	Signals.connect("playerMoved", self, "movePlayer")
	Signals.connect("characterMoved", self, "moveCharacter")


func instantiateLocation(player : Character, shortName : String, toSpawnId : int = 0) -> void:
	location = readLocationFromFile(shortName)
	location.enter(player, toSpawnId)


func changeLocation(newLocationName : String, toSpawnId : int) -> void:
	instantiateLocation(player, newLocationName, toSpawnId)


func movePlayer(direction : int) -> void:
	location.move(player, direction)


func moveCharacter(character, direction) -> void:
	location.move(character, direction)


func readLocationFromFile(shortName : String) -> Location:
	var newLocation : Location
	var file = File.new()
	file.open_compressed(
		_LOCATION_BIN_PATH % shortName,
		File.READ,
		File.COMPRESSION_ZSTD)
	newLocation = bytes2var(file.get_buffer(file.get_len()))
	file.close()
	
	return newLocation


func saveLocationToFile(location : Location) -> void:
	var file = File.new()
	file.open_compressed(
		_LOCATION_BIN_PATH % location.shortName,
		File.WRITE,
		File.COMPRESSION_ZSTD)
	file.store_buffer(var2bytes(location))
	file.close()

