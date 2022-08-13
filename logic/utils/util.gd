class_name Util


static func countIndividualModType(type : int, modifiers : Array) -> int:
	var count = 0
	for modifier in modifiers:
		if modifier == type:
			count += 1
	
	return count


static func countAbsoluteModType(type : int, modifiers : Array) -> int:
	var result = 0
	
	match type:
		Enums.MoveModifierType.ATK:
			for mod in modifiers:
				if mod == Enums.MoveModifierProperty.ATK_P:
					result += 1
				elif mod == Enums.MoveModifierProperty.ATK_M:
					result -= 1
		Enums.MoveModifierType.DEF:
			for mod in modifiers:
				if mod == Enums.MoveModifierProperty.DEF_P:
					result += 1
				elif mod == Enums.MoveModifierProperty.DEF_M:
					result -= 1
		Enums.MoveModifierType.CD:
			for mod in modifiers:
				if mod == Enums.MoveModifierProperty.CD_P:
					result += 1
				elif mod == Enums.MoveModifierProperty.CD_M:
					result -= 1
	
	return result
