class_name Weapon
extends Equipment

var damage : int
var modifierDice : int # returns Dice.Type enum
var modifierRollType : int # returns Dice.RollType enum
var modifier : int # returns Character.Modifier enum
var cdPre : int
var cdPost : int


# TODO fix expressions
func _init(id : int, itemId : int, damage : int = 1, modifierDice : int = Enums.DiceType.D4, modifier : int = Enums.CharacterModifier.STR, cdPre : int = 1, cdPost : int = 1, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, itemId, characterAproachesScript, characterLeavesScript) -> void:
	self.damage = damage
	self.modifierDice = modifierDice
	self.modifierRollType = modifierRollType
	self.modifier = modifier
	self.cdPre = cdPre
	self.cdPost = cdPost


func calculateDamage(character : Character) -> int:
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

