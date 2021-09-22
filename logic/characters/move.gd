class_name Move

const _INTERNAL_MOVE_SCRIPT_NOOP_VALUE : String = 'func getValue(character : Character) -> int:\n\treturn 0'
const _INTERNAL_MOVE_SCRIPT_NOOP_OUTCOME : String = 'func getOutcome(character : Character) -> int:\n\treturn 0'

var name : String = 'Move'
var description : String = 'NOOP move'

var valueExpression : String = _INTERNAL_MOVE_SCRIPT_NOOP_VALUE
var outcomeExpression : String = _INTERNAL_MOVE_SCRIPT_NOOP_OUTCOME

var cdPre : int = 0
var cdPost : int = 0

var executions : int = 1
var persistent : bool = false

var targetType : int = Enums.CharacterTargetType.FOE # relative to the executor

var prepareAnimation : String = 'prepare1'
var attackAnimation : String = 'attack1'


func getResult(character) -> MoveResult:
	var reference = ScriptTool.getReference(valueExpression + '\n' + outcomeExpression)
	
	return MoveResult.new(reference.getValue(character), reference.getOutcome(character))

