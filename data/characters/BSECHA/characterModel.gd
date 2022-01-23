extends Spatial

# Every battle character must have the following animations:
# idle, damage, death, attack[...]
# 
# Attacks must begin with the 'attack' prefix to be able to be controlled by the
# state methods
# Preparation animations are optional, but recommended


var character : Character


func _ready() -> void:
	Signals.connect("startedBattleAnimation", self, "play")
	Signals.connect("characterTookDamage", self, "damage")
	Signals.connect("characterDied", self, "die")
	
	$AnimationPlayer.play("idle")
	$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length)


func play(character : Character, animation : String) -> void:
	if (character == self.character) && (character.currentHp > 0) && (!animation.empty() || (animation != null)):
		$AnimationPlayer.play(animation)
		
		if animation.begins_with("attack"):
			yield($AnimationPlayer, "animation_finished")
			if character.currentHp > 0:
				$AnimationPlayer.play("idle")


func damage(character : Character) -> void:
	if (character == self.character) && (character.currentHp > 0):
		var previousAnimation = $AnimationPlayer.current_animation
		var previousPosition = $AnimationPlayer.current_animation_position
		
		$AnimationPlayer.play("damage")
		yield($AnimationPlayer, "animation_finished")
		
		play(character, previousAnimation)
		if character.currentHp > 0:
			if previousAnimation.begins_with("attack"):
				# return 1/5 of the attack animation
				$AnimationPlayer.seek(max(0, previousPosition - ($AnimationPlayer.current_animation_length / 5.0)))
			else:
				$AnimationPlayer.seek(previousPosition)


func die(character : Character) -> void:
	if character == self.character:
		$AnimationPlayer.play("death")


# this method must be called from every attack animation (add a Call Mathod track)
func done() -> void:
	if character.currentHp > 0:
		Signals.emit_signal("finishedBattleAnimation", character)

