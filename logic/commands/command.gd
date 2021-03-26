class_name Command

var executorCharacter
var totalTicks : int setget setTotalTicks
var remainingTicks : int
var executed : bool = false


func _init(executorCharacter, ticks : int) -> void:
	self.executorCharacter = executorCharacter
	self.totalTicks = ticks


func execute() -> void:
	pass


func setTotalTicks(value : int) -> void:
	totalTicks = value
	remainingTicks = value


func tick() -> void:
	if executorCharacter.currentHp == 0:
		executed = true
	
	remainingTicks -= 1
	
	if(remainingTicks <= 0) && !executed:
		executed = true
		execute()

