extends Spatial

const ROTATE_90 : float = PI / 2
var blocks : Dictionary = {}


func _ready() -> void:
	LocationEditorSignals.connect("selectedRoom", self, "setPreview")
	LocationEditorSignals.connect("changedRoomMesh", self, "setPreview")
	LocationEditorSignals.connect("testLocation", self, "hideWindow")


func rotatePivot(angle : float) -> void:
	if !$Tween.is_active():
		$Tween.interpolate_property(
			$pivot,
			'rotation:y',
			$pivot.rotation.y,
			$pivot.rotation.y + deg2rad(angle),
			0.1)
		$Tween.start()


# ignore parameters
func hideWindow(location, x, y, direction) -> void:
	hide()


func setPreview(room : RoomTile, ignore) -> void:
	$pivot/Camera.current = true
	visible = true
	
	for node in $blockArea.get_children():
		node.queue_free()
	
	$blockArea.add_child(blocks[room.mesh].instance())
	$pivot.rotation.y = ROTATE_90 * room.orientation

