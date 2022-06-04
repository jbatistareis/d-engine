class_name CharacterQuery

# TODO find by move modifier

#
# multi target queries
#

static func findByHighestHp(characters : Array) -> Array:
	var matches = []
	
	var highest = 0
	for character in characters:
		if character.currentHp > highest:
			highest = character.currentHp
	
	for character in characters:
		if character.currentHp >= highest:
			matches.append(character)
	
	return matches


static func findByLowestHp(characters : Array) -> Array:
	var matches = []
	
	var lowest = 9999
	for character in characters:
		if character.currentHp < lowest:
			lowest = character.currentHp
	
	for character in characters:
		if character.currentHp <= lowest:
			matches.append(character)
	
	return matches


# use Enums.CharacterAbility
static func findByHighestAbilityScore(characters : Array, ability : int) -> Array:
	var matches = []
	
	var highest = 0
	for character in characters:
		if character.getScore(ability) > highest:
			highest = character.getScore(ability)
	
	for character in characters:
		if character.getScore(ability) >= highest:
			matches.append(character)
	
	return matches


# use Enums.CharacterAbility
static func findByLowestAbilityScore(characters : Array, ability : int) -> Array:
	var matches = []
	
	var lowest = 9999
	for character in characters:
		if character.getScore(ability) < lowest:
			lowest = character.getScore(ability)
	
	for character in characters:
		if character.getScore(ability) <= lowest:
			matches.append(character)
	
	return matches


# percentage is normalized, 0.05~0.95
static func findByHpLt(characters : Array, percent : float) -> Array:
	var matches = []
	
	for character in characters:
		if ((character.getCurrentHp() * 100.0) / character.maxHp) <= clamp(percent, 0.05 ,0.95):
			matches.append(character)
	
	return matches


# percentage is normalized, 0.05~0.95
static func findByHpGt(characters : Array, percent : float) -> Array:
	var matches = []
	
	for character in characters:
		if ((character.getCurrentHp() * 100.0) / character.maxHp) >= clamp(percent, 0.05 ,0.95):
			matches.append(character)
	
	return matches


# TODO
# use Enums.AfflictionType
static func findByAfflictionType(characters : Array, type : int) -> Array:
	var matches = []
	
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
		if presentItem.id == item.id:
			return true
	
	return false

