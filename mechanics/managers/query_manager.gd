extends Node

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func randomizeResult(matches : Array) -> int:
	return matches[rng.randi_range(1, matches.size()) - 1] if !matches.empty() else null


#
# multi queries
#

func findByHighestHp(characterSpawnIds : Array) -> int:
	var matches = []
	
	var character
	var highest = 0
	for characterSpawnId in characterSpawnIds:
		character = CharactersDatabase.getEntitySpawn(characterSpawnId)
		if (character.currentHp > highest): highest = character.currentHp
	
	for characterSpawnId in characterSpawnIds:
		character = CharactersDatabase.getEntitySpawn(characterSpawnId)
		if (character.currentHp >= highest): matches.append(character.spawnId)
	
	return randomizeResult(matches)

func findByLowestHp(characterSpawnIds : Array) -> int:
	var matches = []
	
	var character
	var lowest = 9999
	for characterSpawnId in characterSpawnIds:
		character = CharactersDatabase.getEntitySpawn(characterSpawnId)
		if (character.currentHp < lowest): lowest = character.currentHp
	
	for characterSpawnId in characterSpawnIds:
		character = CharactersDatabase.getEntitySpawn(characterSpawnId)
		if (character.currentHp <= lowest): matches.append(character.spawnId)
	
	return randomizeResult(matches)

# use Enums.CharacterAbility
func findByHighestAbilityScore(characterSpawnIds : Array, ability : int) -> int:
	var matches = []
	
	var character
	var highest = 0
	for characterSpawnId in characterSpawnIds:
		character = CharactersDatabase.getEntitySpawn(characterSpawnId)
		if (character.getScore(ability) > highest): highest = character.getScore(ability)
	
	for characterSpawnId in characterSpawnIds:
		character = CharactersDatabase.getEntitySpawn(characterSpawnId)
		if (character.getScore(ability) >= highest): matches.append(character.spawnId)
	
	return randomizeResult(matches)

# use Enums.CharacterAbility
func findByLowestAbilityScore(characterSpawnIds : Array, ability : int) -> int:
	var matches = []
	
	var character
	var lowest = 9999
	for characterSpawnId in characterSpawnIds:
		character = CharactersDatabase.getEntitySpawn(characterSpawnId)
		if (character.getScore(ability) < lowest): lowest = character.getScore(ability)
	
	for characterSpawnId in characterSpawnIds:
		character = CharactersDatabase.getEntitySpawn(characterSpawnId)
		if (character.getScore(ability) <= lowest): matches.append(characterSpawnId)
	
	return randomizeResult(matches)

# percentage is normalized, 0-1
func findByPctHp(characterSpawnIds : Array, hpPctTarget : int) -> int:
	var matches = []
	
	for characterSpawnId in characterSpawnIds:
		if isCharacterAtPctHp(characterSpawnId, hpPctTarget): matches.append(characterSpawnId)
	
	return randomizeResult(matches)

# TODO
# use Enums.AfflictionType
func findByAfflictionType(characterSpawnIds : Array, type : int) -> int:
	var matches = []
	
	for characterSpawnId in characterSpawnIds:
		if characterHasAfflictionType(characterSpawnId, type): matches.append(characterSpawnId)
	
	return randomizeResult(matches)


#
# individual queries
#

# percentage is normalized, 0-1
func isCharacterAtPctHp(characterSpawnId : int, hpPctTarget : int) -> bool:
	var character = CharactersDatabase.getEntitySpawn(characterSpawnId)
	
	return max(0, min(1, hpPctTarget)) <= ((character.getCurrentHp() * 100) / character.maxHp)

# TODO
# use Enums.AfflictionType
func characterHasAfflictionType(characterSpawnId : int, type : int) -> bool:
	return rng.randi_range(0, 1) == 0


# TODO
func characterHasItem(characterSpawnId : int, itemId : int) -> bool:
	return rng.randi_range(0, 1) == 0

