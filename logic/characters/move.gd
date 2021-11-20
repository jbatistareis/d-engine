class_name Move

const _INTERNAL_MOVE_SCRIPT_NOOP_VALUE : String = 'func getValue(character : Character) -> int:\n\treturn -character.strength.score'
const _INTERNAL_MOVE_SCRIPT_NOOP_OUTCOME : String = 'func getOutcome(character : Character) -> int:\n\treturn Enums.DiceOutcome.BEST'

var name : String = 'NOOP move'
var description : String = 'Placeholder move'

var valueExpression : String = _INTERNAL_MOVE_SCRIPT_NOOP_VALUE
var outcomeExpression : String = _INTERNAL_MOVE_SCRIPT_NOOP_OUTCOME

var cdPre : int = 5
var cdPost : int = 5

var executions : int = 1
var persistent : bool = false

var targetType : int = Enums.CharacterTargetType.FOE # relative to the executor

var prepareAnimation : String = 'prepare1'
var attackAnimation : String = 'attack1'


# negative values represent damage, positive represent cure
func getResult(character) -> MoveResult:
	var reference = ScriptTool.getReference(valueExpression + '\n' + outcomeExpression)
	
	return MoveResult.new(reference.getValue(character), reference.getOutcome(character))

