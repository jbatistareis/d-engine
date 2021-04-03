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


# used only by the player
func enter(player : Character, toSpawnId : int) -> void:
	var spawn = findSpawn(toSpawnId)
	
	Signals.emit_signal("playerArrivedLocation", self)
	executeScript(entranceLogic, player)
	
	player.currentLocation = shortName
	findRoom(spawn.toRoomId).enter(player)


func exit(character : Character, newLocationName : String, toSpawnId : int) -> void:
	executeScript(exitLogic, character)
	
	Signals.emit_signal("playerLeftLocation", self)
	Signals.emit_signal("playerTransferedLocation", newLocationName, toSpawnId)


func move(character : Character, direction : int) -> void:
	var canPass = false
	var fromRoom = findRoom(character.currentRoom)
	var portalId = fromRoom.getPortal(direction)
	var exitPoint = fromRoom.getExitRoom(direction)
	
	if portalId == 0: # no portal, can pass
		canPass = true
	else: # see if can pass
		canPass = findPortal(portalId).canPass(character)
	
	if canPass:
		if exitPoint != 0: # its a room
			var toRoom = findRoom(exitPoint)
			fromRoom.exit(character)
			toRoom.enter(character)
			Signals.emit_signal("playerChangedRoom", direction)
			
		else: # its a location
			if character.type == Enums.CharacterType.PC:
				var portal = findPortal(portalId)
				exit(character, portal.newLocationName, portal.toSpawnId)


func executeScript(script : String, character : Character) -> void:
	ScriptTool.getReference(script).execute(character)


func findRoom(id : int) -> Room:
	return rooms[rooms.bsearch_custom(id, EntityArrayHelper, 'idFind')]


func findPortal(id : int) -> Room:
	return portals[portals.bsearch_custom(id, EntityArrayHelper, 'idFind')]


func findSpawn(id : int) -> Room:
	return spawns[spawns.bsearch_custom(id, EntityArrayHelper, 'idFind')]

