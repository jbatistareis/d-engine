extends Spatial

var player : Character


func _init():
	Persistence.saveDTO(CharacterDTO.new())
	Persistence.saveDTO(VerdictDTO.new())
	Persistence.saveDTO(FactDTO.new())
	Persistence.saveDTO(InventoryDTO.new())
	Persistence.saveDTO(ItemDTO.new())
	Persistence.saveDTO(WeaponDTO.new())
	Persistence.saveDTO(ArmorDTO.new())
	Persistence.saveDTO(MoveDTO.new())
	Persistence.saveDTO(LocationDTO.new())
	
	player = Character.new('BSECHA')


func _ready() -> void:
	print('TEST START')
	
	
	player.name = 'Player'
	player.shortName = 'PLAYER'
	player.currentHp = 100
	player.constitution.score = 91
	player.type = Enums.CharacterType.PC
	player.verdictActive = false
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

