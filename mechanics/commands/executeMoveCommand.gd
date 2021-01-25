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
					max(1, floor(moveResult.value / max(1, ((target.strength.modifier + target.dexterity.modifier + target.wisdom.modifier) / 3)))))
			
			_: # Dice.Outcome.WORST
				pass # TODO miss
	
	if executor.verdictActive:
		CommandManager.publishCommand(VerdictCommand.new(executor.spawnId))
	else:
		return # TODO publish next command prompt


func damageCharacter(character : Character, amount : int, bypassArmor : bool = false) -> void:
	if (!bypassArmor && (amount < 0) && (character.armor != null)):
		# TODO get from inventory database
		amount = ArmorsDatabase.getEntitySpawn(character.armorId).takeHit(amount)
	
	character.changeHp(amount)

