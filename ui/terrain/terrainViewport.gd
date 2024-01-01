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
		block.rotation.y = _ROTATE_90 * -room.orientation
		block.transform.origin = Vector3(room.x * 2 + 1, 1, room.y * 2 + 1).snapped(Vector3.ONE)
		block.transform.orthonormalized()
		
		$viewport/blocks.add_child(block)

