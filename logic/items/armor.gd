class_name Armor
extends Entity

var name : String
var maxProtection : int
var currentProtection : int

var plateValue : int


#armor items equip the character when interacted
func _init(id : int, name : String, maxProtection : int = 0) -> void:
	self.name = name
	self.maxProtection = maxProtection if (maxProtection >= 5) else 5
	self.currentProtection = maxProtection
	self.plateValue = floor(maxProtection / 5)


# returns the amount of damage to the character body
func takeHit(value : int) -> int:
	if value < 0:
		Signals.emit_signal("armorTookHit", self, value)
	else:
		Signals.emit_signal("armorRepaired", self, value)
	
	if (currentProtection > 0):
		currentProtection = max(0, currentProtection + value)
		
		return 0
	else:
		return value

