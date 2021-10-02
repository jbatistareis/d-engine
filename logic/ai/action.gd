class_name Action

var fact : Fact
var move : Move


func _init(fact : Fact = Fact.new(), move : Move = Move.new()) -> void:
	self.fact = fact
	self.move = move

