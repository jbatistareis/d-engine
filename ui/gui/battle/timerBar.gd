extends Control

var character : Character


func _ready() -> void:
	Signals.commandOnQueue.connect(commandQueued)
	Signals.commandsPaused.connect(pause)
	Signals.commandsResumed.connect(resume)
	Signals.characterDied.connect(dead)


func commandQueued(command : Command) -> void:
	if command.executorCharacter == character:
		var newScale = 1 / (GameParameters.GCD * command.totalTicks)
		
		if (command is ExecuteMoveCommand) || (command is UseItemCommand): # pre
			$player.speed_scale = newScale
		else: # pos
			$player.speed_scale = -newScale
		
		$player.play("run")


func pause() -> void:
	$player.pause()


func resume() -> void:
	$player.play("run")


func dead(character : Character) -> void:
	if character == self.character:
		$player.speed_scale = -1.0
		$player.play("run")

