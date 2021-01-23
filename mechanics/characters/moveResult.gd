class_name MoveResult

var value : int
var outcome : int # returns Dice.Outcome enum


func _init(value : int, outcome : int) -> void:
	self.value = value
	self.outcome = outcome

