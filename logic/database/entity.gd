class_name Entity

const _INTERNAL_SCRIPT_NOOP : String = 'extends Node\nfunc execute(character : Character) -> void:\n\treturn'

var id : int
var spawnId : int = 0 setget setSpawnId,getSpawnId

var characterAproachesScript : String
var characterLeavesScript : String
var interactScript : String


func _init(id : int, characterAproachesScript : String = '', characterLeavesScript : String = '', interactScript : String = '') -> void:
	self.id = id
	self.characterAproachesScript = characterAproachesScript if !characterAproachesScript.empty() else _INTERNAL_SCRIPT_NOOP
	self.characterLeavesScript = characterLeavesScript if !characterLeavesScript.empty() else _INTERNAL_SCRIPT_NOOP
	self.interactScript = interactScript if !interactScript.empty() else _INTERNAL_SCRIPT_NOOP


func setSpawnId(value : int) -> void:
	spawnId = value


func getSpawnId() -> int:
	return spawnId


func serialize() -> String:
	return ''

