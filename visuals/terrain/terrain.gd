extends Spatial

const ROTATE_90 : float = PI / 2
var blocks : Dictionary = {}


func _ready() -> void:
	Signals.connect("playerSpawned", self, "loadMap")
	LocationEditorSignals.connect("testLocation", self, "loadMap")


func loadMap(location : Location, x : int, y : int, direction : int) -> void:
	blocks.clear()
	for node in $blocks.get_children():
		node.queue_free()
	
	var directory = Directory.new()
	var path = GamePaths.MAP_DATA % (location.shortName if !location.shortName.empty() else 'baseLocation')
	
	directory.open(GamePaths.MAP_DATA % location.shortName)
	directory.list_dir_begin(true, true)
	
	var filename = directory.get_next()
	while !filename.empty():
		if filename.ends_with('.tscn'):
			blocks[filename.substr(0, filename.find_last('.'))] = load(path + '/' + filename)
		filename = directory.get_next()
	
	for room in location.rooms:
		var block : Spatial = blocks[room.mesh].instance()
		block.transform.origin.x = room.x * 2 + 1
		block.transform.origin.y = 1
		block.transform.origin.z = room.y * 2 + 1
		block.rotation.y = ROTATE_90 * -room.orientation
		
		$blocks.add_child(block)

