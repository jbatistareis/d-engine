class_name MoveDTO
extends DTO

var name : String = 'Base attack'
var shortName : String = 'BSEATK'
var description : String = 'Attack with basic parameters'

var valueExpression : String = GameParameters.MOVE_BASE_VALUE
var outcomeExpression : String = GameParameters.MOVE_BASE_OUTCOME
var pickExpression : String = GameParameters.MOVE_BASE_PICK
var excuteExpression : String = GameParameters.MOVE_BASE_EXECUTE

var cdPre : int = 1
var cdPos : int = 1

var targetType : int = Enums.CharacterTargetType.FOE # relative to the executor

var prepareAnimation : String = 'prepare1'
var attackAnimation : String = 'attack1'

var executorModifiers : Array = [] # use Enums.MoveModifierProperty
var targetModifiers : Array = [] # use Enums.MoveModifierProperty

