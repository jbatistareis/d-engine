extends Node

var location : Location = null


func _ready():
	Signals.connect("characterTransferedLocation", self, "changeLocation")
	Signals.connect("characterMoved", self, "moveCharacter")
	Signals.connect("characterTeleported", self, "teleportCharacter")


func changeLocation(character : Character, locationShortName : String, toRoomId : int, facingDirection : int) -> void:
	if location != null:
		location.exit(character)
	
	location = Location.new().fromShortName(locationShortName)
	SceneLoadManager.fromLocation(location)
	
	location.enter(character, toRoomId, facingDirection)


func moveCharacter(character : Character, direction : int) -> void:
	var result = location.move(character, direction)
	
	match result:
		Enums.Direction.FORWARD:
			Signals.emit_signal("cameraMovedForward")
		
		Enums.Direction.BACKWARD:
			Signals.emit_signal("cameraMovedBackward")
	
	if result == Enums.Direction.NONE:
		Signals.emit_signal("playerRoomChangeDenied")
	else:
		Signals.emit_signal("playerChangedRoom", direction)


func teleportCharacter(character : Character, toRoomId : int, facingDirection : int) -> void:
	location.teleport(character, toRoomId, facingDirection)
	
	var room = location.findRoom(toRoomId)
	Signals.emit_signal("cameraSnapped", room.x, room.y, facingDirection)

