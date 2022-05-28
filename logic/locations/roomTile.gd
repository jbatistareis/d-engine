class_name RoomTile
extends Entity

var x : int
var y : int
var type : int
var orientation : int
var mesh : String

var exits : Array
var portals : Array 

var entranceLogic : String
var exitLogic : String

# TODO spawn then
# short names of NPCs present in the room
var friendlyShortNames : Array
# 2D array representing possible enemy groups
var foeShortNameGroups : Array

var visited : bool


func _init(roomTileDict : Dictionary) -> void:
	self.id = roomTileDict.id
	self.x = roomTileDict.x
	self.y = roomTileDict.y
	self.type = roomTileDict.type
	self.orientation = roomTileDict.orientation
	self.mesh = roomTileDict.mesh
	
	self.exits = roomTileDict.exits
	self.portals = roomTileDict.portals
	
	self.entranceLogic = roomTileDict.entranceLogic
	self.exitLogic = roomTileDict.exitLogic
	
	self.friendlyShortNames = roomTileDict.friendlyShortNames
	self.foeShortNameGroups = roomTileDict.foeShortNameGroups
	
	self.visited = roomTileDict.visited


func enter(character, battleTriggered : bool) -> void:
	visited = true
	executeScript(entranceLogic, character)
	
	character.currentRoom = id
	
	if character.type == Enums.CharacterType.PC:
		if !foeShortNameGroups.empty() && battleTriggered:
			var enemies = []
			
			var chosenGroup = foeShortNameGroups[Dice.rollNormal(foeShortNameGroups.size(), -1)]
			for shortName in chosenGroup:
				if !shortName.empty():
					var enemy = Character.new(shortName)
					enemy.currentRoom = id
					enemies.append(enemy)
			
			Signals.emit_signal("battleStarted", [character], enemies) # TODO form a player party


func exit(character) -> void:
	executeScript(exitLogic, character)


func executeScript(script : String, character) -> void:
	ScriptTool.getReference(script).execute(character)


func setOrientation(value : int) -> void:
	var correctedValue = value if (value > -1) else 3
	orientation = correctedValue % 4


func getPortal(direction : int) -> int:
	return portals[direction]


func getExit(direction : int) -> int:
	return exits[direction]

