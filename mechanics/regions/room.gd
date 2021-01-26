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

var itemIds : Array # present item ids
var friendlyIds : Array # present npc ids
var foeIds : Array # present enemy ids

# use this for queries
var characterSpawns : Array = [] # spawned players 
var itemSpawns : Array = [] # spawned item
var friendSpawns : Array = [] # spawned npcs
var foeSpawns : Array = [] # spawned enemies

var visited : bool

var elapsed : float = 0


func _init(id : int, location : int, northPortal : int = 0, southPortal : int = 0, eastPortal : int = 0, westPortal : int = 0, cd : float = 1, itemIds : Array = [], friendlyIds : Array = [], foeIds : Array = [], visited : bool = false, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
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


func enter(character : Character) -> void:
	Signals.emit_signal("characterArrivedRoom", character, self)
	executeScript(characterAproachesScript, character)
	
	character.currentRoomId = id
	characterSpawns.append(character)
	characterSpawns.sort()
	
	for id in itemIds:
		var item = ItemsDatabase.spawnEntity(id)
		executeScript(item.characterAproachesScript, character)
		itemSpawns.append(item)
	
	for id in friendlyIds:
		var npc = CharactersDatabase.spawnEntity(id)
		npc.currentRoomId = id
		executeScript(character.characterAproachesScript, npc)
		friendSpawns.append(npc)
	
	for id in foeIds:
		var npc = CharactersDatabase.spawnEntity(id)
		npc.currentRoomId = id
		executeScript(character.characterAproachesScript, npc)
		foeSpawns.append(npc)
	
	visited = true


func exit(character : Character) -> void:
	for item in itemSpawns:
		executeScript(item.characterLeavesScript, character)
		ItemsDatabase.deSpawnEntity(item.spawnId)
	itemSpawns.clear()
	
	for npc in friendSpawns:
		executeScript(npc.characterLeavesScript, character)
		CharactersDatabase.deSpawnEntity(npc.spawnId)
	friendSpawns.clear()
	
	for npc in foeSpawns:
		executeScript(npc.characterLeavesScript, character)
		CharactersDatabase.deSpawnEntity(npc.spawnId)
	foeSpawns.clear()
	
	characterSpawns.erase(character)
	
	executeScript(characterLeavesScript, character)
	Signals.emit_signal("characterLeftRoom", character, self)


func executeScript(script : String, character : Character) -> void:
	var node = ScriptTool.getNode(script)
	node.execute(character)
	node.queue_free()


func getPortal(direction : int) -> int:
	match direction:
		Enums.RoomDirection.NORTH:
			return northPortal
		Enums.RoomDirection.SOUTH:
			return southPortal
		Enums.RoomDirection.EAST:
			return eastPortal
		Enums.RoomDirection.WEST:
			return westPortal
		_:
			return 0

