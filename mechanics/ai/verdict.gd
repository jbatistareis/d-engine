class_name Verdict
extends Entity

var active : bool
var concreteFacts : Array = [] # holds 2 dimensional arrays [<FACT ID>, <MOVE ID>]


# TODO store as a string, parse into int array
func _init(id : int, concreteFacts : Array).(id) -> void:
	for concreteFactStr in concreteFacts:
		self.concreteFacts.append(Array(concreteFactStr.split(';')))


func decision(auditorSpawnId : int, suspectsSpawnIds : Array) -> void:
	var auditor = CharactersDatabase.getEntitySpawn(auditorSpawnId)
	
	if auditor != null:
		var result
		var fact
		
		for concreteFact in concreteFacts:
			result = FactsDatabase.getEntity(concreteFact[0]).analyze(suspectsSpawnIds)
			if !result.empty():
				Signals.emit_signal("publishedCommand", ExecuteMoveCommand.new(auditor.spawnId, result, concreteFact[1]))
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

