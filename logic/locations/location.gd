class_name Location
extends Entity

var description : String
var rooms : Array = []
var portals : Array
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
	
	self.rooms.clear()
	for room in locationDto.roomDicts:
		self.rooms.append(RoomTile.new().fromDict(room))
	
	self.portals = locationDto.portals
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
	
	for room in self.rooms:
		locationDto.roomDicts.append(room.toDict())
	
	locationDto.portals = self.portals
	locationDto.spawns = self.spawns
	
	locationDto.entranceLogic = self.entranceLogic
	locationDto.exitLogic = self.exitLogic
	
	locationDto.encounterRate = self.encounterRate
	
	return locationDto


# used only by the player
func enter(player, toSpawnId : int) -> void:
	Signals.emit_signal("playerArrivedLocation", self)
	
	executeScript(entranceLogic, player)
	player.currentLocation = shortName
	findRoom(findSpawn(toSpawnId).toRoomId).enter(player, false)


func exit(character, newLocationName : String, toSpawnId : int) -> void:
	executeScript(exitLogic, character)
	
	Signals.emit_signal("playerLeftLocation", self)
	Signals.emit_signal("playerTransferedLocation", newLocationName, toSpawnId)


func move(character, direction : int) -> int:
	var fromRoom = findRoom(character.currentRoom)
	var portalId = fromRoom.getPortal(direction)
	var exitPoint = fromRoom.getExit(direction)
	var canPass = true if (portalId == 0) else canPass(findPortal(portalId).passLogic, character)
	
	if (exitPoint > 0) && canPass: # move to a room
		var toRoom = findRoom(exitPoint)
		var battleTriggered = (Dice.rollNormal(Enums.DiceType.D100) <= (100 * encounterRate))
		
		fromRoom.exit(character)
		toRoom.enter(character, battleTriggered)
		
		return Enums.Direction.FORWARD if (GameManager.direction == direction) else Enums.Direction.BACKWARD
	
	if (exitPoint == 0) && canPass: # move to a location
		var portal = findPortal(portalId)
		
		if !portal.newLocationShortName.empty():
			exit(character, portal.newLocationName, portal.toSpawnId)
	
	return Enums.Direction.NONE


func executeScript(script : String, character) -> void:
	ScriptTool.getReference(script).execute(character)


func canPass(passLogic : String, character : Character) -> bool:
	return ScriptTool.getReference(passLogic).execute(character)


func findRoom(id : int) -> RoomTile:
	return rooms[rooms.bsearch_custom(id, EntityArrayHelper, 'idFind')]


func findPortal(id : int) -> Dictionary:
	return portals[portals.bsearch_custom(id, EntityArrayHelper, 'idFind')]


func findSpawn(id : int) -> Dictionary:
	return spawns[spawns.bsearch_custom(id, EntityArrayHelper, 'idFind')]


func changeEncounterRate(value : float) -> void:
	encounterRate = max(0.0, min(value, 1.0))

