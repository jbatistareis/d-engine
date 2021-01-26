class_name Moves

var moveIds : Array = []


func _init(moveIds : Array) -> void:
	self.moveIds = moveIds
	self.moveIds.sort()


func addMove(moveId) -> void:
	moveIds.append(moveId)
	moveIds.sort()


func removeMove(moveId) -> void:
	moveIds.erase(moveId)
	moveIds.sort()

