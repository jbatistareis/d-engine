class_name Armor
extends Entity

var name : String
var protection : int
var currentProtection : int

var plateValue : int


#armor items equip the character when interacted
func _init(id : int, name : String, protection : int = 0).(id) -> void:
	self.name = name
	self.protection = protection if (protection >= 5) else 5
	self.currentProtection = protection
	self.plateValue = floor(protection / 5)


# returns the amount of damage to the character body
func takeHit(value : int) -> int:
	Signals.emit_signal("armorTookHit", self, value)
	
	if (currentProtection > 0):
		currentProtection = max(0, currentProtection + value)
		
		return 0
	else:
		return value

