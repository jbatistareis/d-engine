class_name Armor
extends Entity

var name : String
var maxIntegrity : int = 0
var currentIntegrity : int = 0


# returns unsoaked damage
func changeIntegrity(amount : int) -> int:
	if currentIntegrity == 0:
		return amount
	
	elif amount != 0:
		var result = currentIntegrity + amount
		currentIntegrity = min(maxIntegrity, max(0, result))
		Signals.emit_signal("armorChangedIntegrity", self, currentIntegrity - maxIntegrity)
		
		return int(min(0, result))
	
	else:
		Signals.emit_signal("armorChangedIntegrity", self, 0)
		
		return 0

