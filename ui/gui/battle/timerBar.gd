extends Control

const _CONDITION_TXT : String = 'AT:%2d DF:%2d CD:%2d'

var character : Character
var charDead : bool = false


func _ready() -> void:
	Signals.commandOnQueue.connect(commandQueued)
	Signals.commandsPaused.connect(pause)
	Signals.commandsResumed.connect(resume)
	Signals.characterDied.connect(dead)
	
	updateCondition()


func commandQueued(command : Command) -> void:
	if charDead:
		return
	
	updateCondition()
	if command.executorCharacter == character:
		$player.speed_scale = 1.0 / (GameParameters.GCD * command.totalTicks)
		
		if (command is ExecuteMoveCommand) || (command is UseItemCommand): # pre
			$player.play("run")
		else: # pos
			$player.play_backwards("run")


func pause() -> void:
	if charDead:
		return
	
	updateCondition()
	$player.pause()


func resume() -> void:
	if charDead:
		return
	
	updateCondition()
	$player.play("run")


func dead(character : Character) -> void:
	if character == self.character:
		updateCondition()
		
		charDead = true
		
		$player.speed_scale = 1.0
		$player.play_backwards("run")


func updateCondition() -> void:
	$condition.text = _CONDITION_TXT % [character.atkMod, character.defMod, character.cdMod]

