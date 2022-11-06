class_name ItemMove
extends Move

const _DESCRIPTION : String = 'Using %s'


func _init(item : Item).():
	self.shortName = item.shortName
	self.type = Enums.MoveType.ITEM
	self.description = _DESCRIPTION % item.name
	self.excuteExpression = item.actionExpression
	self.cdPre = GameParameters.MIN_CD
	self.cdPos = GameParameters.MIN_CD
	self.targetType = item.targetType

