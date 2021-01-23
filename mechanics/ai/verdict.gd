class_name Verdict
extends Entity

var concreteFacts : Array = []


# TODO store as a string, parse into int array
func _init(id : int, concreteFacts : Array).(id) -> void:
	for concreteFactStr in concreteFacts:
		self.concreteFacts.append(Array(concreteFactStr.split(';')))


func decision(auditorSpawnId : int, suspectsSpawnIds : Array) -> void:
	var result
	var fact
	
	for concreteFact in concreteFacts:
		# TODO get from facts database
		fact = load('res://mechanics/ai/fact.gd')
		result = fact.analyze(suspectsSpawnIds)
		if !result.empty():
			CommandManager.publishCommand(ExecuteMoveCommand.new(auditorSpawnId, result, concreteFact[1]))
			return
	
	CommandManager.publishCommand(VerdictCommand.new(auditorSpawnId))


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

