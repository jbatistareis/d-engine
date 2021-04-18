extends Spatial

const ROTATE_90 : float = PI / 2
var blocks : Dictionary = {}


func _ready() -> void:
	LocationEditorSignals.connect("selectedRoom", self, "setPreview")
	LocationEditorSignals.connect("changedRoomMesh", self, "setPreview")
	LocationEditorSignals.connect("testLocation", self, "hideWindow")


# ignore parameters
func hideWindow(location, x, y, direction) -> void:
	hide()


func setPreview(room : Room, ignore) -> void:
	$Camera.current = true
	visible = true
	
	for node in $blockArea.get_children():
		node.queue_free()
	
	$blockArea.add_child(blocks[room.mesh].instance())
	$blockArea.rotation.y = ROTATE_90 * -room.orientation

