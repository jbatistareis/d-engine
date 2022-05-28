class_name Armor
extends Entity

# TODO expand functionality

var maxIntegrity : int
var currentIntegrity : int


func _init(armorShortName : String) -> void:
	var dto = Persistence.loadDTO(armorShortName, Enums.EntityType.ARMOR)
	
	self.name = dto.name
	self.shortName = dto.shortName
	
	self.maxIntegrity = dto.maxIntegrity
	self.currentIntegrity = dto.currentIntegrity


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

