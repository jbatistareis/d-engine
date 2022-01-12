extends Spatial

const ROTATE_90 : float = PI / 2
var blocks : Dictionary = {}


func _ready() -> void:
	Signals.connect("playerSpawned", self, "loadMap")
	LocationEditorSignals.connect("testLocation", self, "loadMap")


func loadMap(location : Location, x : int, y : int, direction : int) -> void:
	SceneLoadManager.fromLocation(location)
	
	blocks.clear()
	for node in $blocks.get_children():
		node.queue_free()
	
	for room in location.rooms:
		var block = SceneLoadManager.scenes[room.mesh].instance()
		block.transform.origin.x = room.x * 2 + 1
		block.transform.origin.y = 1
		block.transform.origin.z = room.y * 2 + 1
		block.rotation.y = ROTATE_90 * -room.orientation
		
		$blocks.add_child(block)


