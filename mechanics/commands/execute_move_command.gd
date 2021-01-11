class_name ExecuteMoveCommand
extends Command

var executor : Character
var target : Character
var move : Move

func _init(moveId : int, executorSpawnId : int, targetSpawnId : int) -> void:
	self.executor = CharactersDatabase.getEntitySpawn(executorSpawnId)
	self.target = CharactersDatabase.getEntitySpawn(targetSpawnId)
	self.move = MovesDatabase.getEntity(moveId)
	setTotalTicks(self.move.cdPre)

func execute() -> void:
	var moveResult = move.getResult(executor)
	
	match moveResult.getOutcome():
		Dice.Outcome.BEST:
			receiveDamage(target, moveResult.value)
		
		Dice.Outcome.WITH_CONSEQUENCE: # reduces damage by a factor of '(STR + DEX + WIS) / 3'
			receiveDamage(
				target,
				max(1, floor(moveResult.value / max(1, ((target.getModifier(Enums.CharacterModifier.STR) + target.getModifier(Enums.CharacterModifier.DEX) + target.getModifier(Enums.CharacterModifier.WIS)) / 3)))))
		
		_: # Dice.Outcome.WORST
			pass # TODO miss
	
	# TODO publish next command prompt / AI verdict
	# CommandManager.publishCommand(WaitCommand.new(move.getCdPost(), Command.new()))

func receiveDamage(character : Character, amount : int, bypassArmor : bool = false) -> void:
	if (!bypassArmor && (amount < 0) && (character.armor != null)):
		amount = armorDamage(character, amount)
	
	hpChange(character, amount)

func armorDamage(character : Character, amount : int):
	# TODO get from inventory database
	var amountPased = ArmorsDatabase.getEntitySpawn(character.armor).takeHit(amount)
	
	if (amountPased == 0):
		pass # TODO armor damage

func hpChange(character : Character, amount : int):
	character.changeHp(amount)

