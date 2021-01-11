class_name Entity

var id : int setget ,getId
var spawnId : int = 0 setget setSpawnId, getSpawnId
var characterAproachesScript : String setget ,getCharacterAproachesScript
var characterLeavesScript : String setget ,getCharacterLeavesScript
var characterNearbyScript : String setget ,getCharacterNearbyScript


func _init(id : int, characterAproachesScript : String = '', characterLeavesScript : String = '', characterNearbyScript : String = '') -> void:
	self.id = id
	self.characterAproachesScript = characterAproachesScript
	self.characterLeavesScript = characterLeavesScript
	self.characterNearbyScript = characterNearbyScript


func getId() -> int:
	return id


func setSpawnId(value : int) -> void:
	spawnId = value


func getSpawnId() -> int:
	return spawnId


func getCharacterAproachesScript() -> String:
	return characterAproachesScript


func getCharacterLeavesScript() -> String:
	return characterLeavesScript


func getCharacterNearbyScript() -> String:
	return characterNearbyScript

