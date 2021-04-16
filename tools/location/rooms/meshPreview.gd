extends Spatial

var meshLib : MeshLibrary


func _ready() -> void:
	LocationEditorSignals.connect("selectedRoom", self, "setPreview")
	LocationEditorSignals.connect("changedRoomMesh", self, "updateMesh")
	LocationEditorSignals.connect("testLocation", self, "hideWindow")


# ignore parameters
func hideWindow(location, x, y, direction) -> void:
	hide()


func setPreview(room : Room, ignore) -> void:
	$Camera.current = true
	visible = true
	
	updateMesh(room.mesh)
	setDirection(room.orientation)


func setDirection(value : int) -> void:
	$room.rotation.y = PI / 2 * -value


func updateMesh(id : int) -> void:
	$room.mesh = meshLib.get_item_mesh(id + 1)

