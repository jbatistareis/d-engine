class_name Location
extends Entity

var name : String
var description : String


func _init(id : int, name : String, description : String, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
	self.name = name
	self.description = description


# used only by the player
func enter(characterId : int, fromRoomId : int) -> int:
	CharactersDatabase.clearEntitySpawns()
	RoomsDatabase.clearEntitySpawns()
	
	var locationSpawn = LocationSpawnsDatabase.getEntityByLocationIdAndFromRoomId(id, fromRoomId)
	var character = CharactersDatabase.spawnEntity(characterId)
	
	Signals.emit_signal("playerArrivedLocation", self)
	executeScript(characterAproachesScript, character)
	
	RoomsDatabase.spawnEntity(locationSpawn.toRoomId).enter(character)
	
	return character.spawnId


func exit(character : Character, newLocationId : int, fromRoom : Room) -> void:
	executeScript(characterLeavesScript, character)
	
	Signals.emit_signal("playerLeftLocation", self)
	Signals.emit_signal("playerTransferLocation", id, newLocationId, fromRoom.id)


# if points A or B are negative, its a location portal
func move(character : Character, direction : int) -> void:
	var goingToExit = false
	var fromRoom = RoomsDatabase.getEntitySpawn(character.currentRoomId)
	
	if fromRoom.getExitRoom(direction) != 0: #its a passage
		if fromRoom.getPortal(direction) == 0: #can pass
			goingToExit = true
		else: #see if can pass
			goingToExit = PortalsDatabase.getEntity(fromRoom.getPortal(direction)).canPass(character)
	
	if goingToExit:
		var exitPointId = fromRoom.getExitRoom(direction)
		
		if exitPointId > 0: #its a room
			var toRoom = RoomsDatabase.spawnEntity(exitPointId)
			fromRoom.exit(character)
			toRoom.enter(character)
			
			Signals.emit_signal("characterTravelled", character, direction, fromRoom, toRoom)
				
		else: #its a location
			if character.type == Enums.CharacterType.PC:
				exit(character, -exitPointId, fromRoom.id)


func executeScript(script : String, character : Character) -> void:
	ScriptTool.getReference(script).execute(character)

