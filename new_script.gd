extends Node


func _ready() -> void:
	set_process_input(true)
	
	print('TEST START')
	
	Signals.connect("playerArrivedLocation", self, 'printEntering')
	Signals.connect("playerChangedRoom", self, 'printTraveling')
	
	Signals.emit_signal("playerStartedAtLocation", Character.new(), 'entity', 13)


#func _input(event) -> void:
#	if event.is_action_pressed("ui_up"):
#		Signals.emit_signal("playerMoved", Enums.Direction.NORTH)
#	elif event.is_action_pressed("ui_down"):
#		Signals.emit_signal("playerMoved", Enums.Direction.SOUTH)
#	elif event.is_action_pressed("ui_left"):
#		Signals.emit_signal("playerMoved", Enums.Direction.EAST)
#	elif event.is_action_pressed("ui_right"):
#		Signals.emit_signal("playerMoved", Enums.Direction.WEST)
#	elif event.is_action_pressed("ui_accept"):
#		pass


func _process(delta) -> void:
	pass


func printEntering(location : Location) -> void:
	print('Entering location \'' + location.name + '\'')


func printTraveling(direction : int) -> void:
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
	
	print('moving to the ' + directionStr)

