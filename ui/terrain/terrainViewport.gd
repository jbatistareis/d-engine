extends SubViewportContainer

const _ROTATE_90 : float = PI / 2
var blocks : Dictionary = {}


func _ready() -> void:
	Signals.playerSpawned.connect(loadMap)


func loadMap(location : Location, x : int, y : int, _direction : int) -> void:
	SceneLoadManager.fromLocation(location)
	
	blocks.clear()
	for node in $viewport/blocks.get_children():
		node.queue_free()
	
	for room in location.rooms:
		var block = SceneLoadManager.scenes[room.model].instantiate()
		block.transform.origin.x = room.x * 2 + 1
		block.transform.origin.y = 1
		block.transform.origin.z = room.y * 2 + 1
		block.rotation.y = _ROTATE_90 * -room.orientation
		
		$viewport/blocks.add_child(block)

