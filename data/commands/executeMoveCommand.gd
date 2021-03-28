class_name ExecuteMoveCommand
extends Command

var targets : Array = []
var move : Move


func _init(executorCharacter, targets : Array, move : Move).(executorCharacter, move.cdPre, move.executions, move.persistent) -> void:
	self.targets = targets
	self.move = move


func execute() -> void:
	var moveResult
	for target in targets:
		moveResult = move.getResult(executorCharacter)
		
		match moveResult.outcome:
			Dice.Outcome.BEST:
				changeHp(target, moveResult.value)
			
			Dice.Outcome.WITH_CONSEQUENCE: # reduces damage by a factor of '(STR + DEX + WIS) / 3'
				changeHp(
					target,
					max(1, floor(moveResult.value / max(1, ((target.strength.modifier + target.dexterity.modifier + target.wisdom.modifier) / 3)))))
			
			_: # Dice.Outcome.WORST
				pass # TODO miss
	
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


func changeHp(character, amount : int, bypassArmor : bool = false) -> void:
	if (!bypassArmor && (amount < 0) && (character.armor != null)):
		# TODO get from inventory database
		amount = ArmorsDatabase.getEntitySpawn(character.armorId).takeHit(amount)
	
	character.changeHp(amount)

