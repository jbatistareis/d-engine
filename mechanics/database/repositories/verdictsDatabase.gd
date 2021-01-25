extends EntityDatabase

# TODO remove
var verdicts : Array = [
	Verdict.new(1, []),
	Verdict.new(2, []),
]

# TODO get from DB
func getEntity(id : int) -> Verdict:
	return verdicts[id - 1]
