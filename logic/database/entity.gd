class_name Entity

var id : int
var name : String
var shortName : String = 'ENTITY' : set = setShortName


func setShortName(value : String) -> void:
	shortName = value.substr(0, 10).to_upper()


func fromShortName(_shortName : String):
	return null


func fromDTO(_dto):
	return null


func toDTO():
	return null

