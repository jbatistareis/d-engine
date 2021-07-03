extends Node

onready var currentState : State = getState(Enums.States.IDLE)

# player vars
var testing : bool = false
var direction : int setget setDirection


func setDirection(value : int) -> void:
	var correctedValue = value if (value > -1) else 3
	direction = correctedValue % 4


func getState(id : int) -> State:
	match id:
		Enums.States.IDLE:
			return IdleState.new()
		
		Enums.States.MOVE_BACKWARD:
			return MoveBackwardState.new()
		
		Enums.States.ROTATE_LEFT:
			return RotateLeftState.new()
		
		Enums.States.ROTATE_RIGHT:
			return RotateRightState.new()
		
		Enums.States.MOVE_FORWARD:
			return MoveForwardState.new()
		
		Enums.States.BATTLE_MENU:
			return BattleMenuState.new()
		
		Enums.States.GAME_MENU:
			return GameMenuState.new()
		
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


func _input(event : InputEvent) -> void:
	if currentState != null:
		currentState.handleInput(event)
		currentState = currentState.next

