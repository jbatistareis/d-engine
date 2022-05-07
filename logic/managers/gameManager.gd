extends Node

onready var currentState : State = getState(Enums.States.EXPLORING)

var player : Character setget setPlayer

# control vars
var testing : bool = false
var cameraMoving : bool = false
var direction : int setget setDirection


func _ready() -> void :
	Signals.connect("playerEnteredGame", self, "setPlayer")
	Signals.connect("battleStarted", self, "startBattleState")


func setPlayer(value : Character) -> void:
	player = value


func canMove() -> bool:
	return !cameraMoving && !BattleManager.inBattle


func setDirection(value : int) -> void:
	var correctedValue = value if (value > -1) else 3
	direction = correctedValue % 4


func startBattleState(players, enemies) -> void:
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


func _process(delta) -> void:
	currentState.handleInput()
	currentState = currentState.next

