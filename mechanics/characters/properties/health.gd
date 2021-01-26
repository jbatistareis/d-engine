class_name Health

var baseHp : int
var currentHp : int
var maxHp : int setget ,getMaxHp

var characterSpawnId : int
var constitution : int


func _init(baseHp : int, currentHp : int) -> void:
	self.baseHp = baseHp
	self.currentHp = currentHp


func getMaxHp() -> int:
	return baseHp + constitution


func change_hp(amount : int) -> void:
	var character = CharactersDatabase.getEntitySpawn(characterSpawnId)
	
	if amount >= 0:
		Signals.emit_signal("characterGainedHp", character, amount)
	else:
		Signals.emit_signal("characterLostHp", character, amount)
	
	if amount != 0:
		var result = currentHp + amount
		
		if result > 0:
			currentHp = result if (result < self.maxHp) else self.maxHp
		else:
			currentHp = 0
			
			Signals.emit_signal("characterDied", character)

