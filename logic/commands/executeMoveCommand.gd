class_name ExecuteMoveCommand
extends Command

var executor : Character
var targets : Array = []
var move : Move


func _init(executor : Character, targets : Array, move : Move) -> void:
	self.executor = executor
	self.targets = targets
	self.move = move
	self.totalTicks = self.move.cdPre
	
	Signals.emit_signal("charaterTimerSet", self.character, self.totalTicks)


func execute() -> void:
	var moveResult
	for target in targets:
		moveResult = move.getResult(executor)
		
		match moveResult.outcome:
			Dice.Outcome.BEST:
				changeHp(target, moveResult.value)
			
			Dice.Outcome.WITH_CONSEQUENCE: # reduces damage by a factor of '(STR + DEX + WIS) / 3'
				changeHp(
					target,
					max(1, floor(moveResult.value / max(1, ((target.strength.modifier + target.dexterity.modifier + target.wisdom.modifier) / 3)))))
			
			_: # Dice.Outcome.WORST
				pass # TODO miss
	
	if executor.verdictActive:
		Signals.emit_signal("publishedCommand", VerdictCommand.new(move.cdPost, executor))
	else:
		Signals.emit_signal("publishedCommand", AskPlayerBattleInputCommand.new(move.cdPost, executor))


func changeHp(character : Character, amount : int, bypassArmor : bool = false) -> void:
	if (!bypassArmor && (amount < 0) && (character.armor != null)):
		# TODO get from inventory database
		amount = ArmorsDatabase.getEntitySpawn(character.armorId).takeHit(amount)
	
	character.changeHp(amount)

