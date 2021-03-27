class_name Location
extends Entity

var name : String
var shortName : String
var description : String
var rooms : Array = []
var portals : Array = []
var spawns : Array = []

var entranceLogic : String = _INTERNAL_SCRIPT_NOOP
var exitLogic : String = _INTERNAL_SCRIPT_NOOP


# used only by the player
func enter(player : Character, toSpawnId : int) -> void:
	CharactersDatabase.clearEntitySpawns()
	ItemsDatabase.clearEntitySpawns()
	
	var locationSpawn = spawns[toSpawnId]
	
	Signals.emit_signal("playerArrivedLocation", self)
	executeScript(entranceLogic, player)
	
	player.currentLocation = shortName
	rooms[locationSpawn.toRoomId].enter(player)


func exit(character : Character, newLocationName : String, toSpawnId : int) -> void:
	executeScript(exitLogic, character)
	
	Signals.emit_signal("playerLeftLocation", self)
	Signals.emit_signal("playerTransferLocation", newLocationName, toSpawnId)


func move(character : Character, direction : int) -> void:
	var canPass = false
	var fromRoom = rooms[character.currentRoomId]
	var portalId = fromRoom.getPortal(direction)
	
	if portalId == -1: # no portal, can pass
		canPass = true
	else: # see if can pass
		canPass = portals[portalId].canPass(character)
	
	if canPass:
		var exitPoint = fromRoom.getExitRoom(direction)
		
		if exitPoint != -1: # its a room
			var toRoom = rooms[exitPoint]
			fromRoom.exit(character)
			toRoom.enter(character)
			
			Signals.emit_signal("characterTravelled", character, direction, fromRoom, toRoom)
			
		else: # its a location
			if character.type == Enums.CharacterType.PC:
				exit(
					character,
					portals[portalId].newLocationName,
					portals[portalId].toSpawnId
				)


func executeScript(script : String, character : Character) -> void:
	ScriptTool.getReference(script).execute(character)

