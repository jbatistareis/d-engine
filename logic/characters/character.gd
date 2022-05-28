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

var strength : Stat
var dexterity : Stat
var constitution : Stat
var intelligence : Stat
var wisdom : Stat
var charisma : Stat

# does not persist
var moveModifiers : Array = []

var inventory : Inventory

var verdict : Verdict
var verdictActive : bool

var currentLocation : String
var currentRoom : int


func _init(characterShortName : String) -> void:
	var dto = Persistence.loadDTO(characterShortName, Enums.EntityType.CHARACTER)
	
	self.name = dto.name
	self.shortName = dto.shortName
	
	self.type = dto.type
	self.model = dto.model
	
	self.baseHp = dto.baseHp
	self.currentHp = dto.currentHp
	self.extraHp = dto.extraHp
	
	self.baseDamage = dto.baseDamage
	
	self.currentLevel = dto.currentLevel
	self.experiencePoints = dto.experiencePoints
	self.sparePoints = dto.sparePoints
	
	self.strength = Stat.new(dto.strength)
	self.dexterity = Stat.new(dto.dexterity)
	self.constitution = Stat.new(dto.constitution)
	self.intelligence = Stat.new(dto.intelligence)
	self.wisdom = Stat.new(dto.wisdom)
	self.charisma = Stat.new(dto.charisma)
	
	self.inventory = Inventory.new(dto.inventoryShortName)
	
	self.verdict = Verdict.new(dto.verdictShortName)
	self.verdictActive = dto.verdictActive
	
	self.currentLocation = dto.currentLocation
	self.currentRoom = dto.currentRoom


func getMaxHp() -> int:
	return baseHp + constitution.score


func takeHit(amount : int, bypassArmor : bool = false) -> void:
	if currentHp == 0:
		return
	elif amount < 0:
		Signals.emit_signal("characterTookDamage", self)
		
		var defOffset = (0.2 * countModifiersByProperty(Enums.MoveModifierProperty.DEF_P)) - (1 + 0.2 * countModifiersByProperty(Enums.MoveModifierProperty.DEF_M))
		amount = -ceil(amount * defOffset)
		
		moveModifiers.erase(Enums.MoveModifierProperty.DEF_P)
		moveModifiers.erase(Enums.MoveModifierProperty.DEF_M)
	
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


func getExperienceToNextLevel() -> int:
	return int(round(7 * pow(currentLevel, 1.3)))


func countModifiersByProperty(modifierProperty : int, modifiers : Array = moveModifiers) -> int:
	var count = 0
	for modifier in modifiers:
		if modifier == modifierProperty:
			count += 1
	
	return count


func clearModifiersByType(modifierType : int) -> void:
	for modifier in moveModifiers:
		if modifier == modifierType:
			moveModifiers.erase(modifier)


func removeModifierByType(modifierType : int) -> void:
	moveModifiers.erase(modifierType)


func applyMoveModifiers(newModifiers : Array, onlyApply : bool = false) -> void:
	for modifier in newModifiers:
		if countModifiersByProperty(modifier) < 3:
			moveModifiers.append(modifier)
	
	if !onlyApply:
		_reduceModifierStack(newModifiers, Enums.MoveModifierProperty.ATK_P)
		_reduceModifierStack(newModifiers, Enums.MoveModifierProperty.ATK_M)
		_reduceModifierStack(newModifiers, Enums.MoveModifierProperty.CD_P)
		_reduceModifierStack(newModifiers, Enums.MoveModifierProperty.CD_M)


func _reduceModifierStack(newModifiers : Array, modifierType : int) -> void:
	var count = countModifiersByProperty(modifierType, newModifiers)
	if count == 0:
		moveModifiers.erase(modifierType)

