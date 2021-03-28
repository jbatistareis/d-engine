extends Node


func _ready() -> void:
	set_process_input(true)
	
	print('TEST START')
	
	Signals.connect("playerArrivedLocation", self, 'printEntering')
	Signals.connect("characterTravelled", self, 'printTraveling')
	
	Signals.emit_signal("playerStartedAtLocation", Character.new(), 'test', 0)


func _input(event) -> void:
	if event.is_action_pressed("ui_up"):
		Signals.emit_signal("playerMoved", Enums.RoomDirection.NORTH)
	elif event.is_action_pressed("ui_down"):
		Signals.emit_signal("playerMoved", Enums.RoomDirection.SOUTH)
	elif event.is_action_pressed("ui_left"):
		Signals.emit_signal("playerMoved", Enums.RoomDirection.EAST)
	elif event.is_action_pressed("ui_right"):
		Signals.emit_signal("playerMoved", Enums.RoomDirection.WEST)
	elif event.is_action_pressed("ui_accept"):
		pass


func _process(delta) -> void:
	pass


func printEntering(location : Location) -> void:
	print('Entering location \'' + location.name + '\'')


func printTraveling(character : Character, direction : int, fromRoom : Room, toRoom : Room) -> void:
	var directionStr
	
	match direction:
		0:
			directionStr = 'north'
		1:
			directionStr = 'east'
		2:
			directionStr = 'south'
		3:
			directionStr = 'west'
		_:
			directionStr = ''
	
	print('Character \'' + character.name + '\' moving to the ' + directionStr + ' of room ' + str(fromRoom.id) + ', into room ' + str(toRoom.id))

