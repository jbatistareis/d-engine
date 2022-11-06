class_name ItemDTO
extends DTO

var name : String = 'Base Item'
var shortName : String = 'BSEITM'
var description : String = 'Item with default parameters'

var price : int = 0

var type : int = Enums.ItemType.CONSUMABLE

var targetType : int = Enums.MoveTargetType.FRIENDLY
var actionExpression : String = DefaultValues.ITEM_BASE_ACTION

