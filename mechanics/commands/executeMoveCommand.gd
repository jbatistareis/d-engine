class_name ExecuteMoveCommand
extends Command

var executor : Character
var targets : Array = []
var move : Move


func _init(executorSpawnId : int, targetSpawnIds : Array, moveId : int) -> void:
	self.executor = CharactersDatabase.getEntitySpawn(executorSpawnId)
	
	for targetSpawnId in targetSpawnIds:
		self.targets.append(CharactersDatabase.getEntitySpawn(targetSpawnId))
		
	self.move = MovesDatabase.getEntity(moveId)
	self.totalTicks = self.move.cdPre


func execute() -> void:
	var moveResult
	for target in targets:
		moveResult = move.getResult(executor)
		
		match moveResult.getOutcome():
			Dice.Outcome.BEST:
				damageCharacter(target, moveResult.value)
			
			Dice.Outcome.WITH_CONSEQUENCE: # reduces damage by a factor of '(STR + DEX + WIS) / 3'
				damageCharacter(
					target,
					max(1, floor(moveResult.value / max(1, ((target.getModifier(Enums.CharacterModifier.STR) + target.getModifier(Enums.CharacterModifier.DEX) + target.getModifier(Enums.CharacterModifier.WIS)) / 3)))))
			
			_: # Dice.Outcome.WORST
				pass # TODO miss
	
	# TODO publish next command prompt / AI verdict
	# CommandManager.publishCommand(WaitCommand.new(move.getCdPost(), Command.new()))


func damageCharacter(character : Character, amount : int, bypassArmor : bool = false) -> void:
	if (!bypassArmor && (amount < 0) && (character.armor != null)):
		# TODO get from inventory database
		amount = ArmorsDatabase.getEntitySpawn(character.armor).takeHit(amount)
	
	character.changeHp(amount)

