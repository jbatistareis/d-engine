extends Node3D

# Every battle character must have the following animations:
# idle, damage, death, attack[...]
# 
# Attacks must begin with the 'attack' prefix to be able to be controlled by the
# state methods
# Preparation animations are optional, but recommended


var character : Character


func _ready() -> void:
	Signals.startedBattleAnimation.connect(play)
	Signals.characterTookDamage.connect(damage)
	Signals.characterDied.connect(die)
	
	$AnimationPlayer.play("idle")
	$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length)
	
	Signals.commandsPaused.connect(pause)
	Signals.commandsResumed.connect(resume)


func play(character : Character, animation : String) -> void:
	if (character == self.character) && (character.currentHp > 0) && (!animation.is_empty() || (animation != null)):
		$AnimationPlayer.play(animation)
		
		if animation.begins_with("attack"):
			await $AnimationPlayer.animation_finished
			if character.currentHp > 0:
				$AnimationPlayer.play("idle")


func damage(character : Character) -> void:
	if (character == self.character) && (character.currentHp > 0):
		var previousAnimation = $AnimationPlayer.current_animation
		var previousPosition = $AnimationPlayer.current_animation_position
		
		$AnimationPlayer.play("damage")
		await $AnimationPlayer.animation_finished
		
		play(character, previousAnimation)
		if character.currentHp > 0:
			$AnimationPlayer.seek(previousPosition)


func die(character : Character) -> void:
	if character == self.character:
		$AnimationPlayer.play("death")


# this method must be called from every attack animation (add a Call Mathod track)
func done() -> void:
	if character.currentHp > 0:
		Signals.finishedBattleAnimation.emit(character)


func pause() -> void:
	var tween = create_tween()
	tween.tween_property($AnimationPlayer, "speed_scale", 0, 0.15)
	tween.play()


func resume() -> void:
	var tween = create_tween()
	tween.tween_property($AnimationPlayer, "speed_scale", 1, 0.15)
	tween.play()

