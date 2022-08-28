class_name ExecuteMoveCommand
extends Command

const _MIN_CD : int = int(0.5 / GameParameters.GCD)

var targets : Array = []
var move : Move

var atkOffset : float
var cdOffset : float


func _init(executorCharacter, targets : Array, move : Move).(executorCharacter, move.cdPre) -> void:
	self.targets = targets
	self.move = move
	
	var atkP = Util.countIndividualModType(Enums.MoveModifierProperty.ATK_P, executorCharacter.moveModifiers)
	var atkM = Util.countIndividualModType(Enums.MoveModifierProperty.ATK_M, executorCharacter.moveModifiers)
	
	var cdP = Util.countIndividualModType(Enums.MoveModifierProperty.CD_P, executorCharacter.moveModifiers)
	var cdM = Util.countIndividualModType(Enums.MoveModifierProperty.CD_M, executorCharacter.moveModifiers)
	
	self.atkOffset = max(0, (1 + (move.modifierScale * atkP)) * (1 - (move.modifierScale * atkM)))
	self.cdOffset = max(0, (1 - (move.modifierScale * cdP)) * (1 + (move.modifierScale * cdM)))
	
	self.totalTicks = max(_MIN_CD, floor(move.cdPre * cdOffset))


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
	
	var cd = max(_MIN_CD, floor(move.cdPos * cdOffset))
	if executorCharacter.verdictActive:
		Signals.emit_signal("commandPublished", VerdictCommand.new(executorCharacter, cd))
	elif executorCharacter.type == Enums.CharacterType.PC:
		Signals.emit_signal("commandPublished", AskPlayerBattleInputCommand.new(executorCharacter, cd))


func confirmExecution() -> bool:
	if !BattleManager.inBattle || (executorCharacter.currentHp == 0):
		toBeExecuted = false
		remainingTicks = 0
		return false
	
	return true

