class_name Armor
extends Entity

var name : String
var maxIntegrity : int = 0
var currentIntegrity : int = 0


# returns the amount of damage to the character body
func changeIntegrity(amount : int) -> int:
	if amount != 0:
		var result = currentIntegrity + amount
		currentIntegrity = min(maxIntegrity, result) if (result >= 0) else 0
		amount = result if (result < 0) else 0
	
	Signals.emit_signal("armorChangedIntegrity", self, currentIntegrity - maxIntegrity)
	
	return 0 if (currentIntegrity > 0) else amount

