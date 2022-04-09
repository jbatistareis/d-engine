class_name Command

var executorCharacter
var totalTicks : int setget setTotalTicks
var remainingTicks : int
var toBeExecuted : bool = false
var canceled : bool = false


func _init(executorCharacter, ticks : int) -> void:
	self.executorCharacter = executorCharacter
	self.totalTicks = ticks


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
	if (executorCharacter != null) && (executorCharacter.currentHp <= 0):
		toBeExecuted = false
		canceled = true
		remainingTicks = 0
		return
	
	remainingTicks -= 1
	toBeExecuted = remainingTicks <= 0

