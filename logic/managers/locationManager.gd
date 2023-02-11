extends Node

var location : Location = null


# puts player checked a location
func changeLocation(character : Character, locationShortName : String, toRoomId : int, facingDirection : int) -> void:
	if location != null:
		location.exit(character)
	
	location = Location.new().fromShortName(locationShortName)
	SceneLoadManager.fromLocation(location)
	
	location.enter(character, toRoomId, facingDirection)


# moves a character around rooms on a relative direction
func moveCharacter(character : Character, direction : int) -> void:
	var result = location.move(character, direction)
	
	match result:
		Enums.Direction.FORWARD:
			Signals.cameraMovedForward.emit()
		
		Enums.Direction.BACKWARD:
			Signals.cameraMovedBackward.emit()
		
		Enums.Direction.NONE:
			Signals.playerRoomChangeDenied.emit()
			return
	
	Signals.playerChangedRoom.emit(direction)


func changeEncounterRate(newRate : float) -> void:
	location.changeEncounterRate(newRate)


func teleportCharacter(character : Character, toRoomId : int, facingDirection : int) -> void:
	location.teleport(character, toRoomId, facingDirection)
	
	var room = location.findRoom(toRoomId)
	Signals.cameraSnapped.emit(room.x, room.y, facingDirection)

