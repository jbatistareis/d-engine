class_name CharacterQuery
#
# multi queries
#

static func findByHighestHp(characters : Array) -> Array:
	var highest = 0
	for character in characters:
		if character.currentHp > highest:
			highest = character.currentHp
	
	for character in characters:
		if character.currentHp >= highest:
			return [character.spawnId]
	
	return []


static func findByLowestHp(characters : Array) -> Array:
	var lowest = 9999
	for character in characters:
		if character.currentHp < lowest:
			lowest = character.currentHp
	
	for character in characters:
		if character.currentHp <= lowest:
			return [character.spawnId]
	
	return []


# use Enums.CharacterAbility
static func findByHighestAbilityScore(characters : Array, ability : int) -> Array:
	var highest = 0
	for character in characters:
		if character.getScore(ability) > highest:
			highest = character.getScore(ability)
	
	for character in characters:
		if character.getScore(ability) >= highest:
			return [character.spawnId]
	
	return []


# use Enums.CharacterAbility
static func findByLowestAbilityScore(characters : Array, ability : int) -> Array:
	var lowest = 9999
	for character in characters:
		if character.getScore(ability) < lowest:
			lowest = character.getScore(ability)
	
	for character in characters:
		if character.getScore(ability) <= lowest:
			return [character.spawnId]
	
	return []


# percentage is normalized, 0-1
static func findByPctHp(characters : Array, hpPctTarget : int) -> Array:
	var matches = []
	
	for character in characters:
		if max(0, min(1, hpPctTarget)) <= ((character.getCurrentHp() * 100) / character.maxHp):
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
# individual queries
#
# TODO
# use Enums.AfflictionType
static func characterHasAfflictionType(characterSpawnId : int, type : int) -> bool:
	return RandomNumberGenerator.new().randi_range(0, 1) == 0


static func characterHasItem(character : Character, item : Item) -> bool:
	for presentItem in character.inventory.items:
		if presentItem.id == item.id:
			return true
	
	return false

