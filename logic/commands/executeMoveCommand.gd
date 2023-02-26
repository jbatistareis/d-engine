class_name ExecuteMoveCommand
extends Command

var targets : Array = []
var move : Move

var atkOffset : float = 1
var cdOffset : float = 1


func _init(executorCharacter,targets : Array,move : Move):
	super(executorCharacter, move.cdPre)
	
	self.targets = targets
	self.move = move
	
	if executorCharacter.atkMod > 0:
		self.atkOffset = (1 + move.modifierScale * executorCharacter.atkMod)
	elif executorCharacter.atkMod < 0:
		self.atkOffset = (1 - move.modifierScale * abs(executorCharacter.atkMod))
	
	if executorCharacter.cdMod > 0:
		self.cdOffset = (1 - move.modifierScale * executorCharacter.cdMod)
	elif executorCharacter.atkMod < 0:
		self.cdOffset = (1 + move.modifierScale * abs(executorCharacter.cdMod))
	
	self.totalTicks = max(GameParameters.MIN_CD, floor(move.cdPre * self.cdOffset))


func published() -> void:
	Signals.startedBattleAnimation.emit(executorCharacter, move.prepareAnimation)
	ScriptTool.getReference(move.pickExpression).pick(executorCharacter)


func execute() -> void:
	if !confirmExecution():
		return
	
	ScriptTool.getReference(move.excuteExpression).execute(executorCharacter)
	
	# TODO enemy/player animations
	Signals.startedBattleAnimation.emit(executorCharacter, move.attackAnimation)
	if executorCharacter.type != Enums.CharacterType.PC:
		while await Signals.finishedBattleAnimation != executorCharacter:
			if !confirmExecution():
				return
			return
	
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
		
		target.atkMod += move.targetAtkModifier
		target.defMod += move.targetDefModifier
		target.cdMod += move.targetCdModifier
	
	if executorCharacter.atkMod <= 0:
		executorCharacter.atkMod += move.executorAtkModifier if (move.executorAtkModifier != 0) else 1
	elif executorCharacter.atkMod >= 0:
		executorCharacter.atkMod += move.executorAtkModifier if (move.executorAtkModifier != 0) else -1
	else:
		executorCharacter.atkMod += move.executorAtkModifier
	
	if executorCharacter.defMod <= 0:
		executorCharacter.defMod += move.executorDefModifier if (move.executorDefModifier != 0) else 1
	elif executorCharacter.defMod >= 0:
		executorCharacter.defMod += move.executorDefModifier if (move.executorDefModifier != 0) else -1
	else:
		executorCharacter.defMod += move.executorDefModifier
	
	if executorCharacter.cdMod <= 0:
		executorCharacter.cdMod += move.executorCdModifier if (move.executorCdModifier != 0) else 1
	elif executorCharacter.cdMod >= 0:
		executorCharacter.cdMod += move.executorCdModifier if (move.executorCdModifier != 0) else -1
	else:
		executorCharacter.cdMod += move.executorCdModifier
	
	var cd = max(GameParameters.MIN_CD, floor(move.cdPos * cdOffset))
	if executorCharacter.verdictActive:
		Signals.commandPublished.emit(VerdictCommand.new(executorCharacter, cd))
	elif executorCharacter.type == Enums.CharacterType.PC:
		Signals.commandPublished.emit(AskPlayerBattleInputCommand.new(executorCharacter, cd))

