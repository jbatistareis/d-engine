class_name CharacterQuery


static func getCharacters(characterSpawnIds : Array) -> Array:
	characterSpawnIds.shuffle()
	
	var characters = []
	for characterSpawnId in characterSpawnIds:
		characters.append(CharactersDatabase.getEntitySpawn(characterSpawnId))
	
	return characters


#
# multi queries
#

static func findByHighestHp(characterSpawnIds : Array) -> Array:
	var characters = getCharacters(characterSpawnIds)
	
	var highest = 0
	for character in characters:
		if character.currentHp > highest:
			highest = character.currentHp
	
	for character in characters:
		if character.currentHp >= highest:
			return [character.spawnId]
	
	return []


static func findByLowestHp(characterSpawnIds : Array) -> Array:
	var characters = getCharacters(characterSpawnIds)
	
	var lowest = 9999
	for character in characters:
		if character.currentHp < lowest:
			lowest = character.currentHp
	
	for character in characters:
		if character.currentHp <= lowest:
			return [character.spawnId]
	
	return []


# use Enums.CharacterAbility
static func findByHighestAbilityScore(characterSpawnIds : Array, ability : int) -> Array:
	var characters = getCharacters(characterSpawnIds)
	
	var highest = 0
	for character in characters:
		if character.getScore(ability) > highest:
			highest = character.getScore(ability)
	
	for character in characters:
		if character.getScore(ability) >= highest:
			return [character.spawnId]
	
	return []


# use Enums.CharacterAbility
static func findByLowestAbilityScore(characterSpawnIds : Array, ability : int) -> Array:
	var characters = getCharacters(characterSpawnIds)
	
	var lowest = 9999
	for character in characters:
		if character.getScore(ability) < lowest:
			lowest = character.getScore(ability)
	
	for character in characters:
		if character.getScore(ability) <= lowest:
			return [character.spawnId]
	
	return []


# percentage is normalized, 0-1
static func findByPctHp(characterSpawnIds : Array, hpPctTarget : int) -> Array:
	var matches = []
	
	for characterSpawnId in characterSpawnIds:
		if isCharacterAtPctHp(characterSpawnId, hpPctTarget):
			matches.append(characterSpawnId)
	
	return matches


# TODO
# use Enums.AfflictionType
static func findByAfflictionType(characterSpawnIds : Array, type : int) -> Array:
	var matches = []
	
	for characterSpawnId in characterSpawnIds:
		if characterHasAfflictionType(characterSpawnId, type):
			matches.append(characterSpawnId)
	
	return matches


#
# individual queries
#

# percentage is normalized, 0-1
static func isCharacterAtPctHp(characterSpawnId : int, hpPctTarget : int) -> bool:
	var character = CharactersDatabase.getEntitySpawn(characterSpawnId)
	
	return max(0, min(1, hpPctTarget)) <= ((character.getCurrentHp() * 100) / character.maxHp)


# TODO
# use Enums.AfflictionType
static func characterHasAfflictionType(characterSpawnId : int, type : int) -> bool:
	return RandomNumberGenerator.new().randi_range(0, 1) == 0


# TODO
static func characterHasItem(characterSpawnId : int, itemId : int) -> bool:
	return RandomNumberGenerator.new().randi_range(0, 1) == 0

