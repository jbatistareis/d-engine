class_name Weapon
extends Entity

var damage : int
var modifierDice : int # returns Dice.Type enum
var modifierRollType : int # returns Dice.RollType enum
var modifier : int # returns Character.Modifier enum
var cdPre : int
var cdPost : int
# characters dont earn moves
# moves should access calculateDamage on its logic
var moves : Array = [Move.new()]


# TODO dto
#func _init(name : String, moves : Array) -> void:
#	self.name = name
#	self.moves = moves


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
	
	match modifierRollType:
		Enums.DiceRollType.NORMAL:
			return Dice.rollNormal(modifierDice) + damage + modifierValue
		
		Enums.DiceRollType.BEST:
			return Dice.rollBest(modifierDice) + damage + modifierValue
		
		Enums.DiceRollType.WORST:
			return Dice.rollWorst(modifierDice) + damage + modifierValue
		
		_: # Dice.RollType.NONE
			return damage + modifierValue

