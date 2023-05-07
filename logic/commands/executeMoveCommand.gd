class_name ExecuteMoveCommand
extends Command

var targets : Array = []
var move : Move

var atkOffset : float = 1
var cdOffset : float = 1

var confirmedExecutions : Array[Character] = []


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
	Signals.startedBattleAnimation.emit(executorCharacter, move.attackAnimation)
	
	# TODO player animations, change this after player animations are implemented
	continueExecution(executorCharacter)


func continueExecution(character : Character) -> void:
	if character != executorCharacter:
		return
	
	var reference = ScriptTool.getReference(move.valueExpression + '\n' + move.outcomeExpression)
	var moveResult = MoveResult.new(
		reference.getValue(character),
		reference.getOutcome(character))
	
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
	
	if character.atkMod <= 0:
		character.atkMod += move.executorAtkModifier if (move.executorAtkModifier != 0) else 1
	elif character.atkMod >= 0:
		character.atkMod += move.executorAtkModifier if (move.executorAtkModifier != 0) else -1
	else:
		character.atkMod += move.executorAtkModifier
	
	if character.defMod <= 0:
		character.defMod += move.executorDefModifier if (move.executorDefModifier != 0) else 1
	elif character.defMod >= 0:
		character.defMod += move.executorDefModifier if (move.executorDefModifier != 0) else -1
	else:
		character.defMod += move.executorDefModifier
	
	if character.cdMod <= 0:
		character.cdMod += move.executorCdModifier if (move.executorCdModifier != 0) else 1
	elif character.cdMod >= 0:
		character.cdMod += move.executorCdModifier if (move.executorCdModifier != 0) else -1
	else:
		character.cdMod += move.executorCdModifier
	
	var cd = max(GameParameters.MIN_CD, floor(move.cdPos * cdOffset))
	if character.verdictActive:
		Signals.commandPublished.emit(VerdictCommand.new(character, cd))
	elif character.type == Enums.CharacterType.PC:
		Signals.commandPublished.emit(AskPlayerBattleInputCommand.new(character, cd))
