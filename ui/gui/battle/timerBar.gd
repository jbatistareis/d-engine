extends Control

var character : Character
var paused : bool = false


func _ready() -> void:
	Signals.connect("commandOnQueue", self, "commandQueued")
	Signals.connect("commandsPaused", self, "pause")
	Signals.connect("commandsResumed", self, "resume")
	Signals.connect("characterDied", self, "dead")


func commandQueued(command : Command) -> void:
	if command.executorCharacter == character:
		while paused:
			yield(Signals, "commandsResumed")
		
		$Tween.remove_all()
		
		var start
		var end
		
		if command is ExecuteMoveCommand: # pre
			start = 0
			end = 100
		else: # pos
			start = 100
			end = 0
		
		$Tween.interpolate_property($timer, "value", start, end, GameParameters.GCD * command.totalTicks)
		$Tween.start()


func pause() -> void:
	paused = true
	$Tween.stop_all()


func resume() -> void:
	paused = false
	$Tween.resume_all()


func dead(character : Character) -> void:
	if character == self.character:
		$Tween.interpolate_property($timer, "value", $timer.value, 0, 0.25)
		yield($Tween, "tween_all_completed")
		$Tween.remove_all()

