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
	var weapon3 = Weapon.new().fromShortName("BSEWPN")
	var weapon4 = Weapon.new().fromShortName("BSEWPN")
	var weapon5 = Weapon.new().fromShortName("BSEWPN")
	
	weapon.name = "Test Weapon1"
	weapon.shortName = "TSTWPN1"
	weapon2.name = "Test Weapon2"
	weapon2.shortName = "TSTWPN2"
	weapon3.name = "Test Weapon3"
	weapon3.shortName = "TSTWPN3"
	weapon4.name = "Test Weapon4"
	weapon4.shortName = "TSTWPN4"
	weapon5.name = "Test Weapon5"
	weapon5.shortName = "TSTWPN5"
	
	player.inventory.add(weapon)
	player.inventory.add(weapon2)
	player.inventory.add(weapon3)
	player.inventory.add(weapon4)
	player.inventory.add(weapon5)
	
	var item1 = Item.new().fromShortName("BSEITM")
	var item2 = Item.new().fromShortName("BSEITM")
	var item3 = Item.new().fromShortName("BSEITM")
	var item4 = Item.new().fromShortName("BSEITM")
	var item5 = Item.new().fromShortName("BSEITM")
	
	item1.shortName = "ITM1"
	item2.shortName = "ITM2"
	item3.shortName = "ITM3"
	item4.shortName = "ITM4"
	item5.shortName = "ITM5"
	
	player.inventory.add(item1)
	player.inventory.add(item2)
	player.inventory.add(item3)
	player.inventory.add(item4)
	player.inventory.add(item5)
	
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

