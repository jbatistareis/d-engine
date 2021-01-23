class_name Equipment
extends Entity

var itemId : int

func _init(id : int, itemId : int, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
	self.itemId = itemId

