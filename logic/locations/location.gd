class_name Location
extends Entity

var roomTile = RoomTile.new()

var description : String
var rooms : Array = []
var spawns : Array

var entranceLogic : String
var exitLogic : String

var encounterRate : float


func _init() -> void:
	Signals.connect("changedEncounterRate", self, "changeEncounterRate")


func fromShortName(locationShortName : String) -> Location:
	return fromDTO(Persistence.loadDTO(locationShortName, Enums.EntityType.LOCATION))


func fromDTO(locationDto : LocationDTO) -> Location:
	self.name = locationDto.name
	self.shortName = locationDto.shortName
	self.description = locationDto.description
	
	self.rooms = locationDto.rooms
	self.spawns = locationDto.spawns
	
	self.entranceLogic = locationDto.entranceLogic
	self.exitLogic = locationDto.exitLogic
	
	self.encounterRate = locationDto.encounterRate
	
	return self


func toDTO() -> LocationDTO:
	var locationDto = LocationDTO.new()
	locationDto.name = self.name
	locationDto.shortName = self.shortName
	locationDto.description = self.description
	
	locationDto.rooms = self.rooms
	locationDto.spawns = self.spawns
	
	locationDto.entranceLogic = self.entranceLogic
	locationDto.exitLogic = self.exitLogic
	
	locationDto.encounterRate = self.encounterRate
	
	return locationDto


# used only by the player
func enter(player, toSpawnId : int) -> void:
	Signals.emit_signal("playerArrivedLocation", self)
	executeScript(entranceLogic, player)
	
	var spawn = findSpawn(toSpawnId)
	
	player.currentLocation = shortName
	roomTile.fromDict(findRoom(spawn.toRoomId)).enter(player, reverseDirection(spawn.direction), false)


# used only by the player
func exit(player) -> void:
	executeScript(exitLogic, player)
	Signals.emit_signal("playerLeftLocation", self)


func move(character, direction : int) -> int:
	roomTile.fromDict(findRoom(character.currentRoom))
	var exitPoint = roomTile.getExit(direction)
	
	if exitPoint != -1:
		var toRoom = findRoom(exitPoint)
		
		if canPass(toRoom.canEnterLogic, character, reverseDirection(direction)):
			roomTile.exit(character, direction)
			
			roomTile.fromDict(toRoom)
			roomTile.enter(character, reverseDirection(direction), Dice.rollNormal(Enums.DiceType.D100) <= (100 * encounterRate))
			
			return Enums.Direction.FORWARD if (GameManager.direction == direction) else Enums.Direction.BACKWARD
	
	return Enums.Direction.NONE


func executeScript(script : String, character) -> void:
	ScriptTool.getReference(script).execute(character)


func canPass(passLogic : String, character : Character, direction : int) -> bool:
	return ScriptTool.getReference(passLogic).execute(character, direction)


func findRoom(id : int) -> Dictionary:
	return rooms[rooms.bsearch_custom(id, EntityArrayHelper, 'idFind')]


func findSpawn(id : int) -> Dictionary:
	return GameParameters.spwanBase
#	return spawns[spawns.bsearch_custom(id, EntityArrayHelper, 'idFind')]


func changeEncounterRate(value : float) -> void:
	encounterRate = clamp(value, 0.0, 1.0)


func reverseDirection(direction : int) -> int:
	return (direction + 2) % 4

