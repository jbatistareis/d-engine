class_name Armor
extends Equipment

var protection : int
var plateValue : int
var currentProtection : int

func _init(id : int, itemId : int, protection : int = 5, currentProtection : int = 5, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, itemId, characterAproachesScript, characterLeavesScript) -> void:
	self.protection = protection if (protection >= 5) else 5
	self.currentProtection = currentProtection
	self.plateValue = floor(protection / 5)


func repair() -> void:
	var oldProtection = currentProtection
	var newProtection = currentProtection + plateValue
	currentProtection = newProtection if (newProtection < protection) else protection
	
	Signals.emit_signal("armorRepaired", spawnId, currentProtection - oldProtection)

# returns the amount of damage to the character body
func takeHit(value : int) -> int:
	Signals.emit_signal("armorTookHit", spawnId, value)
	
	if (currentProtection > 0):
		currentProtection = max(0, currentProtection + value)
		
		return 0
	else:
		return value

