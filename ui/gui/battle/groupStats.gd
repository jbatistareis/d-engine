extends MarginContainer

var healthBarsPackedScene : PackedScene = preload("res://ui/gui/battle/healthBars.tscn")
var timerBarPackedScene : PackedScene = preload("res://ui/gui/battle/timerBar.tscn")
var characters : Array = [] : set = setCharacters


func setCharacters(value : Array) -> void:
	characters = value
	
	clear()
	
	for character in characters:
		var label = Label.new()
		label.text = character.name
		
		var healthBars = healthBarsPackedScene.instantiate()
		healthBars.character = character
		
		var timerBar = timerBarPackedScene.instantiate()
		timerBar.character = character
		
		$characters.add_child(label)
		$characters.add_child(healthBars)
		$characters.add_child(timerBar)


func clear() -> void:
	for child in $characters.get_children():
		child.queue_free()

