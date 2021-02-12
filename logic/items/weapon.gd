class_name Weapon
extends Entity

var name : String

var damage : int
var modifierDice : int # returns Dice.Type enum
var modifierRollType : int # returns Dice.RollType enum
var modifier : int # returns Character.Modifier enum
var cdPre : int
var cdPost : int


#weapon items equip the character when interacted
func _init(id : int, name : String, damage : int = 1, modifierDice : int = Enums.DiceType.D4, modifier : int = Enums.CharacterModifier.STR, cdPre : int = 1, cdPost : int = 1).(id) -> void:
	self.name = name
	self.damage = damage
	self.modifierDice = modifierDice
	self.modifierRollType = modifierRollType
	self.modifier = modifier
	self.cdPre = cdPre
	self.cdPost = cdPost


#TODO find a better way to do it
#the type of the character parameter is not specified to avoid a cyclic reference error
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
	
	if (modifierDice == null):
		return damage + modifierValue
	
	match modifierRollType:
		Enums.DiceRollType.BEST:
			return Dice.rollBest(modifierDice) + damage + modifierValue
		
		Enums.DiceRollType.WORST:
			return Dice.rollWorst(modifierDice) + damage + modifierValue
		
		_: # Dice.RollType.NORMAL
			return Dice.rollNormal(modifierDice) + damage + modifierValue

