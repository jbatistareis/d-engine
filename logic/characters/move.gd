class_name Move

const _BASE_VALUE : String = 'func getValue(character : Character) -> int:\n\treturn -character.strength.score'
const _BASE_OUTCOME : String = 'func getOutcome(character : Character) -> int:\n\treturn Enums.DiceOutcome.BEST'
const _BASE_PICK : String = 'func pick(character : Character) -> void:\n\tpass'
const _BASE_EXECUTE : String = 'func execute(character : Character) -> void:\n\tpass'

var name : String = 'Speed jab'
var description : String = 'Attacks keeping balance'

var valueExpression : String = _BASE_VALUE
var outcomeExpression : String = _BASE_OUTCOME
var pickExpression : String = _BASE_PICK
var excuteExpression : String = _BASE_EXECUTE

var cdPre : int = 4
var cdPost : int = 3

var executions : int = 1
var persistent : bool = false

var targetType : int = Enums.CharacterTargetType.FOE # relative to the executor

var prepareAnimation : String = 'prepare1'
var attackAnimation : String = 'attack1'


# negative values represent damage, positive represent cure
func getResult(character) -> MoveResult:
	var reference = ScriptTool.getReference(valueExpression + '\n' + outcomeExpression)
	
	return MoveResult.new(reference.getValue(character), reference.getOutcome(character))


func pick(character) -> void:
	ScriptTool.getReference(pickExpression).pick(character)


func execute(character) -> void:
	ScriptTool.getReference(excuteExpression).execute(character)

