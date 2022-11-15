extends ColorRect

const _ROTATION : float = PI / 2
const _BASE_MODELS : Array = ['', '0_exits', '1_exit', '2_exits_I', '2_exits_L', '3_exits', '4_exits']
const _HINT_TEXT : String = 'id: %d\nx: %d, y: %d'

var id : int
var x : int
var y : int
var room : Dictionary = {} setget setRoom

var selected : bool = false


func _ready() -> void:
	updateHint()
	
	$options.get_popup().connect("mouse_exited", self, "closeMenu")
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
	if (room.type != Enums.RoomType.DUMMY) && (index == 0):
		$icon.rotate(_ROTATION)
		var newOrientation = room.orientation + 1
		room.orientation = newOrientation if (newOrientation <= Enums.Direction.WEST) else 0
	
	elif (room.type != Enums.RoomType.DUMMY) && (index == 1):
		$icon.rotate(-_ROTATION)
		var newOrientation = room.orientation - 1
		room.orientation = newOrientation if (newOrientation >= Enums.Direction.NORTH) else 3
	
	elif index >= 3:
		index -= 3
		$icon.frame = index
		
		if index > 0:
			room.type = index
			room.model = _BASE_MODELS[index]
		else:
			self.room = DefaultValues.roomBase
	
	updateHint()
	
	EditorSignals.emit_signal("mapSelectedRoom", room)


func updateHint() -> void:
	$options.hint_tooltip = _HINT_TEXT % [id, x, y]
	$icon/pointer.visible = !room.empty() && (room.type != Enums.RoomType.DUMMY)


func setRoom(value : Dictionary) -> void:
	room = value.duplicate(true)
	
	room.id = id
	room.x = x
	room.y = y
	
	$icon.frame = room.type
	$icon.rotation = (_ROTATION * room.orientation) if (room.type != Enums.RoomType.DUMMY) else 0
	
	updateHint()


func closeMenu() -> void:
	$options.get_popup().hide()


func toggleSelect() -> void:
	select(!selected)


func select(value : bool) -> void:
	selected = value
	color.b = 0.8 if value else 0
	color.a = 0.4 if value else 0.15


func _on_options_pressed():
	EditorSignals.emit_signal("mapSelectedRoom", room)

