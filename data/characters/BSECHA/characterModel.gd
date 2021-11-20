extends Spatial


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
# pattern (as in attack2, prepare2, damage2, death2).


onready var playback : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")
var character : Character


func _ready() -> void:
	Signals.connect("startedBattleAnimation", self, "play")
	
	playback.travel('idle')
	randomizePosition('idle')


func play(character : Character, animation : String) -> void:
	if character == self.character:
		var current = playback.get_current_node()
		
		if current.begins_with('prepare'):
			if animation == 'damage':
				animation = 'damage' + current.substr(7)
		
		playback.travel(animation)


# this method must be called from every attack animation (add a Call Mathod track)
func done() -> void:
	Signals.emit_signal("finishedBattleAnimation", self.character)


# uso to randomize looping animations
func randomizePosition(animation : String) -> void:
	$AnimationTree.advance((Dice.rollNormal(Enums.DiceType.D100) / 100.0) * $AnimationPlayer.get_animation(animation).length)

