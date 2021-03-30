extends VBoxContainer

var spanwnItem : PackedScene = preload("res://tools/location/spawns/spawnItem.tscn")


func _ready() -> void:
	LocationEditorSignals.connect("loadedLocation", self, "loadSpawns")
	$btnNewSpawn.connect("button_up", self, "addSpawn")


func loadSpawns(location : Location) -> void:
	for spawn in location.spawns:
		var spawnItem = spanwnItem.instance()
		$ScrollContainer/spawnsContainer.add_child(spawnItem)
		spawnItem.spawn = spawn


func addSpawn() -> void:
	var spawn = Spawn.new()
	spawn.id = EditorIdGenerator.id
	
	var spawnItem = spanwnItem.instance()
	$ScrollContainer/spawnsContainer.add_child(spawnItem)
	spawnItem.spawn = spawn

