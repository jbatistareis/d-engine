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


func getModifierExpression() -> String:
	match modifier:
		Enums.CharacterModifier.STR:
			return '$CHARACTER.STR'
		
		Enums.CharacterModifier.DEX:
			return '$CHARACTER.DEX'
		
		Enums.CharacterModifier.CON:
			return '$CHARACTER.CON'
		
		Enums.CharacterModifier.INT:
			return '$CHARACTER.INT'
		
		Enums.CharacterModifier.WIS:
			return '$CHARACTER.WIS'
		
		Enums.CharacterModifier.CHA:
			return '$CHARACTER.CHA'
			
		_: # Character.Modifier.NONE
			return '0'


func getDamageExpression() -> String:
	if (modifierDice == null):
		return '(' + str(damage) + ' + ' + getModifierExpression() + ')'
	
	match modifierRollType:
		Enums.DiceRollType.BEST:
			return '(' + str(Dice.rollBest(modifierDice) + damage) + ' + ' + getModifierExpression() + ')'
		
		Enums.DiceRollType.WORST:
			return '(' + str(Dice.rollWorst(modifierDice) + damage) + ' + ' + getModifierExpression() + ')'
		
		_: # Dice.RollType.NORMAL
			return '(' + str(Dice.rollNormal(modifierDice) + damage) + ' + ' + getModifierExpression() + ')'

