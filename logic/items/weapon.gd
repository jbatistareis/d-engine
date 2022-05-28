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


func _init(weaponShortName : String) -> void:
	var dto = Persistence.loadDTO(weaponShortName, Enums.EntityType.WEAPON)
	
	self.name = dto.name
	self.shortName = dto.shortName
	
	self.damage = dto.damage
	self.modifierDice = dto.modifierDice
	self.modifierRollType = dto.modifierRollType
	self.modifier = dto.modifier
	
	self.cdPre = dto.cdPre
	self.cdPos = dto.cdPos
	
	for moveSrtNm in dto.moveShortNames:
		moves.clear()
		var move = Move.new(moveSrtNm)
		move.cdPre += cdPre
		move.cdPos += cdPos
		moves.append(move)


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

