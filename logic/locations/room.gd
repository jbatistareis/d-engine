class_name Room
extends Entity

const NOOP : String = 'func execute(character : Character) -> void:\n\treturn'

var x : int = 0
var y : int = 0
var type : int = 0
var orientation : int = Enums.RoomDirection.NORTH setget setOrientation

var northExit : int = 0
var southExit : int = 0
var eastExit : int = 0
var westExit : int = 0

var northPortal : int = 0
var southPortal : int = 0
var eastPortal : int = 0
var westPortal : int = 0

var entranceLogic : String = NOOP
var exitLogic : String = NOOP
var danger : float = 0 # from 0 to 1, controls the possibility of a battle ocurring

var friendlyShortNames : Array = [] # present npc short names
var foeShortNameGroups : Array = [] # 2D array representing possible enemy groups

# use this for queries
var friendSpawns : Array = [] # spawned npcs

var visited : bool = false

# TODO
#var stayLogic : String = NOOP
#var cd : float = 1
#var elapsed : float = 0


func _init() -> void:
	for shortName in friendlyShortNames:
		var npc = EntityLoader.loadCharacter(shortName)
		npc.currentRoom = id
		friendSpawns.append(npc)


func enter(character : Character) -> void:
	visited = true
	executeScript(entranceLogic, character)
	
	character.currentRoom = id
	
	if character.type == Enums.CharacterType.PC:
		for npc in friendSpawns:
			executeScript(character.characterAproachesScript, npc)
		
		var battleTriggered = (Dice.rollNormal(Enums.DiceType.D100) <= (100 * danger))
		if !foeShortNameGroups.empty() && battleTriggered:
			var enemies = []
			
			var chosenGroup = foeShortNameGroups[Dice.rollNormal(foeShortNameGroups.size() - 1)]
			for shortName in chosenGroup:
				var enemy = EntityLoader.loadCharacter(shortName)
				enemy.currentRoom = id
				enemies.append(enemy)
			
			Signals.emit_signal("battleStart", [character], enemies) # TODO form a player party


func exit(character : Character) -> void:
	if character.type == Enums.CharacterType.PC:
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

