extends EntityDatabase

var characters : Array = [
	Character.new(1, Enums.CharacterType.PC, 'Dummy 1'),
	Character.new(2, Enums.CharacterType.FOE_NPC, 'Dummy 2')
]


func _ready():
	Signals.connect("characterDied", self, 'deSpawnEntity')


# TODO save on DB
func saveEntity(id : int) -> void:
	pass

# TODO get from DB
func getEntity(id : int) -> Character:
	return characters[id - 1]

func spawnEntity(id : int) -> Character:
	var character = .spawnEntity(id)
	Signals.emit_signal("characterSpawned", character)
	
	return character

func deSpawnEntity(spawnId : int) -> void:
	var entity = .getEntitySpawn(spawnId)
	
	if entity != null:
		Signals.emit_signal("characterDespawned", entity.spawnId, entity.id)
		.deSpawnEntity(spawnId)

