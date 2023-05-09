class_name Character
extends Entity

var type : int
var model : String

var baseHp : int
var currentHp : int
var extraHp : int
var maxHp : int : get = getMaxHp

var baseDamage : int

var currentLevel : int
var experiencePoints : int
var experienceToNextLevel : int : get = getExperienceToNextLevel
var sparePoints : int

var stats : Array[Stat] = []

# does not persist
var atkMod : int = 0 :
	set(value):
		atkMod = clamp(value, -3, 3)
var defMod : int = 0 :
	set(value):
		defMod = clamp(value, -3, 3)
var cdMod : int = 0 :
	set(value):
		cdMod = clamp(value, -3, 3)

var inventory : Inventory

var verdict : Verdict
var verdictActive : bool

var currentLocation : String
var currentRoom : int


func fromShortName(characterShortName : String) -> Character:
	return fromDTO(Persistence.loadDTO(characterShortName, Enums.EntityType.CHARACTER))


func fromDTO(characterDto : CharacterDTO) -> Character:
	self.name = characterDto.name
	self.shortName = characterDto.shortName
	
	self.type = characterDto.type
	self.model = characterDto.model
	
	self.baseHp = characterDto.baseHp
	self.currentHp = characterDto.currentHp
	self.extraHp = characterDto.extraHp
	
	self.baseDamage = characterDto.baseDamage
	
	self.currentLevel = characterDto.currentLevel
	self.experiencePoints = characterDto.experiencePoints
	self.sparePoints = characterDto.sparePoints
	
	stats.clear()
	stats.append(Stat.new(0))
	stats.append(Stat.new(characterDto.constitution))
	stats.append(Stat.new(characterDto.strength))
	stats.append(Stat.new(characterDto.dexterity))
	
	self.inventory = Inventory.new().fromShortName(characterDto.inventoryShortName)
	
	self.verdict = Verdict.new().fromShortName(characterDto.verdictShortName)
	self.verdictActive = characterDto.verdictActive
	
	self.currentLocation = characterDto.currentLocation
	self.currentRoom = characterDto.currentRoom
	
	return self


func toDTO() -> CharacterDTO:
	var characterDto = CharacterDTO.new()
	characterDto.name = self.name
	characterDto.shortName = self.shortName
	
	characterDto.type = self.type
	characterDto.model = self.model
	
	characterDto.baseHp = self.baseHp
	characterDto.currentHp = self.currentHp
	characterDto.extraHp = self.extraHp
	
	characterDto.baseDamage = self.baseDamage
	
	characterDto.currentLevel = self.currentLevel
	characterDto.experiencePoints = self.experiencePoints
	characterDto.sparePoints = self.sparePoints
	
	characterDto.constitution = self.stats[1].score
	characterDto.strength = self.stats[2].score
	characterDto.dexterity = self.stats[3].score
	
	characterDto.strength = self.strength.score
	characterDto.dexterity = self.dexterity.score
	characterDto.constitution = self.constitution.score
	
	characterDto.inventoryShortName = self.inventory.shortName
	
	characterDto.verdictShortName = self.verdict.shortName
	characterDto.verdictActive = self.verdictActive
	
	characterDto.currentLocation = self.currentLocation
	characterDto.currentRoom = self.currentRoom
	
	return characterDto


func getMaxHp() -> int:
	if stats.size() > Enums.CharacterAbility.CONSTITUTION:
		return baseHp + stats[Enums.CharacterAbility.CONSTITUTION].score
	else:
		return 0


# use Enums.CharacterAbility
func getStat(ability : int) -> Stat:
	return stats[ability]


# use Enums.CharacterAbility
func getScore(ability : int) -> int:
	return stats[ability].score


# use Enums.CharacterModifier
func getModifier(modifier : int) -> int:
	return stats[modifier].modifier


func takeHit(amount : int, bypassArmor : bool = false) -> void:
	if currentHp == 0:
		return
	
	if amount < 0:
		var positiveScale = inventory.armor.positiveScale if (inventory.armor != null) else 0.05
		var negativeScale = inventory.armor.negativeScale if (inventory.armor != null) else 0.33
		
		var finalMod = 1
		if defMod > 0:
			finalMod = (1 - positiveScale * defMod)
			defMod = max(0, defMod - 1)
		elif defMod < 0:
			finalMod = (1 + negativeScale * abs(defMod))
			defMod = min(0, defMod + 1)
		
		amount = floor(amount * finalMod)
		
		Signals.characterTookDamage.emit(self)
	
	if (amount < 0) && (extraHp > 0):
		amount = changeExtraHp(amount)
	
	if (amount < 0) && !bypassArmor && (inventory.armor != null):
		amount = inventory.armor.changeIntegrity(amount)
	
	if amount < 0:
		changeHp(amount)


func changeHp(amount : int) -> void:
	if currentHp == 0:
		return
	
	elif amount != 0:
		var result = currentHp + amount
		
		if result > 0:
			currentHp = min(self.maxHp, result)
		else:
			currentHp = 0
			Signals.characterDied.emit(self)
		
		Signals.characterChangedHp.emit(self, currentHp - self.maxHp)
	else:
		Signals.characterChangedHp.emit(self, 0)


# returns unsoaked damage
func changeExtraHp(amount : int) -> int:
	if currentHp == 0:
		return 0
	
	elif amount != 0:
		var prevExtraHp = extraHp
		var result = extraHp + amount
		extraHp = max(0, result)
		Signals.characterChangedExtraHp.emit(self, extraHp - prevExtraHp)
		
		return int(min(0, result))
	
	else:
		Signals.characterChangedExtraHp.emit(self, 0)
		
		return 0


func canLevelUp() -> bool:
	return experiencePoints >= self.experienceToNextLevel


func additionalLevels() -> int:
	return floor(experiencePoints / self.experienceToNextLevel) as int


func levelUp() -> void:
	if canLevelUp():
		experiencePoints -= self.experienceToNextLevel
		sparePoints += 1
		currentLevel += 1
		
		Signals.characterLeveledUp.emit(self)


func gainExperience(amount : int) -> void:
	experiencePoints += amount
	
	Signals.characterGotExperience.emit(self, amount)


# TODO a better curve
func getExperienceToNextLevel() -> int:
	return int(round(7 * pow(currentLevel, 1.3)))

