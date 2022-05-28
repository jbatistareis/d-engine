class_name Move
extends Entity

var description : String

var valueExpression : String
var outcomeExpression : String
var pickExpression : String
var excuteExpression : String

var cdPre : int
var cdPos : int

var targetType : int # relative to the executor

var prepareAnimation : String
var attackAnimation : String

var executorModifiers : Array = [] # use Enums.MoveModifierProperty
var targetModifiers : Array = [] # use Enums.MoveModifierProperty


func _init(moveShortName : String):
	var dto = Persistence.loadDTO(moveShortName, Enums.EntityType.MOVE)
	
	self.name = dto.name
	self.shortName = dto.shortName
	self.description = dto.description
	
	self.valueExpression = dto.valueExpression
	self.outcomeExpression = dto.outcomeExpression
	self.pickExpression = dto.pickExpression
	self.excuteExpression = dto.excuteExpression
	
	self.cdPre = dto.cdPre
	self.cdPos = dto.cdPos
	
	self.targetType = dto.targetType
	
	self.prepareAnimation = dto.prepareAnimation
	self.attackAnimation = dto.attackAnimation
	
	self.executorModifiers = dto.executorModifiers
	self.targetModifiers = dto.targetModifiers


# negative values represent damage, positive represent cure
func getResult(executor) -> MoveResult:
	var reference = ScriptTool.getReference(valueExpression + '\n' + outcomeExpression)
	var result = MoveResult.new(reference.getValue(executor), reference.getOutcome(executor))
	
	return result


func pick(executor) -> void:
	ScriptTool.getReference(pickExpression).pick(executor)


func execute(executor) -> void:
	ScriptTool.getReference(excuteExpression).execute(executor)

