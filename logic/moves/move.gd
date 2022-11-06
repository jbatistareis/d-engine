class_name Move
extends Entity

var type : int = Enums.MoveType.SKILL

var description : String

# negative values represent damage, positive represent cure
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

var modifierScale : float


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
	
	self.modifierScale = moveDto.modifierScale
	
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
	
	moveDto.modifierScale = self.modifierScale
	
	return moveDto

