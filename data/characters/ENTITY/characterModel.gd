extends Spatial

onready var playback : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/playback")


func _ready() -> void:
	Signals.connect("startedBattleAnimation", self, "play")


func play(character : Character, animation : String) -> void:
	if character.shortName == name:
		var current = playback.get_current_node()
		
		if animation == 'damage':
			if current.begins_with('prepare'):
				animation = 'damagePrep' + current.substr(7)
			elif current == 'idle':
				animation = 'damageIdle'
		elif animation == 'death':
			if current.begins_with('prepare'):
				animation = 'deathPrep' + current.substr(7)
			elif current == 'idle':
				animation = 'deathIdle'
		
		playback.travel(animation)

