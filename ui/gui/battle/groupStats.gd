extends MarginContainer

var healthBarsPackedScene : PackedScene = preload("res://ui/gui/battle/healthBars.tscn")
var timerBarPackedScene : PackedScene = preload("res://ui/gui/battle/timerBar.tscn")
var characters : Array = [] setget setCharacters


func setCharacters(value : Array) -> void:
	characters = value
	
	for child in $characters.get_children():
		child.queue_free()
	yield(get_tree(), "idle_frame")
	
	for character in characters:
		var label = Label.new()
		label.text = character.name
		
		var healthBars = healthBarsPackedScene.instance()
		healthBars.character = character
		
		var timerBar = timerBarPackedScene.instance()
		timerBar.character = character
		
		$characters.add_child(label)
		$characters.add_child(healthBars)
		$characters.add_child(timerBar)


func clear() -> void:
	$characters.get_children().clear()

