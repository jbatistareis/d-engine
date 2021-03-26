class_name Character
extends Entity

var type : int = Enums.CharacterType.FRIENDLY_NPC

var name : String = 'Character'

var baseHp : int = 1
var currentHp : int = 1
var maxHp : int setget ,getMaxHp

var baseDamage : int = 1

var currentLevel : int = 1
var experiencePoints : int = 0
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
var verdictActive : bool = false

var currentLocation : String = ''
var currentRoom : int = 0


func getMaxHp() -> int:
	return baseHp + constitution.score


func change_hp(amount : int) -> void:
	if amount >= 0:
		Signals.emit_signal("characterGainedHp", self, amount)
	else:
		Signals.emit_signal("characterLostHp", self, amount)
	
	if amount != 0:
		var result = currentHp + amount
		
		if result > 0:
			currentHp = result if (result < self.maxHp) else self.maxHp
		else:
			currentHp = 0
			
			Signals.emit_signal("characterDied", self)


func canLevelUp() -> bool:
	return experiencePoints >= (currentLevel + 7)


func additional_levels() -> int:
	return floor(experiencePoints / (currentLevel + 7)) as int


func level_up() -> void:
	if canLevelUp():
		experiencePoints -= currentLevel + 7
		sparePoints += 1
		currentLevel += 1
		
		Signals.emit_signal("characterLeveledUp", self)


func gainExperience(amount : int) -> void:
	experiencePoints += amount
	
	Signals.emit_signal("characterGotExperience", self, amount)

