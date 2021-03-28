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
	var spawn = spawns[toSpawnId]
	
	Signals.emit_signal("playerArrivedLocation", self)
	executeScript(entranceLogic, player)
	
	player.currentLocation = shortName
	rooms[spawn.toRoomId].enter(player)


func exit(character : Character, newLocationName : String, toSpawnId : int) -> void:
	executeScript(exitLogic, character)
	
	Signals.emit_signal("playerLeftLocation", self)
	Signals.emit_signal("playerTransferedLocation", newLocationName, toSpawnId)


func move(character : Character, direction : int) -> void:
	var canPass = false
	var fromRoom = rooms[character.currentRoomId]
	var portalId = fromRoom.getPortal(direction)
	var exitPoint = fromRoom.getExitRoom(direction)
	
	if portalId == -1: # no portal, can pass
		canPass = true
	else: # see if can pass
		canPass = portals[portalId].canPass(character)
	
	if canPass:
		if exitPoint != -1: # its a room
			var toRoom = rooms[exitPoint]
			fromRoom.exit(character)
			Signals.emit_signal("playerChangedRoom")
			toRoom.enter(character)
			
		else: # its a location
			if character.type == Enums.CharacterType.PC:
				exit(
					character,
					portals[portalId].newLocationName,
					portals[portalId].toSpawnId
				)


func executeScript(script : String, character : Character) -> void:
	ScriptTool.getReference(script).execute(character)

