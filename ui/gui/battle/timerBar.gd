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
		
		$Tween.interpolate_property($timer, "value", start, end, (1000 * GameParameters.GCD * command.totalTicks / 1000.0))
		$Tween.start()


func pause() -> void:
	$Tween.stop_all()
	paused = true


func resume() -> void:
	$Tween.resume_all()
	paused = false


func dead(character : Character) -> void:
	if character == self.character:
		$Tween.interpolate_property($timer, "value", $timer.value, 0, 0.25)
		yield($Tween, "tween_all_completed")
		$Tween.remove_all()

