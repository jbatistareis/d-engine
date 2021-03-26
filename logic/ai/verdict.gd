class_name Verdict

var concreteFacts : Array = [] # holds 2 dimensional arrays [<FACT>, <MOVE>]


func decision(auditorCharacter, suspects : Array) -> void:
	if auditorCharacter != null:
		var result
		var fact
		
		for concreteFact in concreteFacts:
			result = concreteFact[0].analyze(suspects)
			if !result.empty():
				Signals.emit_signal(
						"commandPublished",
						ExecuteMoveCommand.new(auditorCharacter, result, concreteFact[1])
				)
				return


func addConcreteFact(index : int, fact : Fact, move : Move) -> void:
	concreteFacts.insert(index, [fact, move])


func removeConcreteFact(index : int) -> void:
	concreteFacts.remove(index)


func swapConcreteFacts(chosenConcreteFactIndex : int, targetConcreteFactIndex : int) -> void:
	var chosen = concreteFacts[chosenConcreteFactIndex]
	var target = concreteFacts[targetConcreteFactIndex]
	
	concreteFacts.remove(chosenConcreteFactIndex)
	concreteFacts.remove(targetConcreteFactIndex)
	
	concreteFacts.insert(targetConcreteFactIndex, chosen)
	concreteFacts.insert(chosenConcreteFactIndex, target)

