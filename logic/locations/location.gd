class_name Location
extends Entity

const NOOP : String = 'func execute(character : Character) -> void:\n\treturn'

var name : String
var description : String
var rooms : Array = []
var portals : Array = []
var spawns : Array = []

var entranceLogic : String = NOOP
var exitLogic : String = NOOP

var encounterRate : float = 0.0


func _init() -> void:
	Signals.connect("changedEncounterRate", self, "changeEncounterRate")
	
	self.name = 'Base Location'
	self.shortName = 'BSELOC'


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
	var canPass = true if (portalId == 0) else findPortal(portalId).canPass(character)
	
	if (exitPoint > 0) && canPass: # move to a room
		var toRoom = findRoom(exitPoint)
		var battleTriggered = (Dice.rollNormal(Enums.DiceType.D100) <= (100 * encounterRate))
		
		fromRoom.exit(character)
		toRoom.enter(character, battleTriggered)
		
		return Enums.Direction.FORWARD if (GameManager.direction == direction) else Enums.Direction.BACKWARD
	
	if (exitPoint == 0) && canPass: # move to a location
		var portal = findPortal(portalId)
		
		if (portal != null) && !portal.newLocationName.empty():
			exit(character, portal.newLocationName, portal.toSpawnId)
	
	return Enums.Direction.NONE


func executeScript(script : String, character) -> void:
	ScriptTool.getReference(script).execute(character)


func findRoom(id : int) -> RoomTile:
	var index = rooms.bsearch_custom(id, EntityArrayHelper, 'idFind')
	
	if index >= rooms.size():
		return null
	
	var found = rooms[index]
	return found if (found.id == id) else null


func findPortal(id : int) -> RoomPortal:
	var index = portals.bsearch_custom(id, EntityArrayHelper, 'idFind')
	
	if index >= portals.size():
		return null
	
	var found = portals[index]
	return found if (found.id == id) else null


func findSpawn(id : int) -> RoomSpawn:
	var index = spawns.bsearch_custom(id, EntityArrayHelper, 'idFind')
	
	if index >= spawns.size():
		return null
	
	var found = spawns[index]
	return found if (found.id == id) else null


func changeEncounterRate(value : float) -> void:
	encounterRate = max(0.0, min(value, 1.0))

