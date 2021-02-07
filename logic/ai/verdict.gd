class_name Verdict
extends Entity

var concreteFacts : Array = [] # holds 2 dimensional arrays [<FACT ID>, <MOVE ID>]


# TODO store as a string, parse into int array
func _init(id : int, concreteFacts : Array = []).(id) -> void:
	for concreteFactStr in concreteFacts:
		self.concreteFacts.append(Array(concreteFactStr.split(';')))


func decision(auditor : Character, suspects : Array) -> void:
	if auditor != null:
		var result
		var fact
		
		for concreteFact in concreteFacts:
			result = FactsDatabase.getEntity(concreteFact[0]).analyze(suspects)
			if !result.empty():
				Signals.emit_signal(
						"commandPublished",
						ExecuteMoveCommand.new(auditor, result, MovesDatabase.getEntity(concreteFact[1]))
				)
				return


func addConcreteFact(index : int, factId : int, moveId : int) -> void:
	concreteFacts.insert(index, [factId, moveId])


func removeConcreteFact(index : int) -> void:
	concreteFacts.remove(index)


func swapConcreteFacts(chosenConcreteFactIndex : int, targetConcreteFactIndex : int) -> void:
	var chosen = concreteFacts[chosenConcreteFactIndex]
	var target = concreteFacts[targetConcreteFactIndex]
	
	concreteFacts.remove(chosenConcreteFactIndex)
	concreteFacts.remove(targetConcreteFactIndex)
	
	concreteFacts.insert(targetConcreteFactIndex, chosen)
	concreteFacts.insert(chosenConcreteFactIndex, target)

