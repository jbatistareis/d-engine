class_name Entity

const _INTERNAL_SCRIPT_NOOP : String = 'extends Node\nfunc execute(characterSpawnId : int) -> void:\n\treturn'

var id : int
var spawnId : int = 0

var characterAproachesScript : String
var characterLeavesScript : String
var interactScript : String


func _init(id : int, characterAproachesScript : String = '', characterLeavesScript : String = '', interactScript : String = '') -> void:
	self.id = id
	self.characterAproachesScript = characterAproachesScript if !characterAproachesScript.empty() else _INTERNAL_SCRIPT_NOOP
	self.characterLeavesScript = characterLeavesScript if !characterLeavesScript.empty() else _INTERNAL_SCRIPT_NOOP
	self.interactScript = interactScript if !interactScript.empty() else _INTERNAL_SCRIPT_NOOP

