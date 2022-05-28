class_name Item
extends Entity

# TODO use logic

var description : String

var price : int
var type : int # use Enums.ItemType


func _init(itemShortName : String) -> void:
	var dto = Persistence.loadDTO(itemShortName, Enums.EntityType.ITEM)
	
	self.name = dto.name
	self.shortName = dto.shortName
	self.description = dto.description
	
	self.price = dto.price
	self.type = dto.type

