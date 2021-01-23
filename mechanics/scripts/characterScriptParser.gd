extends Node

#	to access the character base damage:
#		$CHARACTER.BASE_DAMAGE
#
#	to access weapon damage:
#		$CHARACTER.WEAPON_DAMAGE
#
#	to access the character weapon:
#		$CHARACTER.PRIMARY_WEAPON
#
#	to access the character ability modifiers:
#		$CHARACTER.STR, $CHARACTER.DEX, $CHARACTER.CON, $CHARACTER.INT, $CHARACTER.WIS, $CHARACTER.CHA
#
#	to access the character ability scores:
#		$CHARACTER.STRENGTH, $CHARACTER.DEXTERITY, $CHARACTER.CONSTITUTION, $CHARACTER.INTELLIGENCE, $CHARACTER.WISDOM, $CHARACTER.CHARISMA
#
#	to get a value from a normal dice roll:
#		$ROLL.NORMAL.D4, $ROLL.NORMAL.D6, $ROLL.NORMAL.D8, $ROLL.NORMAL.D10, $ROLL.NORMAL.D12, $ROLL.NORMAL.D20, $ROLL.NORMAL.D100
#
#	to get a value from a best dice roll:
#		$ROLL.BEST.D4, $ROLL.BEST.D6, $ROLL.BEST.D8, $ROLL.BEST.D10, $ROLL.BEST.D12, $ROLL.BEST.D20, $ROLL.BEST.D100
#
#	to get a value from a worst dice roll:
#		$ROLL.WORST.D4, $ROLL.WORST.D6, $ROLL.WORST.D8, $ROLL.WORST.D10, $ROLL.WORST.D12, $ROLL.WORST.D20, $ROLL.WORST.D100

func parse(rawExpression : String) -> String:
	var mathExpression = rawExpression
	
	mathExpression = mathExpression.replace('$CHARACTER.WEAPON_DAMAGE', 'WeaponsDatabase.getWeapon(character.getWeapon()).getDamageExpression()')
	mathExpression = mathExpression.replace('$CHARACTER.BASE_DAMAGE', 'Dice.rollNormal(character.getBaseDamage())')
	mathExpression = mathExpression.replace('$CHARACTER.STR', 'character.getModifier(Enums.CharacterModifier.STR)')
	mathExpression = mathExpression.replace('$CHARACTER.DEX', 'character.getModifier(Enums.CharacterModifier.DEX)')
	mathExpression = mathExpression.replace('$CHARACTER.CON', 'character.getModifier(Enums.CharacterModifier.CON)')
	mathExpression = mathExpression.replace('$CHARACTER.INT', 'character.getModifier(Enums.CharacterModifier.INT)')
	mathExpression = mathExpression.replace('$CHARACTER.WIS', 'character.getModifier(Enums.CharacterModifier.WIS)')
	mathExpression = mathExpression.replace('$CHARACTER.CHA', 'character.getModifier(Enums.CharacterModifier.CHA)')
	mathExpression = mathExpression.replace('$CHARACTER.STRENGTH', 'character.getScore(Enums.CharacterAbility.STRENGTH)')
	mathExpression = mathExpression.replace('$CHARACTER.DEXTERITY', 'character.getScore(Enums.CharacterAbility.DEXTERITY)')
	mathExpression = mathExpression.replace('$CHARACTER.CONSTITUTION', 'character.getScore(Enums.CharacterAbility.CONSTITUTION)')
	mathExpression = mathExpression.replace('$CHARACTER.INTELLIGENCE', 'character.getScore(Enums.CharacterAbility.INTELLIGENCE)')
	mathExpression = mathExpression.replace('$CHARACTER.WISDOM', 'character.getScore(Enums.CharacterAbility.WISDOM)')
	mathExpression = mathExpression.replace('$CHARACTER.CHARISMA', 'character.getScore(Enums.CharacterAbility.CHARISMA)')
	mathExpression = mathExpression.replace('$ROLL.NORMAL.D4', 'Dice.rollNormal(Enums.DiceType.D4)')
	mathExpression = mathExpression.replace('$ROLL.NORMAL.D6', 'Dice.rollNormal(Enums.DiceType.D6)')
	mathExpression = mathExpression.replace('$ROLL.NORMAL.D8', 'Dice.rollNormal(Enums.DiceType.D8)')
	mathExpression = mathExpression.replace('$ROLL.NORMAL.D10', 'Dice.rollNormal(Enums.DiceType.D10)')
	mathExpression = mathExpression.replace('$ROLL.NORMAL.D12', 'Dice.rollNormal(Enums.DiceType.D12)')
	mathExpression = mathExpression.replace('$ROLL.NORMAL.D20', 'Dice.rollNormal(Enums.DiceType.D20)')
	mathExpression = mathExpression.replace('$ROLL.NORMAL.D100', 'Dice.rollNormal(Enums.DiceType.D100)')
	mathExpression = mathExpression.replace('$ROLL.BEST.D4', 'Dice.rollBest(Enums.DiceType.D4)')
	mathExpression = mathExpression.replace('$ROLL.BEST.D6', 'Dice.rollBest(Enums.DiceType.D6)')
	mathExpression = mathExpression.replace('$ROLL.BEST.D8', 'Dice.rollBest(Enums.DiceType.D8)')
	mathExpression = mathExpression.replace('$ROLL.BEST.D10', 'Dice.rollBest(Enums.DiceType.D10)')
	mathExpression = mathExpression.replace('$ROLL.BEST.D12', 'Dice.rollBest(Enums.DiceType.D12)')
	mathExpression = mathExpression.replace('$ROLL.BEST.D20', 'Dice.rollBest(Enums.DiceType.D20)')
	mathExpression = mathExpression.replace('$ROLL.BEST.D100', 'Dice.rollBest(Enums.DiceType.D100)')
	mathExpression = mathExpression.replace('$ROLL.WORST.D4', 'Dice.rollWorst(Enums.DiceType.D4)')
	mathExpression = mathExpression.replace('$ROLL.WORST.D6', 'Dice.rollWorst(Enums.DiceType.D6)')
	mathExpression = mathExpression.replace('$ROLL.WORST.D8', 'Dice.rollWorst(Enums.DiceType.D8)')
	mathExpression = mathExpression.replace('$ROLL.WORST.D10', 'Dice.rollWorst(Enums.DiceType.D10)')
	mathExpression = mathExpression.replace('$ROLL.WORST.D12', 'Dice.rollWorst(Enums.DiceType.D12)')
	mathExpression = mathExpression.replace('$ROLL.WORST.D20', 'Dice.rollWorst(Enums.DiceType.D20)')
	mathExpression = mathExpression.replace('$ROLL.WORST.D100', 'Dice.rollWorst(Enums.DiceType.D100)')
	
	while ('$' in mathExpression):
		parse(mathExpression)
	
	return mathExpression
