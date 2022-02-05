extends Spatial

var player : Character = Character.new()


func _ready() -> void:
	# TODO tests
	var character : Character = Character.new()
#	EntitySaver.saveCharacter(character)
	#
	
	print('TEST START')
	
	
	var atkP = Move.new()
	atkP.name = 'Target ATK+'
	atkP.targetModifiers.append(Enums.MoveModifierProperty.ATK_P)
	
	var atkM = Move.new()
	atkM.name = 'Target ATK-'
	atkM.targetModifiers.append(Enums.MoveModifierProperty.ATK_M)
	
	var defP = Move.new()
	defP.name = 'Target DEF+'
	defP.targetModifiers.append(Enums.MoveModifierProperty.DEF_P)
	
	var defM = Move.new()
	defM.name = 'Target DEF-'
	defM.targetModifiers.append(Enums.MoveModifierProperty.DEF_M)
	defM.targetModifiers.append(Enums.MoveModifierProperty.DEF_M)
	
	var cdP = Move.new()
	cdP.name = 'Target CD+'
	cdP.targetModifiers.append(Enums.MoveModifierProperty.CD_P)
	
	var cdM = Move.new()
	cdM.name = 'Target CD-'
	cdM.targetModifiers.append(Enums.MoveModifierProperty.CD_M)
	
	
	player.name = 'Player'
	player.shortName = 'PLAYER'
	player.currentHp = 100
	player.constitution.score = 91
	player.type = Enums.CharacterType.PC
	player.verdictActive = false
	player.moves.append_array([Move.new()])
#	player.moves.append_array([atkP, atkM, defP, defM, cdP, cdM])
	Signals.connect("playerArrivedLocation", self, 'printEntering')
	Signals.connect("playerChangedRoom", self, 'printTraveling')
	
	Signals.emit_signal("playerEnteredGame", player)
	Signals.emit_signal("playerTransferedLocation", 'BSELOC', 26)


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

