class_name Moves

var moveIds : Array = [] setget ,getMoveIds


func _init(moveIds : Array) -> void:
	self.moveIds = moveIds
	self.moveIds.sort()


func getMoveIds() -> Array:
	return moveIds


func addMove(moveId) -> void:
	moveIds.append(moveId)
	moveIds.sort()


func removeMove(moveId) -> void:
	moveIds.erase(moveId)
	moveIds.sort()

