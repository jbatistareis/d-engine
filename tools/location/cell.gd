extends Panel

const _ROTATION : float = PI / 2
var room : Dictionary


func _init() -> void:
	room =  GameParameters.roomBase
	room.id = -1
	room.type = Enums.RoomType.DUMMY
	room.mesh = ''


func _enter_tree() -> void:
	$options.hint_tooltip = 'id: %d\nx: %d, y: %d' % [room.id, room.x, room.y]
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

