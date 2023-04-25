extends Control

var character : Character
var forward : bool = true


func _ready() -> void:
	Signals.commandOnQueue.connect(commandQueued)
	Signals.commandsPaused.connect(pause)
	Signals.commandsResumed.connect(resume)
	Signals.characterDied.connect(dead)


func commandQueued(command : Command) -> void:
	if command.executorCharacter == character:
		$player.speed_scale = 1.0 / (GameParameters.GCD * command.totalTicks)
		
		if (command is ExecuteMoveCommand) || (command is UseItemCommand): # pre
			forward = true
			$player.play("run")
		else: # pos
			forward = false
			$player.play_backwards("run")


func pause() -> void:
	$player.pause()


func resume() -> void:
	if forward:
		$player.play("run")
	else:
		$player.play_backwards("run")


func dead(character : Character) -> void:
	if character == self.character:
		$player.speed_scale = -1.0
		$player.play_backwards("run")

