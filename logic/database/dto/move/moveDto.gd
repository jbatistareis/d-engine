class_name MoveDTO
extends DTO

var name : String = 'Base attack'
var shortName : String = 'BSEATK'
var description : String = 'Attack with basic parameters'

# negative values represent damage, positive represent cure
var valueExpression : String = DefaultValues.MOVE_BASE_VALUE
var outcomeExpression : String = DefaultValues.MOVE_BASE_OUTCOME
var pickExpression : String = DefaultValues.MOVE_BASE_PICK
var excuteExpression : String = DefaultValues.MOVE_BASE_EXECUTE

var cdPre : int = 15
var cdPos : int = 25

# use Enums.CharacterTargetType
# relative to the executor
var targetType : int = Enums.MoveTargetType.FOE

var prepareAnimation : String = 'prepare1'
var attackAnimation : String = 'attack1'

var executorAtkModifier : int = 0
var executorDefModifier : int = 0
var executorCdModifier : int = 0

var targetAtkModifier : int = 0
var targetDefModifier : int = 0
var targetCdModifier : int = 0

var modifierScale : float = 0.1

