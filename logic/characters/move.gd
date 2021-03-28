class_name Move

const _INTERNAL_MOVE_SCRIPT_NOOP_VALUE : String = 'func getValue(character : Character) -> int:\n\treturn 0'
const _INTERNAL_MOVE_SCRIPT_NOOP_OUTCOME : String = 'func getOutcome(character : Character) -> int:\n\treturn 0'

var name : String = ''
var description : String = ''
var valueExpression : String = _INTERNAL_MOVE_SCRIPT_NOOP_VALUE
var outcomeExpression : String = _INTERNAL_MOVE_SCRIPT_NOOP_OUTCOME
var cdPre : int = 0
var cdPost : int = 0
var executions : int = 1
var persistent : bool = false


func getResult(character) -> MoveResult:
	var reference = ScriptTool.getReference(valueExpression + '\n' + outcomeExpression)
	var result = MoveResult.new(reference.getValue(character), reference.getOutcome(character))
	
	return result

