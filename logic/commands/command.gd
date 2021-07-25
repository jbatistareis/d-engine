class_name Command

var executorCharacter
var totalTicks : int setget setTotalTicks
var remainingTicks : int
var executions : int
var persistent : bool
var toBeExecuted : bool = false
var executed : bool = false


func _init(executorCharacter, ticks : int, executions : int = 1, persistent : bool = false) -> void:
	self.executorCharacter = executorCharacter
	self.totalTicks = ticks
	self.executions = executions
	self.persistent = persistent


# implement this
func execute() -> void:
	pass


# implement this
func published() -> void:
	pass


func setTotalTicks(value : int) -> void:
	totalTicks = value
	remainingTicks = value


func tick() -> void:
	if (executorCharacter != null) && (executorCharacter.currentHp == 0):
		toBeExecuted = true
	
	remainingTicks -= 1


func run() -> void:
	if(remainingTicks <= 0) && !executed:
		executions -= 1
		executed = (executions <= 0)
		execute()

