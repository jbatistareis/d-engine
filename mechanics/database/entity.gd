class_name Entity

const _INTERNAL_CHARACTER_SCRIPT_NOOP : String = 'extends Node\nfunc execute(characterSpawnId : int) -> void:\n\treturn'

var id : int
var spawnId : int = 0

var characterAproachesScript : String
var characterLeavesScript : String
var characterNearbyScript : String


func _init(id : int, characterAproachesScript : String = '', characterLeavesScript : String = '', characterNearbyScript : String = '') -> void:
	self.id = id
	self.characterAproachesScript = characterAproachesScript if !characterAproachesScript.empty() else _INTERNAL_CHARACTER_SCRIPT_NOOP
	self.characterLeavesScript = characterLeavesScript if !characterLeavesScript.empty() else _INTERNAL_CHARACTER_SCRIPT_NOOP
	self.characterNearbyScript = characterNearbyScript if !characterNearbyScript.empty() else _INTERNAL_CHARACTER_SCRIPT_NOOP

