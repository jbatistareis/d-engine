extends Spatial

var player : Character


func _init():
	OS.low_processor_usage_mode = true
	player = Character.new().fromShortName('BSECHA')


func _ready() -> void:
	print('TEST START')
	
	
	player.name = 'Player'
	player.shortName = 'PLAYER'
	player.currentHp = 20
	player.constitution.score = 20
	player.type = Enums.CharacterType.PC
	player.verdictActive = false
	Signals.connect("playerArrivedLocation", self, 'printEntering')
	Signals.connect("playerChangedRoom", self, 'printTraveling')
	
	# TEST
	var weapon = Weapon.new().fromShortName("BSEWPN")
	var weapon2 = Weapon.new().fromShortName("BSEWPN")
	weapon.name = "Test Weapon"
	weapon.shortName = "TSTWPN"
	player.inventory.add(weapon)
	player.inventory.add(weapon2)
	player.inventory.add(Item.new().fromShortName("BSEITM"))
	
	GameManager.player = player
	LocationManager.changeLocation(GameManager.player, 'BSELOC', 0, Enums.Direction.EAST)


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

