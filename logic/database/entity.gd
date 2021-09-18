class_name Entity

var id : int
var shortName : String = 'ENTITY' setget setShortName


func setShortName(value : String) -> void:
	shortName = value.substr(0, 6).to_upper()
