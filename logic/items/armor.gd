class_name Armor
extends Entity

# TODO expand functionality

var maxIntegrity : int
var currentIntegrity : int


func fromShortName(armorShortName : String) -> Armor:
	return fromDTO(Persistence.loadDTO(armorShortName, Enums.EntityType.ARMOR))


func fromDTO(armorDto : ArmorDTO) -> Armor:
	self.name = armorDto.name
	self.shortName = armorDto.shortName
	
	self.maxIntegrity = armorDto.maxIntegrity
	self.currentIntegrity = armorDto.currentIntegrity
	
	return self


func toDTO() -> ArmorDTO:
	var armorDto = ArmorDTO.new()
	armorDto.name = self.name
	armorDto.shortName = self.shortName
	
	armorDto.maxIntegrity = self.maxIntegrity
	armorDto.currentIntegrity = self.currentIntegrity
	
	return armorDto


# returns unsoaked damage
func changeIntegrity(amount : int) -> int:
	if currentIntegrity == 0:
		return amount
	
	elif amount != 0:
		var result = currentIntegrity + amount
		currentIntegrity = clamp(result, 0, maxIntegrity)
		Signals.emit_signal("armorChangedIntegrity", self, currentIntegrity - maxIntegrity)
		
		return int(min(0, result))
	
	else:
		Signals.emit_signal("armorChangedIntegrity", self, 0)
		
		return 0

