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
	var fromRoom = findRoom(character.currentRoom)
	var portalId = fromRoom.getPortal(direction)
	var exitPoint = fromRoom.getExit(direction)
	
	if (exitPoint > 0) && ((portalId == 0) || findPortal(portalId).canPass(character)): # move to a room
		var toRoom = findRoom(exitPoint)
		fromRoom.exit(character)
		toRoom.enter(character)
		Signals.emit_signal("playerChangedRoom", direction)
		
	elif (character.type == Enums.CharacterType.PC) && (exitPoint == 0) && (portalId > 0): # see if can move to a location
		if findPortal(portalId).canPass(character):
			var portal = findPortal(portalId)
			exit(character, portal.newLocationName, portal.toSpawnId)


func executeScript(script : String, character : Character) -> void:
	ScriptTool.getReference(script).execute(character)


func findRoom(id : int) -> Room:
	var index = rooms.bsearch_custom(id, EntityArrayHelper, 'idFind')
	
	if index >= rooms.size():
		return null
	
	var found = rooms[index]
	return found if (found.id == id) else null


func findPortal(id : int) -> Portal:
	var index = portals.bsearch_custom(id, EntityArrayHelper, 'idFind')
	
	if index >= portals.size():
		return null
	
	var found = portals[index]
	return found if (found.id == id) else null


func findSpawn(id : int) -> Spawn:
	var index = spawns.bsearch_custom(id, EntityArrayHelper, 'idFind')
	
	if index >= spawns.size():
		return null
	
	var found = spawns[index]
	return found if (found.id == id) else null

