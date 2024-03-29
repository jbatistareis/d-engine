extends Node

@onready var currentState : State = getState(Enums.States.EXPLORING)

var player : Character
var party : Array[Character] = [] : get = getParty

# control vars
var testing : bool = false
var cameraMoving : bool = false
var direction : int : set = setDirection

# format:
#	{
#		'LOCATION': {
#			'VARIABLE': <String, int, float, bool>
#		}
#	}
#
# cells that reacts to variables (eg.: doors) must have code that checks the variable state on its script
var variables : Dictionary = {}


func _ready() -> void :
	Signals.playerLoaded.connect(loadData)
	Signals.battleStarted.connect(startBattleState)


# TODO proper party
func getParty() -> Array[Character]:
	return [player]


func storeVariable(location : String, variableName : String, value) -> void:
	if !variables.has(location):
		variables[location] = {}
	
	variables[location][variableName] = value


func accessVariable(location : String, variableName : String):
	if !variables.has(location) || !variables[location].has(variableName):
		push_error(ErrorMessages.VARIABLE_NOT_FOUND % [variableName, location])
		return null
	
	return variables[location][variableName]


# TODO define a save format, load data, transitions, etc...
func loadData(saveSlotName : String) -> void:
	var saveDto = Persistence.loadDTO(saveSlotName, Enums.EntityType.SAVE_DATA)
	# define a save format
#	LocationManager.changeLocation(player, location, roomId, direction)
	pass


# TODO define a save format, gather data
func saveData(saveSlotName : String) -> void:
	var saveDto = SaveDTO.new()
	saveDto.shortName = saveSlotName
	
	Persistence.saveDTO(saveDto)


func canMove() -> bool:
	return !cameraMoving && !BattleManager.inBattle


func setDirection(value : int) -> void:
	var correctedValue = value if (value > -1) else 3
	direction = correctedValue % 4


func startBattleState(_players, _enemies) -> void:
	currentState = getState(Enums.States.BATTLE)



func getState(id : int) -> State:
	match id:
		Enums.States.EXPLORING:
			return ExploringState.new()
		
		Enums.States.BATTLE:
			return BattleState.new()
		
		Enums.States.EXPLORING_MENU:
			return ExploringMenuState.new()
		
		Enums.States.INVENTORY:
			return InventoryState.new()
		
		Enums.States.EQUIPMENT:
			return EquipmentState.new()
		
		Enums.States.BOOT:
			return BootState.new()
		
		Enums.States.MAIN_MENU:
			return MainMenuState.new()
		
		Enums.States.TITLE:
			return TitleState.new()
		
		_:
			return null


func _process(_delta) -> void:
	currentState.handleInput()
	currentState = currentState.next

