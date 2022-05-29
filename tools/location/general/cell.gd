extends Panel

const _ROTATION : float = PI / 2
const _BASE_MESHES = ['', '0_exits', '1_exit', '2_exits_I', '2_exits_L', '3_exits', '4_exits']


var roomDict : Dictionary = {
	'id': 0,
	'x': 0,
	'y': 0,
	'type': Enums.RoomType.DUMMY, # use  Enums.RoomType
	'orientation': Enums.Direction.NORTH , # use Enums.Direction
	'mesh': '4_exits',
	'exits': [0, 0, 0, 0, 0, 0],
	'portals': [0, 0, 0, 0, 0, 0],
	'entranceLogic': GameParameters.ROOM_TILE_NOOP,
	'exitLogic': GameParameters.ROOM_TILE_NOOP,
	'friendlyShortNames': [], # short names of NPCs present in the room
	'foeShortNameGroups': [], # 2D array representing possible enemy groups
	'visited': false,
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
		roomDict.mesh = _BASE_MESHES[index]
		print(index)
		print(Enums.RoomType.keys()[index])
	
	updateHint()


func updateHint() -> void:
	$options.hint_tooltip = 'id: %d\nx: %d, y: %d\n%s' % [roomDict.id, roomDict.x, roomDict.y, Enums.Direction.keys()[roomDict.orientation].capitalize()]
	$icon/pointer.visible = roomDict.type != Enums.RoomType.DUMMY


func setRoomDict(value : Dictionary) -> void:
	roomDict = value
	$icon.frame = roomDict.type
	$icon.rotate(_ROTATION * roomDict.orientation)
	
	updateHint()

