class_name Character
extends Entity

var type : int # Enums.CharacterType

var name : String
var health : Health setget ,getHealth
var baseDamage : int
var level : Level

var strength : Stat
var dexterity : Stat
var constitution : Stat
var intelligence : Stat
var wisdom : Stat
var charisma : Stat

var moveIds : Moves

var inventory : Inventory

var verdictId : int
var verdictActive : bool

var currentRoomId : int


func _init(id : int, type : int, name : String, baseHp : int = 1, currentHp : int = 1, baseDamage : int = Enums.DiceType.D4, level : int = 1, experience : int = 0, sparePoints : int = 0, strengthScore : int = 1, dexterityScore : int = 1, constitutionScore : int = 1, intelligenceScore : int = 1, wisdomScore : int = 1, charismaScore : int = 1, moveIds : Array = [], inventoryId : int = 1, verdictId : int = 0, currentRoomId : int = 0, characterAproachesScript : String = '', characterLeavesScript : String = '', interactScript : String = '').(id, characterAproachesScript, characterLeavesScript, interactScript):
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
	
	self.moveIds = Moves.new(moveIds)
	
	self.inventory = InventoriesDatabase.getEntity(inventoryId)
	
	self.currentRoomId = currentRoomId
	
	self.verdictId = verdictId
	self.verdictActive = type > 0


func setSpawnId(value : int) -> void:
	.setSpawnId(value)
	health.characterSpawnId = spawnId
	level.characterSpawnId = spawnId


func getHealth() -> Health:
	health.constitution = constitution.score
	
	return health

