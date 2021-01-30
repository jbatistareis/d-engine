class_name Command

var executor : Character
var totalTicks : int setget setTotalTicks
var remainingTicks : int
var executed : bool = false


func _init(executor : Character, ticks : int) -> void:
	self.executor = executor
	self.totalTicks = ticks


func execute() -> void:
	pass


func setTotalTicks(value : int) -> void:
	totalTicks = value
	remainingTicks = value


func tick() -> void:
	if executor.health.currentHp == 0:
		executed = true
	
	remainingTicks -= 1
	
	if(remainingTicks <= 0) && !executed:
		executed = true
		execute()

