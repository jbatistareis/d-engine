class_name ExecuteMoveCommand
extends Command

var targets : Array = []
var move : Move


func _init(executorCharacter, targets : Array, move : Move).(executorCharacter, move.cdPre, move.executions, move.persistent) -> void:
	self.targets = targets
	self.move = move


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
		match moveResult.outcome:
			Enums.DiceOutcome.BEST:
				target.takeHit(moveResult.value)
			
			# TODO
			Enums.DiceOutcome.WITH_CONSEQUENCE: # reduces damage
				target.takeHit(moveResult.value * randf())
			
			_: # Enums.DiceOutcome.WORST
				target.takeHit(0) # TODO miss
	
	# TODO a persistent move effect should be applyed only one time per character
	if persistent && (executions > 0):
		Signals.emit_signal("commandPublished", self)
	elif persistent && (executions < 1):
		return
	else:
		if executorCharacter.verdictActive:
			Signals.emit_signal("commandPublished", VerdictCommand.new(executorCharacter, move.cdPost))
		else:
			Signals.emit_signal("commandPublished", AskPlayerBattleInputCommand.new(executorCharacter, move.cdPost))


func confirmExecution() -> bool:
	if !BattleManager.inBattle || (executorCharacter.currentHp == 0):
		executed = true
		toBeExecuted = false
		return false
	
	return true

