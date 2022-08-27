class_name MoveDTO
extends DTO

var name : String = 'Base attack'
var shortName : String = 'BSEATK'
var description : String = 'Attack with basic parameters'

var valueExpression : String = DefaultValues.MOVE_BASE_VALUE
var outcomeExpression : String = DefaultValues.MOVE_BASE_OUTCOME
var pickExpression : String = DefaultValues.MOVE_BASE_PICK
var excuteExpression : String = DefaultValues.MOVE_BASE_EXECUTE

var cdPre : int = 1
var cdPos : int = 1

# use Enums.CharacterTargetType
# relative to the executor
var targetType : int = Enums.MoveTargetType.FOE

var prepareAnimation : String = 'prepare1'
var attackAnimation : String = 'attack1'

# use Enums.MoveModifierProperty
var executorModifiers : Array = []
# use Enums.MoveModifierProperty
var targetModifiers : Array = []

var modifierScale : float = 0.1

