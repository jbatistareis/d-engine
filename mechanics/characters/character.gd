class_name Character
extends Entity

var type : int setget ,getType

var name : String setget ,getName
var health : Health setget ,getHealth
var baseDamage : int setget ,getBaseDamage
var level : Level setget ,getLevel

var strength : Stat setget ,getStrength
var dexterity : Stat setget ,getDexterity
var constitution : Stat setget ,getConstitution
var intelligence : Stat setget ,getIntelligence
var wisdom : Stat setget ,getWisdom
var charisma : Stat setget ,getCharisma

var weaponId : int setget setWeaponId, getWeaponId
var armorId : int setget setArmorId, getArmorId

var moves : Moves setget ,getMoves

var currentRoomId : int setget setCurrentRoomId,getCurrentRoomId


func _init(id : int, type : int, name : String, baseHp : int = 1, currentHp : int = 1, baseDamage : int = Enums.DiceType.D4, level : int = 1, experience : int = 0, sparePoints : int = 0, strengthScore : int = 1, dexterityScore : int = 1, constitutionScore : int = 1, intelligenceScore : int = 1, wisdomScore : int = 1, charismaScore : int = 1, weaponId : int = 1, armorId : int = 1, moveIds : Array = [], currentRoomId : int = 0, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, characterAproachesScript, characterLeavesScript):
	self.type = type
	
	self.name = name
	self.health = Health.new(baseHp, currentHp)
	self.baseDamage = baseDamage
	
	self.level = Level.new(level, experience, sparePoints)
	
	self.strength = Stat.new(strengthScore)
	self.dexterity = Stat.new(dexterityScore)
	self.constitution = Stat.new(constitutionScore)
	self.intelligence = Stat.new(intelligenceScore)
	self.wisdom = Stat.new(wisdomScore)
	self.charisma = Stat.new(charismaScore)
	
	self.weaponId = weaponId
	self.armorId = armorId
	
	self.moves = Moves.new(moveIds)
	
	self.currentRoomId = currentRoomId


# Enums.CharacterType
func getType() -> int:
	return type


func getName() -> String:
	return name


func getHealth() -> Health:
	health.spawnId = spawnId
	health.constitution = constitution.score
	
	return health


func getBaseDamage() -> int:
	return baseDamage


func getLevel() -> Level:
	level.spawnId = spawnId
	
	return level


func getStrength() -> Stat:
	return strength


func getDexterity() -> Stat:
	return dexterity


func getConstitution() -> Stat:
	return constitution


func getIntelligence() -> Stat:
	return intelligence


func getWisdom() -> Stat:
	return wisdom


func getCharisma() -> Stat:
	return charisma


func setWeaponId(value : int) -> void:
	weaponId = value


func getWeaponId() -> int:
	return weaponId


func setArmorId(value : int) -> void:
	armorId = value


func getArmorId() -> int:
	return armorId


func getMoves() -> Moves:
	return moves


func setCurrentRoomId(value : int) -> void:
	currentRoomId = value


func getCurrentRoomId() -> int:
	return currentRoomId

