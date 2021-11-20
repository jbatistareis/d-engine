class_name Verdict

var name : String = 'NOOP verdict'
var description : String = 'Placeholder verdict'
var actions : Array = [Action.new()] # Action array


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
		WaitCommand.new(VerdictCommand.new(auditorCharacter, GameParameters.WAIT_TICKS / 2))
	)


func addAction(index : int, fact : Fact, move : Move) -> void:
	actions.insert(index, Action.new(fact, move))


func removeConcreteFact(index : int) -> void:
	actions.remove(index)


func swapActions(chosenActionIndex : int, targetActionIndex : int) -> void:
	var chosen = actions[chosenActionIndex]
	var target = actions[targetActionIndex]
	
	actions.remove(chosenActionIndex)
	actions.remove(targetActionIndex)
	
	actions.insert(targetActionIndex, chosen)
	actions.insert(chosenActionIndex, target)

