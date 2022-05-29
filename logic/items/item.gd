class_name Item
extends Entity

# TODO use logic

var description : String

var price : int
var type : int # use Enums.ItemType


func fromShortName(itemShortName : String) -> Item:
	return fromDTO(Persistence.loadDTO(itemShortName, Enums.EntityType.ITEM))


func fromDTO(itemDto : ItemDTO) -> Item:
	self.name = itemDto.name
	self.shortName = itemDto.shortName
	self.description = itemDto.description
	
	self.price = itemDto.price
	self.type = itemDto.type
	
	return self


func toDTO() -> ItemDTO:
	var itemDto = ItemDTO.new()
	itemDto.name = self.name
	itemDto.shortName = self.shortName
	itemDto.description = self.description
	
	itemDto.price = self.price
	itemDto.type = self.type
	
	return itemDto

