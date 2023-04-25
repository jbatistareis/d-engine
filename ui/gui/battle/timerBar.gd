extends Control

var character : Character
var paused : bool = false
var foward : bool = true


func _ready() -> void:
	Signals.commandOnQueue.connect(commandQueued)
	Signals.commandsPaused.connect(pause)
	Signals.commandsResumed.connect(resume)
	Signals.characterDied.connect(dead)


func commandQueued(command : Command) -> void:
	if command.executorCharacter == character:
		while paused:
			await Signals.commandsResumed
		
		$player.speed_scale = 1000 * GameParameters.GCD * command.totalTicks / 1000.0
		
		if (command is ExecuteMoveCommand) || (command is UseItemCommand): # pre
			$player.play("run")
			foward = true
		else: # pos
			$player.play_backwards("run")
			foward = false


func pause() -> void:
	paused = true
	$player.pause()


func resume() -> void:
	paused = false
	if foward:
		$player.play("run")
	else:
		$player.play_backwards("run")


func dead(character : Character) -> void:
	if character == self.character:
		$player.speed_scale = 1.0
		$player.play_backwards("run")

