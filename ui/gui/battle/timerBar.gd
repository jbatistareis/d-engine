extends Control

var character : Character
var charDead : bool = false


func _ready() -> void:
	Signals.commandOnQueue.connect(commandQueued)
	Signals.commandsPaused.connect(pause)
	Signals.commandsResumed.connect(resume)
	Signals.characterDied.connect(dead)


func commandQueued(command : Command) -> void:
	if charDead:
		return
	
	if command.executorCharacter == character:
		$player.speed_scale = 1.0 / (GameParameters.GCD * command.totalTicks)
		
		if (command is ExecuteMoveCommand) || (command is UseItemCommand): # pre
			$player.play("run")
		else: # pos
			$player.play_backwards("run")


func pause() -> void:
	if charDead:
		return
	
	$player.pause()


func resume() -> void:
	if charDead:
		return
	
	$player.play("run")


func dead(character : Character) -> void:
	if character == self.character:
		charDead = true
		
		$player.speed_scale = 1.0
		$player.play_backwards("run")

