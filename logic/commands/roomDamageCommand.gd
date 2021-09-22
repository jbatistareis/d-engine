class_name RoomDamageCommand
extends Command

var damage : int
var characters : Array = []
var currentRoom : int


func _init(ticks, damage : int, executions : int).(null, ticks, executions, true) -> void:
	self.damage = damage


func execute() -> void:
	var playersRoom = LocationManager.player.currentRoom
	
	if playersRoom != currentRoom:
		executed = true
		return
	else:
		currentRoom = playersRoom
	
	characters.clear()
	if BattleManager.inBattle:
		for player in BattleManager.players:
			characters.append(player)
		
		for enemies in BattleManager.enemies:
			characters.append(enemies)
	else:
		characters.append(LocationManager.player)
	
	for character in characters:
		character.changeHp(damage)

