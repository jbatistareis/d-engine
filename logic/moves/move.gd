class_name Move
extends Entity

var description : String

var valueExpression : String
var outcomeExpression : String
var pickExpression : String
var excuteExpression : String

var cdPre : int
var cdPos : int

# relative to the executor
var targetType : int

var prepareAnimation : String
var attackAnimation : String

# use Enums.MoveModifierProperty in both
var executorModifiers : Array = []
var targetModifiers : Array = []


func fromShortName(moveShortName : String) -> Move:
	return fromDTO(Persistence.loadDTO(moveShortName, Enums.EntityType.MOVE))


func fromDTO(moveDto : MoveDTO) -> Move:
	self.name = moveDto.name
	self.shortName = moveDto.shortName
	self.description = moveDto.description
	
	self.valueExpression = moveDto.valueExpression
	self.outcomeExpression = moveDto.outcomeExpression
	self.pickExpression = moveDto.pickExpression
	self.excuteExpression = moveDto.excuteExpression
	
	self.cdPre = moveDto.cdPre
	self.cdPos = moveDto.cdPos
	
	self.targetType = moveDto.targetType
	
	self.prepareAnimation = moveDto.prepareAnimation
	self.attackAnimation = moveDto.attackAnimation
	
	self.executorModifiers = moveDto.executorModifiers
	self.targetModifiers = moveDto.targetModifiers
	
	return self


func toDTO() -> MoveDTO:
	var moveDto = MoveDTO.new()
	moveDto.name = self.name
	moveDto.shortName = self.shortName
	moveDto.description = self.description
	
	moveDto.valueExpression = self.valueExpression
	moveDto.outcomeExpression = self.outcomeExpression
	moveDto.pickExpression = self.pickExpression
	moveDto.excuteExpression = self.excuteExpression
	
	moveDto.cdPre = self.cdPre
	moveDto.cdPos = self.cdPos
	
	moveDto.targetType = self.targetType
	
	moveDto.prepareAnimation = self.prepareAnimation
	moveDto.attackAnimation = self.attackAnimation
	
	moveDto.executorModifiers = self.executorModifiers
	moveDto.targetModifiers = self.targetModifiers
	
	return moveDto


# negative values represent damage, positive represent cure
func getResult(executor) -> MoveResult:
	var reference = ScriptTool.getReference(valueExpression + '\n' + outcomeExpression)
	var result = MoveResult.new(reference.getValue(executor), reference.getOutcome(executor))
	
	return result


func pick(executor) -> void:
	ScriptTool.getReference(pickExpression).pick(executor)


func execute(executor) -> void:
	ScriptTool.getReference(excuteExpression).execute(executor)
