class_name Location
extends Entity

var roomTile : RoomTile = RoomTile.new()
var adjacentState : Dictionary = {
	Enums.Direction.NORTH: false,
	Enums.Direction.EAST: false,
	Enums.Direction.SOUTH: false,
	Enums.Direction.WEST: false
}

var description : String
var rooms : Array = []

var entranceLogic : String
var exitLogic : String

var encounterRate : float


func fromShortName(locationShortName : String) -> Location:
	return fromDTO(Persistence.loadDTO(locationShortName, Enums.EntityType.LOCATION))


func fromDTO(locationDto : LocationDTO) -> Location:
	self.name = locationDto.name
	self.shortName = locationDto.shortName
	self.description = locationDto.description
	
	self.rooms = locationDto.rooms
	
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
func enter(player, toRoomId : int, facingDirection : int) -> void:
	roomTile.fromDict(findRoom(toRoomId))
	
	Signals.emit_signal("playerArrivedLocation", self)
	Signals.emit_signal("playerSpawned", self, roomTile.x, roomTile.y, facingDirection)
	executeScript(entranceLogic, player)
	
	player.currentLocation = shortName
	roomTile.enter(player, facingDirection, false)
	checkAdjacentAccess(player)


# used only by the player
func exit(player) -> void:
	executeScript(exitLogic, player)
	Signals.emit_signal("playerLeftLocation", self)


func move(character, direction : int) -> int:
	var canMove = adjacentState[direction]
	
	if canMove:
		roomTile.exit(character, direction)
		roomTile.fromDict(findRoom(roomTile.getExit(direction)))
		roomTile.enter(character, reverseDirection(direction), Dice.rollNormal(Enums.DiceType.D100) <= (100 * encounterRate))
	
	checkAdjacentAccess(character)
	return Enums.Direction.NONE if !canMove else (Enums.Direction.FORWARD if (GameManager.direction == direction) else Enums.Direction.BACKWARD)


func checkAdjacentAccess(character) -> void:
	for direction in range(4):
		var exitPoint = roomTile.getExit(direction)
		
		if exitPoint != -1:
			var nextRoomTile = findRoom(exitPoint)
			adjacentState[direction] = ScriptTool.getReference(nextRoomTile.entryLogic).execute(character, reverseDirection(direction))
		else:
			adjacentState[direction] = false


func teleport(character : Character, toRoomId : int, facingDirection : int) -> void:
	GameManager.direction = facingDirection
	roomTile.fromDict(findRoom(toRoomId)).enter(character, reverseDirection(facingDirection), false)


func executeScript(script : String, character) -> void:
	ScriptTool.getReference(script).execute(character)


func findRoom(id : int) -> Dictionary:
	return rooms[rooms.bsearch_custom(id, func(a, b): EntityArrayHelper.idFind(a, b))]


func changeEncounterRate(value : float) -> void:
	encounterRate = clamp(value, 0.0, 1.0)


func reverseDirection(direction : int) -> int:
	return (direction + 2) % 4

