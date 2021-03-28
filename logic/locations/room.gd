class_name Room

const _NOOP : String = 'func execute(character : Character) -> void:\n\treturn'

var id : int
var x : int
var y : int
var type : int = 0
var orientation : int = 0 setget setOrientation

var northExit : int = -1
var southExit : int = -1
var eastExit : int = -1
var westExit : int = -1

var northPortal : int = -1
var southPortal : int = -1
var eastPortal : int = -1
var westPortal : int = -1

var entranceLogic : String = _NOOP
var exitLogic : String = _NOOP
var danger : float = 0 # from 0 to 1, controls the possibility of a battle ocurring

var itemIds : Array = [] # present item ids
var friendlyIds : Array = [] # present npc ids
var foeIdGroups : Array = [] # 2D array representing possible enemy groups

# use this for queries
var itemSpawns : Array = [] # spawned item
var friendSpawns : Array = [] # spawned npcs

var visited : bool = false

# TODO
#var stayLogic : String = _NOOP
#var cd : float = 1
#var elapsed : float = 0


func _init() -> void:
	for id in itemIds:
		itemSpawns.append(ItemsDatabase.spawnEntity(id))
	
	for id in friendlyIds:
		var npc = CharactersDatabase.spawnEntity(id)
		npc.currentRoomId = id
		friendSpawns.append(npc)


func enter(character : Character) -> void:
	visited = true
	executeScript(entranceLogic, character)
	
	character.currentRoom = id
	
	if character.type == Enums.CharacterType.PC:
		for item in itemSpawns:
			executeScript(item.characterAproachesScript, character)
		
		for npc in friendSpawns:
			executeScript(character.characterAproachesScript, npc)
		
		if !foeIdGroups.empty() && (danger > 0) && (Dice.rollNormal(Enums.DiceType.D100) <= (100 * danger)):
			var enemies = []
			
			for id in foeIdGroups[Dice.rollNormal(foeIdGroups.size() - 1)]: # picks a spawn combination
				var enemy = CharactersDatabase.spawnEntity(id)
				enemy.currentRoomId = id
				enemies.append(enemy)
				
				executeScript(entranceLogic, enemy)
			
			Signals.emit_signal("battleStart", [character], enemies) # TODO form a player party


func exit(character : Character) -> void:
	if character.type == Enums.CharacterType.PC:
		for item in itemSpawns:
			executeScript(item.characterLeavesScript, character)
		
		for npc in friendSpawns:
			executeScript(npc.characterLeavesScript, character)
		
	executeScript(exitLogic, character)


func executeScript(script : String, character : Character) -> void:
	ScriptTool.getReference(script).execute(character)


func setOrientation(value : int) -> void:
	var correctedValue = value if (value > -1) else 0
	orientation = correctedValue % 4


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


func getExit(direction : int) -> int:
	match direction:
		Enums.RoomDirection.NORTH:
			return northExit
		Enums.RoomDirection.SOUTH:
			return southExit
		Enums.RoomDirection.EAST:
			return eastExit
		Enums.RoomDirection.WEST:
			return westExit
		_:
			return 0

