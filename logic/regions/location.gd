class_name Location
extends Entity

var name : String
var description : String

var portals : Array


func _init(id : int, name : String, description : String, portals : Array, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
	self.name = name
	self.description = description
	self.portals = portals


# used only by the player
func enter(characterId : int, fromPortalId : int) -> int:
	CharactersDatabase.clearEntitySpawns()
	RoomsDatabase.clearEntitySpawns()
	
	var character = CharactersDatabase.spawnEntity(characterId)
	var portal = PortalsDatabase.getEntity(fromPortalId)
	var locationSpawn = LocationSpawnsDatabase.getEntityByLocationAndPortal(id, fromPortalId)
	
	Signals.emit_signal("playerArrivedLocation", self, portal)
	executeScript(characterAproachesScript, character)
	
	RoomsDatabase.spawnEntity(locationSpawn.roomId).enter(character)
	
	return character.spawnId


func exit(character : Character, fromPortal : Portal) -> void:
	executeScript(characterLeavesScript, character)
	character.currentRoomId = 0
	
	Signals.emit_signal(
			"playerLeftLocation",
			self,
			LocationsDatabase.getEntity(-(fromPortal.pointA if (-fromPortal.pointA != id) else fromPortal.pointB)),
			fromPortal
	)


# if points A or B are negative, its a location portal
func travel(character : Character, direction : int) -> void:
	var fromRoom = RoomsDatabase.getEntitySpawn(character.currentRoomId)
	
	if fromRoom.getPortal(direction) != 0:
		var portal = PortalsDatabase.getEntity(fromRoom.getPortal(direction))
		var exitPoint = portal.pointA if portal.pointB == character.currentRoomId else portal.pointB
		
		if portal.enter(character, fromRoom):
			if exitPoint > 0:
				var toRoom = RoomsDatabase.spawnEntity(exitPoint)
				fromRoom.exit(character)
				toRoom.enter(character)
				
				Signals.emit_signal("characterTravelled", character, direction, fromRoom, toRoom)
				
			else:
				if character.type == Enums.CharacterType.PC:
					exit(character, portal)
		
	else: # not an exit
		return


func executeScript(script : String, character : Character) -> void:
	var node = ScriptTool.getNode(script)
	node.execute(character)
	node.queue_free()

