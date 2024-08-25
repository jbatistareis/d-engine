class_name Entity

var id : int
var name : String
var shortName : String = 'ENTITY' : set = setShortName


func setShortName(value : String) -> void:
	shortName = value.substr(0, 10).to_upper()


func fromShortName(_shortName : String) -> Entity:
	return null


func fromDTO(_dto) -> Entity:
	return null


func toDTO() -> DTO:
	return null
