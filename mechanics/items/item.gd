class_name Item
extends Entity

var name : String setget ,getName
var description : String setget ,getDescription
var price : int setget ,getPrice
var type : int setget ,getType

var useScript : String setget ,getUseScript


func _init(id : int, name : String, description : String, price : int, type : int, characterAproachesScript : String = '', characterLeavesScript : String = '', useScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
	self.name = name
	self.description = description
	self.price = price
	self.type = type
	self.useScript = useScript


func getName() -> String:
	return name


func getDescription() -> String:
	return description


func getPrice() -> int:
	return price


func getType() -> int:
	return type


func getUseScript() -> String:
	return useScript

