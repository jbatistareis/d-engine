class_name Character
extends Entity

var type : int = Enums.CharacterType.FRIENDLY_NPC
var model : String = ''

var name : String = 'Base Character'

var baseHp : int = 9
var currentHp : int = 10
var extraHp : int = 0
var maxHp : int setget ,getMaxHp

var baseDamage : int = 1

var currentLevel : int = 1
var experiencePoints : int = 0
var experienceToNextLevel : int setget ,getExperienceToNextLevel
var sparePoints : int = 0

var strength : Stat = Stat.new()
var dexterity : Stat = Stat.new()
var constitution : Stat = Stat.new()
var intelligence : Stat = Stat.new()
var wisdom : Stat = Stat.new()
var charisma : Stat = Stat.new()

var moves : Array = []

var inventory : Inventory = Inventory.new()

var verdict : Verdict = Verdict.new()
var verdictActive : bool = true

var currentLocation : String = ''
var currentRoom : int = 0


func _init() -> void:
	self.shortName = 'BSECHA'


func getMaxHp() -> int:
	return baseHp + constitution.score


func takeHit(amount : int, bypassArmor : bool = false) -> void:
	if currentHp == 0:
		return
	
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

