class_name Equipment
extends Entity

var itemId : int setget ,getItemId

func _init(id : int, itemId : int, characterAproachesScript : String = '', characterLeavesScript : String = '').(id, characterAproachesScript, characterLeavesScript) -> void:
	self.itemId = itemId

func getItemId() -> int:
	return itemId

