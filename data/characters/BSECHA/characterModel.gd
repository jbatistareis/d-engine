extends Spatial

onready var playback : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")


func _ready() -> void:
	Signals.connect("startedBattleAnimation", self, "play")
	
	playback.travel('idle')
	randomizePosition('idle')


func play(character : Character, animation : String) -> void:
	if character.shortName == name:
		var current = playback.get_current_node()
		
		if animation == 'damage':
			if current.begins_with('prepare'):
				animation = 'damagePrepare' + current.substr(7)
			elif current == 'idle':
				animation = 'damageIdle'
		elif animation == 'death':
			if current.begins_with('prepare'):
				animation = 'deathPrepare' + current.substr(7)
			elif current == 'idle':
				animation = 'deathIdle'
		
		playback.travel(animation)


# this method must be called from every attack animation (add a Call Mathod track)
func done() -> void:
	Signals.emit_signal("finishedBattleAnimation")


# uso to randomize looping animations
func randomizePosition(animation : String) -> void:
	$AnimationTree.advance((Dice.rollNormal(Enums.DiceType.D100) / 100.0) * $AnimationPlayer.get_animation(animation).length)

