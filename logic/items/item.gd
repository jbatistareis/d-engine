class_name Item
extends Entity

var name : String
var description : String
var price : int
var type : int


# TODO use script
func _init(id : int, name : String, description : String, price : int, type : int, characterAproachesScript : String = '', characterLeavesScript : String = '', interactScript : String = '') -> void:
	self.name = name
	self.description = description
	self.price = price
	self.type = type

