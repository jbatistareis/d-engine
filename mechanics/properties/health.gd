class_name Health

var baseHp : int setget ,getBaseHp
var currentHp : int setget ,getCurrentHp
var maxHp : int setget ,getMaxHp

var spawnId : int setget setSpawnId
var constitution : int setget setConstitution


func _init(baseHp : int, currentHp : int) -> void:
	self.baseHp = baseHp
	self.currentHp = currentHp


func getBaseHp() -> int:
	return currentHp


func getCurrentHp() -> int:
	return currentHp


func getMaxHp() -> int:
	return baseHp + constitution


func change_hp(amount : int) -> void:
	if amount >= 0:
		Signals.emit_signal("characterGainedHp", spawnId, amount)
	else:
		Signals.emit_signal("characterLostHp", spawnId, amount)
	
	if amount != 0:
		var result = currentHp + amount
		
		if result > 0:
			currentHp = result if (result < self.maxHp) else self.maxHp
		else:
			currentHp = 0
			
			Signals.emit_signal("characterDied", spawnId)


func setSpawnId(value : int) -> void:
	spawnId = value


func setConstitution(value : int) -> void:
	constitution = value

