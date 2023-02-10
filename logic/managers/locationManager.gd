extends Node

var location : Location = null


# puts player checked a location
func changeLocation(character : Character, locationShortName : String, toRoomId : int, facingDirection : int) -> void:
	if location != null:
		location.exit(character)
	
	location = Location.new().fromShortName(locationShortName)
	SceneLoadManager.fromLocation(location)
	
	location.enter(character, toRoomId, facingDirection)


# moves a character around rooms based checked an absolute direction
func moveCharacter(character : Character, direction : int) -> void:
	var result = location.move(character, direction)
	
	match result:
		Enums.Direction.FORWARD:
			Signals.emit_signal("cameraMovedForward")
		
		Enums.Direction.BACKWARD:
			Signals.emit_signal("cameraMovedBackward")
		
		Enums.Direction.NONE:
			Signals.emit_signal("playerRoomChangeDenied")
			return
	
	Signals.emit_signal("playerChangedRoom", direction)


func changeEncounterRate(newRate : float) -> void:
	location.changeEncounterRate(newRate)


func teleportCharacter(character : Character, toRoomId : int, facingDirection : int) -> void:
	location.teleport(character, toRoomId, facingDirection)
	
	var room = location.findRoom(toRoomId)
	Signals.emit_signal("cameraSnapped", room.x, room.y, facingDirection)

