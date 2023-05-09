class_name CharacterQuery

# TODO find by move modifier

#
# multi target queries
#

static func findByHighestHp(characters : Array[Character]) -> Array[Character]:
	var matches : Array[Character] = []
	
	var highest = 0
	for character in characters:
		if character.currentHp > highest:
			highest = character.currentHp
	
	for character in characters:
		if character.currentHp >= highest:
			matches.append(character)
	
	return matches


static func findByLowestHp(characters : Array[Character]) -> Array[Character]:
	var matches : Array[Character] = []
	
	var lowest = 9999
	for character in characters:
		if character.currentHp < lowest:
			lowest = character.currentHp
	
	for character in characters:
		if character.currentHp <= lowest:
			matches.append(character)
	
	return matches


# use Enums.CharacterAbility
static func findByHighestAbilityScore(characters : Array[Character], ability : int) -> Array[Character]:
	var matches : Array[Character] = []
	
	var highest = 0
	for character in characters:
		if character.getScore(ability) > highest:
			highest = character.getScore(ability)
	
	for character in characters:
		if character.getScore(ability) >= highest:
			matches.append(character)
	
	return matches


# use Enums.CharacterAbility
static func findByLowestAbilityScore(characters : Array[Character], ability : int) -> Array[Character]:
	var matches : Array[Character] = []
	
	var lowest = 9999999999
	for character in characters:
		if character.getScore(ability) < lowest:
			lowest = character.getScore(ability)
	
	for character in characters:
		if character.getScore(ability) <= lowest:
			matches.append(character)
	
	return matches


# percentage is clamp, 0.05~0.95
static func findByHpLt(characters : Array[Character], percent : float) -> Array[Character]:
	var matches : Array[Character] = []
	percent = clamp(percent, 0.05 ,0.95)
	
	for character in characters:
		if ((character.getCurrentHp() * 100.0) / character.maxHp) <= percent:
			matches.append(character)
	
	return matches


# percentage is clamp, 0.05~0.95
static func findByHpGt(characters : Array[Character], percent : float) -> Array[Character]:
	var matches : Array[Character] = []
	percent = clamp(percent, 0.05 ,0.95)
	
	for character in characters:
		if ((character.getCurrentHp() * 100.0) / character.maxHp) >= percent:
			matches.append(character)
	
	return matches


# use Enums.MoveModifierType, clamps to -3~3
func findByMovModLt(characters : Array[Character], moveModifierType : int, amount : int) -> Array[Character]:
	var matches : Array[Character] = []
	amount = clamp(amount, -3, 3)
	
	match moveModifierType:
		Enums.MoveModifierType.ATK:
			for character in characters:
				var sum = 0
				
				for mod in character.moveModifiers:
					if mod == Enums.MoveModifierProperty.ATK_M:
						sum -= 1
					elif mod == Enums.MoveModifierProperty.ATK_P:
						sum += 1
				
				if sum <= amount:
					matches.append(character)
		
		Enums.MoveModifierType.DEF:
			for character in characters:
				var sum = 0
				
				for mod in character.moveModifiers:
					if mod == Enums.MoveModifierProperty.DEF_M:
						sum -= 1
					elif mod == Enums.MoveModifierProperty.DEF_P:
						sum += 1
				
				if sum <= amount:
					matches.append(character)
		
		Enums.MoveModifierType.CD:
			for character in characters:
				var sum = 0
				
				for mod in character.moveModifiers:
					if mod == Enums.MoveModifierProperty.CD_M:
						sum -= 1
					elif mod == Enums.MoveModifierProperty.CD_P:
						sum += 1
				
				if sum <= amount:
					matches.append(character)
	
	return matches


# use Enums.MoveModifierType, clamps to -3~3
func findByMovModGt(characters : Array[Character], moveModifierType : int, amount : int) -> Array[Character]:
	var matches : Array[Character] = []
	amount = clamp(amount, -3, 3)
	
	match moveModifierType:
		Enums.MoveModifierType.ATK:
			for character in characters:
				var sum = 0
				
				for mod in character.moveModifiers:
					if mod == Enums.MoveModifierProperty.ATK_M:
						sum -= 1
					elif mod == Enums.MoveModifierProperty.ATK_P:
						sum += 1
				
				if sum >= amount:
					matches.append(character)
		
		Enums.MoveModifierType.DEF:
			for character in characters:
				var sum = 0
				
				for mod in character.moveModifiers:
					if mod == Enums.MoveModifierProperty.DEF_M:
						sum -= 1
					elif mod == Enums.MoveModifierProperty.DEF_P:
						sum += 1
				
				if sum >= amount:
					matches.append(character)
		
		Enums.MoveModifierType.CD:
			for character in characters:
				var sum = 0
				
				for mod in character.moveModifiers:
					if mod == Enums.MoveModifierProperty.CD_M:
						sum -= 1
					elif mod == Enums.MoveModifierProperty.CD_P:
						sum += 1
				
				if sum >= amount:
					matches.append(character)
	
	return matches


# TODO
# use Enums.AfflictionType
static func findByAfflictionType(characters : Array[Character], type : int) -> Array[Character]:
	var matches : Array[Character] = []
	
	for character in characters:
		if characterHasAfflictionType(character, type):
			matches.append(character)
	
	return matches


#
# single target queries
#
# TODO
# use Enums.AfflictionType
static func characterHasAfflictionType(character : Character, type : int) -> bool:
	return RandomNumberGenerator.new().randi_range(0, 1) == 0


static func characterHasItem(character : Character, item : Item) -> bool:
	for presentItem in character.inventory.items:
		if presentItem.shortName == item.shortName:
			return true
	
	return false

