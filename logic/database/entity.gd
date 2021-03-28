class_name Entity

const _INTERNAL_SCRIPT_NOOP : String = 'func execute(character : Character) -> void:\n\treturn'

var id : int
var spawnId : int = 0 setget setSpawnId,getSpawnId
var shortName : String = ''


func setSpawnId(value : int) -> void:
	spawnId = value


func getSpawnId() -> int:
	return spawnId


func serialize() -> PoolByteArray:
	return var2bytes(self)

