class_name Item
extends Entity

const _INTERNAL_SCRIPT_NOOP : String = 'extends Node\nfunc result() -> void:\n\treturn'

var name : String
var description : String
var price : int
var type : int

var useScript : String


# TODO use script
func _init(id : int, name : String, description : String, price : int, type : int, characterAproachesScript : String = '', characterLeavesScript : String = '', useScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
	self.name = name
	self.description = description
	self.price = price
	self.type = type
	self.useScript = _INTERNAL_SCRIPT_NOOP

