class_name Weapon
extends Entity

var damage : int
var modifierDice : int # returns Dice.Type enum
var modifierRollType : int # returns Dice.RollType enum
var modifier : int # returns Character.Modifier enum

var cdPre : int
var cdPos : int

# moves should access calculateDamage checked its logic
var move1 : Move = null
var move2 : Move = null
var move3 : Move = null


func fromShortName(weaponShortName : String) -> Weapon:
	return fromDTO(Persistence.loadDTO(weaponShortName, Enums.EntityType.WEAPON))


func fromDTO(weaponDto : WeaponDTO) -> Weapon:
	self.name = weaponDto.name
	self.shortName = weaponDto.shortName
	
	self.damage = weaponDto.damage
	self.modifierDice = weaponDto.modifierDice
	self.modifierRollType = weaponDto.modifierRollType
	self.modifier = weaponDto.modifier
	
	self.cdPre = weaponDto.cdPre
	self.cdPos = weaponDto.cdPos
	
	if !weaponDto.move1ShortName.is_empty():
		self.move1 = Move.new().fromShortName(weaponDto.move1ShortName)
		self.move1.cdPre += self.cdPre
		self.move1.cdPos += self.cdPos
	
	if !weaponDto.move2ShortName.is_empty():
		self.move2 = Move.new().fromShortName(weaponDto.move2ShortName)
		self.move2.cdPre += self.cdPre
		self.move2.cdPos += self.cdPos
	
	if !weaponDto.move3ShortName.is_empty():
		self.move3 = Move.new().fromShortName(weaponDto.move3ShortName)
		self.move3.cdPre += self.cdPre
		self.move3.cdPos += self.cdPos
	
	return self


func toDTO() -> WeaponDTO:
	var weaponDto = WeaponDTO.new()
	weaponDto.name = self.name
	weaponDto.shortName = self.shortName
	
	weaponDto.damage = self.damage
	weaponDto.modifierDice = self.modifierDice
	weaponDto.modifierRollType = self.modifierRollType
	weaponDto.modifier = self.modifier
	
	weaponDto.cdPre = self.cdPre
	weaponDto.cdPos = self.cdPos
	
	weaponDto.move1ShortName = self.move1.shortName if (self.move1.shortName != null) else ''
	weaponDto.move2ShortName = self.move2.shortName if (self.move2.shortName != null) else ''
	weaponDto.move3ShortName = self.move3.shortName if (self.move3.shortName != null) else ''
	weaponDto.move4ShortName = self.move4.shortName if (self.move4.shortName != null) else ''
	
	return weaponDto


func calculateDamage(character) -> int:
	match modifierRollType:
		Enums.DiceRollType.NORMAL:
			return Dice.rollNormal(modifierDice) + damage + character.getModifier(modifier)
		
		Enums.DiceRollType.BEST:
			return Dice.rollBest(modifierDice) + damage + character.getModifier(modifier)
		
		Enums.DiceRollType.WORST:
			return Dice.rollWorst(modifierDice) + damage + character.getModifier(modifier)
		
		_: # Dice.RollType.NONE
			return damage + character.getModifier(modifier)

