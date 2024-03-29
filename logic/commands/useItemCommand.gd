class_name UseItemCommand
extends Command

var itemMove : Move
var targets : Array[Character] = []


func _init(executorCharacter : Character, targets : Array[Character], itemMove : Move):
	super(executorCharacter, itemMove.cdPre)
	
	self.targets = targets
	self.itemMove = itemMove


func execute() -> void:
	if !confirmExecution():
		return
	
	var index = executorCharacter.inventory.items.bsearch_custom(itemMove.shortName, func(a, b): return EntityArrayHelper.shortNameFind(a, b))
	Signals.characterUsedItem.emit(
		executorCharacter,
		targets,
		executorCharacter.inventory.items[index])
	
	if executorCharacter.verdictActive:
		Signals.commandPublished.emit(VerdictCommand.new(executorCharacter, GameParameters.MIN_CD))
	elif executorCharacter.type == Enums.CharacterType.PC:
		Signals.commandPublished.emit(AskPlayerBattleInputCommand.new(executorCharacter, GameParameters.MIN_CD))

