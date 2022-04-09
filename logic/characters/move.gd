class_name Move

const _BASE_VALUE : String = 'func getValue(character : Character) -> int:\n\treturn -character.strength.score'
const _BASE_OUTCOME : String = 'func getOutcome(character : Character) -> int:\n\treturn Enums.DiceOutcome.BEST'
const _BASE_PICK : String = 'func pick(character : Character) -> void:\n\tpass'
const _BASE_EXECUTE : String = 'func execute(character : Character) -> void:\n\tpass'

var name : String = 'Base attack'
var description : String = 'Base attack'

var valueExpression : String = _BASE_VALUE
var outcomeExpression : String = _BASE_OUTCOME
var pickExpression : String = _BASE_PICK
var excuteExpression : String = _BASE_EXECUTE

var cdPre : int = 5
var cdPos : int = 5

var targetType : int = Enums.CharacterTargetType.FOE # relative to the executor

var prepareAnimation : String = 'prepare1'
var attackAnimation : String = 'attack1'

var executorModifiers : Array = []
var targetModifiers : Array = []


# negative values represent damage, positive represent cure
func getResult(executor) -> MoveResult:
	var reference = ScriptTool.getReference(valueExpression + '\n' + outcomeExpression)
	var result = MoveResult.new(reference.getValue(executor), reference.getOutcome(executor))
	
	return result


func pick(executor) -> void:
	ScriptTool.getReference(pickExpression).pick(executor)


func execute(executor) -> void:
	ScriptTool.getReference(excuteExpression).execute(executor)

