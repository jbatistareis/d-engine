extends Spatial

# OUTDATED
# Every battle character must have the following animations:
# idle, damage, death, attack#, prepare#
# The # relates to the attack and its preparation, in case of
# multiple attacks with different preparation animations.
#
# In order for animations to work, the character node must
# have an Animation Player and Animation Tree nodes named
# AnimationPlayer and AnimationTree, respectively.
# The animations are controlled via the $AnimationTree, which
# must be constructed similar to the one from the base
# character.
# Note that idle has its damage and death state connections,
# and prepare1 has its damage1 and death1 connections.
# These are going to be used for their specific trasitions.
# If you have multiple attacks, you must follow the naming
# pattern (as in attack2, prepare2).


var character : Character


func _ready() -> void:
	Signals.connect("startedBattleAnimation", self, "play")
	
	$AnimationPlayer.play("idle")
	$AnimationPlayer.seek(randf() * $AnimationPlayer.current_animation_length)

func play(character : Character, animation : String) -> void:
	if character == self.character:
		$AnimationPlayer.play(animation)


# this method must be called from every attack animation (add a Call Mathod track)
func done() -> void:
	Signals.emit_signal("finishedBattleAnimation", character)

