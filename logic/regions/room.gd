class_name Room
extends Entity

var location : int

var northExitRoom : int
var southExitRoom : int
var eastExitRoom : int
var westExitRoom : int

var northPortal : int
var southPortal : int
var eastPortal : int
var westPortal : int

var entranceLogic : String
var exitLogic : String
var stayLogic : String
var cd : float
var danger : float # from 0 to 1, controls the possibility of a battle ocurring

var itemIds : Array # present item ids
var friendlyIds : Array # present npc ids
var foeIdGroups : Array # 2D array representing possible enemy groups

# use this for queries
var itemSpawns : Array = [] # spawned item
var friendSpawns : Array = [] # spawned npcs

var visited : bool

var elapsed : float = 0


func _init(id : int, location : int, northExitRoom : int = 0, southExitRoom : int = 0, eastExitRoom : int = 0, westExitRoom : int = 0, northPortal : int = 0, southPortal : int = 0, eastPortal : int = 0, westPortal : int = 0, cd : float = 1, danger : float = 0,  itemIds : Array = [], friendlyIds : Array = [], foeIdGroups : Array = [], visited : bool = false, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
	self.location = location
	
	self.northExitRoom = northExitRoom
	self.southExitRoom = southExitRoom
	self.eastExitRoom = eastExitRoom
	self.westExitRoom = westExitRoom
	
	self.northPortal = northPortal
	self.southPortal = southPortal
	self.eastPortal = eastPortal
	self.westPortal = westPortal
	
	self.entranceLogic = entranceLogic
	self.exitLogic = exitLogic
	self.stayLogic = stayLogic
	self.cd = cd
	self.danger = danger
	
	self.itemIds = itemIds
	self.friendlyIds = friendlyIds
	self.foeIdGroups = foeIdGroups
	
	self.visited = visited


func enter(character : Character) -> void:
	visited = true
	Signals.emit_signal("characterArrivedRoom", character, self)
	executeScript(characterAproachesScript, character)
	
	character.currentRoomId = id
	
	if character.type == Enums.CharacterType.PC:
		for id in itemIds:
			var item = ItemsDatabase.spawnEntity(id)
			executeScript(item.characterAproachesScript, character)
			itemSpawns.append(item)
		
		for id in friendlyIds:
			var npc = CharactersDatabase.spawnEntity(id)
			npc.currentRoomId = id
			executeScript(character.characterAproachesScript, npc)
			friendSpawns.append(npc)
		
		if !foeIdGroups.empty() && (danger > 0) && (Dice.rollNormal(Enums.DiceType.D100) <= (100 * danger)):
			var enemies = []
			
			for id in foeIdGroups[Dice.rollNormal(foeIdGroups.size() - 1)]: # picks a spawn combination
				var enemy = CharactersDatabase.spawnEntity(id)
				enemy.currentRoomId = id
				enemies.append(enemy)
				
				executeScript(characterAproachesScript, enemy)
			
			Signals.emit_signal("battleStart", [character], enemies) # TODO form a player party


func exit(character : Character) -> void:
	if character.type == Enums.CharacterType.PC:
		for item in itemSpawns:
			executeScript(item.characterLeavesScript, character)
			ItemsDatabase.deSpawnEntity(item.spawnId)
		itemSpawns.clear()
		
		for npc in friendSpawns:
			executeScript(npc.characterLeavesScript, character)
			CharactersDatabase.deSpawnEntity(npc.spawnId)
		friendSpawns.clear()
		
	executeScript(characterLeavesScript, character)
	Signals.emit_signal("characterLeftRoom", character, self)


func executeScript(script : String, character : Character) -> void:
	ScriptTool.getReference(script).execute(character)


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


func getExitRoom(direction : int) -> int:
	match direction:
		Enums.RoomDirection.NORTH:
			return northExitRoom
		Enums.RoomDirection.SOUTH:
			return southExitRoom
		Enums.RoomDirection.EAST:
			return eastExitRoom
		Enums.RoomDirection.WEST:
			return westExitRoom
		_:
			return 0

