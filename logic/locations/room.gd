class_name Room
extends Entity

const NOOP : String = 'func execute(character : Character) -> void:\n\treturn'

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

var entranceLogic : String = NOOP
var exitLogic : String = NOOP
var danger : float = 0 # from 0 to 1, controls the possibility of a battle ocurring

var itemShortNames : Array = [] # present item short names
var friendlyShortNames : Array = [] # present npc short names
var foeShortNameGroups : Array = [] # 2D array representing possible enemy groups

# use this for queries
var itemSpawns : Array = [] # spawned item
var friendSpawns : Array = [] # spawned npcs

var visited : bool = false

# TODO
#var stayLogic : String = NOOP
#var cd : float = 1
#var elapsed : float = 0


func _init() -> void:
	# TODO filter out unique items
	for shortName in itemShortNames:
		itemSpawns.append(EntityLoader.loadItem(shortName))
	
	for shortName in friendlyShortNames:
		var npc = EntityLoader.loadCharacter(shortName)
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
		
		var battleTriggered = (Dice.rollNormal(Enums.DiceType.D100) <= (100 * danger))
		if !foeShortNameGroups.empty() && battleTriggered:
			var enemies = []
			
			var chosenGroup = foeShortNameGroups[Dice.rollNormal(foeShortNameGroups.size() - 1)]
			for shortName in chosenGroup:
				var enemy = EntityLoader.loadCharacter(shortName)
				enemy.currentRoomId = id
				enemies.append(enemy)
			
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

