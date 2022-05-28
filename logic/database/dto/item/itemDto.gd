class_name ItemDTO
extends DTO

var name : String = 'Base Item'
var shortName : String = 'BSEITM'
var description : String = 'Item with default parameters'

var price : int = 0

# use Enums.ItemType
var type : int = Enums.ItemType.CONSUMABLE

