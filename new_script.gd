extends Node


func _ready() -> void:
	set_process_input(true)
	
	print('TEST START')
	
	Signals.connect("playerArrivedLocation", self, 'printEntering')
	Signals.connect("playerChangedRoom", self, 'printTraveling')
	
	Signals.emit_signal("playerStartedAtLocation", Character.new(), 'baseLocation', 47)


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

