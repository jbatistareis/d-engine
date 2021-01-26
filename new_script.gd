extends Node

var character : Character
var location : Location

func _ready():
	print('TEST START')
	
	Signals.connect("characterArrivedLocation", self, 'printEntering')
	Signals.connect("characterTravelledLocation", self, 'printTraveling')
	
	LocationsDatabase.spawnEntity(1, true).enter(1, 1)
	
	location.travel(character, Enums.RoomDirection.NORTH)
	location.travel(character, Enums.RoomDirection.SOUTH)
	location.travel(character, Enums.RoomDirection.WEST)

func _process(delta):
	pass

func printEntering(character : Character, location : Location) -> void:
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
	
	print('Character \'' + character.name + '\' moving to the ' + directionStr + ' of room ' + str(fromRoom.id) + ', into room ' + str(fromRoom.id))

