class_name Verdict
extends Entity

const _ALL : String = "_ALL"

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# { fact, move } dict
var actions : Array = []


func fromShortName(verdictShortName : String) -> Verdict:
	return fromDTO(Persistence.loadDTO(verdictShortName, Enums.EntityType.VERDICT))


func fromDTO(verdictDto : VerdictDTO) -> Verdict:
	self.name = verdictDto.name
	self.shortName = verdictDto.shortName
	
	self.actions.clear()
	for actionShtNms in verdictDto.actions:
		self.actions.append({
			'fact': Fact.new().fromShortName(actionShtNms.factShortName),
			'move': Move.new().fromShortName(actionShtNms.moveShortName)
		})
	
	return self


func toDTO() -> VerdictDTO:
	var verdictDto = VerdictDTO.new()
	verdictDto.name = self.name
	verdictDto.shortName = self.shortName
	
	for action in self.actions:
		verdictDto.actions.append({
			'factShortName': action.fact.shortName,
			'moveShortName': action.move.shortName
		})
	
	return verdictDto


func decision(auditorCharacter, suspects : Array) -> void:
	for action in actions:
		var targets = action.fact.analyze(auditorCharacter, suspects)
		
		if !targets.empty():
			if Enums.MoveTargetType.keys()[action.move.targetType].ends_with(_ALL):
				Signals.emit_signal(
					"commandPublished",
					ExecuteMoveCommand.new(auditorCharacter, targets, action.move))
			else:
				rng.randomize()
				Signals.emit_signal(
						"commandPublished",
						ExecuteMoveCommand.new(
							auditorCharacter,
							[targets[rng.randi_range(0, targets.size() - 1)]],
							action.move))
			return
	
	Signals.emit_signal(
		"commandPublished",
		WaitCommand.new(VerdictCommand.new(auditorCharacter, GameParameters.WAIT_TICKS))
	)


# action is a { fact, move } dict
func addAction(action : Dictionary) -> void:
	actions.append(action)


func removeConcreteFact(index : int) -> void:
	actions.remove(index)


func swapActions(chosenActionIndex : int, targetActionIndex : int) -> void:
	var chosen = actions[chosenActionIndex]
	var target = actions[targetActionIndex]
	
	actions.remove(chosenActionIndex)
	actions.remove(targetActionIndex)
	
	actions.insert(targetActionIndex, chosen)
	actions.insert(chosenActionIndex, target)

