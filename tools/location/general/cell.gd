extends Panel

const _ROTATION : float = PI / 2
const _BASE_MODELS = ['', '0_exits', '1_exit', '2_exits_I', '2_exits_L', '3_exits', '4_exits']


var room : Dictionary = {
	'id': 0,
	'x': 0,
	'y': 0,
	'type': Enums.RoomType.DUMMY, # use  Enums.RoomType
	'orientation': Enums.Direction.NORTH , # use Enums.Direction
	'model': '4_exits',
	'exits': [0, 0, 0, 0, 0, 0],
	'canEnterLogic': GameParameters.ROOM_ENTER_NOOP,
	'enteringLogic': GameParameters.ROOM_NOOP,
	'exitingLogic': GameParameters.ROOM_NOOP,
	'foeShortNameGroups': [], # 2D array representing possible enemy groups
	'visited': false,
} setget setRoom


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
		var newOrientation = room.orientation + 1
		room.orientation = newOrientation if (newOrientation <= Enums.Direction.WEST) else 0
	
	elif index == 1:
		$icon.rotate(-_ROTATION)
		var newOrientation = room.orientation - 1
		room.orientation = newOrientation if (newOrientation >= Enums.Direction.NORTH) else 3
	
	elif index >= 3:
		index -= 3
		$icon.frame = index
		room.type = index
		room.model = _BASE_MODELS[index]
		print(index)
		print(Enums.RoomType.keys()[index])
	
	updateHint()


func updateHint() -> void:
	$options.hint_tooltip = 'id: %d\nx: %d, y: %d\n%s' % [room.id, room.x, room.y, Enums.Direction.keys()[room.orientation].capitalize()]
	$icon/pointer.visible = room.type != Enums.RoomType.DUMMY


func setRoom(value : Dictionary) -> void:
	room = value
	$icon.frame = room.type
	$icon.rotate(_ROTATION * room.orientation)
	
	updateHint()

