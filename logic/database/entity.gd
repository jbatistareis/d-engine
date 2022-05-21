class_name Entity

var id : int
var shortName : String = 'ENTITY' setget setShortName
var name : String


func setShortName(value : String) -> void:
	shortName = value.substr(0, 10).to_upper()


func fromDto(dto : DTO) -> void:
	pass

