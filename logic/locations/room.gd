class_name Room
extends Entity

const NOOP : String = 'func execute(character : Character) -> void:\n\treturn'

var x : int = 0
var y : int = 0
var type : int = Enums.RoomType._0_EXIT
var orientation : int = Enums.Direction.NORTH setget setOrientation

var exits : Array = [0, 0, 0, 0, 0, 0]
var portals : Array = [0, 0, 0, 0, 0, 0]

var entranceLogic : String = NOOP
var exitLogic : String = NOOP
var alert : float = 0 # from 0 to 1, controls the possibility of a battle ocurring

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
		
		var battleTriggered = (Dice.rollNormal(Enums.DiceType.D100) <= (100 * alert))
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
	return portals[direction]


func getExit(direction : int) -> int:
	return exits[direction]

