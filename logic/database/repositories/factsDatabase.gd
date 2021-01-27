extends EntityDatabase

# TODO remove
var facts : Array = [
	Fact.new(1),
	Fact.new(2),
]

# TODO get from DB
func getEntity(id : int) -> Fact:
	return facts[id - 1]
