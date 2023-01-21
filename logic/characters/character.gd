class_name Character
extends Entity

var type : int
var model : String

var baseHp : int
var currentHp : int
var extraHp : int
var maxHp : int setget ,getMaxHp

var baseDamage : int

var currentLevel : int
var experiencePoints : int
var experienceToNextLevel : int setget ,getExperienceToNextLevel
var sparePoints : int

var stats : Array = []

# does not persist
var moveModifiers : Array = []

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
	for stat in Enums.CharacterAbility.values():
		stats.append(Stat.new(characterDto.stats[stat]))
	
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
	
	characterDto.stats.clear()
	for stat in stats:
		characterDto.stats.append(stat.score)
	
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
		var defP = Util.countIndividualModType(Enums.MoveModifierProperty.DEF_P, moveModifiers)
		var defM = Util.countIndividualModType(Enums.MoveModifierProperty.DEF_M, moveModifiers)
		
		var positiveScale = inventory.armor.positiveScale if (inventory.armor != null) else 0.05
		var negativeScale = inventory.armor.negativeScale if (inventory.armor != null) else 0.33
		
		amount = floor(amount * ((1 - (positiveScale * defP)) * (1 + (negativeScale * defM))))
		
		moveModifiers.erase(Enums.MoveModifierProperty.DEF_P)
		moveModifiers.erase(Enums.MoveModifierProperty.DEF_M)
		
		Signals.emit_signal("characterTookDamage", self)
	
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
			Signals.emit_signal("characterDied", self)
		
		Signals.emit_signal("characterChangedHp", self, currentHp - self.maxHp)
	else:
		Signals.emit_signal("characterChangedHp", self, 0)


# returns unsoaked damage
func changeExtraHp(amount : int) -> int:
	if currentHp == 0:
		return 0
	
	elif amount != 0:
		var prevExtraHp = extraHp
		var result = extraHp + amount
		extraHp = max(0, result)
		Signals.emit_signal("characterChangedExtraHp", self, extraHp - prevExtraHp)
		
		return int(min(0, result))
	
	else:
		Signals.emit_signal("characterChangedExtraHp", self, 0)
		
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
		
		Signals.emit_signal("characterLeveledUp", self)


func gainExperience(amount : int) -> void:
	experiencePoints += amount
	
	Signals.emit_signal("characterGotExperience", self, amount)


# TODO a better curve
func getExperienceToNextLevel() -> int:
	return int(round(7 * pow(currentLevel, 1.3)))


func clearModifiersByType(modifierType : int) -> void:
	for modifier in moveModifiers:
		if modifier == modifierType:
			moveModifiers.erase(modifier)


func removeModifierByType(modifierType : int) -> void:
	moveModifiers.erase(modifierType)


func applyMoveModifiers(newModifiers : Array, applyOnly : bool = false) -> void:
	for modifier in newModifiers:
		if Util.countIndividualModType(modifier, moveModifiers) < 3:
			moveModifiers.append(modifier)
	
	if !applyOnly:
		_reduceModifierStack(newModifiers, Enums.MoveModifierProperty.ATK_P)
		_reduceModifierStack(newModifiers, Enums.MoveModifierProperty.ATK_M)
		_reduceModifierStack(newModifiers, Enums.MoveModifierProperty.CD_P)
		_reduceModifierStack(newModifiers, Enums.MoveModifierProperty.CD_M)


# reduces only when it isnt a new stack
func _reduceModifierStack(newModifiers : Array, modifierType : int) -> void:
	var count = Util.countIndividualModType(modifierType, newModifiers)
	if count == 0:
		moveModifiers.erase(modifierType)

