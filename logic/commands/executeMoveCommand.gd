class_name ExecuteMoveCommand
extends Command

var targets : Array = []
var move : Move

var currentTarget = null


func _init(executorCharacter, targets : Array, move : Move).(executorCharacter, move.cdPre, move.executions, move.persistent) -> void:
	self.targets = targets
	self.move = move


func published() -> void:
	Signals.emit_signal("startedBattleAnimation", executorCharacter, move.prepareAnimation)


func execute() -> void:
	if !BattleManager.inBattle:
		executed = true
		toBeExecuted = false
		return
	
	var moveResult
	for target in targets:
		currentTarget = target
		moveResult = move.getResult(executorCharacter)
		
		Signals.emit_signal("startedBattleAnimation", executorCharacter, move.attackAnimation)
		
		# TODO player animations
		if executorCharacter.type != Enums.CharacterType.PC:
			yield(Signals, "finishedBattleAnimation")
		
		match moveResult.outcome:
			Enums.DiceOutcome.BEST:
				Signals.emit_signal("startedBattleAnimation", target, 'damage')
				target.takeHit(moveResult.value)
			
			# TODO
			Enums.DiceOutcome.WITH_CONSEQUENCE: # reduces damage by a factor of '(STR + DEX + WIS) / 3'
				Signals.emit_signal("startedBattleAnimation", target, 'damage')
				.takeHit(
					max(1, floor(moveResult.value / max(1, ((target.strength.modifier + target.dexterity.modifier + target.wisdom.modifier) / 3)))))
			
			_: # Enums.DiceOutcome.WORST
				target.takeHit(0) # TODO miss
		
		if target.currentHp == 0:
			Signals.emit_signal("startedBattleAnimation", target, 'death')
	
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


func shouldResume(character) -> void:
	if character == currentTarget:
		Signals.emit_signal("commandsResumed")
