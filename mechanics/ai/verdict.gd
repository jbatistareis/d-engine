class_name Verdict
extends Entity

var factIds : Array = [] setget ,getFactIds


func getFactIds() -> Array:
	return factIds


# TODO get from db
func decision(auditorSpawnId : int, suspectsSpawnIds : Array) -> void:
	var result
	
	for factId in factIds:
		var fact
		result = fact.analyze(auditorSpawnId, suspectsSpawnIds)
		if result != null:
			CommandManager.publishCommand(result)
			return
	
	CommandManager.publishCommand(VerdictCommand.new(auditorSpawnId))


func addFact(factId : Fact, index : int) -> void:
	factIds.insert(index, factId)


func removeFact(factId : Fact) -> void:
	factIds.erase(factId)


func swapFacts(chosenFactId : Fact, targetFactId : Fact) -> void:
	var fromIndex = factIds.find(chosenFactId)
	var toIndex = factIds.find(targetFactId)
	
	factIds.remove(fromIndex)
	factIds.remove(toIndex)
	
	factIds.insert(toIndex, chosenFactId)
	factIds.insert(fromIndex, targetFactId)

