class_name MoveResult

var value : int setget ,getValue
var outcome : int setget ,getOutcome


func _init(value : int, outcome : int) -> void:
	self.value = value
	self.outcome = outcome


func getValue() -> int:
	return value


# returns Dice.Outcome enum
func getOutcome() -> int:
	return outcome

