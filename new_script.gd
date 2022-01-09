extends Spatial

var player : Character = Character.new()


func _ready() -> void:
	# TODO tests
	var character : Character = Character.new()
	#EntitySaver.saveCharacter(character)
	#
	
	print('TEST START')
	
	player.type = Enums.CharacterType.PC
	player.verdictActive = false
	player.moves.append_array([Move.new()])
	Signals.connect("playerArrivedLocation", self, 'printEntering')
	Signals.connect("playerChangedRoom", self, 'printTraveling')
	
	Signals.emit_signal("playerStartedAtLocation", player, 'BSELOC', 26)


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

