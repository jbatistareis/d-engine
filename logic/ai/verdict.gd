class_name Verdict
extends Entity

const _ALL : String = "_ALL"
const _ANY : String = "ANY"
const _FRIENDLY : String = "FRIENDLY"
const _FOE : String = "FOE"


var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# { Enums.Fact, move } dict
var actions : Array = []


func fromShortName(verdictShortName : String) -> Verdict:
	return fromDTO(Persistence.loadDTO(verdictShortName, Enums.EntityType.VERDICT))


func fromDTO(verdictDto : VerdictDTO) -> Verdict:
	self.name = verdictDto.name
	self.shortName = verdictDto.shortName
	
	self.actions.clear()
	for action in verdictDto.actions:
		self.actions.append({
			'self': action.own,
			'target': action.target,
			'move': Move.new().fromShortName(action.moveShortName)
		})
	
	return self


func toDTO() -> VerdictDTO:
	var verdictDto = VerdictDTO.new()
	verdictDto.name = self.name
	verdictDto.shortName = self.shortName
	
	for action in self.actions:
		verdictDto.actions.append({
			'self': action.own,
			'target': action.target,
			'moveShortName': action.move.shortName
		})
	
	return verdictDto


func decision(auditor) -> void:
	for action in actions:
		var targetType = Enums.MoveTargetType.keys()[action.move.targetType]
		var suspects = []
		
		match auditor.type:
			Enums.CharacterType.PC:
				if targetType.begins_with(_FOE):
					suspects = BattleManager.enemies
				elif targetType.begins_with(_FRIENDLY):
					suspects = BattleManager.players
				elif targetType.begins_with(_ANY):
					suspects = BattleManager.players + BattleManager.enemies
			
			Enums.CharacterType.FOE:
				if targetType.begins_with(_FOE):
					suspects = BattleManager.players
				elif targetType.begins_with(_FRIENDLY):
					suspects = BattleManager.enemies
				elif targetType.begins_with(_ANY):
					suspects = BattleManager.players + BattleManager.enemies
		
		suspects.shuffle()
		
		var selfMatch = !analyze(DefaultValues.facts[action.own], auditor, [auditor]).is_empty()
		var targets = analyze(DefaultValues.facts[action.target], auditor, suspects)
		
		if selfMatch && !targets.is_empty():
			var move = Move.new().fromShortName(action.move.shortName)
			move.cdPre += auditor.inventory.weapon.cdPre
			move.cdPos += auditor.inventory.weapon.cdPos
			
			if targetType.ends_with(_ALL):
				Signals.commandPublished.emit(ExecuteMoveCommand.new(auditor, targets, move))
			else:
				rng.randomize()
				Signals.commandPublished.emit(
						ExecuteMoveCommand.new(
							auditor,
							[targets[rng.randi_range(0, targets.size() - 1)]],
							move))
			
			return
	
	Signals.commandPublished.emit(
		WaitCommand.new(VerdictCommand.new(auditor, GameParameters.WAIT_TICKS))
	)


func analyze(script : String, auditor, suspects : Array) -> Array:
	return ScriptTool.getReference(script).execute(auditor, suspects)


# action is a { fact, move } dict
func addAction(action : Dictionary) -> void:
	actions.append(action)


func removeConcreteFact(index : int) -> void:
	actions.remove_at(index)


func swapActions(chosenActionIndex : int, targetActionIndex : int) -> void:
	var chosen = actions[chosenActionIndex]
	var target = actions[targetActionIndex]
	
	actions.remove_at(chosenActionIndex)
	actions.remove_at(targetActionIndex)
	
	actions.insert(targetActionIndex, chosen)
	actions.insert(chosenActionIndex, target)

