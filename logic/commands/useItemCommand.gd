class_name UseItemCommand
extends Command

var itemMove : Move
var targets : Array = []


func _init(executorCharacter, targets : Array, itemMove : Move).(executorCharacter, GameParameters.MIN_CD) -> void:
	self.targets = targets
	self.itemMove = itemMove


func execute() -> void:
	if !confirmExecution():
		return
	
	var item = executorCharacter.inventory.items.bsearch_custom(itemMove.shortName, EntityArrayHelper, 'shortNameFind')
	executorCharacter.inventory.items.erase(item)
	
	ScriptTool.getReference(itemMove.excuteExpression).execute(executorCharacter, targets)
	
	if executorCharacter.verdictActive:
		Signals.emit_signal("commandPublished", VerdictCommand.new(executorCharacter, GameParameters.MIN_CD))
	elif executorCharacter.type == Enums.CharacterType.PC:
		Signals.emit_signal("commandPublished", AskPlayerBattleInputCommand.new(executorCharacter, GameParameters.MIN_CD))

