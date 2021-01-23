class_name Location
extends Entity

var name : String
var description : String

var portals : Array

var currentRoomId : int


func _init(id : int, name : String, description : String, portals : Array, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
	self.name = name
	self.description = description
	self.portals = portals


func enter(characterId : int, fromPortalId : int) -> void:
	CharactersDatabase.clearEntitySpawns()
	RoomsDatabase.clearEntitySpawns()
	
	var characterSpawnId = CharactersDatabase.spawnEntity(characterId).spawnId
	var portal = PortalsDatabase.getEntity(fromPortalId)
	var locationSpawn = LocationSpawnsDatabase.getEntityByLocationAndPortal(id, fromPortalId)
	
	Signals.emit_signal("characterArrivedLocation", characterSpawnId, id)
	
	var node = ScriptTool.getNode(characterAproachesScript)
	node.execute(characterSpawnId)
	node.free()
	
	currentRoomId = locationSpawn.roomId
	RoomsDatabase.spawnEntity(currentRoomId, true).enter(characterSpawnId)


func exit(characterSpawnId : int, fromPortalId : int) -> void:
	Signals.emit_signal("characterLeftLocation", characterSpawnId, id)
	
	var node = ScriptTool.getNode(characterLeavesScript)
	node.execute(characterSpawnId)
	node.free()
	
	var portal = PortalsDatabase.getEntity(fromPortalId)
	var newLocation = LocationsDatabase.spawnEntity(portal.pointA if (portal.pointA != id) else portal.pointB, true)
	
	newLocation.enter(characterSpawnId, portal.id)
	LocationsDatabase.deSpawnEntity(id)


# if points A or B are negative, its a location portal
func travel(characterSpawnId : int, direction : int) -> void:
	var portalId = RoomsDatabase.getEntitySpawn(currentRoomId).getPortal(direction)
	
	if (portalId != 0):
		var portal = PortalsDatabase.getEntity(portalId)
		var exitPoint = portal.pointA if (portal.pointA != currentRoomId) else portal.pointB
		
		if (portal.enter(characterSpawnId, id, currentRoomId)):
			if(exitPoint > 0):
				RoomsDatabase.getEntitySpawn(currentRoomId).exit(characterSpawnId)
				RoomsDatabase.spawnEntity(exitPoint, true).enter(characterSpawnId)
				Signals.emit_signal("characterTravelledLocation", characterSpawnId, direction, currentRoomId, exitPoint)
				
				currentRoomId = exitPoint
				
			else:
				exit(characterSpawnId, portal.id)
		
	else: # not an exit
		return

