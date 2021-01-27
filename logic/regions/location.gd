class_name Location
extends Entity

var name : String
var description : String

var portals : Array


func _init(id : int, name : String, description : String, portals : Array, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
	self.name = name
	self.description = description
	self.portals = portals


func enter(characterId : int, fromPortalId : int) -> void:
	CharactersDatabase.clearEntitySpawns()
	RoomsDatabase.clearEntitySpawns()
	
	var character = CharactersDatabase.spawnEntity(characterId)
	var portal = PortalsDatabase.getEntity(fromPortalId)
	var locationSpawn = LocationSpawnsDatabase.getEntityByLocationAndPortal(id, fromPortalId)
	
	Signals.emit_signal("characterArrivedLocation", character, self, portal)
	executeScript(characterAproachesScript, character)
	
	RoomsDatabase.spawnEntity(locationSpawn.roomId).enter(character)


func exit(character : Character, fromPortal : Portal) -> void:
	executeScript(characterLeavesScript, character)
	character.currentRoomId = 0
	
	Signals.emit_signal(
			"characterLeftLocation",
			character,
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
				
				Signals.emit_signal("characterTravelledLocation", character, direction, fromRoom, toRoom)
				
			else:
				exit(character, portal)
		
	else: # not an exit
		return


func executeScript(script : String, character : Character) -> void:
	var node = ScriptTool.getNode(script)
	node.execute(character)
	node.queue_free()

