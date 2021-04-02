extends Tabs

var spawnItemScene : PackedScene = preload("res://tools/location/spawns/spawnItem.tscn")


func _ready() -> void:
	LocationEditorSignals.connect("loadedLocation", self, "loadSpawns")
	$VBoxContainer/btnNewSpawn.connect("button_up", self, "addSpawn")


func loadSpawns(location : Location) -> void:
	for spawn in location.spawns:
		var spawnItem = spawnItemScene.instance()
		$VBoxContainer/ScrollContainer/spawnsContainer.add_child(spawnItem)
		spawnItem.spawn = spawn


func collectSpawns() -> Array:
	var spawns = []
	for spawnItem in $VBoxContainer/ScrollContainer/spawnsContainer.get_children():
		spawns.append(spawnItem.spawn)
	return spawns


func addSpawn() -> void:
	var spawn = Spawn.new()
	spawn.id = EditorIdGenerator.id
	
	var spawnItem = spawnItemScene.instance()
	$VBoxContainer/ScrollContainer/spawnsContainer.add_child(spawnItem)
	spawnItem.spawn = spawn

