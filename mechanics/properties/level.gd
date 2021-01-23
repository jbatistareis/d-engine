class_name Level

var current : int
var experience : int
var sparePoints : int

var spawnId : int


func _init(level : int, experience : int, sparePoints : int) -> void:
	self.current = level
	self.experience = experience
	self.sparePoints = sparePoints


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

