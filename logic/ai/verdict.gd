class_name Verdict
extends Entity

const _ALL : String = "_ALL"

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
			'fact': action.fact,
			'move': Move.new().fromShortName(action.moveShortName)
		})
	
	return self


func toDTO() -> VerdictDTO:
	var verdictDto = VerdictDTO.new()
	verdictDto.name = self.name
	verdictDto.shortName = self.shortName
	
	for action in self.actions:
		verdictDto.actions.append({
			'fact': action.fact,
			'moveShortName': action.move.shortName
		})
	
	return verdictDto


func decision(auditor, suspects : Array) -> void:
	for action in actions:
		var targets = analyze(DefaultValues.facts[action.fact], auditor, suspects)
		
		if !targets.empty():
			var move = Move.new().fromShortName(action.move.shortName)
			move.cdPre += auditor.inventory.weapon.cdPre
			move.cdPos += auditor.inventory.weapon.cdPos
			
			if Enums.MoveTargetType.keys()[action.move.targetType].ends_with(_ALL):
				Signals.emit_signal(
					"commandPublished",
					ExecuteMoveCommand.new(auditor, targets, move))
			else:
				rng.randomize()
				Signals.emit_signal(
						"commandPublished",
						ExecuteMoveCommand.new(
							auditor,
							[targets[rng.randi_range(0, targets.size() - 1)]],
							move))
			
			return
	
	Signals.emit_signal(
		"commandPublished",
		WaitCommand.new(VerdictCommand.new(auditor, GameParameters.WAIT_TICKS))
	)


func analyze(script : String, auditor, suspects : Array) -> Array:
	return ScriptTool.getReference(script).execute(auditor, suspects)


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

