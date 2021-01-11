class_name Command

var totalTicks : int setget setTotalTicks,getTotalTicks
var executorCharSpawnId : int setget ,getExecutorCharSpawnId
var targetCharSpawnId : int
var entityId : int

var remainingTicks : int setget ,getRemainingTicks
var executed : bool = false setget ,wasExecuted

func _init(totalTicks : int = 1, executorCharSpawnId : int = -1, targetCharSpawnId : int = -1, entityId : int = -1) -> void:
	setTotalTicks(totalTicks)
	self.executorCharSpawnId = executorCharSpawnId
	self.targetCharSpawnId = targetCharSpawnId
	self.entityId = entityId

func execute() -> void:
	pass

func setTotalTicks(value : int) -> void:
	totalTicks = value
	remainingTicks = value

func getTotalTicks() -> int:
	return totalTicks

func getExecutorCharSpawnId() -> int:
	return executorCharSpawnId

func getRemainingTicks() -> int:
	return remainingTicks

func wasExecuted() -> bool:
	return executed

func tick() -> void:
	remainingTicks -= 1
	
	if((remainingTicks <= 0) && !executed):
		executed = true
		execute()

