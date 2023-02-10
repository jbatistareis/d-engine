class_name ExecuteMoveCommand
extends Command

var targets : Array = []
var move : Move

var atkOffset : float
var cdOffset : float


func _init(executorCharacter,targets : Array,move : Move,executorCharacter,move.cdPre):
	self.targets = targets
	self.move = move
	
	var atkP = Util.countIndividualModType(Enums.MoveModifierProperty.ATK_P, executorCharacter.moveModifiers)
	var atkM = Util.countIndividualModType(Enums.MoveModifierProperty.ATK_M, executorCharacter.moveModifiers)
	
	var cdP = Util.countIndividualModType(Enums.MoveModifierProperty.CD_P, executorCharacter.moveModifiers)
	var cdM = Util.countIndividualModType(Enums.MoveModifierProperty.CD_M, executorCharacter.moveModifiers)
	
	self.atkOffset = max(0, (1 + (move.modifierScale * atkP)) * (1 - (move.modifierScale * atkM)))
	self.cdOffset = max(0, (1 - (move.modifierScale * cdP)) * (1 + (move.modifierScale * cdM)))
	
	self.totalTicks = max(GameParameters.MIN_CD, floor(move.cdPre * cdOffset))


func calculateModOffset(moveModifierProperty : int) -> float:
	return move.modifierScale * Util.countIndividualModType(moveModifierProperty, executorCharacter.moveModifiers)


func published() -> void:
	Signals.emit_signal("startedBattleAnimation", executorCharacter, move.prepareAnimation)
	ScriptTool.getReference(move.pickExpression).pick(executorCharacter)


func execute() -> void:
	if !confirmExecution():
		return
	
	ScriptTool.getReference(move.excuteExpression).execute(executorCharacter)
	
	# TODO enemy/player animations
	Signals.emit_signal("startedBattleAnimation", executorCharacter, move.attackAnimation)
	if executorCharacter.type != Enums.CharacterType.PC:
		while await Signals.finishedBattleAnimation != executorCharacter:
			if !confirmExecution():
				return
			pass
	
	var reference = ScriptTool.getReference(move.valueExpression + '\n' + move.outcomeExpression)
	var moveResult = MoveResult.new(
		reference.getValue(executorCharacter),
		reference.getOutcome(executorCharacter))
	
	for target in targets:
		var value = floor(moveResult.value * atkOffset)
		
		match moveResult.outcome:
			Enums.DiceOutcome.BEST:
				target.takeHit(value)
			
			# TODO
			Enums.DiceOutcome.WITH_CONSEQUENCE: # reduces damage
				target.takeHit(value * randf())
			
			_: # Enums.DiceOutcome.WORST
				target.takeHit(0) # TODO miss
		
		target.applyMoveModifiers(move.targetModifiers, true)
	
	executorCharacter.applyMoveModifiers(move.executorModifiers)
	
	var cd = max(GameParameters.MIN_CD, floor(move.cdPos * cdOffset))
	if executorCharacter.verdictActive:
		Signals.emit_signal("commandPublished", VerdictCommand.new(executorCharacter, cd))
	elif executorCharacter.type == Enums.CharacterType.PC:
		Signals.emit_signal("commandPublished", AskPlayerBattleInputCommand.new(executorCharacter, cd))

