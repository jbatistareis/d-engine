class_name Entity

var id : int
var name : String
var shortName : String = 'ENTITY' setget setShortName


func setShortName(value : String) -> void:
	shortName = value.substr(0, 10).to_upper()


func fromShortName(shortName : String):
	return null


func fromDTO(dto):
	return null


func toDTO():
	return null

