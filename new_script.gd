extends Node

var character : Character
var location : Location


func _ready() -> void:
	set_process_input(true)
	
	print('TEST START')
	
	Signals.connect("characterArrivedLocation", self, 'printEntering')
	Signals.connect("characterTravelledLocation", self, 'printTraveling')
	
	LocationsDatabase.getEntity(1).enter(1, 1)


func _input(event) -> void:
	if event.is_action_pressed("ui_up"):
		location.travel(character, Enums.RoomDirection.NORTH)
	elif event.is_action_pressed("ui_down"):
		location.travel(character, Enums.RoomDirection.SOUTH)
	elif event.is_action_pressed("ui_left"):
		location.travel(character, Enums.RoomDirection.EAST)
	elif event.is_action_pressed("ui_right"):
		location.travel(character, Enums.RoomDirection.WEST)


func _process(delta) -> void:
	pass


func printEntering(character : Character, location : Location, fromPortal : Portal) -> void:
	self.character = character
	self.location = location
	
	print('Character \'' + character.name + '\' entering location \'' + location.name + '\'')


func printTraveling(character : Character, direction : int, fromRoom : Room, toRoom : Room) -> void:
	var directionStr
	
	match direction:
		0:
			directionStr = 'north'
		1:
			directionStr = 'south'
		2:
			directionStr = 'east'
		3:
			directionStr = 'west'
		_:
			directionStr = ''
	
	print('Character \'' + character.name + '\' moving to the ' + directionStr + ' of room ' + str(fromRoom.id) + ', into room ' + str(toRoom.id))

