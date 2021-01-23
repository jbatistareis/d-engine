class_name Command

var totalTicks : int setget setTotalTicks
var executorCharSpawnId : int
var targetCharSpawnId : int
var entityId : int

var remainingTicks : int
var executed : bool = false


func execute() -> void:
	pass


func setTotalTicks(value : int) -> void:
	totalTicks = value
	remainingTicks = value


func tick() -> void:
	remainingTicks -= 1
	
	if((remainingTicks <= 0) && !executed):
		executed = true
		execute()

