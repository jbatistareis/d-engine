class_name ExecuteMoveCommand
extends Command

var targets : Array = []
var move : Move

var atkOffset : float
var cdOffset : float


func _init(executorCharacter, targets : Array, move : Move).(executorCharacter, move.cdPre) -> void:
	self.atkOffset = (1 + calculateModOffset(Enums.MoveModifierProperty.ATK_P)) - calculateModOffset(Enums.MoveModifierProperty.ATK_M)
	self.cdOffset = -(calculateModOffset(Enums.MoveModifierProperty.CD_P) - (1 + calculateModOffset(Enums.MoveModifierProperty.CD_M)))
	
	self.targets = targets
	self.move = move
	self.totalTicks = ceil(move.cdPre * cdOffset)


func calculateModOffset(moveModifierProperty : int) -> float:
	return move.modifierScale * Util.countIndividualModType(moveModifierProperty, executorCharacter.moveModifiers)


func published() -> void:
	Signals.emit_signal("startedBattleAnimation", executorCharacter, move.prepareAnimation)
	move.pick(executorCharacter)


func execute() -> void:
	if !confirmExecution():
		return
	
	move.execute(executorCharacter)
	
	# TODO enemy/player animations
	Signals.emit_signal("startedBattleAnimation", executorCharacter, move.attackAnimation)
	if executorCharacter.type != Enums.CharacterType.PC:
		while yield(Signals, "finishedBattleAnimation") != executorCharacter:
			if !confirmExecution():
				return
			pass
	
	var moveResult = move.getResult(executorCharacter)
	for target in targets:
		var sig = sign(moveResult.value)
		var value = ceil(moveResult.value * atkOffset * sig) * sig
		
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
	
	if executorCharacter.verdictActive:
		Signals.emit_signal("commandPublished", VerdictCommand.new(executorCharacter, ceil(move.cdPos * cdOffset)))
	elif executorCharacter.type == Enums.CharacterType.PC:
		Signals.emit_signal("commandPublished", AskPlayerBattleInputCommand.new(executorCharacter, ceil(move.cdPos * cdOffset)))


func confirmExecution() -> bool:
	if !BattleManager.inBattle || (executorCharacter.currentHp == 0):
		toBeExecuted = false
		remainingTicks = 0
		return false
	
	return true

