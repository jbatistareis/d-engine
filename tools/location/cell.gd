extends Panel

const _ROTATION : float = PI / 2

var roomDict : Dictionary = {
		'id': 0,
		'x': 0,
		'y': 0,
		'type': Enums.RoomType.DUMMY,
		'orientation': Enums.Direction.NORTH
	} setget setRoomDict


func _ready() -> void:
	$options.get_popup().add_multistate_item("Rotate R", 1)
	$options.get_popup().add_multistate_item("Rotate L", 1)
	$options.get_popup().add_separator()
	$options.get_popup().add_multistate_item("None", 1)
	$options.get_popup().add_multistate_item("0 Exits", 1)
	$options.get_popup().add_multistate_item("1 Exit", 1)
	$options.get_popup().add_multistate_item("2 Exits I", 1)
	$options.get_popup().add_multistate_item("2 Exits L", 1)
	$options.get_popup().add_multistate_item("3 Exits", 1)
	$options.get_popup().add_multistate_item("4 Exits", 1)
	$options.get_popup().connect("index_pressed", self, "optionSelected")


func optionSelected(index : int) -> void:
	if index == 0:
		$icon.rotate(_ROTATION)
		var newOrientation = roomDict.orientation + 1
		roomDict.orientation = newOrientation if (newOrientation <= Enums.Direction.WEST) else 0
	
	elif index == 1:
		$icon.rotate(-_ROTATION)
		var newOrientation = roomDict.orientation - 1
		roomDict.orientation = newOrientation if (newOrientation >= Enums.Direction.NORTH) else 3
	
	elif index >= 3:
		index -= 3
		$icon.frame = index
		roomDict.type = index
	
	updateHint()


func updateHint() -> void:
	$options.hint_tooltip = 'id: %d\nx: %d, y: %d\n%s' % [roomDict.id, roomDict.x, roomDict.y, Enums.Direction.keys()[roomDict.orientation]]
	$icon/pointer.visible = roomDict.type != Enums.RoomType.DUMMY


func setRoomDict(value : Dictionary) -> void:
	roomDict = value
	$icon.frame = roomDict.type
	$icon.rotate(_ROTATION * roomDict.orientation)
	
	updateHint()

