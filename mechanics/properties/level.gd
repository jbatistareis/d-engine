class_name Level

var current : int setget ,getCurrent
var experience : int setget ,getExperience
var sparePoints : int setget ,get_sparePoints

var spawnId : int setget setSpawnId


func _init(level : int, experience : int, sparePoints : int) -> void:
	self.current = level
	self.experience = experience
	self.sparePoints = sparePoints


func getCurrent() -> int:
	return current


func getExperience() -> int:
	return experience


func get_sparePoints() -> int:
	return sparePoints


func setSpawnId(value : int) -> void:
	spawnId = value


func canLevelUp() -> bool:
	return experience >= (current + 7)


func additional_levels() -> int:
	return floor(experience / (current + 7)) as int


func level_up() -> void:
	if canLevelUp():
		experience -= current + 7
		sparePoints += 1
		current += 1
		
		Signals.emit_signal("characterLeveledUp", spawnId, current)


func gainExperience(amount : int) -> void:
	experience += amount
	
	Signals.emit_signal("characterGotExperience", spawnId, amount)

