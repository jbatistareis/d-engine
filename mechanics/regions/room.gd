class_name Room
extends Entity

var location : int

var northPortal : int
var southPortal : int
var eastPortal : int
var westPortal : int

var entranceLogic : String
var exitLogic : String
var stayLogic : String
var cd : float

var itemIds : Array # item ids
var friendlyIds : Array # npc ids
var foeIds : Array # enemy ids

# use this for queries
var characterSpawns : Array = [] # spawned players ids
var itemSpawns : Array = [] # spawned item ids
var friendSpawns : Array = [] # spawned npcs ids
var foeSpawns : Array = [] # spawned enemies ids

var visited : bool

var elapsed : float = 0


func _init(id : int, location : int, northPortal : int = 0, southPortal : int = 0, eastPortal : int = 0, westPortal : int = 0, cd : float = 1, itemIds : Array = [], friendlyIds : Array = [], foeIds : Array = [], visited : bool = false, characterAproachesScript : String = '', characterLeavesScript : String = '', characterNearbyScript : String = '').(id, characterAproachesScript, characterLeavesScript, characterNearbyScript) -> void:
	self.location = location
	
	self.northPortal = northPortal
	self.southPortal = southPortal
	self.eastPortal = eastPortal
	self.westPortal = westPortal
	
	self.entranceLogic = entranceLogic
	self.exitLogic = exitLogic
	self.stayLogic = stayLogic
	self.cd = cd
	
	self.itemIds = itemIds
	self.friendlyIds = friendlyIds
	self.foeIds = foeIds
	
	self.visited = visited


func _process(delta : float) -> void:
	elapsed += delta
	
	if (elapsed >= cd):
		elapsed = 0
		tick()


func tick() -> void:
	for id in characterSpawns:
		ScriptTool.execute(characterNearbyScript, id)


# Enums.RoomDirection
func getPortal(direction : int) -> int:
	match direction:
		0:
			return northPortal
		1:
			return southPortal
		2:
			return eastPortal
		3:
			return westPortal
		_:
			return 0


# Enums.RoomDirection
func setPortal(direction : int, portalId : int) -> void:
	match direction:
		0:
			northPortal = portalId
		1:
			southPortal = portalId
		2:
			eastPortal = portalId
		3:
			westPortal = portalId
		_:
			pass


func enter(characterSpawnId : int) -> void:
	Signals.emit_signal("characterArrivedRoom", characterSpawnId, spawnId)
	executeScript(characterAproachesScript, characterSpawnId)
	
	CharactersDatabase.getEntitySpawn(characterSpawnId).currentRoomId = id
	characterSpawns.append(characterSpawnId)
	characterSpawns.sort()
	
	for id in itemIds:
		var item = ItemsDatabase.spawnEntity(id)
		executeScript(item.characterAproachesScript, characterSpawnId)
		itemSpawns.append(item.spawnId)
	itemSpawns.sort()
	
	for id in friendlyIds:
		var character = CharactersDatabase.spawnEntity(id)
		character.setCurrentRoom(id)
		executeScript(character.characterAproachesScript, characterSpawnId)
		friendSpawns.append(character.spawnId)
	friendSpawns.sort()
	
	for id in foeIds:
		var character = CharactersDatabase.spawnEntity(id)
		character.setCurrentRoom(id)
		executeScript(character.characterAproachesScript, characterSpawnId)
		foeSpawns.append(character.spawnId)
	foeSpawns.sort()


func exit(characterSpawnId : int) -> void:
	Signals.emit_signal("characterLeftRoom", characterSpawnId, spawnId)
	executeScript(characterLeavesScript, characterSpawnId)
	
	for spawnId in itemSpawns:
		executeScript(ItemsDatabase.getEntitySpawn(spawnId).characterLeavesScript, characterSpawnId)
		ItemsDatabase.deSpawnEntity(spawnId)
	itemSpawns.clear()
	
	for spawnId in friendSpawns:
		executeScript(CharactersDatabase.getEntitySpawn(spawnId).characterLeavesScript, characterSpawnId)
		CharactersDatabase.deSpawnEntity(spawnId)
	friendSpawns.clear()
	
	for spawnId in foeSpawns:
		executeScript(CharactersDatabase.getEntitySpawn(spawnId).characterLeavesScript, characterSpawnId)
		CharactersDatabase.deSpawnEntity(spawnId)
	foeSpawns.clear()
	
	characterSpawns.erase(characterSpawnId)


func executeScript(script : String, spawnId : int) -> void:
	var node = ScriptTool.getNode(script)
	node.execute(spawnId)
	node.free()

