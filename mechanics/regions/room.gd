class_name Room
extends Entity

var location : int setget ,getLocation

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
var characterSpawns : Array = [] setget ,getCharacterSpawns # spawned players ids
var itemSpawns : Array = [] setget ,getItemSpawns # spawned item ids
var friendSpawns : Array = [] setget ,getFriendSpawns # spawned npcs ids
var foeSpawns : Array = [] setget ,getFoeSpawns # spawned enemies ids

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


func getLocation() -> int:
	return location


func getCharacterSpawns() -> Array:
	return characterSpawns


func getItemSpawns() -> Array:
	return itemSpawns


func getFriendSpawns() -> Array:
	return friendSpawns


func getFoeSpawns() -> Array:
	return foeSpawns


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
	ScriptTool.execute(characterAproachesScript, characterSpawnId)
	
	CharactersDatabase.getEntitySpawn(characterSpawnId).setCurrentRoomId(id)
	characterSpawns.append(characterSpawnId)
	characterSpawns.sort()
	
	for id in itemIds:
		var item = ItemsDatabase.spawnEntity(id)
		ScriptTool.execute(item.characterAproachesScript, characterSpawnId)
		itemSpawns.append(item.spawnId)
	itemSpawns.sort()
	
	for id in friendlyIds:
		var character = CharactersDatabase.spawnEntity(id)
		character.setCurrentRoom(id)
		ScriptTool.execute(character.characterAproachesScript, characterSpawnId)
		friendSpawns.append(character.spawnId)
	friendSpawns.sort()
	
	for id in foeIds:
		var character = CharactersDatabase.spawnEntity(id)
		character.setCurrentRoom(id)
		ScriptTool.execute(character.characterAproachesScript, characterSpawnId)
		foeSpawns.append(character.spawnId)
	foeSpawns.sort()


func exit(characterSpawnId : int) -> void:
	Signals.emit_signal("characterLeftRoom", characterSpawnId, spawnId)
	ScriptTool.execute(characterLeavesScript, characterSpawnId)
	
	for itemSpawnId in itemSpawns:
		ScriptTool.execute(
				ItemsDatabase.getEntitySpawn(itemSpawnId).characterAproachesScript,
				characterSpawnId)
		ItemsDatabase.deSpawnEntity(itemSpawnId)
	itemSpawns.clear()
	
	for npcId in friendSpawns:
		ScriptTool.execute(
				CharactersDatabase.getEntitySpawn(npcId).characterAproachesScript,
				characterSpawnId)
		CharactersDatabase.deSpawnEntity(npcId)
	friendSpawns.clear()
	
	for enemyId in foeSpawns:
		ScriptTool.execute(
				CharactersDatabase.getEntitySpawn(enemyId).characterAproachesScript,
				characterSpawnId)
		CharactersDatabase.deSpawnEntity(enemyId)
	foeSpawns.clear()
	
	characterSpawns.erase(characterSpawnId)


func onEnemyDeath(spawnId : int) -> void:
	if (foeSpawns.find(spawnId) > -1):
		foeIds.erase(CharactersDatabase.getEntitySpawn(spawnId).id)
		foeSpawns.erase(spawnId)
		foeSpawns.sort()
		CharactersDatabase.deSpawnEntity(spawnId)

