class_name Verdict
extends Entity

# { fact, move } dict
var actions : Array = []


func _init(verdictShrtNm : String) -> void:
	var dto = Persistence.loadDTO(verdictShrtNm, Enums.EntityType.VERDICT)
	
	self.name = dto.name
	self.shortName = dto.shortName
	
	for actionShtNms in dto.actions:
		self.actions.append({
			'fact': Fact.new(actionShtNms.factShortName),
			'move': Move.new(actionShtNms.moveShortName)
		})


func decision(auditorCharacter, suspects : Array) -> void:
	for action in actions:
		var targets = action.fact.analyze(auditorCharacter, suspects)
		if !targets.empty():
			Signals.emit_signal(
					"commandPublished",
					ExecuteMoveCommand.new(auditorCharacter, targets, action.move)
			)
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

