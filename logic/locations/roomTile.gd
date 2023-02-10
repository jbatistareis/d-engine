class_name RoomTile

var id : int

var x : int
var y : int
var type : int
var orientation : int
var model : String

var exits : Array

var canEnterLogic : String
var enteringLogic : String
var exitingLogic : String

var foeShortNameGroups : Array

var visited : bool


func fromDict(roomTileDict : Dictionary) -> RoomTile:
	self.id = roomTileDict.id
	
	self.x = roomTileDict.x
	self.y = roomTileDict.y
	self.type = roomTileDict.type
	self.orientation = roomTileDict.orientation
	self.model = roomTileDict.model
	
	self.exits = roomTileDict.exits
	
	self.canEnterLogic = roomTileDict.canEnterLogic
	self.enteringLogic = roomTileDict.enteringLogic
	self.exitingLogic = roomTileDict.exitingLogic
	
	self.foeShortNameGroups = roomTileDict.foeShortNameGroups
	
	self.visited = roomTileDict.visited
	
	return self


func toDict() -> Dictionary:
	return {
		'id': self.id,
		'x': self.x,
		'y': self.y,
		'type': self.type, # use  Enums.RoomType
		'orientation': self.orientation, # use Enums.Direction
		'model': self.model,
		'exits': self.exits,
		'canEnterLogic': self.canEnterLogic,
		'enteringLogic': self.enteringLogic,
		'exitingLogic': self.exitingLogic,
		'foeShortNameGroups': self.foeShortNameGroups, # 2D array representing possible enemy groups
		'visited': self.visited,
	}


func enter(character, direction : int, battleTriggered : bool) -> void:
	visited = true
	executeScript(enteringLogic, character, direction)
	
	character.currentRoom = id
	
	if character.type == Enums.CharacterType.PC:
		if !foeShortNameGroups.is_empty() && battleTriggered:
			var enemies = []
			
			var chosenGroup = foeShortNameGroups[Dice.rollNormal(foeShortNameGroups.size(), -1)]
			for shortName in chosenGroup:
				if !shortName.is_empty():
					var enemy = Character.new().fromShortName(shortName)
					enemy.currentRoom = id
					enemies.append(enemy)
			
			# TODO form a player party
			Signals.emit_signal("battleStarted", [character], enemies)


func exit(character, direction : int) -> void:
	executeScript(exitingLogic, character, direction)


func executeScript(script : String, character, direction : int) -> void:
	ScriptTool.getReference(script).execute(character, direction)


func setOrientation(value : int) -> void:
	var correctedValue = value if (value > -1) else 3
	orientation = correctedValue % 4


func getExit(direction : int) -> int:
	return exits[direction]

