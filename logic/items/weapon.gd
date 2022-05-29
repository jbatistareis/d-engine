class_name Weapon
extends Entity

var damage : int
var modifierDice : int # returns Dice.Type enum
var modifierRollType : int # returns Dice.RollType enum
var modifier : int # returns Character.Modifier enum

var cdPre : int
var cdPos : int

# moves should access calculateDamage on its logic
var moves : Array = []


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
	
	self.moves.clear()
	for moveSrtNm in weaponDto.moveShortNames:
		var move = Move.new().fromShortName(moveSrtNm)
		move.cdPre += self.cdPre
		move.cdPos += self.cdPos
		self.moves.append(move)
	
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
	
	for move in self.moves:
		weaponDto.moveShortNames.append(move.shortName)
	
	return weaponDto


func calculateDamage(character) -> int:
	var modifierValue
	match modifier:
		Enums.CharacterModifier.STR:
			modifierValue = character.strength.modifier
		
		Enums.CharacterModifier.DEX:
			modifierValue = character.dexterity.modifier
		
		Enums.CharacterModifier.CON:
			modifierValue = character.constitution.modifier
		
		Enums.CharacterModifier.INT:
			modifierValue = character.intelligence.modifier
		
		Enums.CharacterModifier.WIS:
			modifierValue = character.wisdom.modifier
		
		Enums.CharacterModifier.CHA:
			modifierValue = character.charisma.modifier
			
		_: # Character.Modifier.NONE
			modifierValue = 0
	
	match modifierRollType:
		Enums.DiceRollType.NORMAL:
			return Dice.rollNormal(modifierDice) + damage + modifierValue
		
		Enums.DiceRollType.BEST:
			return Dice.rollBest(modifierDice) + damage + modifierValue
		
		Enums.DiceRollType.WORST:
			return Dice.rollWorst(modifierDice) + damage + modifierValue
		
		_: # Dice.RollType.NONE
			return damage + modifierValue

