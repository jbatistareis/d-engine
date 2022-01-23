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
	if (!bypassArmor && (amount < 0) && (inventory.armor != null)):
		amount = inventory.armor.changeIntegrity(amount)
	
	changeHp(amount)


func changeHp(amount : int) -> void:
	if (extraHp > 0) && (amount < 0):
		var prevExtraHp = extraHp
		var result = extraHp + amount
		extraHp = result if (result >= 0) else 0
		amount = result if (result < 0) else 0
		
		Signals.emit_signal("characterChangedExtraHp", self, extraHp - prevExtraHp)
	
	if amount != 0:
		var result = currentHp + amount
		
		if result > 0:
			currentHp = result if (result < self.maxHp) else self.maxHp
		else:
			currentHp = 0
			Signals.emit_signal("characterDied", self)
	
	Signals.emit_signal("characterChangedHp", self, currentHp - self.maxHp)


func changeExtraHp(amount : int) -> void:
	var prevExtraHp = extraHp
	extraHp = max(0, min(self.maxHp, extraHp + amount))
	Signals.emit_signal("characterChangedExtraHp", self, extraHp - prevExtraHp)


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

